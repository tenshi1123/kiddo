import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:kiddo/modules/lesson/detail_lesson_screen.dart';
import 'package:kiddo/student_models/my_course_model.dart';
import 'package:kiddo/student_repo/home_repo.dart';
import 'package:kiddo/utils/constants/color.dart';
import 'package:kiddo/utils/constants/styles.dart';
import 'package:kiddo/utils/widget/app_image.dart';

class DetailCourseScreen extends StatefulWidget {
  const DetailCourseScreen(
      {super.key,
      required this.courseScheduleId,
      required this.settingCourseTypeId});
  final String courseScheduleId;
  final String settingCourseTypeId;
  @override
  State<DetailCourseScreen> createState() => _DetailCourseScreenState();
}

class _DetailCourseScreenState extends State<DetailCourseScreen> {
  bool isLoading = true;
  DetailClass? data;
  @override
  void initState() {
    super.initState();
    fetchData();
  }

  Future<void> fetchData() async {
    try {
      final response = await HomeRepo().getDetailClass(
        courseScheduleId: widget.courseScheduleId,
        settingCourseTypeId: widget.settingCourseTypeId,
      );
      setState(() {
        data = response;
        isLoading = false;
      });
    } catch (e) {
      // Xử lý lỗi nếu cần
      debugPrint('Lỗi khi gọi API: $e');
      setState(() {
        isLoading = false;
      });
    }
  }

