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

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      try {
        final prefs = await SharedPreferences.getInstance();
        final token = prefs.getString('token');
        final type = prefs.getString(ConstString.type);

        if (token == null || token.isEmpty) {
          await _goToOnboarding();
          return;
        }
        if (type == null) {
          await _goToOnboarding();
          return;
        }
        if (type == 'student') {
          listClass = await LoginRepo()
              .getListClass()
              .timeout(const Duration(seconds: 3));

          listCategory = await HomeRepo()
              .getCategories()
              .timeout(const Duration(seconds: 3));

          if (!mounted) return;

          if (listCategory.isNotEmpty) {
            AppRouter.toPage(context, AppPages.BottomNavBarPage);
          } else {
            await _goToOnboarding();
          }
        } else {
          listTeacherClass = await TeacherClassRepo().getTeacherClass();
          listCategory = await HomeRepo().getCategories();

          if (!mounted) return;

          if (listTeacherClass.isNotEmpty) {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (_) => BottombarTeacher(index: 0),
              ),
            );
          } else {
            await _goToOnboarding();
          }
        }
      } catch (e) {
        // BẤT KỲ lỗi nào cũng về onboarding
        await _goToOnboarding();
      }
    });
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
