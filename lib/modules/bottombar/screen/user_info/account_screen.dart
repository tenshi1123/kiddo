import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:kiddo/l10n/l10n.dart';
import 'package:kiddo/modules/bottombar/screen/user_info/change_pass_screen.dart';
import 'package:kiddo/modules/bottombar/screen/user_info/detail_info_screen.dart';
import 'package:kiddo/modules/bottombar/screen/user_info/pronuce_test.dart';
import 'package:kiddo/modules/bottombar/screen/user_info/speech_to_text_widget.dart';
import 'package:kiddo/modules/splash/onboarding.dart';
import 'package:kiddo/student_models/profile_model.dart';
import 'package:kiddo/student_repo/customer_repo.dart';
import 'package:kiddo/utils/constants/color.dart';
import 'package:kiddo/utils/constants/styles.dart';
import 'package:kiddo/utils/widget/app_image.dart';
import 'package:kiddo/utils/widget/custom_dialog.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AccountScreen extends StatefulWidget {
  const AccountScreen({
    super.key,
    required this.model,
  });
  final ProfileModel model;

  @override
  State<AccountScreen> createState() => _AccountScreenState();
}

class _AccountScreenState extends State<AccountScreen> {
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : Column(
              children: [
                SizedBox(
                  width: 375.w,
                  height: 200.h,
                  child: Stack(children: [
                    Positioned(
                      top: 0,
                      left: 0,
                      child: Image(
                        width: 375.w,
                        height: 200.h,
                        image: const AssetImage(
                          'assets/images/person_background.png',
                        ),
                        fit: BoxFit.fill,
                      ),
                    ),
                    Positioned(
                      top: 40.h,
                      child: SizedBox(
                        width: 375.w,
                        child: Column(
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                SizedBox(width: 24.w),
                                Text(
                                  L10n.of(context).accountManagement,
                                  style: defaultText16B.copyWith(
                                    color: Colors.white,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                    Positioned(
                      bottom: 0,
                      child: Container(
                        width: 375.w,
                        height: 50.h,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(24.r),
                            topRight: Radius.circular(24.r),
                          ),
                        ),
                      ),
                    ),
                    Positioned(
                        bottom: 0,
                        left: 138.w,
                        child: Container(
                          padding: EdgeInsets.all(12.dg),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            shape: BoxShape.circle,
                          ),
                          child: AppImage(
                            url: widget.model.avatar,
                            width: 80.w,
                            height: 80.h,
                            fit: BoxFit.fill,
                          ),
                        )),
                  ]),
                ),
                SizedBox(height: 16.h),
                Text(
                  widget.model.fullName,
                  style: defaultText18B,
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 4.h),
                Text(
                  widget.model.phone,
                  style: defaultText14M.copyWith(
                      color: colorText.withValues(alpha: 0.6)),
                ),
                Text(
                  widget.model.email,
                  style: defaultText14M.copyWith(
                      color: colorText.withValues(alpha: 0.6)),
                ),

                buildActionTile(
                  title: L10n.of(context).accountInfo,
                  iconPath: 'assets/icons/person.svg',
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => DetailInfoScreen(
                          model: widget.model,
                        ),
                      ),
                    );
                  },
                ),
                buildActionTile(
                  title: L10n.of(context).changePass,
                  iconPath: 'assets/icons/key.svg',
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ChangePassScreen(),
                      ),
                    );
                  },
                ),
                buildActionTile(
                  title: L10n.of(context).language,
                  onTap: () {
                    showLanguageDialog(context);
                  },
                ),
                buildActionTile(
                  title: L10n.of(context).logout,
                  iconPath: 'assets/icons/logout.svg',
                  textColor: mainRed,
                  onTap: () => _dialogBuilder(context),
                ),
                //test button
                // ElevatedButton(
                //   onPressed: () {
                //     Navigator.push(
                //       context,
                //       MaterialPageRoute(
                //         builder: (context) => PronunciationDemo(),
                //       ),
                //     );
                //   },
                //   child: Text("Test"),
                // )
              ],
            ),
    );
  }
}

Future<void> _dialogBuilder(BuildContext context) {
  return showDialog<void>(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        backgroundColor: Colors.white,
        title: Text(
          'Đăng xuất',
          style: defaultText16B,
        ),
        content: Text(
          'Bạn có chắc muốn đăng xuất ?',
          style: defaultText14M,
        ),
        actions: <Widget>[
          TextButton(
            style: TextButton.styleFrom(
              textStyle: Theme.of(context).textTheme.labelLarge,
            ),
            child: Text(
              'Hủy',
              style: defaultText14M.copyWith(
                color: mainBlue,
              ),
            ),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
          TextButton(
            style: TextButton.styleFrom(
              textStyle: Theme.of(context).textTheme.labelLarge,
            ),
            child: Text(
              'Đăng xuất',
              style: defaultText14B.copyWith(color: mainRed),
            ),
            onPressed: () async {
              SharedPreferences prefs = await SharedPreferences.getInstance();
              await prefs.remove('token');
              if (!context.mounted) return;
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: ((context) => Onbonding()),
                ),
              );
            },
          ),
        ],
      );
    },
  );
}

Widget buildActionTile({
  required String title,
  String? iconPath,
  required VoidCallback onTap,
  Color? textColor,
}) {
  return GestureDetector(
    onTap: onTap,
    child: Container(
      margin: EdgeInsets.only(top: 16.h),
      width: 343.w,
      height: 60.h,
      decoration: BoxDecoration(
        color: const Color(0xFFF0F2F4),
        borderRadius: BorderRadius.circular(16.r),
      ),
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 16.w),
        child: Row(
          children: [
            Container(
              width: 36.w,
              height: 36.h,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12.r),
              ),
              child: Center(
                child: iconPath != null
                    ? SvgPicture.asset(
                        iconPath,
                        width: 20.w,
                        height: 20.h,
                      )
                    : Icon(Icons.language, size: 20.r),
              ),
            ),
            SizedBox(width: 12.w),
            Text(
              title,
              style: defaultText14B.copyWith(
                color: textColor ?? colorText,
              ),
            ),
            const Spacer(),
            Icon(
              Icons.arrow_forward_ios,
              size: 20.r,
              color: colorText,
            ),
          ],
        ),
      ),
    ),
  );
}
