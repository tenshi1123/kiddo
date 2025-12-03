import 'dart:io';

import 'package:dio/dio.dart';
import 'package:kiddo/student_models/excercise_model.dart' as exc;
import 'package:kiddo/student_models/my_course_model.dart';
import 'package:kiddo/utils/DioClient.dart';
import 'package:kiddo/utils/constants/api_path.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MycourseRepo {
  Dio dio = Dio();

  Future<List<MyCourseModel>> getListMyCourse() async {
    final dio = await DioClient.getInstance();
    Response response;
    response = await dio.post(
      ApiPath.myCourse,
    );
    List<MyCourseModel> list = [];
    for (var item in response.data['data']['value']) {
      list.add(MyCourseModel.fromJson(item));
    }
    return list;
  }

  Future<DetailMyCourse> getDetailMyCourse({required String id}) async {
    final dio = await DioClient.getInstance();
    Response response;
    response = await dio.post(
      ApiPath.detailMyCourse,
      data: {
        'id': id,
      },
    );
    return DetailMyCourse.fromJson(response.data['data']);
  }

  Future<DetailBaoCaoModel> getMycourseBaocao({required String id}) async {
    final dio = await DioClient.getInstance();
    Response response;
    response = await dio.post(
      ApiPath.detailBaoCao,
      data: {
        'id': id,
      },
    );
    return DetailBaoCaoModel.fromJson(response.data['data']);
  }

  Future<MycourseBaiTapModel> getMycourseBaitap({required String id}) async {
    final dio = await DioClient.getInstance();
    Response response;
    response = await dio.post(
      ApiPath.myCoursedetailBaiTap,
      data: {
        'id': id,
      },
    );
    return MycourseBaiTapModel.fromJson(response.data);
  }

  Future<exc.DetailBuoiHocModel> getDetailBuoiHoc({
    required String typeLearn,
    required String checkinOffId,
    required String meetingId,
  }) async {
    final dio = await DioClient.getInstance();
    Response response;
    response = await dio.post(
      ApiPath.detailBuoihoc,
      data: {
        'type_learn': typeLearn,
        'checkin_off_id': checkinOffId,
        'meeting_id': meetingId,
      },
    );
    return exc.DetailBuoiHocModel.fromJson(response.data['data']);
  }

  Future<String> uploadBtvn(
      {required String id, required List<File> photos}) async {
    final dio = await DioClient.getInstance();
    final formData = FormData.fromMap({
      'class_lesson_document_id': int.parse(id),
      'file[]': [
        for (final photo in photos)
          await MultipartFile.fromFile(
            photo.path,
            filename: photo.path.split('/').last,
          ),
      ],
    });
    Response response;
    response = await dio.post(
      ApiPath.uploadBtvn,
      data: formData,
    );
    return response.data['data'];
  }

  Future<String> takeADayOff({
    required String typeLearn,
    required String checkinOffId,
    required String meetingId,
    required String reason,
  }) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final String? token = prefs.getString('token');
    dio.options.headers['Authorization'] = 'Bearer $token';
    try {
      Response response;
      response = await dio.post(
        ApiPath.xinNghi,
        data: FormData.fromMap(
          {
            'type': typeLearn,
            'checkin_off_id': checkinOffId,
            'meeting_id': meetingId,
            'reason': reason,
          },
        ),
      );
      if (response.data['status'] == 'false') {
        return "Xin nghỉ thất bại - error";
      } else if (response.data['status'] == 'true') {
        return "Xin nghỉ thành công";
      } else if (response.data['status'] == 'warning') {
        return "Xin nghỉ thất bại - warning";
      }
      return "Đã có lỗi xảy ra, vui lòng thử lại sau";
    } catch (e) {
      return "Xin nghỉ thất bại";
    }
  }
}
