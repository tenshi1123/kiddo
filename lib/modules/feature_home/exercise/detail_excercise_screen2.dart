import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:kiddo/modules/notification/notification.dart';
import 'package:kiddo/student_models/diem_danh_model.dart';
import 'package:kiddo/student_models/excercise_model.dart';
import 'package:kiddo/student_repo/home_repo.dart';
import 'package:kiddo/utils/constants/color.dart';
import 'package:kiddo/utils/constants/styles.dart';
import 'package:url_launcher/url_launcher.dart';

class DetailExcerciseScreen extends StatefulWidget {
  const DetailExcerciseScreen({
    super.key,
    required this.model,
  });
  final ClassModel model;

  @override
  State<DetailExcerciseScreen> createState() => _DetailExcerciseScreenState();
}

class _DetailExcerciseScreenState extends State<DetailExcerciseScreen> {
  bool isLoading = true;
  List<HomeWorkModel> listBaiTap = [];
  @override
  void initState() {
    super.initState();
    _fetchData();
  }

  Future<void> _fetchData() async {
    try {
      final data = await HomeRepo()
          .getListBaiTap(id: widget.model.customerCourseScheduleId);
      setState(() {
        listBaiTap = data;
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        isLoading = false;
      });
      debugPrint('Error fetching data: $e');
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
          'Theo dõi kết quả bài tập',
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
      body: isLoading
          ? CircularProgressIndicator()
          : Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(26.r),
                  topRight: Radius.circular(26.r),
                ),
              ),
              child: Column(
                children: [
                  Container(
                    margin: EdgeInsets.only(bottom: 12.h),
                    padding: EdgeInsets.all(12.w),
                    child: Row(
                      children: [
                        Image.asset(
                          'assets/images/computer.png',
                          width: 40.w,
                          height: 40.h,
                        ),
                        SizedBox(width: 12.w),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(widget.model.courseName,
                                style: defaultText16B),
                            SizedBox(height: 4.h),
                            Text(
                              widget.model.settingCourseTypeName,
                              style: defaultText14Re,
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  listBaiTap.isEmpty
                      ? Center(
                          child: Center(
                            child: Image.asset(
                              'assets/images/empty2.png',
                              height: 300.h,
                              width: 300.w,
                            ),
                          ),
                        )
                      : ListView.separated(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          separatorBuilder: (_, __) => SizedBox(height: 12.h),
                          itemCount: listBaiTap.length,
                          itemBuilder: (context, index) {
                            return GestureDetector(
                              onTap: () async {
                                if (!await launchUrl(Uri.parse(
                                    listBaiTap[index].urlFileLesson))) {
                                  throw Exception('Could not launch ');
                                }
                              },
                              child: Container(
                                width: 343.w,
                                margin: EdgeInsets.symmetric(horizontal: 16.w),
                                padding: EdgeInsets.symmetric(
                                    vertical: 16.h, horizontal: 16.w),
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(16.r),
                                  boxShadow: [
                                    BoxShadow(
                                      color: colorText
                                          .withValues(alpha: 0.8)
                                          .withOpacity(0.2),
                                      spreadRadius: 2,
                                      blurRadius: 5,
                                      offset: const Offset(0, 3),
                                    ),
                                  ],
                                ),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      listBaiTap[index].name,
                                      style: defaultText16B,
                                    ),
                                    SizedBox(
                                      height: 20.h,
                                    ),
                                    Row(
                                      children: [
                                        SizedBox(
                                          width: 100.w,
                                          child: Text(
                                            'Deadline:',
                                            style: defaultText14M.copyWith(
                                                color: colorText.withValues(
                                                    alpha: 0.8)),
                                          ),
                                        ),
                                        SizedBox(width: 8.w),
                                        Text(
                                          listBaiTap[index].timeDeadline,
                                          style: defaultText14SB,
                                        ),
                                      ],
                                    ),
                                    SizedBox(
                                      height: 12.h,
                                    ),
                                    Row(
                                      children: [
                                        SizedBox(
                                          width: 100.w,
                                          child: Text(
                                            'Ngày nộp:',
                                            style: defaultText14M.copyWith(
                                                color: colorText.withValues(
                                                    alpha: 0.8)),
                                          ),
                                        ),
                                        SizedBox(width: 8.w),
                                        Text(
                                          listBaiTap[index].daySubmit,
                                          style: defaultText14SB,
                                        ),
                                      ],
                                    ),
                                    SizedBox(
                                      height: 12.h,
                                    ),
                                    Row(
                                      children: [
                                        SizedBox(
                                          width: 100.w,
                                          child: Text(
                                            'Trạng thái:',
                                            style: defaultText14M.copyWith(
                                                color: colorText.withValues(
                                                    alpha: 0.8)),
                                          ),
                                        ),
                                        SizedBox(width: 8.w),
                                        Container(
                                          padding: EdgeInsets.symmetric(
                                              horizontal: 8.w),
                                          height: 24.h,
                                          decoration: BoxDecoration(
                                            color: mainGreen,
                                            borderRadius:
                                                BorderRadius.circular(6.r),
                                          ),
                                          child: Center(
                                            child: Text(
                                              listBaiTap[index]
                                                          .isSubmitHomework ==
                                                      '1'
                                                  ? 'Đã nộp'
                                                  : 'Chưa nộp',
                                              style: defaultText12B.copyWith(
                                                  color: Colors.white),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                    SizedBox(
                                      height: 12.h,
                                    ),
                                    Row(
                                      children: [
                                        SizedBox(
                                          width: 100.w,
                                          child: Text(
                                            'Điểm:',
                                            style: defaultText14M.copyWith(
                                              color: colorText.withValues(
                                                  alpha: 0.8),
                                            ),
                                          ),
                                        ),
                                        SizedBox(width: 8.w),
                                        Text(
                                          listBaiTap[index].finalMark,
                                          style: defaultText14SB,
                                        ),
                                      ],
                                    ),
                                    SizedBox(
                                      height: 12.h,
                                    ),
                                    Text(
                                      'Nhận xét:',
                                      style: defaultText14M.copyWith(
                                        color: colorText.withValues(alpha: 0.8),
                                      ),
                                    ),
                                    Container(
                                      width: double.infinity,
                                      margin: EdgeInsets.only(top: 8.h),
                                      padding: EdgeInsets.symmetric(
                                          vertical: 12.h, horizontal: 12.w),
                                      decoration: BoxDecoration(
                                        color: state2,
                                        borderRadius:
                                            BorderRadius.circular(8.r),
                                      ),
                                      child: Text(
                                        listBaiTap[index].note,
                                        style: defaultText14M.copyWith(
                                          color:
                                              colorText.withValues(alpha: 0.6),
                                        ),
                                      ),
                                    )
                                  ],
                                ),
                              ),
                            );
                          },
                        ),
                ],
              ),
            ),
    );
  }
}
