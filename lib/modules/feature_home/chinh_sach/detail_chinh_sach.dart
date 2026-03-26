import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:kiddo/student_repo/home_repo.dart';
import 'package:kiddo/utils/constants/color.dart';
import 'package:kiddo/utils/constants/styles.dart';

class DetailChinhSachScreen extends StatefulWidget {
  const DetailChinhSachScreen({
    super.key,
    required this.id,
    required this.title,
  });
  final String id;
  final String title;
  @override
  State<DetailChinhSachScreen> createState() => _DetailChinhSachScreenState();
}

class _DetailChinhSachScreenState extends State<DetailChinhSachScreen> {
  bool isLoading = true;
  late String data;
  @override
  void initState() {
    super.initState();
    fetchData();
  }

  Future<void> fetchData() async {
    try {
      final response =
          await HomeRepo().getChinhSach(courseScheduleId: widget.id);
      setState(() {
        data = response;
        isLoading = false;
      });
    } catch (e) {
      // Xử lý lỗi nếu cần
      debugPrint('Lỗi khi gọi API: $e');
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: mainOrange,
      appBar: AppBar(
        backgroundColor: mainOrange,
        elevation: 0,
        centerTitle: true,
        title: Text(
          widget.title,
          style: defaultText16B.copyWith(color: Colors.white),
        ),
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: const Icon(
            Icons.arrow_back_ios,
            color: Colors.white,
          ),
        ),
      ),
      body: Container(
        width: double.infinity,
        height: double.infinity,
        padding: EdgeInsets.symmetric(
          horizontal: 20.w,
          vertical: 16.h,
        ),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(26.r),
            topRight: Radius.circular(26.r),
          ),
        ),
        child: isLoading
            ? Center(child: CircularProgressIndicator())
            : SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Chính sách khoá : ${widget.title}',
                      style: defaultText14SB.copyWith(fontSize: 16.sp),
                    ),
                    SizedBox(height: 8.h),
                    Html(data: data)
                  ],
                ),
              ),
      ),
    );
  }
}
