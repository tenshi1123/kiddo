import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:intl/intl.dart';
import 'package:kiddo/modules/notification/notification.dart';
import 'package:kiddo/teacher_model/roll_call_model.dart';
import 'package:kiddo/teacher_modules/teacher_bottombar/screen/bao_cao/gio_day_screen.dart';
import 'package:kiddo/teacher_repo/teacher_info_repo.dart';
import 'package:kiddo/utils/constants/color.dart';
import 'package:kiddo/utils/constants/styles.dart';
import 'package:kiddo/utils/widget/custom_sumary.dart';

class BaoCaoScreen extends StatefulWidget {
  const BaoCaoScreen({
    super.key,
  });

  @override
  State<BaoCaoScreen> createState() => _BaoCaoScreenState();
}

class _BaoCaoScreenState extends State<BaoCaoScreen> {
  int selectedTab = 0;
  DataBaoCaoModel report = DataBaoCaoModel(
    infoReport: InfoReportModel(total: 0, off: 0, zoom: 0),
    cntToday: 0,
    teachingHourReport: [],
  );
  @override
  void initState() {
    fetchData();
    super.initState();
  }

  Future<void> fetchData() async {
    try {
      final response = await TeacherInfoRepo().getInfoReport();
      setState(() {
        report = response;
      });
    } catch (e) {
      debugPrint('Lỗi khi gọi API: $e');
      setState(() {});
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
          padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(26.r),
              topRight: Radius.circular(26.r),
            ),
          ),
          child: Column(
            children: [
              ClassSummaryWidget(
                zoomCount: report.infoReport.zoom,
                offlineCount: report.infoReport.off,
              ),
              SizedBox(
                height: 20.h,
              ),

              // ====== DANH SÁCH LỚP ======
              Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  color: const Color(0xffF9F9F9),
                  borderRadius: BorderRadius.circular(16.r),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // ====== HEADER CARD ======
                    Container(
                      padding: EdgeInsets.all(16.w),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(12.r),
                        border: Border.all(color: const Color(0xffD3E2FF)),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.05),
                            blurRadius: 8,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: Row(
                        children: [
                          Container(
                            width: 44.w,
                            height: 44.w,
                            padding: EdgeInsets.all(6),
                            decoration: const BoxDecoration(
                              color: Color(0xff1D7FE0),
                              shape: BoxShape.circle,
                            ),
                            child: Image.asset('assets/images/computer.png'),
                          ),
                          SizedBox(width: 12.w),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "Lớp dạy ngày hôm nay",
                                  style: defaultText14SB.copyWith(
                                    fontSize: 16.sp,
                                  ),
                                ),
                                SizedBox(height: 4.h),
                                Text(
                                  DateFormat('yyyy-MM-dd')
                                      .format(DateTime.now()),
                                  style: TextStyle(
                                    fontSize: 13.sp,
                                    color: Colors.grey.shade600,
                                  ),
                                ),
                              ],
                            ),
                          ),

                          // Số lượng lớp
                          Text(
                            report.cntToday.toString(),
                            style: defaultText20B.copyWith(
                              color: mainRed,
                            ),
                          ),
                        ],
                      ),
                    ),
                    _buildClassItem(
                        "Lớp Orca 56", "Học trực tiếp tại trung tâm"),
                    Divider(color: Colors.grey.shade300, height: 1),
                    _buildClassItem("Lớp couple", "Lớp học Zoom"),
                  ],
                ),
              ),
              SizedBox(height: 12.h),

              // ====== NÚT XEM SỐ GIỜ DẠY ======
              GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => GioDayScreen(),
                    ),
                  );
                },
                child: Container(
                  width: double.infinity,
                  padding:
                      EdgeInsets.symmetric(vertical: 14.h, horizontal: 16.w),
                  decoration: BoxDecoration(
                    color: const Color(0xffF9FBFF),
                    borderRadius: BorderRadius.circular(12.r),
                    border: Border.all(color: const Color(0xffD3E2FF)),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "Xem số giờ dạy",
                        style: TextStyle(
                          fontSize: 14.sp,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const Icon(Icons.arrow_forward_ios, size: 16),
                    ],
                  ),
                ),
              ),
            ],
          )),
    );
  }
}

Widget _buildClassItem(String title, String subtitle) {
  return Padding(
    padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Text(
          title,
          style: defaultText14SB.copyWith(
            fontSize: 16.sp,
          ),
        ),
        SizedBox(height: 4.h),
        Text(
          subtitle,
          style: TextStyle(fontSize: 13.sp, color: Colors.grey.shade600),
        ),
      ],
    ),
  );
}