  int selectedTab = 0;
  @override
  Widget build(BuildContext context) {
    final filtered =
        selectedTab == 0 ? data?.daXayRa ?? [] : data?.chuaXayRa ?? [];
    return Scaffold(
      backgroundColor: mainOrange,
      appBar: AppBar(
        backgroundColor: mainOrange,
        elevation: 0,
        centerTitle: true,
        title: Text(
          'Chi tiết lớp học',
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
      ),
      body: Container(
        width: double.infinity,
        height: double.infinity,
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 20.h),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(26.r),
            topRight: Radius.circular(26.r),
          ),
        ),
        child: isLoading
            ? Center(
                child: CircularProgressIndicator(),
              )
            : Column(
                children: [
                  Row(
                    children: [
                      Image.asset(
                        'assets/images/computer.png',
                        height: 40.h,
                        width: 40.w,
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: EdgeInsets.only(left: 12.w),
                            child: Text(
                              data?.info.name ?? '',
                              style: defaultText14SB.copyWith(fontSize: 16.sp),
                            ),
                          ),
                          // Padding(
                          //   padding: EdgeInsets.only(left: 12.w, top: 4.h),
                          //   child: Text(
                          //     data?.info.settingCourseTypeName ?? '',
                          //     style: defaultText14Re,
                          //   ),
                          // ),
                        ],
                      ),
                    ],
                  ),
                  SizedBox(height: 16.h),
                  AppImage(
                    url: data?.info.courseImg ?? '',
                    width: 343.w,
                    fit: BoxFit.fitWidth,
                  ),
                  // Image.asset(
                  //   'assets/images/detail.png',
                  //   width: 343.w,
                  //   fit: BoxFit.fitWidth,
                  // ),
                  SizedBox(height: 16.h),
                  Container(
                    padding: const EdgeInsets.all(4),
                    decoration: BoxDecoration(
                      color: Color(0xffF2E8E8),
                      borderRadius: BorderRadius.circular(30),
                    ),
                    child: Row(
                      children: [
                        Expanded(
                          child: GestureDetector(
                            onTap: () => setState(() => selectedTab = 0),
                            child: Container(
                              padding: const EdgeInsets.symmetric(vertical: 10),
                              decoration: BoxDecoration(
                                color: selectedTab == 0
                                    ? Colors.white
                                    : Colors.transparent,
                                borderRadius: BorderRadius.circular(30),
                              ),
                              alignment: Alignment.center,
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    "Đã diễn ra ",
                                    style: defaultText14M.copyWith(
                                      color: selectedTab == 0
                                          ? colorText
                                          : colorText.withValues(alpha: 0.8),
                                    ),
                                  ),
                                  Container(
                                      margin: const EdgeInsets.only(left: 6),
                                      padding: EdgeInsets.symmetric(
                                          horizontal: 8.w, vertical: 2.h),
                                      decoration: BoxDecoration(
                                        color: selectedTab == 0
                                            ? mainOrange
                                            : Color(0xffC9B2A5),
                                        borderRadius:
                                            BorderRadius.circular(24.r),
                                      ),
                                      child: Text(
                                        (data?.cntDaDienRa ?? 0).toString(),
                                        style: defaultText14SB.copyWith(
                                          color: Colors.white,
                                          fontSize: 12.sp,
                                        ),
                                      ))
                                ],
                              ),
                            ),
                          ),
                        ),
                        Expanded(
                          child: GestureDetector(
                            onTap: () => setState(() => selectedTab = 1),
                            child: Container(
                              padding: const EdgeInsets.symmetric(vertical: 10),
                              decoration: BoxDecoration(
                                color: selectedTab == 1
                                    ? Colors.white
                                    : Colors.transparent,
                                borderRadius: BorderRadius.circular(30),
                              ),
                              alignment: Alignment.center,
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    "Chưa diễn ra",
                                    style: defaultText14M.copyWith(
                                      color: selectedTab == 1
                                          ? colorText
                                          : colorText.withValues(alpha: 0.8),
                                    ),
                                  ),
                                  Container(
                                      margin: const EdgeInsets.only(left: 6),
                                      padding: EdgeInsets.symmetric(
                                          horizontal: 8.w, vertical: 2.h),
                                      decoration: BoxDecoration(
                                        color: selectedTab == 1
                                            ? mainOrange
                                            : Color(0xffC9B2A5),
                                        borderRadius:
                                            BorderRadius.circular(24.r),
                                      ),
                                      child: Text(
                                        (data?.cntChuaDienRa ?? 0).toString(),
                                        style: defaultText14SB.copyWith(
                                          color: Colors.white,
                                          fontSize: 12.sp,
                                        ),
                                      ))
                                ],
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 8.h),
                  filtered.isNotEmpty
                      ? Expanded(
                          child: ListView.builder(
                            itemCount: filtered.length,
                            padding: EdgeInsets.symmetric(
                                horizontal: 12.w, vertical: 6.h),
                            itemBuilder: (context, index) {
                              return GestureDetector(
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: ((context) => DetailLessonScreen(
                                            typeLearn:
                                                filtered[index].typeLearn,
                                            checkinOffId:
                                                filtered[index].checkinOffId,
                                            meetingId:
                                                filtered[index].meetingId,
                                          )),
                                    ),
                                  );
                                },
                                child: Container(
                                    margin: EdgeInsets.only(bottom: 12.h),
                                    padding: EdgeInsets.symmetric(
                                        horizontal: 16.w, vertical: 16.h),
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.circular(12),
                                      boxShadow: [
                                        BoxShadow(
                                          color: Colors.black12,
                                          blurRadius: 8,
                                          offset: const Offset(0, 4),
                                        ),
                                      ],
                                    ),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          filtered[index].typeLearn == 'zoom'
                                              ? 'Phòng học zoom'
                                              : '${filtered[index].phongHocName} - ${filtered[index].cosoName}',
                                          style: defaultText14M,
                                        ),
                                        Text(
                                          '${filtered[index].name} : ${filtered[index].lessonTopic}',
                                          style: defaultText16B,
                                        ),
                                        Text(
                                          "Nội dung buổi học: ${filtered[index].content}",
                                          style: defaultText14M,
                                        ),
                                      ],
                                    )),
                              );
                            },
                          ),
                        )
                      : Center(
                          child: Text(
                            'Không có buổi học nào',
                            style: defaultText14M,
                          ),
                        ),
                ],
              ),
      ),
    );
  }
}
