import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:intl/intl.dart';
import 'package:kiddo/modules/bottombar/utils.dart';
import 'package:kiddo/modules/notification/notification.dart';
import 'package:kiddo/student_models/diem_danh_model.dart';
import 'package:kiddo/teacher_repo/teacher_schedule_repo.dart';
import 'package:kiddo/utils/constants/color.dart';
import 'package:kiddo/utils/constants/styles.dart';
import 'package:kiddo/utils/widget/custom_dialog.dart';
import 'package:kiddo/utils/widget/custom_widget.dart';
import 'package:table_calendar/table_calendar.dart';

class TeacherCalender extends StatefulWidget {
  const TeacherCalender({super.key});

  @override
  State<TeacherCalender> createState() => _TeacherCalenderState();
}

class _TeacherCalenderState extends State<TeacherCalender> {
  late ValueNotifier<List<ScheduleModel>> _selectedEvents;
  late ValueNotifier<List<AppointmentModel>> _selectedAppointments;

  CalendarFormat _calendarFormat = CalendarFormat.month;
  RangeSelectionMode _rangeSelectionMode = RangeSelectionMode.toggledOn;
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;
  DateTime? _rangeStart;
  DateTime? _rangeEnd;

  late List<ScheduleModel> _listLichHoc;
  late List<AppointmentModel> _listLichHen;

  final Map<DateTime, List<ScheduleModel>> _events = {};
  final Map<DateTime, List<AppointmentModel>> _appointments = {};
  final Map<DateTime, List<BaseCalendarEvent>> _eventsAll = {};
  final Set<String> _loadedMonths = {};
  String? selectedHinhThuc;
  bool isTeachingSelected = true;
  @override
  void initState() {
    super.initState();
    _selectedDay = _focusedDay;
    _listLichHoc = [];
    _selectedEvents = ValueNotifier(
      _getEventsForRange(
        DateTime(_focusedDay.year, _focusedDay.month, 1),
        DateTime(_focusedDay.year, _focusedDay.month + 1, 0),
      ),
    );
    _listLichHen = [];
    _selectedAppointments = ValueNotifier(
      _getAppointForRange(
        DateTime(_focusedDay.year, _focusedDay.month, 1),
        DateTime(_focusedDay.year, _focusedDay.month + 1, 0),
      ),
    );
    _fetchEventsForMonth(_focusedDay);
    _fetchAppointmentForMonth(_focusedDay);
  }

  @override
  void dispose() {
    _selectedEvents.dispose();
    _selectedAppointments.dispose();
    super.dispose();
  }

  Future<void> _fetchEventsForMonth(DateTime date) async {
    final key = '${date.year}-${date.month.toString().padLeft(2, '0')}';
    if (_loadedMonths.contains(key)) return;
    final start = DateTime(date.year, date.month, 1);
    final end = DateTime(date.year, date.month + 1, 0);
    final fetchedEvents = await TeacherScheduleRepo().getScheduleList(
      DateFormat('dd-MM-yyyy').format(start),
      DateFormat('dd-MM-yyyy').format(end),
    );
    if (fetchedEvents.isEmpty) return;
    setState(() {
      for (final e in fetchedEvents) {
        final day = DateTime(
            e.createdDate.year, e.createdDate.month, e.createdDate.day);
        _eventsAll.putIfAbsent(day, () => []).add(e);
      }
      _loadedMonths.add(key);
      if (_selectedDay != null) {
        _selectedEvents.value = _events[_selectedDay!] ?? [];
      }
    });
  }

  Future<void> _fetchAppointmentForMonth(DateTime date) async {
    final key = '${date.year}-${date.month.toString().padLeft(2, '0')}';
    if (_loadedMonths.contains(key)) return;
    final start = DateTime(date.year, date.month, 1);
    final end = DateTime(date.year, date.month + 1, 0);
    final fetchedEvents = await TeacherScheduleRepo().getAppointmentList(
      DateFormat('dd-MM-yyyy').format(start),
      DateFormat('dd-MM-yyyy').format(end),
    );
    if (fetchedEvents.isEmpty) return;
    setState(() {
      for (final e in fetchedEvents) {
        final day = DateTime(e.appointmentDate.year, e.appointmentDate.month,
            e.appointmentDate.day);
        _eventsAll.putIfAbsent(day, () => []).add(e);
      }
      _loadedMonths.add(key);
      if (_selectedDay != null) {
        _selectedAppointments.value = _appointments[_selectedDay!] ?? [];
      }
    });
  }

