import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:kiddo/main.dart';
import 'package:kiddo/modules/feature_home/chinh_sach/detail_chinh_sach.dart';
import 'package:kiddo/modules/notification/notification.dart';
import 'package:kiddo/utils/constants/color.dart';
import 'package:kiddo/utils/constants/styles.dart';

class ListCsachScreen extends StatefulWidget {
  const ListCsachScreen({
    super.key,
  });

  @override
  State<ListCsachScreen> createState() => _ListCsachScreenState();
}

class _ListCsachScreenState extends State<ListCsachScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: mainOrange,
        appBar: AppBar(
          backgroundColor: mainOrange,
          elevation: 0,
          centerTitle: true,
          title: Text(
            'Chính sách khoá học',
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
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => DetailChinhSachScreen(
                        id: item.courseScheduleId,
                        title: item.courseName,
                      ),
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
