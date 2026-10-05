import 'package:flutter/material.dart';
import 'package:kiddo/l10n/app_localizations.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:kiddo/modules/bottombar/screen/user_info/change_pass_screen.dart';
import 'package:kiddo/modules/bottombar/screen/user_info/edit_info_teacher_screen.dart';
import 'package:kiddo/teacher_model/home_teacher_model.dart';
import 'package:kiddo/utils/constants/styles.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:kiddo/utils/widget/app_image.dart';

class TeacherInfo extends StatelessWidget {
  const TeacherInfo({super.key, required this.teacherProfileModel});
  final TeacherProfileModel teacherProfileModel;
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
            width: MediaQuery.of(context).size.width,
            height: 150.h,
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage("assets/images/app_bar.png"),
                fit: BoxFit.fill,
              ),
            ),
            child: Center(
              child: Text(
                'Cá nhân',
                style: defaultText20B.copyWith(
                  color: Colors.white,
                ),
              ),
            )),
        // Avatar
        Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16.r),
            border: Border.all(color: const Color(0xff00AEEF)),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.1),
                blurRadius: 5,
                spreadRadius: 2,
              ),
            ],
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(16.r),
            child: AppImage(
              url: teacherProfileModel.avatar, // Thay bằng ảnh của bạn
              width: 80.w,
              height: 80.h,
              fit: BoxFit.cover,
            ),
          ),
        ),
        const SizedBox(height: 10),

        // Tên và số điện thoại
        Text(teacherProfileModel.fullName, style: defaultText20B),
        Text(teacherProfileModel.phone, style: defaultText16M),
        const SizedBox(height: 20),

        // Menu
        Container(
          width: MediaQuery.of(context).size.width * 0.9,
          decoration: BoxDecoration(
            color: const Color(0xffF6F8FA),
            borderRadius: BorderRadius.circular(15),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.1),
                blurRadius: 5,
                spreadRadius: 2,
              ),
            ],
          ),
          child: Column(
            children: [
              _buildMenuItem(
                icon: Icons.person_outline,
                text: "Thông tin tài khoản",
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => InfoUser(
                        teacherProfileModel: teacherProfileModel,
                      ),
                    ),
                  );
                },
              ),
              _buildMenuItem(
                icon: Icons.vpn_key_outlined,
                text: "Đổi mật khẩu",
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const ChangePassScreen(),
                    ),
                  );
                },
              ),
              _buildMenuItem(
                icon: Icons.logout,
                text: "Đăng xuất",
                onTap: () {
                  _dialogBuilder(context);
                },
                textColor: const Color(0xffED1C24),
                iconColor: const Color(0xffED1C24),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

// Widget tạo item menu
Widget _buildMenuItem({
  required IconData icon,
  required String text,
  required VoidCallback onTap,
  Color textColor = Colors.black87,
  Color iconColor = Colors.black54,
}) {
  return InkWell(
    onTap: onTap,
    child: Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      child: Row(
        children: [
          Container(
              height: 36.h,
              width: 36.w,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.all(
                  Radius.circular(16.r),
                ),
              ),
              child: Icon(icon, color: iconColor)),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              text,
              style: TextStyle(
                fontSize: 16,
                color: textColor,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          const Icon(Icons.arrow_forward_ios, size: 16, color: Colors.black45),
        ],
      ),
    ),
  );
}

Future<void> _dialogBuilder(BuildContext context) {
  return showDialog<void>(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: Text(
          'Đăng xuất',
          style: defaultText14M,
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
            child: Text(AppLocalizations.of(context).cancel),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
          TextButton(
            style: TextButton.styleFrom(
              textStyle: Theme.of(context).textTheme.labelLarge,
            ),
            child: Text(AppLocalizations.of(context).confirm),
            onPressed: () async {
              // Xóa token và thông tin người dùng khỏi SharedPreferences
              // (Thay thế bằng mã của bạn để xóa token và thông tin người dùng)
              SharedPreferences prefs = await SharedPreferences.getInstance();
              await prefs.remove('token');
            },
          ),
        ],
      );
    },
  );
}
