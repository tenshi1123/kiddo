import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kiddo/app.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:kiddo/core/localization/language_cubit.dart';
import 'package:kiddo/student_models/diem_danh_model.dart';
import 'package:kiddo/student_models/home_model.dart';
import 'package:kiddo/teacher_model/teacher_class_model.dart';
import 'package:kiddo/utils/constants/api_path.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:kiddo/utils/constants/api_path_teacher.dart';
import 'package:onesignal_flutter/onesignal_flutter.dart';


List<ClassModel> listClass = [];
List<TeacherClassModel> listTeacherClass = [];
List<CategoryModel> listCategory = [];
Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  

  // 2. Khởi tạo OneSignal ngay từ đầu (Tránh crash khi bấm push notification vào app)
  OneSignal.Debug.setLogLevel(OSLogLevel.verbose);
  OneSignal.initialize("c4d95506-f931-4d7c-9f02-793f2cbe76c2");
  OneSignal.Notifications.requestPermission(true);

  await initApiConfig();
  initializeDateFormatting().then((_) => runApp(
        MultiBlocProvider(
          providers: [
            BlocProvider(
              create: (_) => LanguageCubit(),
            ),
          ],
          child: const App(),
        ),
      ));
}

Future<void> initApiConfig() async {
  // ✅ FIX: Thêm timeout 8 giây để không block app vô hạn khi mạng chậm / server down
  try {
    debugPrint('[initApiConfig] 🚀 Đang tải cấu hình API...');
    final res = await http
        .get(
          Uri.parse(
              'https://612ced09ab461c00178b5fbb.mockapi.io/api/users/kiddo'),
        )
        .timeout(const Duration(seconds: 8));

    final data = jsonDecode(res.body);
    ApiPath.hocvienUrl = data[0]['domain'] + 'api';
    ApiPathTeacher.baseUrl = data[0]['domain'];
    debugPrint('[initApiConfig] ✅ Cấu hình API thành công: ${ApiPath.hocvienUrl}');
  } catch (e) {
    // Fallback: giữ nguyên giá trị mặc định đã được khai báo trong ApiPath/ApiPathTeacher
    // App vẫn có thể chạy, sẽ lỗi khi gọi API cụ thể nếu URL sai
    debugPrint('[initApiConfig] ⚠️ Không tải được cấu hình API: $e – dùng fallback URL');
  }
}