  Future<void> getAppointment(
      {required String dayStart, required String dayEnd}) async {
    _listLichHen =
        await TeacherScheduleRepo().getAppointmentList(dayStart, dayEnd);
    _selectedAppointments.value = _listLichHen;
  }

  List<AppointmentModel> _getAppointForDay(DateTime day) {
    getAppointment(
        dayStart: DateFormat('yyyy-MM-dd').format(day),
        dayEnd: DateFormat('yyyy-MM-dd').format(day));
    return _listLichHen;
  }

  List<AppointmentModel> _getAppointForRange(DateTime start, DateTime end) {
    getAppointment(
      dayStart: DateFormat('yyyy-MM-dd').format(start),
      dayEnd: DateFormat('yyyy-MM-dd').format(end),
    );
    return _listLichHen;
  }

  Future<void> getSchedule(
      {required String dayStart, required String dayEnd}) async {
    _listLichHoc =
        await TeacherScheduleRepo().getScheduleList(dayStart, dayEnd);
    _selectedEvents.value = removeDuplicateLessons(_listLichHoc);
  }

  List<ScheduleModel> _getEventsForDay(DateTime day) {
    getSchedule(
        dayStart: DateFormat('yyyy-MM-dd').format(day),
        dayEnd: DateFormat('yyyy-MM-dd').format(day));
    return _listLichHoc;
  }

