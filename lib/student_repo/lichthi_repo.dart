import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:kiddo/student_models/lichthi_models.dart';
import 'package:kiddo/utils/constants/api_path.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ExamScheduleRepo {
  Dio dio = Dio();
  Future<LichthiModel> getLichThi() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final String? token = prefs.getString('token');
    dio.options.headers['Authorization'] = 'Bearer $token';
    Response response;
    response = await dio.post(
      ApiPath.offlineExamSchedule,
    );
    return LichthiModel.fromJson(response.data['data']);
  }

  Future<List<String>> changeCoso(
      {required String cosoId, required int type}) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final String? token = prefs.getString('token');
    dio.options.headers['Authorization'] = 'Bearer $token';
    Response response;
    response = await dio.post(ApiPath.changeCoso,
        data: jsonEncode({
          'coso_id': int.parse(cosoId),
          'type': type,
        }));
    List<String> list = [];
    for (var item in response.data['data']['value']) {
      list.add(item['day']);
    }
    return list;
  }

  Future<List<ValueModel>> changeDay(
      {required String cosoId, required int type, required String day}) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final String? token = prefs.getString('token');
    dio.options.headers['Authorization'] = 'Bearer $token';
    Response response;
    response = await dio.post(ApiPath.changeDay,
        data: jsonEncode({
          'coso_id': int.parse(cosoId),
          'type': type,
          'day': day,
        }));
    List<ValueModel> list = [];
    for (var item in response.data['data']['value']) {
      list.add(ValueModel.fromJson(item));
    }
    return list;
  }

  Future dkiThi({required String id}) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final String? token = prefs.getString('token');
    dio.options.headers['Authorization'] = 'Bearer $token';
    Response response;
    response = await dio.post(ApiPath.dangKyThi,
        data: jsonEncode({
          'ca_thi_id': id,
        }));
    return response.data['data'];
  }
}
