import 'dart:io';

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

  Future<void> uploadDocument({
    required String name,
    required String id,
    required String type,
    required String note,
    required File photo,
  }) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final String? token = prefs.getString('token');
    dio.options.headers['Authorization'] = 'Bearer $token';
    Response response;
    response = await dio.post(ApiPathTeacher.uploadTaiLieu,
        data: FormData.fromMap({
          'name': name,
          'event_checkin_off_id': id,
          'type': type,
          'note': note,
          'files[]': await MultipartFile.fromFile(photo.path,
              filename: photo.path.split('/').last),
        }));
    return response.data['data'];
  }

  Future<void> deleteDocument({
    required String classLessonDocumentId,
  }) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final String? token = prefs.getString('token');
    dio.options.headers['Authorization'] = 'Bearer $token';
    Response response;
    response = await dio.post(ApiPathTeacher.uploadTaiLieu,
        data: FormData.fromMap({
          'class_lesson_document_id': classLessonDocumentId,
        }));
    return response.data['data'];
  }

  Future<List<BaoCaoModel>> getBaoCao({
    required String courseScheduleId,
    required String typeTeacher,
  }) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final String? token = prefs.getString('token');
    dio.options.headers['Authorization'] = 'Bearer $token';
    Response response;
    response = await dio.get(
      ApiPathTeacher.listBaoCao,
      queryParameters: {
        'course_schedule_id': courseScheduleId,
      },
    );
    List<BaoCaoModel> result = [];
    result = (response.data['data'] as List)
        .map((data) => BaoCaoModel.fromJson(data))
        .toList();
    return result;
  }

  Future<List<ListDocumentModel>> getDocument({
    required String courseScheduleId,
    required String typeTeacher,
  }) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final String? token = prefs.getString('token');
    dio.options.headers['Authorization'] = 'Bearer $token';
    Response response;
    response = await dio.get(
      ApiPathTeacher.listTaiLieu,
      queryParameters: {
        'course_schedule_id': courseScheduleId,
      },
    );
    List<ListDocumentModel> result = [];
    result = (response.data['data'] as List)
        .map((data) => ListDocumentModel.fromJson(data))
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

  Future<String> changeDiemdanh({
    required String typeTeacher,
    required String checkinOffId,
    required String status,
  }) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final String? token = prefs.getString('token');
    String toStatusCode(String name) {
      const status = [
        "Vắng mặt", // 0
        "Xin nghỉ", // 1
        "Đi muộn", // 2
        "Đúng giờ", // 3
      ];
      final index = status.indexOf(name);
      if (index == -1) return "-1"; // hoặc "Không xác định"
      return index.toString();
    }

    dio.options.headers['Authorization'] = 'Bearer $token';
    try {
      Response response;
      response = await dio.post(
        ApiPathTeacher.updateTT,
        data: FormData.fromMap(
          {
            'type_teacher': typeTeacher,
            'checkin_off_id': checkinOffId,
            'status': toStatusCode(status),
          },
        ),
      );
      if (response.data['status'] == 'error') {
        return "Cập nhật thất bại";
      } else if (response.data['status'] == 'success') {
        return "Cập nhật thành công";
      } else if (response.data['status'] == 'warning') {
        return "Cập nhật thất bại";
      }
      return "Đã có lỗi xảy ra, vui lòng thử lại sau";
    } catch (e) {
      return "Cập nhật thất bại";
    }
  }

  Future<String> changePhuDao({
    required String id,
    required String status,
    required String type,
  }) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final String? token = prefs.getString('token');

    dio.options.headers['Authorization'] = 'Bearer $token';
    try {
      Response response;
      response = await dio.post(
        type == 'phudao'
            ? ApiPathTeacher.updatePhuDao
            : ApiPathTeacher.updateXepBu,
        data: FormData.fromMap(
          {
            'status': status,
            'id': id,
          },
        ),
      );
      if (response.data['status'] == 'error') {
        return "Cập nhật thất bại";
      } else if (response.data['status'] == 'success') {
        return "Cập nhật thành công";
      } else if (response.data['status'] == 'warning') {
        return "Cập nhật thất bại";
      }
      return "Đã có lỗi xảy ra, vui lòng thử lại sau";
    } catch (e) {
      return "Cập nhật thất bại";
    }
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
            listError: violationErrors);
      }).toList();
    }

    return valueList.isNotEmpty ? attachViolationToValue() : [];
  }

  Future<String> changeThaiDo({
    required String typeTeacher,
    required String buoiHocId,
    required String customerId,
    required String violationErrorId,
    required String content,
    required int type,
  }) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final String? token = prefs.getString('token');

    dio.options.headers['Authorization'] = 'Bearer $token';
    try {
      Response response;
      response = await dio.post(
        type == 1
            ? ApiPathTeacher.updateAttitude
            : ApiPathTeacher.updateSituation,
        data: FormData.fromMap(
          {
            'type_teacher': typeTeacher,
            'buoi_hoc_id': buoiHocId,
            'customer_id': customerId,
            'violation_error_id': violationErrorId,
            'content': content,
          },
        ),
      );
      if (response.data['status'] == 'error') {
        return "Cập nhật thất bại";
      } else if (response.data['status'] == 'success') {
        return "Cập nhật thành công";
      } else if (response.data['status'] == 'warning') {
        return "Cập nhật thất bại";
      }
      return "Đã có lỗi xảy ra, vui lòng thử lại sau";
    } catch (e) {
      return "Cập nhật thất bại";
    }
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