  List<ScheduleModel> _getEventsForRange(DateTime start, DateTime end) {
    getSchedule(
      dayStart: DateFormat('yyyy-MM-dd').format(start),
      dayEnd: DateFormat('yyyy-MM-dd').format(end),
    );
    return removeDuplicateLessons(_listLichHoc);
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

  void _onAppointSelected(DateTime selectedDay, DateTime focusedDay) {
    if (!isSameDay(_selectedDay, selectedDay)) {
      setState(() {
        _selectedDay = selectedDay;
        _focusedDay = focusedDay;
        _rangeStart = null; // Important to clean those
        _rangeEnd = null;
        _rangeSelectionMode = RangeSelectionMode.toggledOff;
      });
      _selectedAppointments.value = _getAppointForDay(selectedDay);
    }
  }

  void _onRangeAppointment(
      DateTime? start, DateTime? end, DateTime focusedDay) {
    setState(() {
      _selectedDay = null;
      _focusedDay = focusedDay;
      _rangeStart = start;
      _rangeEnd = end;
      _rangeSelectionMode = RangeSelectionMode.toggledOn;
    });
    if (start != null && end != null) {
      _selectedAppointments.value = _getAppointForRange(start, end);
    } else if (start != null) {
      _selectedAppointments.value = _getAppointForDay(start);
    } else if (end != null) {
      _selectedAppointments.value = _getAppointForDay(end);
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
          "Lịch giảng dạy",
          style: defaultText16B.copyWith(
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
              Container(
                margin: EdgeInsets.symmetric(horizontal: 16.w),
                decoration: BoxDecoration(
                  color: Colors.black.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(47.r),
                ),
                child: Row(
                  children: [
                    // Nút "Lịch dạy"
                    Expanded(
                      child: GestureDetector(
                        onTap: () {
                          _fetchEventsForMonth(_focusedDay);
                          setState(() => isTeachingSelected = true);
                        },
                        child: AnimatedContainer(
                          duration: const Duration(milliseconds: 250),
                          height: 44.h,
                          decoration: BoxDecoration(
                            color: isTeachingSelected
                                ? mainGreen
                                : Colors.transparent,
                            borderRadius: BorderRadius.circular(50),
                          ),
                          alignment: Alignment.center,
                          child: Text('Lịch dạy',
                              style: defaultText14SB.copyWith(
                                color: isTeachingSelected
                                    ? Colors.white
                                    : Colors.black.withOpacity(0.7),
                              )),
                        ),
                      ),
                    ),
                    // Nút "Lịch hẹn"
                    Expanded(
                      child: GestureDetector(
                        onTap: () {
                          _fetchAppointmentForMonth(_focusedDay);
                          setState(() => isTeachingSelected = false);
                        },
                        child: AnimatedContainer(
                          duration: const Duration(milliseconds: 250),
                          height: 44.h,
                          decoration: BoxDecoration(
                            color: !isTeachingSelected
                                ? mainPurple
                                : Colors.transparent,
                            borderRadius: BorderRadius.circular(50),
                          ),
                          alignment: Alignment.center,
                          child: Text('Lịch hẹn',
                              style: defaultText14SB.copyWith(
                                color: !isTeachingSelected
                                    ? Colors.white
                                    : Colors.black.withOpacity(0.7),
                              )),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: 12.h,
              ),
              isTeachingSelected
                  ? Padding(
                      padding: EdgeInsetsGeometry.symmetric(horizontal: 16.w),
                      child: HinhThucHocDropdown(
                        value: selectedHinhThuc,
                        onChanged: (value) {
                          setState(() {
                            selectedHinhThuc = value;
                          });
                        },
                      ),
                    )
                  : SizedBox(),
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
                child: TableCalendar<BaseCalendarEvent>(
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
                      color: mainRed,
                    ),
                  ),
                  daysOfWeekHeight: 36.h,
                  calendarFormat: _calendarFormat,
                  rangeSelectionMode: _rangeSelectionMode,
                  eventLoader: (day) {
                    final d = DateTime(day.year, day.month, day.day);
                    return _eventsAll[d] ?? [];
                  },
                  startingDayOfWeek: StartingDayOfWeek.monday,
                  calendarBuilders: CalendarBuilders(
                    markerBuilder: (context, date, events) {
                      return events.isNotEmpty
                          ? _buildEventsMarkerNum(events)
                          : const SizedBox();
                    },
                  ),
                  calendarStyle: CalendarStyle(
                    // Use `CalendarStyle` to customize the UI
                    outsideDaysVisible: true,
                    isTodayHighlighted: true,

                    defaultTextStyle: defaultText14M,
                    weekendTextStyle: defaultText14M.copyWith(color: mainRed),
                    todayTextStyle:
                        defaultText14M.copyWith(color: Colors.white),
                    selectedDecoration: BoxDecoration(
                      color: isTeachingSelected ? mainGreen : mainPurple,
                      shape: BoxShape.rectangle,
                      borderRadius: BorderRadius.all(Radius.circular(10.r)),
                    ),
                    rangeStartDecoration: BoxDecoration(
                      color: isTeachingSelected ? mainGreen : mainPurple,
                      shape: BoxShape.rectangle,
                      borderRadius: BorderRadius.all(Radius.circular(10.r)),
                    ),
                    rangeEndDecoration: BoxDecoration(
                      color: isTeachingSelected ? mainGreen : mainPurple,
                      shape: BoxShape.rectangle,
                      borderRadius: BorderRadius.all(Radius.circular(10.r)),
                    ),
                    // withinRangeDecoration: BoxDecoration(
                    //   shape: BoxShape.rectangle,
                    //   borderRadius: BorderRadius.circular(10.r),
                    //   color: (isTeachingSelected ? mainGreen : mainPurple)
                    //       .withOpacity(0.15),
                    // ),
                    rangeHighlightColor: isTeachingSelected
                        ? mainGreen.withValues(alpha: 0.1)
                        : mainPurple.withValues(alpha: 0.1),
                    selectedTextStyle: TextStyle(color: Colors.white),
                    todayDecoration: BoxDecoration(
                      color: isTeachingSelected
                          ? mainGreen.withValues(alpha: 0.3)
                          : mainPurple.withValues(alpha: 0.3),
                      shape: BoxShape.rectangle,
                      borderRadius: BorderRadius.all(Radius.circular(10.r)),
                    ),
                  ),
                  onDaySelected:
                      isTeachingSelected ? _onDaySelected : _onAppointSelected,
                  onRangeSelected: isTeachingSelected
                      ? _onRangeSelected
                      : _onRangeAppointment,
                  onFormatChanged: (format) {
                    if (_calendarFormat != format) {
                      setState(() {
                        _calendarFormat = format;
                      });
                    }
                  },
                  onPageChanged: (focusedDay) {
                    _focusedDay = focusedDay;
                    if (isTeachingSelected) {
                      _fetchEventsForMonth(focusedDay);
                      _selectedEvents.value = _getEventsForRange(
                          DateTime(_focusedDay.year, _focusedDay.month, 1),
                          DateTime(_focusedDay.year, _focusedDay.month + 1, 0));
                    } else {
                      _fetchAppointmentForMonth(focusedDay);
                      _selectedAppointments.value = _getAppointForRange(
                          DateTime(_focusedDay.year, _focusedDay.month, 1),
                          DateTime(_focusedDay.year, _focusedDay.month + 1, 0));
                    }
                  },
                ),
              ),
              SizedBox(height: 24.h),
              Container(
                decoration: BoxDecoration(
                  color: Color(0xffFBF0E7),
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(24.r),
                    topRight: Radius.circular(24.r),
                  ),
                ),
                child: AnimatedSwitcher(
                  duration: Duration(milliseconds: 300),
                  child: isTeachingSelected
                      ? Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Padding(
                              padding: EdgeInsets.only(
                                left: 16.w,
                                top: 16.h,
                              ),
                              child: Text(
                                'Lịch dạy của bạn',
                                style: defaultText14B.copyWith(
                                    fontWeight: FontWeight.w400),
                              ),
                            ),
                            ValueListenableBuilder<List<ScheduleModel>>(
                              valueListenable: _selectedEvents,
                              builder: (context, value, _) {
                                List list1;
                                if (selectedHinhThuc ==
                                    'Lịch học ở trung tâm') {
                                  list1 = value
                                      .where(
                                          (item) => item.typeTeacher == "off")
                                      .toList();
                                } else if (selectedHinhThuc ==
                                    'Lịch học Zoom') {
                                  list1 = value
                                      .where(
                                          (item) => item.typeTeacher == "zoom")
                                      .toList();
                                } else if (selectedHinhThuc ==
                                    'Lịch học phụ đạo - học bù') {
                                  list1 = [];
                                } else {
                                  list1 = value;
                                }
                                return list1.isEmpty
                                    ? Center(
                                        child: Padding(
                                          padding: EdgeInsets.symmetric(
                                              vertical: 32.h),
                                          child: Text(
                                            'Chọn ngày để xem lịch dạy',
                                            style: defaultText16B,
                                          ),
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
                        )
                      : Column(
                          children: [
                            SizedBox(
                              height: 12.h,
                            ),
                            Row(
                              children: [
                                Text(
                                  '     Lịch hẹn học viên',
                                  style: defaultText14B.copyWith(
                                      fontWeight: FontWeight.w400),
                                ),
                              ],
                            ),
                            _selectedAppointments.value.isEmpty
                                ? Center(
                                    child: Padding(
                                      padding:
                                          EdgeInsets.symmetric(vertical: 32.h),
                                      child: Text(
                                        'Chọn ngày để xem lịch hẹn',
                                        style: defaultText16B,
                                      ),
                                    ),
                                  )
                                : ValueListenableBuilder<
                                    List<AppointmentModel>>(
                                    valueListenable: _selectedAppointments,
                                    builder: (BuildContext context, value,
                                        Widget? child) {
                                      return ListView.builder(
                                        shrinkWrap: true,
                                        physics: const ScrollPhysics(),
                                        itemCount: value.length,
                                        itemBuilder: (context, index) {
                                          var item = value[index];
                                          return GestureDetector(
                                            onTap: () {
                                              appointmentInfo(
                                                  context, 'Buổi 3');
                                            },
                                            child: Container(
                                              width: 350.w,
                                              margin: EdgeInsets.symmetric(
                                                  horizontal: 16.w,
                                                  vertical: 6.h),
                                              padding: EdgeInsets.symmetric(
                                                  horizontal: 12.w,
                                                  vertical: 12.h),
                                              decoration: BoxDecoration(
                                                borderRadius: BorderRadius.all(
                                                  Radius.circular(16.r),
                                                ),
                                                color: Colors.white,
                                              ),
                                              child: Row(
                                                children: [
                                                  Container(
                                                    width: 40.w,
                                                    height: 40.h,
                                                    padding:
                                                        EdgeInsets.symmetric(
                                                      horizontal: 8.w,
                                                      vertical: 8.h,
                                                    ),
                                                    decoration: BoxDecoration(
                                                      shape: BoxShape.circle,
                                                      color: mainPurple,
                                                    ),
                                                    child: Image.asset(
                                                        'assets/images/study.png'),
                                                  ),
                                                  SizedBox(
                                                    width: 16.w,
                                                  ),
                                                  Column(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: [
                                                      Text(
                                                        item.fullName,
                                                        style: defaultText14SB,
                                                      ),
                                                      SizedBox(
                                                        height: 2.h,
                                                      ),
                                                      Text(
                                                        '${item.time} - ${item.appointmentDate}',
                                                        style: defaultText12Re,
                                                      ),
                                                    ],
                                                  ),
                                                ],
                                              ),
                                            ),
                                          );
                                        },
                                      );
                                    },
                                  ),
                          ],
                        ),
                ),
              ),
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
      color: Colors.white,
      border: Border.all(
        color: backColor,
        width: 2.w,
      ),
    ),
    width: 6.w,
    height: 6.h,
  );
}
