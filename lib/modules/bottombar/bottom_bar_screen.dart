import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:kiddo/l10n/l10n.dart';
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
  // ✅ FIX: Đổi late ProfileModel → ProfileModel? để tránh LateInitializationError
  // khi fetchData thất bại trước khi profileModel được gán giá trị
  ProfileModel? profileModel;

  @override
  void initState() {
    super.initState();
    setupOneSignal();
    fetchData();
  }

  Future<void> fetchData() async {
    debugPrint('[BottombarTeacher] 📡 fetchData bắt đầu...');
    try {
      // ✅ FIX: Thêm timeout để không block UI vô hạn
      final response = await TeacherInfoRepo()
          .getCustomerProfile()
          .timeout(const Duration(seconds: 10));
      if (!mounted) return;
      setState(() {
        profileModel = response;
        isLoading = false;
      });
      debugPrint('[BottombarTeacher] ✅ fetchData thành công');
    } catch (e) {
      debugPrint('[BottombarTeacher] ❌ lỗi khi gọi API: $e');
      if (!mounted) return;
      // ✅ FIX: Dù lỗi vẫn set isLoading=false, không để UI bị treo
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

    //do nothing :v tự báo chính mình
    OneSignal.Notifications.addClickListener((event) {});

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
      {"icon": 'home_icon.svg', "label": L10n.of(context).home},
      {"icon": 'icon_class.svg', "label": L10n.of(context).lopHoc2},
      {"icon": 'chat.svg', "label": 'Chat'},
      {"icon": 'personal.svg', "label": L10n.of(context).profile},
    ];
    // ✅ FIX: Chỉ block bằng loading spinner khi đang load
    // Không dùng splash.gif lần 2
    return isLoading
        ? const Scaffold(
            backgroundColor: Colors.white,
            body: Center(child: CircularProgressIndicator()),
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
