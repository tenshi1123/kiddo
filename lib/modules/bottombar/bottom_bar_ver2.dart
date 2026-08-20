import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:kiddo/modules/chat/list_conversation_screen.dart';
import 'package:kiddo/student_models/profile_model.dart';
import 'package:kiddo/student_repo/customer_repo.dart';
import 'package:kiddo/utils/constants/color.dart';
import 'package:kiddo/utils/constants/styles.dart';
import 'package:kiddo/utils/onesignal.dart';
import 'package:onesignal_flutter/onesignal_flutter.dart';
import 'package:kiddo/modules/bottombar/screen/user_info/account_screen.dart';
import 'package:kiddo/modules/bottombar/screen/info_learning.dart';
import 'screen/offer_screen.dart';
import 'screen/home_screen.dart';
import 'package:kiddo/l10n/l10n.dart';

class Bottombar2 extends StatefulWidget {
  final int index;

  const Bottombar2({
    super.key,
    required this.index,
  });

  @override
  State<Bottombar2> createState() => _Bottombar2State();
}

class _Bottombar2State extends State<Bottombar2> {
  int _selectedIndex = 0;
  bool isLoading = true;
  ProfileModel? profileModel;

  @override
  void initState() {
    super.initState();
    setupOneSignal();
    fetchData();
  }

  Future<void> fetchData() async {
    debugPrint('[Bottombar2] 📡 fetchData bắt đầu...');
    try {
      // ✅ FIX: Thêm timeout để không block UI vô hạn
      final response = await CustomerRepo()
          .getCustomerProfile()
          .timeout(const Duration(seconds: 10));
      if (!mounted) return;
      setState(() {
        profileModel = response;
        isLoading = false;
      });
      debugPrint('[Bottombar2] ✅ fetchData thành công');
    } catch (e) {
      debugPrint('[Bottombar2] ❌ fetchData lỗi: $e');
      if (!mounted) return;
      // ✅ FIX: Dù lỗi vẫn set isLoading=false để không block UI vô hạn
      // profileModel sẽ là null, UI phải xử lý null-safe
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
      HomeScreen(
        model: profileModel,
      ),
      const OfferScreen(),
      ListConversationScreen(
        title: L10n.of(context).contact,
        type: 'student',
      ),
      const InfoLearingScreen(),
      AccountScreen(
        model: profileModel,
      ),
    ];
    final List<Map<String, String>> items = [
      {"icon": 'home_icon.svg', "label": L10n.of(context).home},
      {"icon": 'offers.svg', "label": L10n.of(context).offers},
      {"icon": '', "label": ""},
      {"icon": 'info.svg', "label": L10n.of(context).info},
      {"icon": 'personal.svg', "label": L10n.of(context).account},
    ];
    // ✅ FIX: Chỉ block bằng loading spinner khi đang load
    // Không dùng splash.gif lần 2, không block khi profileModel==null
    return isLoading
        ? const Scaffold(
            backgroundColor: Colors.white,
            body: Center(child: CircularProgressIndicator()),
          )
        : Scaffold(
            extendBody: true,
            backgroundColor: Colors.transparent,
            body: pages[_selectedIndex],
            bottomNavigationBar: Stack(
              alignment: Alignment.bottomCenter,
              clipBehavior: Clip.none,
              children: [
                Image.asset(
                  "assets/images/bottombar.png",
                  width: 375.w,
                  height: 86.h,
                  fit: BoxFit.fitWidth,
                ),
                // --- nút QR giữa ---
                Positioned(
                  top: 0,
                  child: GestureDetector(
                    onTap: () => setState(() => _selectedIndex = 2),
                    child: Column(
                      children: [
                        // viền trắng bao quanh
                        ClipPath(
                          clipper: EyeClipper(),
                          child: Container(
                            width: 80.w,
                            height: 50.h,
                            color: Colors.white,
                            alignment: Alignment.center,
                            child: Container(
                              width: 36.w,
                              height: 36.h,
                              //margin: const EdgeInsets.only(top: 10),
                              padding: EdgeInsets.all(8.w),
                              decoration: BoxDecoration(
                                color: mainOrange,
                                shape: BoxShape.circle,
                              ),
                              child: SvgPicture.asset(
                                'assets/icons/message.svg',
                                colorFilter: const ColorFilter.mode(
                                    Colors.white, BlendMode.srcIn),
                                width: 20.w,
                                height: 20.h,
                              ),
                            ),
                          ),
                        ),

                        Text(L10n.of(context).contact,
                            style: defaultText12M.copyWith(
                              color: _selectedIndex == 2
                                  ? mainOrange
                                  : Colors.grey,
                              fontSize: 10.sp,
                              fontWeight: FontWeight.bold,
                            )),
                        const SizedBox(height: 4),
                      ],
                    ),
                  ),
                ),
                SizedBox(
                  height: 74.h,
                  width: double.infinity,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: List.generate(items.length, (index) {
                      if (items[index]["icon"] == '') {
                        return const SizedBox(width: 60);
                      }
                      final bool selected = _selectedIndex == index;
                      return InkWell(
                        onTap: () => setState(() => _selectedIndex = index),
                        child: SizedBox(
                          width: 75.w,
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
                              const SizedBox(height: 4),
                              Text(items[index]["label"]!,
                                  style: defaultText12M.copyWith(
                                    color: selected ? mainOrange : Colors.grey,
                                    fontSize: 10.sp,
                                    fontWeight: FontWeight.bold,
                                  )),
                            ],
                          ),
                        ),
                      );
                    }),
                  ),
                ),
                Positioned(
                  top: 12.h,
                  left: 0,
                  right: 0,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: List.generate(items.length, (index) {
                      if (items[index]["icon"] == null) {
                        return const SizedBox(width: 60);
                      }
                      return AnimatedContainer(
                        duration: const Duration(milliseconds: 200),
                        width: 60,
                        height: 3,
                        decoration: BoxDecoration(
                          color: _selectedIndex == index && index != 2
                              ? mainOrange
                              : Colors.transparent,
                          borderRadius: BorderRadius.circular(2),
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

class EyeClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    final path = Path();
    path.moveTo(0, size.height / 2);
    path.quadraticBezierTo(
      size.width / 2,
      -size.height / 2,
      size.width,
      size.height / 2,
    );
    path.quadraticBezierTo(
      size.width / 2,
      size.height + size.height / 2,
      0,
      size.height / 2,
    );
    path.close();
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => false;
}
