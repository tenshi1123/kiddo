import 'package:dio/dio.dart';
import 'package:kiddo/student_models/review_models.dart';
import 'package:kiddo/utils/constants/api_path.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ExtensionRepo {
  Dio dio = Dio();
  // Lấy danh sách đánh giá của học viên
  Future<ListFeedBackModel> getListFeedback({required String id}) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final String? token = prefs.getString('token');
    dio.options.headers['Authorization'] = 'Bearer $token';
    Response response;
    response = await dio.post(ApiPath.listFeedback,
        data: FormData.fromMap({
          'customer_course_schedule_id': id,
        }));
    ListFeedBackModel result =
        ListFeedBackModel.fromJson((response.data)['data']);
    return result;
  }

  // Lấy chi tiết đánh giá của học viên
  Future<ReviewDetailModels> getDetailReview(String id) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final String? token = prefs.getString('token');
    dio.options.headers['Authorization'] = 'Bearer $token';
    Response response;
    response = await dio.post(
      ApiPath.detailsFeedback,
      data: {
        'id': id,
      },
    );
    return ReviewDetailModels.fromJson(response.data['data']['value']);
  }

  Future<List<DiscountModels>> getListDiscount() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final String? token = prefs.getString('token');
    dio.options.headers['Authorization'] = 'Bearer $token';
    Response response;
    response = await dio.get(
      ApiPath.discount,
    );
    List<DiscountModels> result = ((response.data)['data'] as List)
        .map((e) => DiscountModels.fromJson(e))
        .toList();
    return result;
  }

  Future<DetailDiscountModels> getDetailDiscount(String id) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final String? token = prefs.getString('token');
    dio.options.headers['Authorization'] = 'Bearer $token';
    Response response;
    response = await dio.post(ApiPath.detailDiscount,
        data: FormData.fromMap({'id': id}));
    return DetailDiscountModels.fromJson(response.data['data']);
  }
}
