import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:upgrader/upgrader.dart';
import 'modules/splash/splash_screen.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

class App extends StatefulWidget {
  const App({super.key});

  @override
  State<App> createState() => _AppState();
}

class _AppState extends State<App> {
  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(375, 812),
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (_, __) {
        return UpgradeAlert(
            upgrader: Upgrader(
              durationUntilAlertAgain: const Duration(hours: 6),
            ),
            child: MaterialApp(
              debugShowCheckedModeBanner: false,
              title: 'K-Nest',
              locale: const Locale('vi', 'VN'),
              supportedLocales: const [
                Locale('vi', 'VN'),
                Locale('en', 'US'),
              ],
              localizationsDelegates: const [
                GlobalMaterialLocalizations.delegate,
                GlobalWidgetsLocalizations.delegate,
                GlobalCupertinoLocalizations.delegate,
              ],
              theme: ThemeData(),
              home: const Splshscreen(),
            ));
        //return const _AppContent();
      },
    );
  }
}
