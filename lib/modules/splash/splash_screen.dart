import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:kiddo/main.dart';
import 'package:kiddo/modules/bottombar/bottom_bar_screen.dart';
import 'package:kiddo/modules/splash/onboarding.dart';
import 'package:kiddo/router/app_pages.dart';
import 'package:kiddo/router/app_router.dart';
import 'package:kiddo/student_repo/home_repo.dart';
import 'package:kiddo/student_repo/login_repo.dart';
import 'package:kiddo/teacher_repo/teacher_class_repo.dart';
import 'package:kiddo/utils/constants/const_string.dart';
import 'package:shared_preferences/shared_preferences.dart';

Future<void> removeToken() async {
  final prefs = await SharedPreferences.getInstance();
  await prefs.remove('token');
}

class Splshscreen extends StatefulWidget {
  const Splshscreen({super.key});

  @override
  State<Splshscreen> createState() => _SplshscreenState();
}

class _SplshscreenState extends State<Splshscreen> {
  bool checked = false;
  @override
  void initState() {
    super.initState();
    Timer(const Duration(seconds: 0), () async {
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      final String? token = prefs.getString('token');
      final String? type = prefs.getString(ConstString.type);
      checked = (token != null && token != '');
      if (checked) {
        if (type != null) {
          if (type == 'student') {
            listClass = await LoginRepo().getListClass();
            listCategory = await HomeRepo().getCategories();
            if (listClass.isNotEmpty) {
              AppRouter.toPage(
                context,
                AppPages.BottomNavBarPage,
              );
            } else {
              // remove token chỗ này
              await removeToken();
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (context) => const Onbonding(),
                ),
              );
            }
          } else {
            listTeacherClass = await TeacherClassRepo().getTeacherClass();
            listCategory = await HomeRepo().getCategories();
            if (listTeacherClass.isNotEmpty) {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (context) => BottombarTeacher(
                    index: 0,
                  ),
                ),
              );
            } else {
              // remove token chỗ này
              await removeToken();
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (context) => const Onbonding(),
                ),
              );
            }
          }
        } else {
          await removeToken();
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => const Onbonding(),
            ),
          );
        }
      } else {
        await removeToken();
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => const Onbonding(),
          ),
        );
      }
    });

    // Timer(
    //   const Duration(seconds: 2),
    //   () => Navigator.pushReplacement(
    //     context,
    //     MaterialPageRoute(
    //       builder: (context) => const Onbonding(),
    //     ),
    //   ),
    // );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Image.asset(
        "assets/images/splash.gif",
        height: 844.h,
        width: 390.w,
        fit: BoxFit.fill,
      ),
    );
  }
}
