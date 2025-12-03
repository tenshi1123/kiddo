import 'dart:convert';
import 'dart:io';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:kiddo/student_models/diem_danh_model.dart';
import 'package:kiddo/student_models/excercise_model.dart';
import 'package:kiddo/student_models/home_model.dart';
import 'package:kiddo/student_models/my_course_model.dart';
import 'package:kiddo/utils/DioClient.dart';
import 'package:kiddo/utils/constants/api_path.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HomeRepo {
  Dio dio = Dio();
  //Lấy danh sách bài tập
  Future<List<HomeWorkModel>> getListBaiTap({required String id}) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final String? token = prefs.getString('token');
    dio.options.headers['Authorization'] = 'Bearer $token';
    Response response;
    response = await dio.post(ApiPath.baiTap,
        data: FormData.fromMap({
          'customer_course_schedule_id': id,
        }));
    return ((response.data['data'] as List)
        .map((e) => HomeWorkModel.fromJson(e))
        .toList());
  }

  //Lấy chi tiết bài tập chi tiet bai tap
  Future<DetailExcerciseModel> getDetailExsercise(
      {required String id, required String customerCourseScheduleId}) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final String? token = prefs.getString('token');
    dio.options.headers['Authorization'] = 'Bearer $token';
    Response response;
    response = await dio.post(ApiPath.detailBaiTap,
        data: jsonEncode({
          'id': int.tryParse(id),
          'customer_course_schedule_id': int.tryParse(
            customerCourseScheduleId,
          ),
        }));
    //return ClassModel.fromJson(response.data['data']);
    return DetailExcerciseModel.fromJson((response.data)['data']);
  }

  //load bài tập trắc nghiệm
  Future<List<QuestionGroupModel>> viewTracNghiem({
    required String id,
    required String customerCourseScheduleId,
    required String examDetailId,
  }) async {
    final dio = await DioClient.getInstance();
    Response response;
    response = await dio.post(
      ApiPath.viewTracNghiem,
      data: jsonEncode(
        {
          'id': int.tryParse(id),
          'customer_course_schedule_id': int.tryParse(
            customerCourseScheduleId,
          ),
          'exam_detail_id': int.tryParse(examDetailId),
        },
      ),
    );
    //return ClassModel.fromJson(response.data['data']);
    return ((response.data['data']['question'] as List)
        .map((e) => QuestionGroupModel.fromJson(e))
        .toList());
  }

  Future uploadExcercise(
      {required String id,
      required String courseScheduleId,
      required String note,
      File? photo}) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final String? token = prefs.getString('token');
    dio.options.headers['Authorization'] = 'Bearer $token';
    FormData formData;
    if (photo == null) {
      formData = FormData.fromMap({
        'id': id,
        'customer_course_schedule_id': courseScheduleId,
        'note': note,
      });
    } else {
      formData = FormData.fromMap({
        'id': id,
        'customer_course_schedule_id': courseScheduleId,
        'note': note,
        'file': [
          await MultipartFile.fromFile(photo.path,
              filename: photo.path.split('/').last),
        ]
      });
    }
    await dio.post(ApiPath.submitExeTL, data: formData);
  }

  Future<String> submitTracNghiem({
    required String id,
    required String examDetailId,
    required String customerCourseScheduleId,
    required String startTime,
    required List<Map<String, String>> data,
  }) async {
    final dio = await DioClient.getInstance();
    final body = {
      "id": int.parse(id),
      "exam_detail_id": int.parse(examDetailId),
      "customer_course_schedule_id": int.parse(customerCourseScheduleId),
      "start_time": startTime,
      "data": data,
    };

    Response response;
    response = await dio.post(ApiPath.submitTracNghiem, data: body);
    // in ra log lỗi
    dio.interceptors.add(LogInterceptor(
      responseBody: true,
      requestBody: true,
      logPrint: (obj) => debugPrint('📦 $obj'),
    ));
    return response.data;
  }

  //Báo cáo điểm
  Future<BaoCaoHocTapModel> getBaoCaoDiem() async {
    final dio = await DioClient.getInstance();
    Response response;
    response = await dio.post(
      ApiPath.reportExercise,
    );
    //return ClassModel.fromJson(response.data['data']);
    return BaoCaoHocTapModel.fromJson((response.data)['data']);
  }

  Future<InfoDiemDanh> getDetailDiemDanh(String id) async {
    final dio = await DioClient.getInstance();
    Response response;
    response =
        await dio.post(ApiPath.detailDiemdanh, data: jsonEncode({"id": id}));
    return InfoDiemDanh.fromJson((response.data)['data']);
  }

  Future<DetailClass> getDetailClass({
    required String courseScheduleId,
    required String settingCourseTypeId,
  }) async {
    final dio = await DioClient.getInstance();
    var formData = FormData.fromMap({
      'course_schedule_id': int.parse(courseScheduleId),
      'setting_course_type_id': int.parse(settingCourseTypeId),
    });
    Response response;
    response = await dio.post(ApiPath.detailClass, data: formData);
    return DetailClass.fromJson((response.data)['data']);
  }

  Future<String> getChinhSach({
    required String courseScheduleId,
  }) async {
    final dio = await DioClient.getInstance();
    Response response;
    response = await dio.get(
      ApiPath.policy,
      queryParameters: {'course_schedule_id': courseScheduleId},
    );
    return response.data['data']['policy'];
  }

  Future<List<CategoryModel>> getCategories() async {
    Response response;
    response = await dio.get(
      ApiPath.category,
    );
    List<CategoryModel> result = ((response.data)['data'] as List)
        .map((e) => CategoryModel.fromJson(e))
        .toList();
    return result;
  }

  Future<List<PostModel>> getListPost({required int id}) async {
    Response response;
    response = await dio.get(
      ApiPath.library,
      queryParameters: {
        'category_id': id,
        'page': 1,
        'per_page': 100,
      },
    );
    List<PostModel> result = ((response.data)['data']['data'] as List)
        .map((e) => PostModel.fromJson(e))
        .toList();
    return result;
  }
}
