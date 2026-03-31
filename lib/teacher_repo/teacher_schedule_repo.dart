import 'package:dio/dio.dart';
import 'package:kiddo/student_models/diem_danh_model.dart';

import 'package:kiddo/utils/constants/api_path_teacher.dart';
import 'package:shared_preferences/shared_preferences.dart';

class TeacherScheduleRepo {
  Dio dio = Dio();

  // Future<InfoDiemDanh> getDetailDiemDanh(String id) async {
  //   final SharedPreferences prefs = await SharedPreferences.getInstance();
  //   final String? token = prefs.getString('token');
  //   dio.options.headers['Authorization'] = 'Bearer $token';
  //   Response response;
  //   response = await dio.post(ApiPath.diemDanh,
  //       data: FormData.fromMap({
  //         'customer_course_schedule_id': id,
  //       }));
  //   return InfoDiemDanh.fromJson((response.data)['data']);
  // }

  Future<List<ScheduleModel>> getScheduleList(
      String dayStart, String dayEnd) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final String? token = prefs.getString('token');
    dio.options.headers['Authorization'] = 'Bearer $token';
    Response response;
    response = await dio.get(
      ApiPathTeacher.teachingSchedule,
      queryParameters: {
        'day_start': dayStart,
        'day_end': dayEnd,
      },
    );
    List<ScheduleModel> result = ((response.data)['data'] as List)
        .map((e) => ScheduleModel.fromJson(e))
        .toList();
    List<ScheduleModel> filteredList = removeDuplicateLessons(result);
    return filteredList;
  }

  Future<List<AppointmentModel>> getAppointmentList(
      String dayStart, String dayEnd) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final String? token = prefs.getString('token');
    dio.options.headers['Authorization'] = 'Bearer $token';
    Response response;
    response = await dio.get(
      ApiPathTeacher.appointment,
      queryParameters: {
        'day_start': dayStart,
        'day_end': dayEnd,
      },
    );
    List<AppointmentModel> result = ((response.data)['data'] as List)
        .map((e) => AppointmentModel.fromJson(e))
        .toList();
    return result;
  }
}

List<ScheduleModel> removeDuplicateLessons(List<ScheduleModel> lessons) {
  final seen = <String>{};

  return lessons.where((lesson) {
    final key = "${lesson.createdDate}_${lesson.timeStart}_${lesson.timeEnd}";

    if (seen.contains(key)) {
      return false; // trùng -> bỏ
    } else {
      seen.add(key);
      return true; // giữ lại
    }
  }).toList();
}
