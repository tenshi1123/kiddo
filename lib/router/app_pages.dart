// ignore_for_file: constant_identifier_names

import 'package:kiddo/modules/bottombar/bottom_bar_screen.dart';
import 'package:kiddo/modules/bottombar/bottom_bar_ver2.dart';
import 'package:kiddo/modules/login/student_login_screen.dart';
import '../modules/login/forgot_password_screen.dart';
import 'page_config.dart';

enum AppPages {
  Initial,
  LoginPage,
  ForgotPassScreen,
  BottomNavBarPage,
  BottomNavBarTeacher,
}

final RegExp _keyPattern = RegExp('(?<=[a-z])[A-Z]');

extension AppPagesExtension on AppPages {
  String get key => toString()
      .split('.')
      .last
      .replaceAll('_', '.')
      .replaceAllMapped(
        _keyPattern,
        (Match m) => "_${m.group(0) ?? ''}",
      )
      .toLowerCase();

  String get path => "/${key.replaceAll('.', '/')}";

  String get name => path;
  static PageConfig getPageConfig(
    AppPages page,
    Map<String, dynamic>? arguments,
  ) {
    switch (page) {
      case AppPages.Initial:
      //Auth
      case AppPages.LoginPage:
        return PageConfig()..pageBuilder = () => const StudentLogin();
      case AppPages.ForgotPassScreen:
        return PageConfig()..pageBuilder = () => const ForgotPassScreen();
      case AppPages.BottomNavBarPage:
        return PageConfig()
          ..pageBuilder = () => Bottombar2(
                index: 0,
              );
      case AppPages.BottomNavBarTeacher:
        return PageConfig()
          ..pageBuilder = () => BottombarTeacher(
                index: 0,
              );
      // default:
      //   throw StateError(
      //     "Missing page: ${page.toString()} in AppPagesExtension.getPageConfig()",
      //   );
    }
  }

  static PageConfig getPageConfigForUnknownRouteName(String? name) =>
      getPageConfig(
        name == AppPages.Initial.name || name?.isEmpty == true
            ? AppPages.Initial
            : AppPages.values.firstWhere(
                (e) => e.name.contains(name!),
                orElse: () => AppPages.Initial,
              ),
        {},
      );
}
