import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:intl/intl.dart';
import 'package:kiddo/modules/bottombar/utils.dart';
import 'package:kiddo/modules/lesson/detail_lesson_screen.dart';
import 'package:kiddo/modules/notification/notification.dart';
import 'package:kiddo/student_models/diem_danh_model.dart';
import 'package:kiddo/student_repo/diemdanh_repo.dart';
import 'package:kiddo/utils/constants/color.dart';
import 'package:kiddo/utils/constants/styles.dart';
import 'package:kiddo/utils/widget/custom_dialog.dart';
import 'package:kiddo/utils/widget/custom_widget.dart';
import 'package:table_calendar/table_calendar.dart';

class CalenderScreen extends StatefulWidget {
  const CalenderScreen({super.key});

  @override
  State<CalenderScreen> createState() => _CalenderScreenState();
}

class _CalenderScreenState extends State<CalenderScreen> {
  late final ValueNotifier<List<ScheduleModel>> _selectedEvents;
  CalendarFormat _calendarFormat = CalendarFormat.month;
  RangeSelectionMode _rangeSelectionMode = RangeSelectionMode
      .toggledOn; // Can be toggled on/off by longpressing a date
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;
  DateTime? _rangeStart;
  DateTime? _rangeEnd;
  late List<ScheduleModel> _listLichHoc;
  final Map<DateTime, List<ScheduleModel>> _events = {};
  final Set<String> _loadedMonths = {};
  String? selectedHinhThuc;
  @override
  void initState() {
    super.initState();
    _selectedDay = _focusedDay;
    _listLichHoc = [];
    _selectedEvents = ValueNotifier(_getEventsForRange(
        DateTime(_focusedDay.year, _focusedDay.month, 1),
        DateTime(_focusedDay.year, _focusedDay.month + 1, 0)));
    _fetchEventsForMonth(_focusedDay);
  }

  @override
  void dispose() {
    _selectedEvents.dispose();
    super.dispose();
  }

  Future<void> _fetchEventsForMonth(DateTime date) async {
    final key = '${date.year}-${date.month.toString().padLeft(2, '0')}';
    if (_loadedMonths.contains(key)) return;

    final start = DateTime(date.year, date.month, 1);
    final end = DateTime(date.year, date.month + 1, 0);

    try {
      final fetchedEvents = await DiemdanhRepo().getScheduleList(
        DateFormat('dd-MM-yyyy').format(start),
        DateFormat('dd-MM-yyyy').format(end),
      );

      if (!mounted) return;
      if (fetchedEvents.isEmpty) {
        _loadedMonths.add(key);
        return;
      }

      setState(() {
        for (final e in fetchedEvents) {
          final day = DateTime(
              e.createdDate.year, e.createdDate.month, e.createdDate.day);
          _events.putIfAbsent(day, () => []).add(e);
        }
        _loadedMonths.add(key);
        if (_selectedDay != null) {
          final dayKey = DateTime(
              _selectedDay!.year, _selectedDay!.month, _selectedDay!.day);
          _selectedEvents.value = _events[dayKey] ?? [];
        }
      });
    } catch (e) {
      debugPrint('Lỗi tải lịch học tháng $key: $e');
    }
  }

  Future<void> getSchedule(
      {required String dayStart, required String dayEnd}) async {
    try {
      final list = await DiemdanhRepo().getScheduleList(dayStart, dayEnd);
      if (!mounted) return;
      _listLichHoc = list;
      _selectedEvents.value = _listLichHoc;
    } catch (e) {
      debugPrint('Lỗi tải lịch học: $e');
    }
  }

  List<ScheduleModel> _getEventsForDay(DateTime day) {
    final dayKey = DateTime(day.year, day.month, day.day);
    if (_events.containsKey(dayKey)) {
      return _events[dayKey] ?? [];
    }
    getSchedule(
        dayStart: DateFormat('dd-MM-yyyy').format(day),
        dayEnd: DateFormat('dd-MM-yyyy').format(day));
    return _listLichHoc;
  }

