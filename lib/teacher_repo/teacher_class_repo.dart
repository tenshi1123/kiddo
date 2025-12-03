import 'package:dio/dio.dart';
import 'package:kiddo/teacher_model/feed_back_model.dart';
import 'package:kiddo/teacher_model/roll_call_model.dart';
import 'package:kiddo/teacher_model/teacher_class_model.dart';
import 'package:kiddo/utils/constants/api_path_teacher.dart';
import 'package:shared_preferences/shared_preferences.dart';

class TeacherClassRepo {
  Dio dio = Dio();
  Future<List<TeacherClassModel>> getTeacherClass() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final String? token = prefs.getString('token');
    dio.options.headers['Authorization'] = 'Bearer $token';
    Response response;
    response = await dio.post(
      ApiPathTeacher.listClass,
    );
    List<TeacherClassModel> result = ((response.data)['data'] as List)
        .map((e) => TeacherClassModel.fromJson(e))
        .toList();
    return result;
  }

  Future<List<TeacherClassModel>> getTeacherClassByType(
      {required String type}) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final String? token = prefs.getString('token');
    dio.options.headers['Authorization'] = 'Bearer $token';
    Response response;
    String apiPath = '';
    switch (type) {
      case 'off':
        apiPath = ApiPathTeacher.listOffClass;
        break;
      case 'zoom':
        apiPath = ApiPathTeacher.listZoomClass;
        break;

      default:
        apiPath = ApiPathTeacher.listOffClass;
    }
    response = await dio.post(
      apiPath,
    );
    List<TeacherClassModel> result = ((response.data)['data'] as List)
        .map((e) => TeacherClassModel.fromJson(e))
        .toList();
    return result;
  }

  Future<List<PhuDaoClassModel>> getPhuDaoClass({required String type}) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final String? token = prefs.getString('token');
    dio.options.headers['Authorization'] = 'Bearer $token';
    Response response;
    response = await dio.post(
      type == 'phu_dao'
          ? ApiPathTeacher.listPhuDaoClass
          : ApiPathTeacher.listXepBuClass,
    );
    List<PhuDaoClassModel> result = ((response.data)['data']['result'] as List)
        .map((e) => PhuDaoClassModel.fromJson(e))
        .toList();
    return result;
  }

  Future<List<BuoiHocModel>> getlistBuoiHoc(
      {required String courseScheduleId, required String typeTeacher}) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final String? token = prefs.getString('token');
    dio.options.headers['Authorization'] = 'Bearer $token';
    Response response;
    response = await dio.post(
      ApiPathTeacher.lessonByClass,
      data: {
        'type_teacher': typeTeacher,
        'course_schedule_id': courseScheduleId,
      },
    );
    List<BuoiHocModel> result = [];
    result = (response.data['data'] as List)
        .map((data) => BuoiHocModel.fromJson(data))
        .toList();
    return result;
  }

  Future<List<DetailBuoiHocExtendedModel>> getDetailBuoiHoc({
    required String courseScheduleId,
    required String typeTeacher,
  }) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final String? token = prefs.getString('token');
    dio.options.headers['Authorization'] = 'Bearer $token';
    Response response;
    response = await dio.post(
      ApiPathTeacher.listEventCheckinOff,
      data: {
        'type_teacher': typeTeacher,
        'course_schedule_id': courseScheduleId,
      },
    );
    List<DetailBuoiHocExtendedModel> result = [];
    result = (response.data['data'] as List)
        .map((data) => DetailBuoiHocExtendedModel.fromJson(data))
        .toList();
    return result;
  }

  Future<List<DiemDanhModel>> getListDiemDanhHs({
    required String typeTeacher,
    required String buoiHocId,
    required String courseScheduleId,
  }) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final String? token = prefs.getString('token');
    dio.options.headers['Authorization'] = 'Bearer $token';
    Response response;
    response = await dio.post(
      ApiPathTeacher.listStudent,
      data: {
        'type_teacher': typeTeacher,
        'buoi_hoc_id': buoiHocId,
        'course_schedule_id': courseScheduleId,
      },
    );
    List<DiemDanhModel> result = [];
    result = (response.data['data']['result']['lop_chinh'] as List)
        .map((data) => DiemDanhModel.fromJson(data))
        .toList();
    return result;
  }

  Future<List<ValueAttitudeModel>> getListThaiDo({
    required String typeTeacher,
    required String buoiHocId,
    required String courseScheduleId,
    required int type,
  }) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final String? token = prefs.getString('token');
    dio.options.headers['Authorization'] = 'Bearer $token';
    Response response;
    response = await dio.post(
      type == 1 ? ApiPathTeacher.attitude : ApiPathTeacher.situation,
      data: {
        'type_teacher': typeTeacher,
        'buoi_hoc_id': buoiHocId,
        'course_schedule_id': courseScheduleId,
      },
    );

    final violationErrors = (response.data['data']["violationError"] as List)
        .map((e) => ViolationError.fromJson(e))
        .toList();

    final valueList = (response.data['data']["value"] as List)
        .map((e) => ValueAttitudeModel.fromJson(e))
        .toList();

    final classLessonErrors =
        (response.data['data']["classLessonViolationError"] as List)
            .map((e) => ClassLessonViolationError.fromJson(e))
            .toList();

    List<ValueAttitudeModel> attachViolationToValue() {
      return valueList.map((value) {
        // tìm record tương ứng trong classLessonViolationError
        final classError = classLessonErrors.firstWhere(
          (e) => e.buoiHocId == value.buoiHocId,
          orElse: () => ClassLessonViolationError(
            violationErrorId: "",
            buoiHocId: "",
          ),
        );

        // tìm violationError theo id
        final violationInfo = violationErrors.firstWhere(
          (e) => e.id == classError.violationErrorId,
          orElse: () => ViolationError(id: "", name: ""),
        );

        return value.copyWith(
          violationErrorId: violationInfo.id,
          violationErrorName: violationInfo.name,
        );
      }).toList();
    }

    return valueList.isNotEmpty ? attachViolationToValue() : [];
  }

  Future<List<FeedbackTermModel>> getListNhanXet({
    required String courseScheduleId,
    required String typeTeacher,
    required String type,
  }) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final String? token = prefs.getString('token');
    dio.options.headers['Authorization'] = 'Bearer $token';
    var formData = FormData.fromMap({
      'course_schedule_id': courseScheduleId,
      'type_teacher': typeTeacher,
    });
    Response response;
    response = await dio.post(
      // type == 'gk'
      //     ? ApiPathTeacher.feedbackmidterm
      //     :
      ApiPathTeacher.feedbackendterm,

      data: formData,
    );
    List<FeedbackTermModel> result = [];
    result = (response.data['data'] as List)
        .map((data) => FeedbackTermModel.fromJson(data))
        .toList();
    return result;
  }
}
