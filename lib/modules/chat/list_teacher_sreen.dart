import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:kiddo/student_models/profile_model.dart';
import 'package:kiddo/utils/constants/color.dart';
import 'package:kiddo/utils/constants/styles.dart';
import 'package:kiddo/utils/widget/custom_widget.dart';

class ListTeacherScreen extends StatelessWidget {
  const ListTeacherScreen({super.key, required this.listTeacher});
  final List<ProfileModel> listTeacher;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(
              height: 150.h,
              child: Stack(
                children: [
                  Positioned(
                    top: 0,
                    child: Container(
                      width: 390.w,
                      height: 140.h,
                      decoration: BoxDecoration(gradient: mainGradient),
                    ),
                  ),
                  Positioned(
                    bottom: 30.h,
                    left: 20.w,
                    child: GestureDetector(
                      onTap: () {
                        Navigator.pop(context);
                      },
                      child: Row(
                        children: [
                          Icon(
                            Icons.keyboard_arrow_left,
                            size: 30.h,
                            color: Colors.white,
                          ),
                          Text(
                            'Giáo viên',
                            style: defaultText20B.copyWith(
                              color: Colors.white,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Positioned(
                    bottom: 0.h,
                    left: 250.w,
                    child: Image.asset(
                      'assets/images/chat_icon.png',
                      width: 117.w,
                      height: 115.h,
                      fit: BoxFit.fill,
                    ),
                  )
                ],
              ),
            ),
            SizedBox(
              height: 10.h,
            ),
            ListView.builder(
                shrinkWrap: true,
                padding: EdgeInsets.only(left: 20.w, right: 20.w, bottom: 20.w),
                physics: const ClampingScrollPhysics(),
                itemCount: listTeacher.length,
                itemBuilder: (BuildContext context, int index) {
                  return Padding(
                    padding: EdgeInsets.only(bottom: 10.h),
                    child: ConversationTeacher(
                      model: listTeacher[index],
                    ),
                  );
                }),
          ],
        ),
      ),
    );
  }
}
