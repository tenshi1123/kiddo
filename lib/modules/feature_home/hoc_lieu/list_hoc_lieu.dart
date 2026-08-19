import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';

import 'package:kiddo/modules/feature_home/hoc_lieu/video_course.dart';
import 'package:kiddo/modules/notification/notification.dart';
import 'package:kiddo/student_models/info_class_model.dart';
import 'package:kiddo/student_models/profile_model.dart';
import 'package:kiddo/student_repo/video_repo.dart';
import 'package:kiddo/utils/constants/color.dart';
import 'package:kiddo/utils/constants/styles.dart';
import 'package:persistent_bottom_nav_bar_v2/persistent_bottom_nav_bar_v2.dart';

class ListDocuments extends StatelessWidget {
  const ListDocuments({
    super.key,
    this.model,
  });
  final ProfileModel? model;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: mainOrange,
        appBar: AppBar(
          backgroundColor: mainOrange,
          elevation: 0,
          centerTitle: true,
          title: Text(
            'Học liệu khoá học',
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
        body: ListHocLieuBodyWidget(model: model),
    );
  }
}

class ListHocLieuBodyWidget extends StatefulWidget {
  final ProfileModel? model;
  final bool shrinkWrap;
  final ScrollPhysics? physics;

  const ListHocLieuBodyWidget({
    Key? key,
    this.model,
    this.shrinkWrap = false,
    this.physics,
  }) : super(key: key);

  @override
  State<ListHocLieuBodyWidget> createState() => _ListHocLieuBodyWidgetState();
}

class _ListHocLieuBodyWidgetState extends State<ListHocLieuBodyWidget> {
  late List<InfoClassModel> listClass;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchData();
  }

  Future<void> fetchData() async {
    try {
      final response = await VideoRepository().getListClass();
      if (mounted) {
        setState(() {
          listClass = response;
          isLoading = false;
        });
      }
    } catch (e) {
      debugPrint('Lỗi khi gọi API: $e');
      if (mounted) {
        setState(() {
          isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(26.r),
          topRight: Radius.circular(26.r),
        ),
      ),
      child: listClass.isEmpty
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.asset(
                    'assets/images/empty2.png',
                    width: 150.w,
                  ),
                  SizedBox(height: 16.h),
                  Text(
                    'Không có học liệu nào',
                    style: TextStyle(
                      fontSize: 16.sp,
                      color: Colors.grey,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            )
          : ListView.builder(
              shrinkWrap: widget.shrinkWrap,
              physics: widget.physics,
              padding: EdgeInsets.all(16.w),
              itemCount: listClass.length,
              itemBuilder: (context, index) {
                final item = listClass[index];
                return GestureDetector(
                  onTap: () async {
                    try {
                      // 1. Gọi API lấy dữ liệu video
                      var detailClassModel =
                          await VideoRepository().getListTopical(
                        typeId: listClass[index].typeId,
                        scheduleId: listClass[index].scheduleId,
                        courseId: listClass[index].courseId,
                      );

                      // Kiểm tra xem BuildContext còn tồn tại hay không trước khi điều hướng
                      if (!context.mounted) return;
                      pushWithoutNavBar(
                        context,
                        MaterialPageRoute(
                          builder: ((context) => VideoCourse(
                                courseVideoModel: detailClassModel,
                                model: widget.model,
                                typeId: listClass[index].typeId,
                                scheduleId: listClass[index].scheduleId,
                                courseId: listClass[index].courseId,
                              )),
                        ),
                      );
                    } catch (error) {
                      // Kiểm tra xem BuildContext còn tồn tại không trước khi hiển thị Dialog
                      if (!context.mounted) return;

                      // 3. Nếu gọi API bị lỗi, hiển thị thông báo
                      showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return AlertDialog(
                            title: const Text('Thông báo'),
                            content: const Text(
                                'Bạn đã hết thời gian xem video.'),
                            actions: <Widget>[
                              TextButton(
                                child: const Text('Đóng'),
                                onPressed: () {
                                  Navigator.of(context).pop(); // Đóng dialog
                                },
                              ),
                            ],
                          );
                        },
                      );
                    }
                  },
                  child: Container(
                    margin: EdgeInsets.only(bottom: 12.h),
                    padding: EdgeInsets.all(12.w),
                    decoration: BoxDecoration(
                      color: Colors.grey.shade100,
                      borderRadius: BorderRadius.circular(12.r),
                      border: Border.all(color: Colors.blue.shade100),
                    ),
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
                            Text(item.courseName, style: defaultText16B),
                            SizedBox(height: 4.h),
                            Text(item.typeName,
                                style: defaultText14M.copyWith(
                                  color: Colors.grey.shade600,
                                )),
                          ],
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
    );
  }
}
