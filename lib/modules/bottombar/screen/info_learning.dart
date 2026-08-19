import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:kiddo/l10n/l10n.dart';
import 'package:kiddo/main.dart';
import 'package:kiddo/modules/info_learning/detail_course_screen.dart';
import 'package:kiddo/modules/info_learning/list_course.dart';
import 'package:kiddo/modules/feature_home/hoc_lieu/list_hoc_lieu.dart';
import 'package:kiddo/utils/constants/color.dart';
import 'package:kiddo/utils/constants/styles.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class InfoLearingScreen extends StatelessWidget {
  const InfoLearingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller1 = PageController(viewportFraction: 1, keepPage: true);
    return Scaffold(
      backgroundColor: mainOrange, // nền AppBar
      appBar: AppBar(
        backgroundColor: mainOrange,
        elevation: 0,
        centerTitle: true,
        title: Text("Thông tin học viên",
            style: defaultText16B.copyWith(
              color: Colors.white,
            )),
        // leading: IconButton(
        //   icon: const Icon(Icons.arrow_back_ios_new, color: Colors.white),
        //   onPressed: () => Navigator.pop(context),
        // ),
        automaticallyImplyLeading: false,
        actions: [
          SvgPicture.asset(
            'assets/icons/bell.svg',
            width: 20.w,
            height: 20.h,
            colorFilter: ColorFilter.mode(
              Colors.white,
              BlendMode.srcIn,
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
            topLeft: Radius.circular(24.r),
            topRight: Radius.circular(24.r),
          ),
        ),
        child: SingleChildScrollView(
          child: Column(
            children: [
              SizedBox(
                height: 16.h,
              ),
              Text(
                "Khóa học",
                style: defaultText18B,
              ),
              SizedBox(height: 12.h),
              listClass.isEmpty
                  ? SizedBox(
                      height:
                          400.h, // Giới hạn chiều cao để tránh lỗi giao diện
                      child: const ListHocLieuBodyWidget(
                        shrinkWrap: true,
                        physics:
                            AlwaysScrollableScrollPhysics(), // Đặt scroll physics để cuộn được bên trong fixed height
                      ),
                    )
                  : SizedBox(
                      height: 190.h,
                      width: 375.w,
                      child: PageView.builder(
                        padEnds: false,
                        controller: controller1,
                        itemCount: listClass.length,
                        itemBuilder: (_, index) {
                          return Container(
                            height: 180.h,
                            width: 348.w,
                            margin: EdgeInsets.symmetric(
                                vertical: 5.h, horizontal: 16.w),
                            decoration: BoxDecoration(
                              color: const Color(0xFFF6F6F6),
                              borderRadius: BorderRadius.circular(12.r),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withValues(alpha: 0.1),
                                  blurRadius: 6,
                                  offset: const Offset(0, 3),
                                ),
                              ],
                            ),
                            child: Padding(
                              padding: EdgeInsets.symmetric(horizontal: 20.w),
                              child: Column(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    '${listClass[index].courseScheduleName} - ${listClass[index].courseName}',
                                    style: defaultText14M.copyWith(
                                        color: mainOrange),
                                  ),
                                  Text(
                                    "Thông tin khoá học:",
                                    style: defaultText14B,
                                  ),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      SvgPicture.asset(
                                        'assets/icons/class.svg',
                                        width: 16.w,
                                        height: 16.h,
                                      ),
                                      SizedBox(width: 12.h),
                                      Text(
                                        listClass[index].settingCourseTypeName,
                                        style: defaultText14M.copyWith(
                                          fontWeight: FontWeight.w400,
                                        ),
                                      ),
                                    ],
                                  ),
                                  Image.network(listClass[index].courseImg,
                                      height: 100.h, fit: BoxFit.fitHeight)
                                ],
                              ),
                            ),
                          );
                        },
                      ),
                    ),
              SizedBox(height: 10.h),
              SmoothPageIndicator(
                controller: controller1,
                count: listClass.length,
                effect: CustomizableEffect(
                  activeDotDecoration: DotDecoration(
                    width: 20.w,
                    height: 8.h,
                    color: mainOrange,
                    borderRadius: BorderRadius.circular(24),
                  ),
                  dotDecoration: DotDecoration(
                    width: 8.w,
                    height: 8.h,
                    color: Colors.grey,
                    borderRadius: BorderRadius.circular(16),
                    verticalOffset: 0,
                  ),
                  spacing: 6.0,
                ),
                onDotClicked: (index) {
                  controller1.animateToPage(index,
                      duration: const Duration(milliseconds: 300),
                      curve: Curves.easeInOut);
                },
              ),
              SizedBox(
                height: 16.h,
              ),
              if (listClass.isNotEmpty)
                GestureDetector(
                  onTap: () {
                    if (listClass.isEmpty) {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => Scaffold(
                            backgroundColor: mainOrange,
                            appBar: AppBar(
                              backgroundColor: mainOrange,
                              elevation: 0,
                              centerTitle: true,
                              title: Text(
                                L10n.of(context).detailCourse,
                                style: defaultText16B.copyWith(
                                    color: Colors.white),
                              ),
                              leading: IconButton(
                                onPressed: () => Navigator.pop(context),
                                icon: const Icon(
                                  Icons.arrow_back_ios,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                            body: Container(
                              width: double.infinity,
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.only(
                                  topLeft: Radius.circular(26.r),
                                  topRight: Radius.circular(26.r),
                                ),
                              ),
                              child: Center(
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Image.asset(
                                      'assets/images/empty2.png',
                                      width: 150.w,
                                      height: 150.h,
                                      fit: BoxFit.contain,
                                    ),
                                    SizedBox(height: 16.h),
                                    Text(
                                      "Không có dữ liệu",
                                      style: defaultText16B.copyWith(
                                          color: Colors.grey),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                      );
                      return;
                    }
                    final pageIndex = controller1.hasClients
                        ? (controller1.page?.round() ?? 0)
                        : 0;
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => DetailCourseScreen(
                          courseScheduleId:
                              listClass[pageIndex].courseScheduleId,
                          settingCourseTypeId:
                              listClass[pageIndex].settingCourseTypeId,
                        ),
                      ),
                    );
                  },
                  child: Container(
                    margin: EdgeInsets.symmetric(horizontal: 16.w),
                    padding: EdgeInsets.symmetric(
                      horizontal: 20.w,
                      vertical: 12.h,
                    ),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12.r),
                      color: const Color(0xffF5F7FA),
                      border: Border.all(
                        color: const Color(0xFF1D74FF).withValues(alpha: 0.2),
                      ),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(L10n.of(context).detailCourse,
                            style: defaultText14B),
                        Spacer(),
                        Icon(Icons.arrow_forward_ios, size: 16.sp),
                      ],
                    ),
                  ),
                ),
              SizedBox(
                height: 16.h,
              ),
              if (listClass.isNotEmpty)
                GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ListCourseScreen(),
                      ),
                    );
                  },
                  child: Container(
                    margin: EdgeInsets.symmetric(horizontal: 16.w),
                    padding: EdgeInsets.symmetric(
                      horizontal: 20.w,
                      vertical: 12.h,
                    ),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12.r),
                      color: const Color(0xffF5F7FA),
                      border: Border.all(
                        color: const Color(0xFF1D74FF).withValues(alpha: 0.2),
                      ),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(L10n.of(context).listCourse,
                            style: defaultText14B),
                        Spacer(),
                        Icon(Icons.arrow_forward_ios, size: 16.sp),
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
