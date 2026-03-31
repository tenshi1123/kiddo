import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:intl/intl.dart';
import 'package:kiddo/modules/notification/notification.dart';
import 'package:kiddo/teacher_model/roll_call_model.dart';
import 'package:kiddo/teacher_repo/teacher_info_repo.dart';
import 'package:kiddo/utils/constants/color.dart';
import 'package:kiddo/utils/constants/styles.dart';

class GioDayScreen extends StatefulWidget {
  const GioDayScreen({super.key});

  @override
  State<GioDayScreen> createState() => _GioDayScreenState();
}

class _GioDayScreenState extends State<GioDayScreen> {
  List<TeachingHourReportModel> listGioDay = [];
  @override
  void initState() {
    fetchData();
    super.initState();
  }

  Future<void> fetchData() async {
    try {
      final response = await TeacherInfoRepo().getTeachingHourReport();
      setState(() {
        listGioDay = response;
      });
    } catch (e) {
      debugPrint('Lỗi khi gọi API: $e');
      setState(() {});
    }
  }

  DateTime? startDate;
  DateTime? endDate;

  // Dữ liệu demo
  // final List<Map<String, dynamic>> lessonList = [
  //   {"date": "2025-10-01", "hours": 2, "minutes": 120},
  //   {"date": "2025-10-02", "hours": 2, "minutes": 120},
  //   {"date": "2025-10-03", "hours": 2, "minutes": 120},
  //   {"date": "2025-10-04", "hours": 2, "minutes": 120},
  // ];
  Future<void> _selectDate({required bool isStart}) async {
    final now = DateTime.now();
    final picked = await showDatePicker(
      context: context,
      initialDate: now,
      firstDate: DateTime(2020),
      lastDate: DateTime(2030),
      helpText: isStart ? "Chọn thời gian bắt đầu" : "Chọn thời gian kết thúc",
      locale: const Locale('vi', 'VN'),
      builder: (context, child) {
        return Localizations.override(
          context: context,
          locale: const Locale('vi', 'VN'),
          child: child!,
        );
      },
    );

    if (picked != null) {
      setState(() {
        if (isStart) {
          startDate = picked;
        } else {
          endDate = picked;
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Builder(builder: (context) {
      final totalMinutes = calculateTotalMinutes(listGioDay);

      final totalHours = totalMinutes ~/ 60;
      final remainingMinutes = totalMinutes % 60;
      return Scaffold(
        backgroundColor: mainOrange,
        appBar: AppBar(
          backgroundColor: mainOrange,
          elevation: 0,
          centerTitle: true,
          title: Text(
            'Báo cáo',
            style: defaultText16B.copyWith(color: Colors.white),
          ),
          leading: IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: const Icon(
              Icons.arrow_back_ios,
              color: Colors.white,
            ),
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
            height: double.infinity,
            padding: EdgeInsets.symmetric(vertical: 16.h),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(26.r),
                topRight: Radius.circular(26.r),
              ),
            ),
            child: SingleChildScrollView(
              padding: EdgeInsets.symmetric(vertical: 16.h),
              child: Column(
                children: [
                  // ======= Ô chọn ngày bắt đầu =======
                  Padding(
                    padding: EdgeInsetsGeometry.symmetric(horizontal: 16.w),
                    child: _buildDateField(
                      label: "Thời gian bắt đầu",
                      date: startDate,
                      onTap: () => _selectDate(isStart: true),
                    ),
                  ),
                  SizedBox(height: 12.h),
                  Padding(
                    padding: EdgeInsetsGeometry.symmetric(horizontal: 16.w),
                    child: _buildDateField(
                      label: "Thời gian kết thúc",
                      date: endDate,
                      onTap: () => _selectDate(isStart: false),
                    ),
                  ),
                  SizedBox(height: 16.h),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 16.w),
                    child: SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: () {
                          final filtered = filterByDate(
                            list: listGioDay,
                            startDate: startDate,
                            endDate: endDate,
                          );

                          setState(() {
                            listGioDay = filtered;
                          });
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xff1D7FE0),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10.r),
                          ),
                          padding: EdgeInsets.symmetric(vertical: 14.h),
                        ),
                        child: Text(
                          "Lọc",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 15.sp,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 20.h),
                  Container(
                    padding:
                        EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
                    decoration: BoxDecoration(
                      color: const Color(0xffFDF5EF),
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(16.r),
                        topRight: Radius.circular(16.r),
                      ),
                    ),
                    child: Column(
                      children: [
                        ...listGioDay.map(
                          (e) => Padding(
                            padding: EdgeInsets.only(bottom: 10.h),
                            child: _buildLessonItem(e),
                          ),
                        ),
                        const Icon(Icons.more_horiz, color: Colors.grey),
                        SizedBox(height: 16.h),
                        Container(
                          width: double.infinity,
                          padding: EdgeInsets.all(14.w),
                          decoration: BoxDecoration(
                            border: Border.all(color: const Color(0xffF06423)),
                            borderRadius: BorderRadius.circular(10.r),
                            color: Color(0xffF9F6F4),
                          ),
                          child: Text(
                            "Tổng số giờ dạy: $totalHours giờ $remainingMinutes phút",
                            textAlign: TextAlign.center,
                            style: defaultText14SB.copyWith(
                              color: mainOrange,
                              fontSize: 16.sp,
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 100.h,
                        )
                      ],
                    ),
                  ),
                ],
              ),
            )),
      );
    });
  }

  Widget _buildDateField({
    required String label,
    required DateTime? date,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 14.h),
        decoration: BoxDecoration(
          color: const Color(0xffF7F7F7),
          borderRadius: BorderRadius.circular(10.r),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              date == null ? label : DateFormat('yyyy-MM-dd').format(date),
              style: TextStyle(
                color: date == null ? Colors.grey : Colors.black,
                fontSize: 14.sp,
              ),
            ),
            const Icon(Icons.calendar_today, color: Colors.grey),
          ],
        ),
      ),
    );
  }

  Widget _buildLessonItem(TeachingHourReportModel e) {
    return Container(
      padding: EdgeInsets.all(14.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 6,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            width: 40.w,
            height: 40.w,
            decoration: const BoxDecoration(
              color: Colors.green,
              shape: BoxShape.circle,
            ),
            child: const Icon(Icons.access_time, color: Colors.white),
          ),
          SizedBox(width: 12.w),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                e.createdDate,
                style: defaultText14SB,
              ),
              Text(
                "${e.timeStart} - ${e.timeEnd}",
                style: defaultText14Re,
              ),
              Text(
                formatMinutes(
                  _parseTime(e.timeEnd)
                      .difference(_parseTime(e.timeStart))
                      .inMinutes,
                ),
                style: defaultText14Re,
              ),
            ],
          ),
        ],
      ),
    );
  }
}

DateTime _parseTime(String time) {
  final parts = time.split(":");
  return DateTime(
    0,
    1,
    1,
    int.parse(parts[0]),
    int.parse(parts[1]),
    int.parse(parts[2]),
  );
}

String formatMinutes(int totalMinutes) {
  final hours = totalMinutes ~/ 60;
  final minutes = totalMinutes % 60;

  return "$hours giờ $minutes phút";
}

DateTime parseCreatedDate(String date) {
  final parts = date.split("-");
  return DateTime(
    int.parse(parts[2]), // year
    int.parse(parts[1]), // month
    int.parse(parts[0]), // day
  );
}

List<TeachingHourReportModel> filterByDate({
  required List<TeachingHourReportModel> list,
  required DateTime? startDate,
  required DateTime? endDate,
}) {
  return list.where((item) {
    final created = parseCreatedDate(item.createdDate);

    if (startDate != null && created.isBefore(startDate)) {
      return false;
    }

    if (endDate != null && created.isAfter(endDate)) {
      return false;
    }

    return true;
  }).toList();
}
