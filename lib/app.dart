import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:kiddo/core/localization/language_cubit.dart';
import 'package:kiddo/l10n/app_localizations.dart';
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
    final locale = context.watch<LanguageCubit>().state;
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
              locale: Locale('vi'),
              supportedLocales: const [
                Locale('vi'),
                Locale('en'),
              ],
              localizationsDelegates: const [
                AppLocalizations.delegate,
                GlobalMaterialLocalizations.delegate,
                GlobalWidgetsLocalizations.delegate,
                GlobalCupertinoLocalizations.delegate,
              ],
              debugShowCheckedModeBanner: false,
              title: 'K-Nest',
              theme: ThemeData.light(),
              home: const Splshscreen(),
            ));
        //return const _AppContent();
      },
    );
  }
}
