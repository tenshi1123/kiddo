import 'package:flutter/material.dart';
import 'package:kiddo/app.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:kiddo/student_models/diem_danh_model.dart';
import 'package:kiddo/student_models/home_model.dart';
import 'package:kiddo/teacher_model/teacher_class_model.dart';

List<ClassModel> listClass = [];
List<TeacherClassModel> listTeacherClass = [];
List<CategoryModel> listCategory = [];
Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp])
  //     .then((_) {
  //   initializeDateFormatting().then((_) => runApp(const App()));
  // });
  initializeDateFormatting().then((_) => runApp(const App()));
}