  List<ScheduleModel> _getEventsForRange(DateTime start, DateTime end) {
    getSchedule(
      dayStart: DateFormat('dd-MM-yyyy').format(start),
      dayEnd: DateFormat('dd-MM-yyyy').format(end),
    );
    return _listLichHoc;
  }

  void _onDaySelected(DateTime selectedDay, DateTime focusedDay) {
    if (!isSameDay(_selectedDay, selectedDay)) {
      setState(() {
        _selectedDay = selectedDay;
        _focusedDay = focusedDay;
        _rangeStart = null; // Important to clean those
        _rangeEnd = null;
        _rangeSelectionMode = RangeSelectionMode.toggledOff;
      });

      _selectedEvents.value = _getEventsForDay(selectedDay);
    }
  }

  void _onRangeSelected(DateTime? start, DateTime? end, DateTime focusedDay) {
    setState(() {
      _selectedDay = null;
      _focusedDay = focusedDay;
      _rangeStart = start;
      _rangeEnd = end;
      _rangeSelectionMode = RangeSelectionMode.toggledOn;
    });

    // `start` or `end` could be null
    if (start != null && end != null) {
      _selectedEvents.value = _getEventsForRange(start, end);
    } else if (start != null) {
      _selectedEvents.value = _getEventsForDay(start);
    } else if (end != null) {
      _selectedEvents.value = _getEventsForDay(end);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: mainOrange,
      appBar: AppBar(
        backgroundColor: mainOrange,
        elevation: 0,
        centerTitle: true,
        title: Text(
          "Lịch học",
          style: defaultText18B.copyWith(
            color: Colors.white,
          ),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        actions: [
          GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => NotificationScreen(),
                ),
              );
            },
            child: SvgPicture.asset(
              'assets/icons/bell.svg',
              width: 20.w,
              height: 20.h,
              colorFilter: ColorFilter.mode(
                Colors.white,
                BlendMode.srcIn,
              ),
            ),
          ),
          SizedBox(width: 16.w),
        ],
      ),
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(16.r),
            topRight: Radius.circular(16.r),
          ),
        ),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                height: 12.h,
              ),
              Padding(
                padding: EdgeInsetsGeometry.symmetric(horizontal: 16.w),
                child: HinhThucHocDropdown(
                  value: selectedHinhThuc,
                  onChanged: (value) {
                    setState(() {
                      selectedHinhThuc = value;
                    });
                  },
                ),
              ),
              Container(
                //height: 403.h,
                padding: EdgeInsets.only(left: 16.w),
                width: 350.w,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.all(
                    Radius.circular(8.r),
                  ),
                ),
                child: TableCalendar<ScheduleModel>(
                  locale: 'vi_VI',
                  firstDay: kFirstDay,
                  lastDay: kLastDay,
                  focusedDay: _focusedDay,
                  selectedDayPredicate: (day) => isSameDay(_selectedDay, day),
                  rangeStartDay: _rangeStart,
                  rangeEndDay: _rangeEnd,
                  availableCalendarFormats: const {
                    CalendarFormat.month: 'Month',
                  },
                  headerStyle: HeaderStyle(titleTextStyle: defaultText16M),
                  daysOfWeekStyle: DaysOfWeekStyle(
                    weekdayStyle: defaultText14M,
                    weekendStyle: defaultText14M.copyWith(
                      color: Colors.red,
                    ),
                  ),
                  daysOfWeekHeight: 36.h,
                  calendarFormat: _calendarFormat,
                  rangeSelectionMode: _rangeSelectionMode,
                  eventLoader: (day) {
                    final d = DateTime(day.year, day.month, day.day);
                    return _events[d] ?? [];
                  },
                  startingDayOfWeek: StartingDayOfWeek.monday,
                  calendarBuilders: CalendarBuilders(
                    markerBuilder: (context, date, events) {
                      List<ScheduleModel> list1;
                      if (selectedHinhThuc == 'Lịch học ở trung tâm') {
                        list1 = events
                            .where((item) => item.typeLearn == "off")
                            .toList();
                      } else if (selectedHinhThuc == 'Lịch học Zoom') {
                        list1 = events
                            .where((item) => item.typeLearn == "zoom")
                            .toList();
                      } else if (selectedHinhThuc ==
                          'Lịch học phụ đạo - học bù') {
                        list1 = [];
                      } else {
                        list1 = events;
                      }

                      return list1.isNotEmpty
                          ? _buildEventsMarkerNum(list1)
                          : const SizedBox();
                    },
                  ),
                  calendarStyle: CalendarStyle(
                    // Use `CalendarStyle` to customize the UI
                    outsideDaysVisible: true,
                    defaultTextStyle: defaultText14M,
                    weekendTextStyle:
                        defaultText14M.copyWith(color: Colors.red),
                    todayTextStyle:
                        defaultText14M.copyWith(color: Colors.white),
                    selectedDecoration: BoxDecoration(
                      color: mainOrange,
                      shape: BoxShape.rectangle,
                      borderRadius: BorderRadius.circular(10.r),
                    ),
                    rangeStartDecoration: BoxDecoration(
                      color: mainOrange,
                      shape: BoxShape.rectangle,
                      borderRadius: BorderRadius.circular(10.r),
                    ),
                    rangeEndDecoration: BoxDecoration(
                      color: mainOrange,
                      shape: BoxShape.rectangle,
                      borderRadius: BorderRadius.circular(10.r),
                    ),
                    rangeHighlightColor: mainOrange.withValues(alpha: 0.1),
                    selectedTextStyle: TextStyle(color: Colors.white),
                    todayDecoration: BoxDecoration(
                      color: mainOrange.withValues(alpha: 0.3),
                      shape: BoxShape.rectangle,
                      borderRadius: BorderRadius.circular(10.r),
                    ),
                  ),
                  onDaySelected: _onDaySelected,
                  onRangeSelected: _onRangeSelected,
                  onFormatChanged: (format) {
                    if (_calendarFormat != format) {
                      setState(() {
                        _calendarFormat = format;
                      });
                    }
                  },
                  onPageChanged: (focusedDay) {
                    _focusedDay = focusedDay;
                    _fetchEventsForMonth(focusedDay);
                    _selectedEvents.value = _getEventsForRange(
                        DateTime(_focusedDay.year, _focusedDay.month, 1),
                        DateTime(_focusedDay.year, _focusedDay.month + 1, 0));
                  },
                ),
              ),
              SizedBox(height: 24.h),
              Padding(
                padding: EdgeInsets.only(left: 16.w),
                child: Text(
                  'Lịch học của bạn',
                  style: defaultText16B.copyWith(fontWeight: FontWeight.w400),
                ),
              ),
              ValueListenableBuilder<List<ScheduleModel>>(
                valueListenable: _selectedEvents,
                builder: (context, value, _) {
                  List list1;
                  if (selectedHinhThuc == 'Lịch học ở trung tâm') {
                    list1 =
                        value.where((item) => item.typeLearn == "off").toList();
                  } else if (selectedHinhThuc == 'Lịch học Zoom') {
                    list1 = value
                        .where((item) => item.typeLearn == "zoom")
                        .toList();
                  } else if (selectedHinhThuc == 'Lịch học phụ đạo - học bù') {
                    list1 = [];
                  } else {
                    list1 = value;
                  }
                  return list1.isEmpty
                      ? Center(
                          child: Text(
                            'Không có lịch học',
                            style: defaultText16B,
                          ),
                        )
                      : ListView.builder(
                          shrinkWrap: true,
                          physics: const ScrollPhysics(),
                          itemCount: list1.length,
                          itemBuilder: (context, index) {
                            return ItemTableCalender(
                              model: list1[index],
                            );
                          },
                        );
                },
              ),
              SizedBox(height: 24.h),
            ],
          ),
        ),
      ),
    );
  }
}

