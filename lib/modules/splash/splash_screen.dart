import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:kiddo/main.dart';
import 'package:kiddo/modules/bottombar/bottom_bar_screen.dart';
import 'package:kiddo/modules/bottombar/bottom_bar_ver2.dart';
import 'package:kiddo/modules/splash/onboarding.dart';
import 'package:kiddo/student_repo/home_repo.dart';
import 'package:kiddo/student_repo/login_repo.dart';
import 'package:kiddo/teacher_repo/teacher_class_repo.dart';
import 'package:kiddo/utils/constants/const_string.dart';
import 'package:shared_preferences/shared_preferences.dart';

Future<void> removeToken() async {
  final prefs = await SharedPreferences.getInstance();
  await prefs.remove('token');
  await prefs.remove(ConstString.type);
}

class Splshscreen extends StatefulWidget {
  const Splshscreen({super.key});

  @override
  State<Splshscreen> createState() => _SplshscreenState();
}

class _SplshscreenState extends State<Splshscreen> {
  @override
  void initState() {
    super.initState();
    _checkAuthAndNavigate(); // bỏ Timer, gọi thẳng
  }

  Future<void> _checkAuthAndNavigate() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final String? token = prefs.getString('token');
      final String? type = prefs.getString(ConstString.type);

      if (token == null || token.isEmpty || type == null || type.isEmpty) {
        await _goToOnboarding();
        return;
      }

      if (type == 'student') {
        try {
          listClass = await LoginRepo()
              .getListClass()
              .timeout(const Duration(seconds: 5));
          listCategory = await HomeRepo()
              .getCategories()
              .timeout(const Duration(seconds: 5));

          if (!mounted) return;

          if (listCategory.isNotEmpty) {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (_) => Bottombar2(index: 0)),
            );
          } else {
            await _goToOnboarding();
          }
        } catch (e) {
          await _goToOnboarding();
        }
      } else {
        try {
          listTeacherClass = await TeacherClassRepo()
              .getTeacherClass()
              .timeout(const Duration(seconds: 5));
          listCategory = await HomeRepo()
              .getCategories()
              .timeout(const Duration(seconds: 5));

          if (!mounted) return;

          if (listTeacherClass.isNotEmpty) {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (_) => BottombarTeacher(index: 0)),
            );
          } else {
            await _goToOnboarding();
          }
        } catch (e) {
          await _goToOnboarding();
        }
      }
    } catch (e) {
      await _goToOnboarding(); // safety net
    }
  }

  Future<void> _goToOnboarding() async {
    await removeToken();

    if (!mounted) return;

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (_) => const Onbonding(),
      ),
    );
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
