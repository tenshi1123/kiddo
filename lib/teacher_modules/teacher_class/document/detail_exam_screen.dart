import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:kiddo/teacher_model/teacher_class_model.dart';
import 'package:kiddo/utils/constants/styles.dart';
import 'package:url_launcher/url_launcher.dart';

class DetailExamScreen extends StatefulWidget {
  const DetailExamScreen({super.key, required this.documentModel});
  final DocumentModel? documentModel;
  @override
  State<DetailExamScreen> createState() => _DetailExamScreenState();
}

class _DetailExamScreenState extends State<DetailExamScreen> {
  String? _fileName;
  File? file;
  final TextEditingController scoreController = TextEditingController();
  final TextEditingController noteController = TextEditingController();
  // Future<void> _pickFile() async {
  //   FilePickerResult? result = await FilePicker.platform.pickFiles();
  //   if (result != null) {
  //     file = File(result.files.single.path!);
  //     setState(() {
  //       _fileName = result.files.single.name;
  //     });
  //   }
  // }

  @override
  void initState() {
    scoreController.text = widget.documentModel?.finalMark ?? '';
    noteController.text = widget.documentModel?.noteTeacher ?? '';
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: const Color(0xff00AEEF),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, color: Colors.white),
          onPressed: () {
            Navigator.of(context).pop(false);
          },
        ),
        title: Text(
          '    Chấm điểm bài tập',
          style: defaultText18B.copyWith(
            color: Colors.white,
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              width: double.infinity,
              height: 20.h,
              color: const Color(0xff00AEEF),
              child: Container(
                width: double.infinity,
                height: 20.h,
                decoration: BoxDecoration(
                  borderRadius:
                      BorderRadius.vertical(top: Radius.circular(20.r)),
                  color: Colors.white,
                ),
              ),
            ),
            Container(
              padding: const EdgeInsets.all(16),
              width: 343.w,
              decoration: BoxDecoration(
                color: Colors.grey[100],
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                _fileName ?? "Chưa có tệp nào được chọn",
                style: TextStyle(color: Colors.grey[600]),
              ),
            ),
            SizedBox(
              height: 20.h,
            ),
            GestureDetector(
              onTap: () async {
                if (!await launchUrl(
                    Uri.parse(widget.documentModel?.urlFileCustomer ?? ''))) {
                  throw Exception('Error no data');
                }
              },
              child: Container(
                margin: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
                padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 16.h),
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.all(
                      Radius.circular(12.r),
                    ),
                    color: const Color(0xffF5F7FA)),
                child: Row(
                  children: [
                    Image.asset(
                      'assets/images/document.png',
                      width: 28.w,
                      height: 28.h,
                    ),
                    SizedBox(
                      width: 8.w,
                    ),
                    Text(
                      'Xem file học sinh đã nộp',
                      style: defaultText16M,
                    ),
                    const Spacer(),
                  ],
                ),
              ),
            ),
            GestureDetector(
              onTap: () async {
                if (!await launchUrl(
                    Uri.parse(widget.documentModel?.urlFileTeacher ?? ''))) {
                  throw Exception('Error no data');
                }
              },
              child: Container(
                margin: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
                padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 16.h),
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.all(
                      Radius.circular(12.r),
                    ),
                    color: const Color(0xffF5F7FA)),
                child: Row(
                  children: [
                    Image.asset(
                      'assets/images/document.png',
                      width: 28.w,
                      height: 28.h,
                    ),
                    SizedBox(
                      width: 8.w,
                    ),
                    Text(
                      'Xem file giải',
                      style: defaultText16M,
                    ),
                    const Spacer(),
                  ],
                ),
              ),
            ),
            Row(
              children: [
                SizedBox(
                  width: 16.w,
                ),
                Text("Điểm bài tập", style: defaultText18B),
              ],
            ),
            Padding(
              padding: EdgeInsets.symmetric(vertical: 12.h, horizontal: 16.w),
              child: TextField(
                style: defaultText14M,
                controller: scoreController,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  // hintText: widget.documentModel?.finalMark ?? '',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  contentPadding:
                      const EdgeInsets.symmetric(vertical: 10, horizontal: 12),
                ),
              ),
            ),
            Row(
              children: [
                SizedBox(
                  width: 16.w,
                ),
                Text("Ghi chú của giáo viên", style: defaultText18B),
              ],
            ),
            Padding(
              padding: EdgeInsets.symmetric(vertical: 12.h, horizontal: 16.w),
              child: TextField(
                controller: noteController,
                style: defaultText14M,
                maxLines: 3,
                decoration: InputDecoration(
                  // hintText: widget.documentModel?.noteTeacher ?? '',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  contentPadding:
                      const EdgeInsets.symmetric(vertical: 10, horizontal: 12),
                ),
              ),
            ),
            Row(
              children: [
                SizedBox(
                  width: 16.w,
                ),
                Text("Ghi chú của học viên", style: defaultText18B),
              ],
            ),
            Container(
              width: 358.w,
              height: 120.h,
              padding: const EdgeInsets.all(16),
              margin: EdgeInsets.symmetric(vertical: 12.h, horizontal: 16.w),
              decoration: BoxDecoration(
                color: Colors.blueGrey[50], // Màu nền nhạt
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                widget.documentModel?.noteCustomers ?? '',
                style: defaultText14M,
              ),
            ),
            GestureDetector(
              onTap: () {},
              child: Container(
                width: 358.w,
                height: 50.h,
                margin: EdgeInsets.symmetric(vertical: 12.h, horizontal: 16.w),
                decoration: BoxDecoration(
                  color: const Color(0xff00AEEF), // Màu nền nhạt
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Center(
                  child: Text(
                    'Lưu thay đổi',
                    style: defaultText16B.copyWith(color: Colors.white),
                  ),
                ),
              ),
            ),
            SizedBox(
              height: 30.h,
            )
          ],
        ),
      ),
    );
  }
}
