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
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _checkAuthAndNavigate();
    });
  }

  Future<void> _checkAuthAndNavigate() async {
    debugPrint('[Splash] 🚀 Bắt đầu kiểm tra auth...');
    try {
      final prefs = await SharedPreferences.getInstance();
      final String? token = prefs.getString('token');
      final String? type = prefs.getString(ConstString.type);

      debugPrint(
          '[Splash] 🔑 token: ${token != null ? "có" : "null"} | type: $type');

      if (token == null || token.isEmpty || type == null || type.isEmpty) {
        debugPrint('[Splash] ➡️ Không có token → onboarding');
        await _goToOnboarding();
        return;
      }

      if (type == 'student') {
        await _handleStudentFlow(token);
      } else {
        await _handleTeacherFlow(token);
      }
    } catch (e) {
      debugPrint('[Splash] ❌ Lỗi ngoài cùng: $e → onboarding');
      await _goToOnboarding();
    }
  }

  Future<void> _handleStudentFlow(String token) async {
    debugPrint('[Splash] 👤 Student flow...');
    try {
      // ✅ FIX: Khởi động 2 Future song song giữ đúng kiểu dữ liệu
      // (Future.wait trả về List<dynamic> gây lỗi type assignment)
      debugPrint('[Splash] 📡 Gọi getListClass + getCategories...');
      final classFuture =
          LoginRepo().getListClass().timeout(const Duration(seconds: 8));
      final categoryFuture =
          HomeRepo().getCategories().timeout(const Duration(seconds: 8));

      listClass = await classFuture;
      listCategory = await categoryFuture;

      debugPrint(
          '[Splash] ✅ Student: ${listClass.length} lớp | ${listCategory.length} category');
      if (listClass.isEmpty || listCategory.isEmpty) {
        debugPrint('[Splash] ⚠️ listClass hoặc listCategory rỗng → onboarding');
        await _goToOnboarding();
        return;
      }
      if (!mounted) {
        debugPrint(
            '[Splash] ⚠️ Widget unmounted sau student API – bỏ navigate');
        return;
      }

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => Bottombar2(index: 0)),
      );
      debugPrint('[Splash] ✅ Navigate → Bottombar2 (student)');
    } on TimeoutException {
      debugPrint('[Splash] ⏱️ Student API timeout → onboarding');
      await _goToOnboarding();
    } catch (e) {
      debugPrint('[Splash] ❌ Student API lỗi: $e → onboarding');
      await _goToOnboarding();
    }
  }

  Future<void> _handleTeacherFlow(String token) async {
    debugPrint('[Splash] 👨‍🏫 Teacher flow...');
    try {
      // ✅ FIX: Khởi động 2 Future song song giữ đúng kiểu dữ liệu
      debugPrint('[Splash] 📡 Gọi getTeacherClass + getCategories...');
      final teacherClassFuture = TeacherClassRepo()
          .getTeacherClass()
          .timeout(const Duration(seconds: 8));
      final categoryFuture =
          HomeRepo().getCategories().timeout(const Duration(seconds: 8));

      listTeacherClass = await teacherClassFuture;
      listCategory = await categoryFuture;

      debugPrint(
          '[Splash] ✅ Teacher: ${listTeacherClass.length} lớp | ${listCategory.length} category');

      if (!mounted) {
        debugPrint(
            '[Splash] ⚠️ Widget unmounted sau teacher API – bỏ navigate');
        return;
      }

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => BottombarTeacher(index: 0)),
      );
      debugPrint('[Splash] ✅ Navigate → BottombarTeacher');
    } on TimeoutException {
      debugPrint('[Splash] ⏱️ Teacher API timeout → onboarding');
      await _goToOnboarding();
    } catch (e) {
      debugPrint('[Splash] ❌ Teacher API lỗi: $e → onboarding');
      await _goToOnboarding();
    }
  }

  Future<void> _goToOnboarding() async {
    debugPrint('[Splash] 🗑️ Xóa token...');
    await removeToken();

    if (!mounted) {
      debugPrint('[Splash] ⚠️ Widget unmounted – không navigate onboarding');
      return;
    }

    debugPrint('[Splash] ➡️ Navigate → Onboarding');
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
