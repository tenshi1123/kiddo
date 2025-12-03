import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:kiddo/modules/login/student_login_screen.dart';
import '../../utils/constants/color.dart';
import '../login/teacher_login_screen.dart';

class WellcomeScreen extends StatelessWidget {
  const WellcomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xff00AEEF),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              "assets/images/wellcome.png",
              width: 195.w,
              height: 139.h,
              fit: BoxFit.fill,
            ),
            SizedBox(
              height: 40.h,
            ),
            InkWell(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: ((context) => const TeacherLoginScreen()),
                  ),
                );
              },
              child: Container(
                height: 48.h,
                width: 340.w,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(9.r),
                  color: const Color(0xffEFF6FF),
                ),
                child: Center(
                  child: Text(
                    'Đăng nhập với vai trò Học Sinh',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: mainBlue,
                      fontSize: 14.sp,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
              ),
            ),
            SizedBox(
              height: 15.h,
            ),
            InkWell(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: ((context) => const StudentLogin(
                        //type: 'ph',
                        )),
                  ),
                );
              },
              child: Container(
                height: 48.h,
                width: 340.w,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(9.r),
                  color: const Color(0xffEFF6FF),
                ),
                child: Center(
                  child: Text(
                    'Đăng nhập với vai trò Giáo Viên',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: mainBlue,
                      fontSize: 14.sp,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
              ),
            ),
            SizedBox(
              height: 15.h,
            ),
          ],
        ),
      ),
    );
  }
}
