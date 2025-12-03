import 'dart:convert';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:kiddo/student_models/customer_models.dart';
import 'package:kiddo/student_models/profile_model.dart';
import 'package:kiddo/utils/DioClient.dart';
import 'package:kiddo/utils/constants/api_path.dart';
import 'package:kiddo/utils/constants/const_string.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CustomerRepo {
  Dio dio = Dio();
  Future<StudentHomeModel?> getHomeInfo() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final String? token = prefs.getString('token');
    dio.options.headers['Authorization'] = 'Bearer $token';
    Response response;
    try {
      response = await dio.post(
        ApiPath.hocvienUrl,
      );
      return StudentHomeModel.fromJson(response.data['data']);
    } on DioException {
      await prefs.remove('token');
      await prefs.remove(ConstString.type);
    } catch (e) {
      await prefs.remove('token');
      await prefs.remove(ConstString.type);
      print(e);
    }
    return null;
  }

  Future<DetailRcmCourse> getDetailRecomentCourse({required String id}) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final String? token = prefs.getString('token');
    dio.options.headers['Authorization'] = 'Bearer $token';
    Response response;
    response = await dio.post(ApiPath.coureDetail,
        data: jsonEncode({
          'id': int.tryParse(id),
        }));

    return DetailRcmCourse.fromJson(response.data['data']);
  }

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
    response = await dio.post(
      ApiPath.profile,
    );
    return ProfileModel.fromJson(response.data['data']);
  }

  Future<List<ChildrenModel>> getChilren() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final String? token = prefs.getString('token');
    dio.options.headers['Authorization'] = 'Bearer $token';
    dio.interceptors.add(LogInterceptor(
      responseBody: true,
      requestBody: true,
      logPrint: (obj) => debugPrint('📦 $obj'),
    ));
    Response response;
    response = await dio.post(
      ApiPath.multiCustomer,
    );
    List<ChildrenModel> list = [];
    for (var item in response.data['data']) {
      list.add(ChildrenModel.fromJson(item));
    }
    return list;
  }

  Future<String> changePassword(
      String oldPass, String password, String newPass) async {
    final dio = await DioClient.getInstance();
    Response response;
    response = await dio.post(ApiPath.changePassword, data: {
      'password_old': oldPass,
      'pass_new': password,
      're_pass_new': newPass,
    });
    return response.data['message'];
  }

  Future<String> changeInfo({
    required String name,
    required String email,
    required String dob,
  }) async {
    try {
      final dio = await DioClient.getInstance();
      final response = await dio.post(ApiPath.changeInfo,
          data: FormData.fromMap({
            'full_name': name,
            'email': email,
            'date': dob,
          }));
      final data = response.data;
      if (data['status'] == 'true') {
        return 'Cập nhật thông tin thành công';
      } else if (data['status'] == 'false') {
        final message = data['message'];
        if (message is Map) {
          return message.entries.map((e) => e.value.toString()).join(', ');
        }
        return message.toString();
      } else {
        return 'Có lỗi không xác định xảy ra.';
      }
    } catch (e) {
      if (e is DioException) {
        return 'Lỗi mạng hoặc server: ${e.message}';
      }
      return 'Đã xảy ra lỗi: ${e.toString()}';
    }
  }

  Future<String> changeAvatar(File photo) async {
    final dio = await DioClient.getInstance();
    Response response;
    var formData = FormData.fromMap({
      'file': await MultipartFile.fromFile(photo.path,
          filename: photo.path.split('/').last),
    });
    response = await dio.post(ApiPath.updateAvatar, data: formData);
    return response.data['message'];
  }

  Future<List<PaymentModel>> getPayment() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final String? token = prefs.getString('token');
    dio.options.headers['Authorization'] = 'Bearer $token';
    Response response;
    response = await dio.post(
      ApiPath.payment,
    );
    List<PaymentModel> list = [];
    for (var item in response.data['data']) {
      list.add(PaymentModel.fromJson(item));
    }
    return list;
  }

  Future<List<PaymentModel>> getPayment2() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final String? token = prefs.getString('token');
    dio.options.headers['Authorization'] = 'Bearer $token';
    Response response;
    response = await dio.post(
      ApiPath.payment2,
    );
    List<PaymentModel> list = [];
    for (var item in response.data['data']) {
      list.add(PaymentModel.fromJson(item));
    }
    return list;
  }

  Future<PaymentDetailModel> getDetailPayment(String id) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final String? token = prefs.getString('token');
    dio.options.headers['Authorization'] = 'Bearer $token';
    dio.interceptors.add(LogInterceptor(
      responseBody: true,
      requestBody: true,
      logPrint: (obj) => debugPrint('📦 $obj'),
    ));
    Response response;
    response = await dio.post(
      ApiPath.detailPayment,
      data: FormData.fromMap({
        'pending_payment_id': id,
      }),
    );
    return PaymentDetailModel.fromJson(response.data['data']);
  }

  Future<String> uploadTransactionTransfer(
      {required String paymentId,
      required String orderId,
      required File photo}) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final String? token = prefs.getString('token');
    dio.options.headers['Authorization'] = 'Bearer $token';
    dio.interceptors.add(LogInterceptor(
      responseBody: true,
      requestBody: true,
      logPrint: (obj) => debugPrint('📦 $obj'),
    ));
    var formData = FormData.fromMap({
      'pending_payment_id': int.parse(paymentId),
      'order_id': int.parse(orderId),
      'file': await MultipartFile.fromFile(photo.path,
          filename: photo.path.split('/').last),
    });
    Response response;
    response = await dio.post(
      ApiPath.uploadTransaction,
      data: formData,
    );
    return response.data['message'];
  }

  Future<String> inviteFriend({
    required String fullName,
    required String date,
    required String phone,
    required String email,
    required String content,
  }) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final String? token = prefs.getString('token');
    dio.options.headers['Authorization'] = 'Bearer $token';
    dio.interceptors.add(LogInterceptor(
      responseBody: true,
      requestBody: true,
      logPrint: (obj) => debugPrint('📦 $obj'),
    ));
    var formData = FormData.fromMap({
      'full_name': fullName,
      'date': date,
      'phone': phone,
      'email': email,
      'content': content,
    });
    Response response;
    response = await dio.post(
      ApiPath.inviteFriend,
      data: formData,
    );
    return response.data['message'];
  }

  Future<List<NotiModel>> getListNoti() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final String? token = prefs.getString('token');
    dio.options.headers['Authorization'] = 'Bearer $token';
    Response response;
    response = await dio.post(
      ApiPath.notification,
    );
    List<NotiModel> reults = [];
    for (var item in response.data['data']['value']) {
      reults.add(NotiModel.fromJson(item));
    }
    return reults;
  }
}
