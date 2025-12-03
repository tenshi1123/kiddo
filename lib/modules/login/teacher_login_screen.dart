import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:kiddo/main.dart';
import 'package:kiddo/modules/login/forgot_password_screen.dart';
import 'package:kiddo/router/app_pages.dart';
import 'package:kiddo/router/app_router.dart';
import 'package:kiddo/student_repo/home_repo.dart';
import 'package:kiddo/student_repo/login_repo.dart';
import 'package:kiddo/utils/constants/color.dart';
import 'package:kiddo/utils/constants/styles.dart';

class TeacherLoginScreen extends StatefulWidget {
  const TeacherLoginScreen({super.key});
  @override
  State<TeacherLoginScreen> createState() => _TeacherLoginScreenState();
}

class _TeacherLoginScreenState extends State<TeacherLoginScreen> {
  bool _obscurePassword = true;
  final TextEditingController phoneController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  bool get isFilled =>
      phoneController.text.isNotEmpty && passwordController.text.isNotEmpty;

  @override
  void initState() {
    super.initState();
    phoneController.addListener(_onChanged);
    passwordController.addListener(_onChanged);
  }

  void _onChanged() {
    setState(() {});
  }

  @override
  void dispose() {
    phoneController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 16.w),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            SizedBox(
              height: 82.h,
            ),
            Row(
              children: [
                GestureDetector(
                  onTap: () {
                    Navigator.of(context).pop();
                  },
                  child: Image.asset(
                    "assets/images/back_icon.png",
                    width: 68.w,
                    //height: 48.h,
                    fit: BoxFit.fitWidth,
                  ),
                ),
              ],
            ),
            SizedBox(
              height: 40.h,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'Đăng nhập!',
                  textAlign: TextAlign.center,
                  overflow: TextOverflow.clip,
                  style: defaultText20B.copyWith(
                    fontSize: 24.sp,
                  ),
                ),
                // Column(children: [
                //   SvgPicture.asset('assets/icons/wave_hand.svg'),
                //   SizedBox(
                //     height: 16.h,
                //   ),
                // ]),
              ],
            ),
            Text(
              'Chào mừng đã trở lại, hãy đăng nhập',
              textAlign: TextAlign.right,
              style: defaultText14Re,
              overflow: TextOverflow.clip,
            ),
            SizedBox(
              height: 32.h,
            ),
            CustomInputField(
              hintText: "Số điện thoại",
              controller: phoneController,
              prefixIcon: "assets/icons/user.svg",
              suffixIcon: "assets/icons/clear.svg",
              onSuffixTap: () => phoneController.clear(),
              keyboardType: TextInputType.phone,
            ),
            const SizedBox(height: 12),
            CustomInputField(
              hintText: "Mật khẩu",
              controller: passwordController,
              prefixIcon: "assets/icons/padlock.svg",
              suffixIcon: _obscurePassword
                  ? "assets/icons/eye_off.svg"
                  : "assets/icons/eye_on.svg",
              obscureText: _obscurePassword,
              onSuffixTap: () {
                setState(() {
                  _obscurePassword = !_obscurePassword;
                });
              },
            ),
            SizedBox(height: 12.h),
            _buildRememberPassword(),
            SizedBox(height: 16.h),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: isFilled
                    ? () async {
                        bool loged = await LoginRepo().loginTeacher(
                          phoneController.text,
                          passwordController.text,
                        );
                        if (loged == true) {
                          // StudentHomeModel? infoModel =
                          //     await CustomerRepo().getHomeInfo();
                          listClass = await LoginRepo().getListClass();
                          listCategory = await HomeRepo().getCategories();
                          AppRouter.toPage(
                            context,
                            AppPages.BottomNavBarTeacher,
                          );
                        } else {
                          showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return CupertinoAlertDialog(
                                title: const Text('Vui lòng thử lại'),
                                content: const Text(
                                    'Vui lòng kiểm tra lại mã học sinh và mật khẩu của bạn'),
                                actions: <Widget>[
                                  CupertinoDialogAction(
                                    isDefaultAction: true,
                                    child: Text(
                                      'Đồng ý',
                                      style: TextStyle(
                                          fontSize: 20, color: mainBlue),
                                    ),
                                    onPressed: () {
                                      Navigator.of(context, rootNavigator: true)
                                          .pop(
                                        (_) => false,
                                      );
                                    },
                                  )
                                ],
                              );
                            },
                          );
                        }
                      }
                    : () {},
                style: ElevatedButton.styleFrom(
                  backgroundColor:
                      isFilled ? mainOrange : mainOrange.withValues(alpha: 0.4),
                  padding: EdgeInsets.symmetric(vertical: 16.h),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12.r)),
                ),
                child: Text(
                  "Đăng nhập",
                  style: defaultText16B.copyWith(color: Colors.white),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRememberPassword() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        SizedBox(
          width: 24.w,
        ),
        TextButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: ((context) => const ForgotPassScreen()),
              ),
            );
          },
          child: Text(
            "Quên mật khẩu?",
            style: TextStyle(color: mainOrange),
          ),
        ),
      ],
    );
  }
}

class CustomInputField extends StatefulWidget {
  final String hintText;
  final TextEditingController controller;
  final String prefixIcon;
  final String? suffixIcon;
  final bool obscureText;
  final VoidCallback? onSuffixTap;
  final TextInputType? keyboardType;

  const CustomInputField({
    super.key,
    required this.hintText,
    required this.controller,
    required this.prefixIcon,
    this.suffixIcon,
    this.obscureText = false,
    this.onSuffixTap,
    this.keyboardType = TextInputType.text,
  });

  @override
  State<CustomInputField> createState() => _CustomInputFieldState();
}

class _CustomInputFieldState extends State<CustomInputField> {
  late ValueNotifier<bool> hasText;

  @override
  void initState() {
    super.initState();
    hasText = ValueNotifier(widget.controller.text.isNotEmpty);
    widget.controller.addListener(() {
      hasText.value = widget.controller.text.isNotEmpty;
    });
  }

  @override
  void dispose() {
    hasText.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<bool>(
      valueListenable: hasText,
      builder: (context, filled, _) {
        final Color color = filled ? mainOrange : Colors.grey;

        return Container(
          margin: const EdgeInsets.symmetric(vertical: 8),
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
          decoration: BoxDecoration(
            color: const Color(0xFFF7F9FB), // nền giống ảnh
            borderRadius: BorderRadius.circular(12),
          ),
          child: Row(
            children: [
              SvgPicture.asset(
                widget.prefixIcon,
                width: 20,
                height: 20,
                colorFilter: ColorFilter.mode(color, BlendMode.srcIn),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: TextField(
                  controller: widget.controller,
                  obscureText: widget.obscureText,
                  keyboardType: widget.keyboardType,
                  style: TextStyle(color: Colors.black), // màu text nhập
                  decoration: InputDecoration(
                    border: InputBorder.none,
                    hintText: widget.hintText,
                    hintStyle: TextStyle(color: Colors.grey), // hint luôn xám
                  ),
                ),
              ),
              if (widget.suffixIcon != null && filled)
                GestureDetector(
                  onTap: widget.onSuffixTap,
                  child: SvgPicture.asset(
                    widget.suffixIcon!,
                    width: 20,
                    height: 20,
                    colorFilter: ColorFilter.mode(color, BlendMode.srcIn),
                  ),
                ),
            ],
          ),
        );
      },
    );
  }
}
