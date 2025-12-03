import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:kiddo/modules/chat/list_conversation_screen.dart';
import 'package:kiddo/student_models/profile_model.dart';
import 'package:kiddo/teacher_repo/teacher_info_repo.dart';
import 'package:kiddo/teacher_modules/teacher_bottombar/home/teacher_homescreen.dart';
import 'package:kiddo/teacher_modules/teacher_bottombar/screen/list_class/list_teacher_class.dart';
import 'package:kiddo/utils/constants/color.dart';
import 'package:kiddo/utils/constants/styles.dart';
import 'package:kiddo/utils/onesignal.dart';
import 'package:onesignal_flutter/onesignal_flutter.dart';
import 'package:kiddo/modules/bottombar/screen/user_info/account_screen.dart';

class BottombarTeacher extends StatefulWidget {
  final int index;

  const BottombarTeacher({
    super.key,
    required this.index,
  });

  @override
  State<BottombarTeacher> createState() => _BottombarTeacherState();
}

class _BottombarTeacherState extends State<BottombarTeacher> {
  int _selectedIndex = 0;
  bool isLoading = true;
  late ProfileModel profileModel;
  @override
  void initState() {
    super.initState();
    setupOneSignal();
    fetchData();
  }

  Future<void> fetchData() async {
    try {
      final response = await TeacherInfoRepo().getCustomerProfile();
      setState(() {
        profileModel = response;
        isLoading = false;
      });
    } catch (e) {
      debugPrint('Lỗi khi gọi API: $e');
      setState(() {
        isLoading = false;
      });
    }
  }

  Future<void> setupOneSignal() async {
    await initOneSignal();
    //var onesignalId = await OneSignal.User.getOnesignalId();
    // await LoginRepo().pushOnesignalId(
    //   onesignalId: onesignalId ?? '',
    // );
    if (Platform.isAndroid) {
      OneSignal.Notifications.addClickListener((event) {});
    } else {
      //do nothing :v tự báo chính mình
      OneSignal.Notifications.addClickListener((event) {});
    }
    promptPolicyPrivacy();
  }

  Future<void> promptPolicyPrivacy() async {
    if (Platform.isAndroid) {
      OneSignal.consentRequired(true);
      OneSignal.consentGiven(true);
    }
  }

  @override
  Widget build(BuildContext context) {
    final List<Widget> pages = [
      TeacherHomeScreen(
        model: profileModel,
      ),
      const ListTeacherClassScreen(),
      const ListConversationScreen(
        title: 'Chat',
      ),
      AccountScreen(
        model: profileModel,
      ),
    ];
    final List<Map<String, String>> items = [
      {"icon": 'home_icon.svg', "label": "Trang chủ"},
      {"icon": 'icon_class.svg', "label": "Lớp học"},
      {"icon": 'chat.svg', "label": "Chat"},
      {"icon": 'personal.svg', "label": "Tài khoản"},
    ];
    return isLoading
        ? Image.asset(
            "assets/images/splash.gif",
            height: 844.h,
            width: 390.w,
            fit: BoxFit.fill,
          )
        : Scaffold(
            extendBody: true,
            backgroundColor: Colors.white,
            body: pages[_selectedIndex],
            bottomNavigationBar: Stack(
              alignment: Alignment.bottomCenter,
              children: [
                Container(
                  height: 66.h,
                  width: double.infinity,
                  color: Colors.white,
                ),
                SizedBox(
                  height: 66.h,
                  width: double.infinity,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: List.generate(items.length, (index) {
                      if (items[index]["icon"] == '') {
                        return const SizedBox(width: 66);
                      }
                      final bool selected = _selectedIndex == index;
                      return InkWell(
                        onTap: () => setState(() => _selectedIndex = index),
                        child: SizedBox(
                          width: 80.w,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              selected && index == 1
                                  ? Image.asset(
                                      "assets/images/offers.png",
                                      width: 16.w,
                                      height: 16.h,
                                    )
                                  : index == 1
                                      ? Image.asset(
                                          "assets/images/offers2.png",
                                          width: 16.w,
                                          height: 16.h,
                                        )
                                      : SvgPicture.asset(
                                          "assets/icons/${items[index]["icon"]!}",
                                          colorFilter: ColorFilter.mode(
                                            selected ? mainOrange : colorText,
                                            BlendMode.srcIn,
                                          ),
                                          width: 16.w,
                                          height: 16.h,
                                        ),
                              SizedBox(height: 4.h),
                              Text(
                                items[index]["label"]!,
                                style: defaultText12M.copyWith(
                                  color: selected ? mainOrange : Colors.grey,
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    }),
                  ),
                ),
                Positioned(
                  top: 0,
                  left: 0,
                  right: 0,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: List.generate(items.length, (index) {
                      if (items[index]["icon"] == null) {
                        return SizedBox(width: 80.w);
                      }
                      return AnimatedContainer(
                        duration: const Duration(milliseconds: 200),
                        width: 70.w,
                        height: 3.h,
                        decoration: BoxDecoration(
                          color: _selectedIndex == index
                              ? mainOrange
                              : Colors.transparent,
                          borderRadius: BorderRadius.circular(2.r),
                        ),
                      );
                    }),
                  ),
                ),
              ],
            ),
          );
  }
}
