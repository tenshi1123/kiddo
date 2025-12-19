import 'package:flutter/material.dart';
import 'package:kiddo/app.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:kiddo/student_models/diem_danh_model.dart';
import 'package:kiddo/student_models/home_model.dart';
import 'package:kiddo/teacher_model/teacher_class_model.dart';
import 'package:kiddo/utils/constants/api_path.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:kiddo/utils/constants/api_path_teacher.dart';

List<ClassModel> listClass = [];
List<TeacherClassModel> listTeacherClass = [];
List<CategoryModel> listCategory = [];
Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initApiConfig();
  // SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp])
  //     .then((_) {
  //   initializeDateFormatting().then((_) => runApp(const App()));
  // });
  initializeDateFormatting().then((_) => runApp(const App()));
}

Future<void> initApiConfig() async {
  //final prefs = await SharedPreferences.getInstance();

  //final cached = prefs.getString('base_url');
  // if (cached != null) {
  //   ApiPath.baseUrl = cached;
  //   return;
  // }

  final res = await http.get(
    Uri.parse('https://612ced09ab461c00178b5fbb.mockapi.io/api/users/kiddo'),
  );

  final data = jsonDecode(res.body);
  ApiPath.hocvienUrl = data[0]['domain'] + 'api';
  ApiPathTeacher.baseUrl = data[0]['domain'];
  //await prefs.setString('base_url', ApiPath.baseUrl);
}
