// ignore_for_file: library_private_types_in_public_api

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:kiddo/modules/login/student_login_screen.dart';
import 'package:kiddo/modules/login/teacher_login_screen.dart';
import 'package:kiddo/utils/constants/color.dart';

import '../../../utils/constants/mediaqury.dart';
import '../../../utils/constants/vn_languegua.dart';
import '../../utils/constants/styles.dart';

class Onbonding extends StatefulWidget {
  const Onbonding({super.key});

  @override
  _OnbondingState createState() => _OnbondingState();
}

class _OnbondingState extends State<Onbonding> {
  final int _numPages = 3;

  final PageController _pageController = PageController(initialPage: 0);
  int _currentPage = 0;

  List<Widget> _buildPageIndicator() {
    List<Widget> list = [];
    for (int i = 0; i < _numPages; i++) {
      list.add(i == _currentPage ? _indicator(true) : _indicator(false));
    }
    return list;
  }

  late bool isLoading;

  @override
  void initState() {
    isLoading = true;
    Future.delayed(const Duration(seconds: 2), () {
      setState(() {
        isLoading = false;
      });
    });
    super.initState();
  }

  Widget _indicator(bool isActive) {
    return AnimatedContainer(
      duration: const Duration(microseconds: 150),
      margin: const EdgeInsets.symmetric(horizontal: 3.0),
      height: 8.h,
      width: isActive ? 20.w : 8.h,
      decoration: BoxDecoration(
        color: isActive ? const Color(0xff28B4E9) : Colors.white,
        borderRadius: BorderRadius.all(
          Radius.circular(100.r),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    height = MediaQuery.of(context).size.height;
    width = MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor: Colors.white,
      body: AnnotatedRegion<SystemUiOverlayStyle>(
        value: SystemUiOverlayStyle.light,
        child: Stack(
          children: [
            Container(
              height: double.infinity,
              width: double.infinity,
              decoration: const BoxDecoration(
                image: DecorationImage(
                  image: AssetImage("assets/images/background.png"),
                  fit: BoxFit.cover,
                ),
              ),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                Container(
                  color: Colors.transparent,
                  height: height,
                  child: PageView(
                    physics: const ClampingScrollPhysics(),
                    controller: _pageController,
                    onPageChanged: (int page) {
                      setState(() {
                        _currentPage = page;
                      });
                    },
                    children: [
                      Stack(
                        children: [
                          Positioned(
                            top: 196.h,
                            left: 114.w,
                            child: Image.asset(
                              "assets/images/onboard1.png",
                              //width: 263.w,
                              height: 140.h,
                              fit: BoxFit.fitHeight,
                            ),
                          ),
                          SingleChildScrollView(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                SizedBox(
                                  height: 354.h,
                                ),
                                Padding(
                                  padding:
                                      EdgeInsets.symmetric(horizontal: 18.w),
                                  child: Text('Chào mừng đến với KIDDO!',
                                      style: defaultText18B.copyWith(
                                          color: Colors.white)),
                                ),
                                //SizedBox(height: height / 40),
                                Padding(
                                  padding:
                                      EdgeInsets.symmetric(horizontal: 20.w),
                                  child: Text(
                                    VnString.itisrecommended,
                                    textAlign: TextAlign.center,
                                    style: defaultText16Re.copyWith(
                                      color: Colors.white.withAlpha(59),
                                    ),
                                  ),
                                )
                              ],
                            ),
                          ),
                        ],
                      ),
                      Stack(
                        children: [
                          Positioned(
                            top: 196.h,
                            left: 116.w,
                            child: Image.asset(
                              "assets/images/onboard2.png",
                              //width: 340.w,
                              height: 140.h,
                              fit: BoxFit.fitHeight,
                            ),
                          ),
                          SingleChildScrollView(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Center(
                                  child: Column(
                                    children: [
                                      SizedBox(height: 354.h),
                                      Padding(
                                        padding: EdgeInsets.symmetric(
                                            horizontal: 18.w),
                                        child: Text(
                                            'Đồng hành cùng con mọi lúc, mọi nơi',
                                            style: defaultText18B.copyWith(
                                                color: Colors.white)),
                                      ),
                                      SizedBox(height: height / 40),
                                      Padding(
                                        padding: EdgeInsets.symmetric(
                                            horizontal: 20.w),
                                        child: Text(
                                          VnString.withtimelynotification,
                                          textAlign: TextAlign.center,
                                          style: defaultText16Re.copyWith(
                                            color: Colors.white.withAlpha(59),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                )
                              ],
                            ),
                          ),
                        ],
                      ),
                      Stack(
                        children: [
                          Positioned(
                            top: 196.h,
                            left: 117.w,
                            child: Image.asset(
                              "assets/images/onboard3.png",
                              //width: 313.w,
                              height: 140.h,
                              fit: BoxFit.fitHeight,
                            ),
                          ),
                          SingleChildScrollView(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Center(
                                  child: Column(
                                    children: [
                                      SizedBox(height: 354.h),
                                      Padding(
                                        padding: EdgeInsets.symmetric(
                                            horizontal: 18.w),
                                        child: Text(
                                            'Đồng hành cùng con mọi lúc, mọi nơi',
                                            style: defaultText18B.copyWith(
                                                color: Colors.white)),
                                      ),
                                      SizedBox(height: height / 40),
                                      Padding(
                                        padding: EdgeInsets.symmetric(
                                            horizontal: 20.w),
                                        child: Text(
                                          VnString.thaksforfunevent,
                                          textAlign: TextAlign.center,
                                          style: defaultText16Re.copyWith(
                                            color: Colors.white.withAlpha(59),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                )
                              ],
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
            Column(
              children: [
                SizedBox(
                  height: 68.h,
                ),
                const Spacer(),
                Container(
                  color: Colors.transparent,
                  height: 250.h,
                  child: Align(
                    child: Padding(
                      padding: EdgeInsets.symmetric(horizontal: 22.w),
                      child: Column(
                        children: <Widget>[
                          Container(
                            color: Colors.transparent,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: _buildPageIndicator(),
                            ),
                          ),
                          SizedBox(
                            height: 16.h,
                          ),
                          InkWell(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: ((context) => const StudentLogin()),
                                ),
                              );
                            },
                            child: Container(
                              //height: 48.h,
                              width: 343.w,
                              padding: EdgeInsets.symmetric(vertical: 13.h),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(9.r),
                                color: mainOrange,
                              ),
                              child: Center(
                                child: Text('Đăng nhập với vai trò Học Sinh',
                                    textAlign: TextAlign.center,
                                    style: defaultText14B.copyWith(
                                        color: Colors.white)),
                              ),
                            ),
                          ),
                          SizedBox(
                            height: 16.h,
                          ),
                          InkWell(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: ((context) =>
                                      const TeacherLoginScreen()),
                                ),
                              );
                            },
                            child: Container(
                              height: 48.h,
                              width: 340.w,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(9.r),
                                color: mainOrange,
                              ),
                              child: Center(
                                child: Text('Đăng nhập với vai trò Giáo Viên',
                                    textAlign: TextAlign.center,
                                    style: defaultText14B.copyWith(
                                        color: Colors.white)),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
