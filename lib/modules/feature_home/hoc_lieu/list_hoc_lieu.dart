import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:kiddo/main.dart';
import 'package:kiddo/modules/feature_home/hoc_lieu/video_course.dart';
import 'package:kiddo/modules/notification/notification.dart';
import 'package:kiddo/student_models/info_class_model.dart';
import 'package:kiddo/student_repo/video_repo.dart';
import 'package:kiddo/utils/constants/color.dart';
import 'package:kiddo/utils/constants/styles.dart';
import 'package:persistent_bottom_nav_bar_v2/persistent_bottom_nav_bar_v2.dart';

class ListDocuments extends StatefulWidget {
  const ListDocuments({
    super.key,
  });

  @override
  State<ListDocuments> createState() => _ListDocumentsState();
}

class _ListDocumentsState extends State<ListDocuments> {
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
        body: Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(26.r),
              topRight: Radius.circular(26.r),
            ),
          ),
          child: ListView.builder(
            padding: EdgeInsets.all(16.w),
            itemCount: listClass.length,
            itemBuilder: (context, index) {
              final item = listClass[index];
              return GestureDetector(
                onTap: () async {
                  CourseVideoModel detailClassModel =
                      await VideoRepository().getListTopical(
                    typeId: listClass[index].settingCourseTypeId,
                    scheduleId: listClass[index].courseScheduleId,
                    courseId: listClass[index].courseId,
                  );
                  if (!context.mounted) return;
                  pushWithoutNavBar(
                    context,
                    MaterialPageRoute(
                      builder: ((context) => VideoCourse(
                            courseVideoModel: detailClassModel,
                          )),
                    ),
                  );
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
                          Text(item.settingCourseTypeName,
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
        ));
  }
}
