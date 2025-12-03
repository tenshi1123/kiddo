import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:kiddo/student_models/home_model.dart';
import 'package:kiddo/student_repo/home_repo.dart';
import 'package:kiddo/teacher_model/teacher_class_model.dart';
import 'package:kiddo/utils/constants/color.dart';
import 'package:kiddo/utils/constants/styles.dart';
import 'package:url_launcher/url_launcher.dart';

class DetailTuLuanScreen extends StatefulWidget {
  const DetailTuLuanScreen(
      {super.key, required this.documentModel, required this.valueModel});
  final DocumentModel? documentModel;
  final DeValueModel valueModel;
  @override
  State<DetailTuLuanScreen> createState() => _DetailTuLuanScreenState();
}

class _DetailTuLuanScreenState extends State<DetailTuLuanScreen> {
  String? _fileName;
  File? file;

  final TextEditingController noteController = TextEditingController();

  @override
  void initState() {
    noteController.text = widget.documentModel?.noteCustomers ?? '';
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
              child: Text(_fileName ?? "Chưa có tệp nào được chọn",
                  style: defaultText14M.copyWith(color: Colors.grey[600])),
            ),
            SizedBox(
              height: 20.h,
            ),
            GestureDetector(
              onTap: () async {
                if (!await launchUrl(Uri.parse(widget.valueModel.urlFile))) {
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
                      'Xem file Bài tập',
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
                readOnly: true,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  hintText: widget.documentModel?.finalMark ?? '',
                  fillColor: const Color(0xffF5F7FA),
                  filled: true,
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
                readOnly: true,
                style: defaultText14M,
                maxLines: 3,
                decoration: InputDecoration(
                  fillColor: const Color(0xffF5F7FA),
                  filled: true,
                  hintText: widget.documentModel?.noteTeacher ?? '',
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
            Padding(
              padding: EdgeInsets.symmetric(vertical: 12.h, horizontal: 16.w),
              child: TextField(
                controller: noteController,
                style: defaultText14M,
                maxLines: 3,
                decoration: InputDecoration(
                  //hintText: widget.documentModel?.noteTeacher ?? '',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  contentPadding:
                      const EdgeInsets.symmetric(vertical: 10, horizontal: 12),
                ),
              ),
            ),
            GestureDetector(
              onTap: () {
                HomeRepo().uploadExcercise(
                    id: widget.valueModel.id,
                    courseScheduleId:
                        widget.valueModel.customerCourseScheduleId,
                    note: noteController.text,
                    photo: file);
                showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return AlertDialog(
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10)),
                      title: Row(
                        children: [
                          const Icon(Icons.check_circle,
                              color: Colors.green, size: 28),
                          const SizedBox(width: 10),
                          Text("Thành công", style: defaultText16B),
                        ],
                      ),
                      content: Text(
                          "Thông tin của bạn đã được thay đổi thành công.",
                          style: defaultText14B),
                      actions: [
                        TextButton(
                          onPressed: () => Navigator.of(context).pop(),
                          child: Text("Đóng",
                              style: defaultText14M.copyWith(color: mainBlue)),
                        ),
                      ],
                    );
                  },
                );
              },
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
