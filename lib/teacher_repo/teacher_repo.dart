import 'package:dio/dio.dart';
import 'package:kiddo/student_models/profile_model.dart';
import 'package:kiddo/teacher_model/home_teacher_model.dart';
import 'package:kiddo/utils/constants/api_path_teacher.dart';
import 'package:kiddo/utils/constants/const_string.dart';
import 'package:shared_preferences/shared_preferences.dart';

class TeacherRepo {
  Dio dio = Dio();
  Future<TeacherHomeModel?> getHomeInfo() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final String? token = prefs.getString('token');
    dio.options.headers['Authorization'] = 'Bearer $token';
    Response response;
    try {
      response = await dio.post(
        ApiPathTeacher.teachersUrl,
      );
      return TeacherHomeModel.fromJson(response.data['data']);
    } on DioException {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.remove(ConstString.type);
      await prefs.remove('token');
    } catch (e) {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.remove('token');
      await prefs.remove(ConstString.type);
    }
    return null;
  }

  Future<List<LichHocModel>> getLichDay(
      {required String day1, required String day2}) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final String? token = prefs.getString('token');
    dio.options.headers['Authorization'] = 'Bearer $token';
    Response response;
    response = await dio.post(
      ApiPathTeacher.lichDay,
      data: {
        'start_day': day1,
        'end_day': day2,
      },
    );
    List<LichHocModel> reults = [];
    for (var item in response.data['data']['value']) {
      reults.add(LichHocModel.fromJson(item));
    }
    return reults;
  }

  Future<TeacherProfileModel> getCustomerProfile() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final String? token = prefs.getString('token');
    dio.options.headers['Authorization'] = 'Bearer $token';
    Response response;
    response = await dio.post(
      ApiPathTeacher.profile,
    );
    return TeacherProfileModel.fromJson(response.data['data']['value']);
  }

  Future<List<NotiModel>> getListNoti() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final String? token = prefs.getString('token');
    dio.options.headers['Authorization'] = 'Bearer $token';
    Response response;
    response = await dio.post(
      ApiPathTeacher.notification,
      data: {
        'page': 1,
      },
    );
    List<NotiModel> reults = [];
    for (var item in response.data['data']['value']) {
      reults.add(NotiModel.fromJson(item));
    }
    return reults;
  }
}
