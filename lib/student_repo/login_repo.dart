import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:kiddo/student_models/diem_danh_model.dart';
import 'package:kiddo/utils/DioClient.dart';
import 'package:kiddo/utils/constants/api_path.dart';
import 'package:kiddo/utils/constants/api_path_teacher.dart';
import 'package:kiddo/utils/constants/const_string.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sp_util/sp_util.dart';

class LoginRepo {
  Dio dio = Dio();
  Future<bool> login(String code, String password) async {
    // dio.options.headers['Token'] = 'PMP123456789';
    Response response;
    dio.interceptors.add(LogInterceptor(
      responseBody: true,
      requestBody: true,
      logPrint: (obj) => debugPrint('📦 $obj'),
    ));
    var formData = FormData.fromMap({
      'phone': code,
      'password': password,
    });
    try {
      response = await dio.post(
        ApiPath.login,
        data: formData,
      );
    } on DioException {
      return false;
    }
    if (response.data['status'] == false) {
      return false;
    }
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('token', response.data['data']["refresh_token"]);
    await prefs.setString(ConstString.type, 'student');
    return response.data['data']["refresh_token"] != null;
  }

  Future<List<ClassModel>> getListClass() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final String? token = prefs.getString('token');
    dio.interceptors.add(LogInterceptor(
      responseBody: true,
      requestBody: true,
      logPrint: (obj) => debugPrint('📦 $obj'),
    ));
    try {
      dio.options.headers['Authorization'] = 'Bearer $token';
      Response response;
      response = await dio.post(
        ApiPath.apiClass,
      );
      List<ClassModel> result = ((response.data)['data'] as List)
          .map((e) => ClassModel.fromJson(e))
          .toList();
      return result;
    } on DioException {
      return [];
    }
  }

  Future<String> refreshToken() async {
    Dio dio = Dio();
    dio.options.headers['Token'] = 'BT123456789';
    Response response;
    response = await dio.post(ApiPath.login,
        data: jsonEncode({
          'code': SpUtil.getString(ConstString.idStudent),
          'password': SpUtil.getString(ConstString.md5Pass),
        }));
    SpUtil.putString(ConstString.token, response.data["token"]);
    // sendUserTag(int.parse(response.data["school_id"].toString()));
    return response.data["token"];
  }

  Future<bool> loginTeacher(String code, String password) async {
    // dio.options.headers['Token'] = 'PMP123456789';
    Response response;
    dio.interceptors.add(LogInterceptor(
      responseBody: true,
      requestBody: true,
      logPrint: (obj) => debugPrint('📦 $obj'),
    ));
    var formData = FormData.fromMap({
      'phone': code,
      'password': password,
    });
    try {
      response = await dio.post(
        ApiPathTeacher.login,
        data: formData,
      );
    } on DioException {
      return false;
    }
    if (response.data['status'] == false) {
      return false;
    }
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('token', response.data['data']["refresh_token"]);
    await prefs.setString(ConstString.type, 'teacher');
    return response.data['data']["refresh_token"] != null;
  }

  Future pushOnesignalId({required String onesignalId}) async {
    final dio = await DioClient.getInstance();
    dio.interceptors.add(LogInterceptor(
      responseBody: true,
      requestBody: true,
      logPrint: (obj) => debugPrint('📦 $obj'),
    ));

    await dio.post(
      ApiPath.pushOnesignal,
      data: jsonEncode({
        'onesignal_id': onesignalId,
      }),
    );
  }
}