Widget _buildEventsMarkerNum(List events) {
  return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [buildCalendarDayMarker(backColor: mainOrange)]);
}

AnimatedContainer buildCalendarDayMarker({
  required Color backColor,
}) {
  return AnimatedContainer(
    duration: const Duration(milliseconds: 300),
    decoration: BoxDecoration(
      shape: BoxShape.circle,
      color: backColor,
    ),
    width: 8.w,
    height: 8.h,
  );
}

class ItemTableCalender extends StatefulWidget {
  final ScheduleModel model;
  const ItemTableCalender({super.key, required this.model});

  @override
  State<ItemTableCalender> createState() => _ItemTableCalenderState();
}

class _ItemTableCalenderState extends State<ItemTableCalender> {
  final bool _isLoading = false;
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () async {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: ((context) => DetailLessonScreen(
                  typeLearn: widget.model.typeLearn,
                  checkinOffId: widget.model.checkinOffId ?? '',
                  meetingId: widget.model.meetingId ?? '',
                )),
          ),
        );
      },
      child: _isLoading
          ? SizedBox(
              height: 136.h,
              width: 343.w,
              child: Center(
                child: SizedBox(
                  width: 40.w,
                  height: 40.h,
                  child: const CircularProgressIndicator(),
                ),
              ),
            )
          : Container(
              margin: EdgeInsets.only(
                  top: 16.h, bottom: 10.h, left: 16.w, right: 16.w),
              padding: EdgeInsets.symmetric(
                horizontal: 16.w,
                vertical: 16.h,
              ),
              width: 343.w,
              //height: 136.h,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.all(Radius.circular(12.r)),
                boxShadow: [
                  BoxShadow(
                    color: const Color(0xff273D8C).withValues(alpha: 0.12),
                    blurRadius: 16,
                    spreadRadius: 0,
                    offset: const Offset(0, 4), // Shadow position
                  ),
                ],
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        padding: EdgeInsets.symmetric(horizontal: 12.w),
                        decoration: BoxDecoration(
                          color: mainBlue,
                          borderRadius: BorderRadius.all(
                            Radius.circular(12.r),
                          ),
                        ),
                        child: Text(
                          '${widget.model.createdDate.day}, Tháng ${widget.model.createdDate.month}',
                          style: defaultText14B.copyWith(
                            color: Colors.white,
                          ),
                        ),
                      ),
                      SizedBox(
                        width: 10.w,
                      ),
                      SvgPicture.asset(
                        'assets/icons/class_icon.svg',
                        width: 16.w,
                        height: 16.h,
                        colorFilter: ColorFilter.mode(
                          mainBlue,
                          BlendMode.srcIn,
                        ),
                      ),
                      Text(
                        ' Phòng ${widget.model.phongHocName} ${widget.model.cosoName}',
                        style: defaultText14SB,
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 10.h,
                  ),
                  Text(
                    widget.model.courseName,
                    style: defaultText16B,
                  ),
                  Text(
                    '${widget.model.timeStart.replaceRange(5, 8, '')} - ${widget.model.timeEnd.replaceRange(5, 8, '')}',
                    style: defaultText14M,
                  ),
                  SizedBox(
                    height: 6.h,
                  ),
                  GestureDetector(
                    onTap: () {
                      showLeaveReasonDialog(context,
                          typeLearn: widget.model.typeLearn,
                          checkinOffId: widget.model.checkinOffId ?? '',
                          meetingId: widget.model.meetingId ?? '');
                    },
                    child: Container(
                      width: 311.w,
                      height: 40.h,
                      decoration: BoxDecoration(
                        color: const Color(0xffFBF4F4),
                        borderRadius: BorderRadius.all(
                          Radius.circular(12.r),
                        ),
                        border: Border.all(
                          color: const Color(0xffF2C6C6),
                        ),
                      ),
                      child: Center(
                        child: Text(
                          'Xin nghỉ',
                          style: defaultText14M.copyWith(
                            color: mainRed,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
    );
  }
}
