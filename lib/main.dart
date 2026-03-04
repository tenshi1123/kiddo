import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kiddo/app.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:kiddo/core/localization/language_cubit.dart';
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
  initializeDateFormatting().then((_) => runApp(
        MultiBlocProvider(
          providers: [
            // ⭐ THÊM DÒNG NÀY
            BlocProvider(
              create: (_) => LanguageCubit(),
            ),
          ],
          child: const App(),
        ),
      ));
}

Future<void> initApiConfig() async {
  final res = await http.get(
    Uri.parse('https://612ced09ab461c00178b5fbb.mockapi.io/api/users/kiddo'),
  );

  final data = jsonDecode(res.body);
  ApiPath.hocvienUrl = data[0]['domain'] + 'api';
  ApiPathTeacher.baseUrl = data[0]['domain'];
  //await prefs.setString('base_url', ApiPath.baseUrl);
}
