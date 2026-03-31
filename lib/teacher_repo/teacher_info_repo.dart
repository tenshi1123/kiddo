import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:kiddo/student_models/profile_model.dart';
import 'package:kiddo/teacher_model/roll_call_model.dart';
import 'package:kiddo/utils/constants/api_path_teacher.dart';
import 'package:shared_preferences/shared_preferences.dart';

class TeacherInfoRepo {
  Dio dio = Dio();
  Future<ProfileModel> getCustomerProfile() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final String? token = prefs.getString('token');
    dio.options.headers['Authorization'] = 'Bearer $token';
    dio.interceptors.add(LogInterceptor(
      responseBody: true,
      requestBody: true,
      logPrint: (obj) => debugPrint('📦 $obj'),
    ));
    Response response;
    response = await dio.get(
      ApiPathTeacher.info,
    );
    return ProfileModel.fromJson(response.data['data']);
  }

  Future<List<GopYModel>> getListGopY() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final String? token = prefs.getString('token');
    dio.options.headers['Authorization'] = 'Bearer $token';
    Response response;
    response = await dio.get(
      ApiPathTeacher.gopY,
    );
    List<GopYModel> result = ((response.data)['data'] as List)
        .map((e) => GopYModel.fromJson(e))
        .toList();
    return result;
  }

  Future<DataBaoCaoModel> getInfoReport() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final String? token = prefs.getString('token');
    dio.options.headers['Authorization'] = 'Bearer $token';
    Response response;
    response = await dio.get(
      ApiPathTeacher.baoCao,
    );
    DataBaoCaoModel result = DataBaoCaoModel.fromJson((response.data)['data']);
    return result;
  }

  Future<List<TeachingHourReportModel>> getTeachingHourReport() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final String? token = prefs.getString('token');
    dio.options.headers['Authorization'] = 'Bearer $token';
    Response response;
    response = await dio.get(
      ApiPathTeacher.baoCaoChiTiet,
    );
    List<TeachingHourReportModel> result = ((response.data)['data'] as List)
        .map((e) => TeachingHourReportModel.fromJson(e))
        .toList();
    List<TeachingHourReportModel> filteredList = removeDuplicateLessons(result);
    return filteredList;
  }
}
