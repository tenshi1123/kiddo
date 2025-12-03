import 'dart:io';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:kiddo/student_models/chat_models.dart';
import 'package:kiddo/utils/constants/api_path.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ChatRepo {
  Dio dio = Dio();

  Future<List<ConverastionModel>> getListConversation() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final String? token = prefs.getString('token');
    dio.options.headers['Authorization'] = 'Bearer $token';
    Response response;
    response = await dio.post(
      ApiPath.lecture,
    );
    List<ConverastionModel> list = [];
    for (var item in response.data['data']) {
      list.add(ConverastionModel.fromJson(item));
    }
    return list;
  }

  Future<List<MessageModel>> getListMessage({required String lectureId}) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final String? token = prefs.getString('token');
    dio.options.headers['Authorization'] = 'Bearer $token';
    Response response;
    response = await dio.post(
      ApiPath.listMessage,
      data: FormData.fromMap(
        {
          'lecturer_id': lectureId,
        },
      ),
    );
    List<MessageModel> list = [];
    for (var item in response.data['data']['message']) {
      list.add(MessageModel.fromJson(item));
    }
    return list;
  }

  Future<List<ChatModel>> getTeacherListConversation() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final String? token = prefs.getString('token');
    dio.options.headers['Authorization'] = 'Bearer $token';
    Response response;
    response = await dio.post(
      ApiPath.teacherChat,
    );
    List<ChatModel> list = [];
    for (var item in response.data['data']['value']) {
      list.add(ChatModel.fromJson(item));
    }
    return list;
  }

  Future<ConverastionModel> createChatConversation(String teacherId) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final String? token = prefs.getString('token');
    dio.options.headers['Authorization'] = 'Bearer $token';
    Response response;
    // in ra log lỗi
    dio.interceptors.add(LogInterceptor(
      responseBody: true,
      requestBody: true,
      logPrint: (obj) => debugPrint('📦 $obj'),
    ));
    response = await dio.post(
      ApiPath.chatTeacherCustomer,
      data: {
        "teachers_id": int.tryParse(teacherId),
      },
    );
    return ConverastionModel.fromJson(response.data['data']);
  }

  Future<ConverastionModel> getConversationDetail(String chatId) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final String? token = prefs.getString('token');
    dio.options.headers['Authorization'] = 'Bearer $token';
    Response response;
    response = await dio.post(
      ApiPath.chatTeacher,
      data: {
        'chat_id': chatId,
      },
    );
    return ConverastionModel.fromJson(response.data['data']);
  }

  Future<bool> sendMessage(String chatId, String message) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final String? token = prefs.getString('token');
    dio.options.headers['Authorization'] = 'Bearer $token';
    Response response;
    response = await dio.post(ApiPath.sendMessage,
        data: FormData.fromMap({
          'lecturer_id': int.parse(chatId),
          'content': message,
        }));
    return response.data['status'] == 200;
  }

  Future<bool> sendImageMessage(String chatId, File photo) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final String? token = prefs.getString('token');
    dio.options.headers['Authorization'] = 'Bearer $token';
    var formData = FormData.fromMap({
      'chat_id': int.parse(chatId),
      'files[]': await MultipartFile.fromFile(photo.path,
          filename: photo.path.split('/').last),
    });
    Response response;
    response = await dio.post(ApiPath.sendImageMessage, data: formData);
    return response.data['status'] == 200;
  }
}
