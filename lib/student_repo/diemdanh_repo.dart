import 'package:dio/dio.dart';
import 'package:kiddo/student_models/diem_danh_model.dart';
import 'package:kiddo/utils/constants/api_path.dart';
import 'package:shared_preferences/shared_preferences.dart';

class DiemdanhRepo {
  Dio dio = Dio();
  Future<InfoDiemDanh> getDetailDiemDanh(String id) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final String? token = prefs.getString('token');
    dio.options.headers['Authorization'] = 'Bearer $token';
    Response response;
    response = await dio.post(ApiPath.diemDanh,
        data: FormData.fromMap({
          'customer_course_schedule_id': id,
        }));
    return InfoDiemDanh.fromJson((response.data)['data']);
  }

  Future<InfoTinhHinhThaiDo> getTinhHinhThaiDo(
      String typeLearn, String id) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final String? token = prefs.getString('token');
    dio.options.headers['Authorization'] = 'Bearer $token';
    Response response;
    response = await dio.post(ApiPath.thaiDo,
        data: FormData.fromMap({'type_learn': typeLearn, 'buoi_hoc_id': id}));
    return InfoTinhHinhThaiDo.fromJson((response.data)['data']);
  }

  Future<List<ScheduleModel>> getScheduleList(
      String dayStart, String dayEnd) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final String? token = prefs.getString('token');
    dio.options.headers['Authorization'] = 'Bearer $token';
    Response response;
    response = await dio.get(
      ApiPath.listSchedule,
      queryParameters: {
        'day_start': dayStart,
        'day_end': dayEnd,
      },
    );
    List<ScheduleModel> result = ((response.data)['data'] as List)
        .map((e) => ScheduleModel.fromJson(e))
        .toList();
    return result;
  }
}
