import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LanguageCubit extends Cubit<Locale> {
  LanguageCubit() : super(_getInitialLocale()) {
    _loadSavedLanguage();
  }

  static Locale _getInitialLocale() {
    final systemLocale = WidgetsBinding.instance.platformDispatcher.locale;

    // App bạn chỉ hỗ trợ vi & en
    if (['vi', 'en'].contains(systemLocale.languageCode)) {
      return Locale(systemLocale.languageCode);
    }

    return const Locale('vi'); // fallback
  }

  Future<void> _loadSavedLanguage() async {
    final prefs = await SharedPreferences.getInstance();
    final savedLang = prefs.getString('lang');

    if (savedLang != null) {
      emit(Locale(savedLang));
    }
  }

  Future<void> changeLanguage(Locale locale) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('lang', locale.languageCode);
    emit(locale);
  }
}
