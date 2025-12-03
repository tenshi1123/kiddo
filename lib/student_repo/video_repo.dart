import 'package:dio/dio.dart';
import 'package:kiddo/student_models/info_class_model.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../utils/constants/api_path.dart';

class VideoRepository {
  Dio dio = Dio();
  Future<List<InfoClassModel>> getListClass() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final String? token = prefs.getString('token');
    dio.options.headers['Authorization'] = 'Bearer $token';
    Response response;
    response = await dio.get(
      ApiPath.listLessonVideo,
    );
    List<InfoClassModel> result = ((response.data)['data'] as List)
        .map((e) => InfoClassModel.fromJson(e))
        .toList();
    return result;
  }

  Future<CourseVideoModel> getListTopical({
    required String typeId,
    required String scheduleId,
    required String courseId,
  }) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final String? token = prefs.getString('token');
    dio.options.headers['Authorization'] = 'Bearer $token';
    final response = await dio.post(
      ApiPath.listTopical,
      data: {
        'course_id': courseId,
        'course_schedule_id': scheduleId,
        'setting_course_type_id': typeId,
      },
    );
    return CourseVideoModel.fromJson(response.data['data']);
  }

  Future<List<LessonVideoModel>> getlistLessonVideo({
    required String topicalId,
    required String settingCoureTypeId,
  }) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final String? token = prefs.getString('token');
    dio.options.headers['Authorization'] = 'Bearer $token';
    final response = await dio.post(
      ApiPath.listLecture,
      data: {
        'topical_id': topicalId,
        'setting_course_type_id': settingCoureTypeId,
      },
    );
    final data = response.data['data'];

    final List allItems = [
      ...?data['lessons'],
      ...?data['document'],
    ];
    final List<LessonVideoModel> result =
        allItems.map((e) => LessonVideoModel.fromJson(e)).toList();
    return result;
  }

  Future<String> getLinkVideo({
    required String lessonId,
    required String settingCoureTypeId,
    required String lessonType,
  }) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final String? token = prefs.getString('token');
    dio.options.headers['Authorization'] = 'Bearer $token';
    final response = await dio.post(
      ApiPath.detailLesson,
      data: {
        'lesson_id': lessonId,
        'setting_course_type_id': settingCoureTypeId,
        'lesson_type': lessonType,
      },
    );
    return response.data['data']['lesson_content'];
  }

  Future<BunnyModel> getBunny({
    required String lessonId,
    required String settingCoureTypeId,
    required String lessonType,
  }) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final String? token = prefs.getString('token');
    dio.options.headers['Authorization'] = 'Bearer $token';
    final response = await dio.post(
      ApiPath.detailLesson,
      data: {
        'lesson_id': lessonId,
        'setting_course_type_id': settingCoureTypeId,
        'lesson_type': lessonType,
      },
    );
    return BunnyModel.fromJson(response.data['data']);
  }
}
