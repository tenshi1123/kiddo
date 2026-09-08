import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:intl/intl.dart';
import 'package:kiddo/core/localization/language_cubit.dart';
import 'package:kiddo/l10n/l10n.dart';
import 'package:kiddo/modules/feature_home/hoc_phi/confirm_screen.dart';
import 'package:kiddo/student_repo/customer_repo.dart';
import 'package:kiddo/student_repo/mycourse_repo.dart';
import 'package:kiddo/teacher_repo/teacher_class_repo.dart';
import 'package:kiddo/utils/constants/color.dart';
import 'package:kiddo/utils/constants/styles.dart';

class LeaveRequestDialog extends StatelessWidget {
  const LeaveRequestDialog(
      {super.key,
      required this.typeLearn,
      required this.checkinOffId,
      required this.meetingId,
      required this.time});
  final String typeLearn;

  final String checkinOffId;
  final String meetingId;
  final DateTime time;
  @override
  Widget build(BuildContext context) {
    TextEditingController reasonController = TextEditingController();

    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      backgroundColor: Colors.white,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Lịch học: ${DateFormat('yyyy-MM-dd').format(time)}',
              style: defaultText16M,
            ),
            const SizedBox(height: 16),
            Text(
              'Lý do xin nghỉ',
              style: defaultText16M,
            ),
            const SizedBox(height: 8),
            TextField(
              controller: reasonController,
              maxLines: 3,
              decoration: InputDecoration(
                hintText: 'Nhập lý do nghỉ',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                contentPadding: const EdgeInsets.all(12),
              ),
            ),
            const SizedBox(height: 24),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: () {
                      Navigator.of(context).pop(); // Close the dialog
                    },
                    style: OutlinedButton.styleFrom(
                      foregroundColor: Colors.black,
                      backgroundColor: const Color(0xFFF7F4F6),
                      padding: const EdgeInsets.symmetric(vertical: 14),
                    ),
                    child: const Text('Hủy'),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: ElevatedButton(
                    onPressed: () async {
                      // Handle confirmation logic
                      String message = await MycourseRepo().takeADayOff(
                          typeLearn: typeLearn,
                          checkinOffId: checkinOffId,
                          meetingId: meetingId,
                          reason: reasonController.text);
                      if (!context.mounted) return;
                      showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return AlertDialog(
                            title: Text(
                              message,
                              style: defaultText16B,
                            ),
                            actionsPadding:
                                const EdgeInsets.symmetric(horizontal: 10.0),
                            actions: <Widget>[
                              TextButton(
                                child: const Text(
                                  'OK',
                                ),
                                onPressed: () {
                                  Navigator.of(context).pop();
                                },
                              ),
                            ],
                          );
                        },
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: mainRed,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 14),
                    ),
                    child: const Text('Xác nhận'),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

Future<void> showInviteDialog(BuildContext context) {
  final nameController = TextEditingController();
  final dobController = TextEditingController();
  final phoneController = TextEditingController();
  final emailController = TextEditingController();
  final noteController = TextEditingController();

  return showDialog(
    context: context,
    barrierDismissible: false, // bấm ra ngoài không tắt
    builder: (context) {
      return Dialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        backgroundColor: Colors.white,
        insetPadding: const EdgeInsets.symmetric(horizontal: 16),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  IconButton(
                    icon: SvgPicture.asset(
                      'assets/icons/close.svg',
                      height: 18.h,
                      width: 18.w,
                    ),
                    onPressed: () => Navigator.pop(context),
                  )
                ],
              ),
              Text(
                "Thông tin người bạn muốn rủ",
                style: defaultText16B,
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 16.h),
              _buildTextField(
                label: "Họ và tên ",
                requiredField: true,
                svg: 'assets/icons/name.svg',
                controller: nameController,
              ),
              SizedBox(height: 12.h),
              _buildTextField(
                label: "Năm sinh",
                svg: 'assets/icons/birth.svg',
                controller: dobController,
              ),
              SizedBox(height: 12.h),
              _buildTextField(
                label: "Số điện thoại ",
                requiredField: true,
                svg: 'assets/icons/phone.svg',
                controller: phoneController,
              ),
              SizedBox(height: 12.h),
              _buildTextField(
                label: "Email",
                svg: 'assets/icons/email.svg',
                controller: emailController,
              ),
              SizedBox(height: 12.h),
              _buildTextField(
                label: "Lời nhắn (Nếu có)",
                svg: null,
                maxLines: 3,
                controller: noteController,
              ),
              SizedBox(height: 20.h),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: mainOrange,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12.r),
                    ),
                    padding: const EdgeInsets.symmetric(vertical: 14),
                  ),
                  onPressed: () {
                    if (nameController.text.isNotEmpty &&
                        phoneController.text.isNotEmpty) {
                      CustomerRepo().inviteFriend(
                        fullName: nameController.text,
                        date: dobController.text,
                        phone: phoneController.text,
                        email: emailController.text,
                        content: noteController.text,
                      );
                      showSuccessDialog(context, 1);
                    } else {
                      showDialog(
                        context: context,
                        builder: (context) => AlertDialog(
                          title: Text(
                            'Thiếu thông tin',
                            style: defaultText16B,
                          ),
                          content: Text(
                            'Vui lòng nhập Họ tên và Số điện thoại',
                            style: defaultText14M,
                          ),
                          actions: [
                            TextButton(
                              onPressed: () => Navigator.pop(context),
                              child: Text(
                                'Đóng',
                                style: defaultText14M,
                              ),
                            ),
                          ],
                        ),
                      );
                    }
                  },
                  child: Text(
                    "Gửi",
                    style: defaultText16M.copyWith(color: Colors.white),
                  ),
                ),
              ),
            ],
          ),
        ),
      );
    },
  );
}

// Hàm build TextField có icon
Widget _buildTextField({
  required String label,
  // IconData? icon,
  String? svg,
  bool requiredField = false,
  int maxLines = 1,
  required TextEditingController controller,
  String? errorText,
}) {
  return TextField(
    controller: controller,
    maxLines: maxLines,
    decoration: InputDecoration(
      //prefixIcon: icon != null ? Icon(icon, size: 20) : null,
      prefixIcon: svg != null
          ? SvgPicture.asset(
              svg,
              height: 14.h,
              width: 14.w,
              fit: BoxFit.scaleDown,
            )
          : null,
      label: RichText(
        text: TextSpan(
          text: label,
          style: defaultText14M.copyWith(color: Colors.grey.shade600),
          children: requiredField
              ? [
                  TextSpan(
                    text: " *",
                    style: defaultText14M.copyWith(color: mainRed),
                  ),
                ]
              : [],
        ),
      ),
      hintStyle: defaultText12M,
      fillColor: Colors.grey.shade100,
      contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
      hintText: label,
      errorText: errorText,
      filled: true,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: BorderSide.none,
      ),
    ),
  );
}

Future<void> showLeaveReasonDialog(BuildContext context,
    {required String typeLearn,
    required String checkinOffId,
    required String meetingId}) async {
  TextEditingController reasonController = TextEditingController();
  showDialog(
    context: context,
    builder: (context) {
      return Dialog(
        backgroundColor: Colors.white,
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(16.r)),
        insetPadding: EdgeInsets.symmetric(horizontal: 24.w),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // --- Header ---
            Container(
              width: double.infinity,
              padding: EdgeInsets.symmetric(vertical: 14.h, horizontal: 16.w),
              decoration: BoxDecoration(
                color: Colors.red,
                borderRadius: BorderRadius.vertical(top: Radius.circular(16.r)),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text("Lý do xin nghỉ",
                      style: defaultText16B.copyWith(color: Colors.white)),
                  GestureDetector(
                    onTap: () => Navigator.pop(context),
                    child: const Icon(Icons.close, color: Colors.white),
                  ),
                ],
              ),
            ),

            // --- Nội dung ---
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // // --- chọn lớp ---
                  // GestureDetector(
                  //   onTap: () {
                  //     // TODO: mở bottom sheet chọn lớp
                  //   },
                  //   child: Container(
                  //     padding: EdgeInsets.symmetric(
                  //         horizontal: 12.w, vertical: 10.h),
                  //     margin: EdgeInsets.only(bottom: 10.h),
                  //     decoration: BoxDecoration(
                  //       color: Colors.grey.shade100,
                  //       borderRadius: BorderRadius.circular(12.r),
                  //     ),
                  //     child: Row(
                  //       children: [
                  //         SvgPicture.asset('assets/icons/videocall_1.svg'),
                  //         SizedBox(width: 8.w),
                  //         Expanded(
                  //           child: Text("Lớp tiếng anh cơ bản CB001",
                  //               style: defaultText14M),
                  //         ),
                  //       ],
                  //     ),
                  //   ),
                  // ),

                  // // --- chọn buổi ---
                  // GestureDetector(
                  //   onTap: () {
                  //     // TODO: mở bottom sheet chọn buổi học
                  //   },
                  //   child: Container(
                  //     padding: EdgeInsets.symmetric(
                  //         horizontal: 12.w, vertical: 10.h),
                  //     margin: EdgeInsets.only(bottom: 10.h),
                  //     decoration: BoxDecoration(
                  //       color: Colors.grey.shade100,
                  //       borderRadius: BorderRadius.circular(12.r),
                  //     ),
                  //     child: Row(
                  //       children: [
                  //         SvgPicture.asset('assets/icons/calendar1.svg'),
                  //         SizedBox(width: 8.w),
                  //         Expanded(
                  //           child: Text("Thứ 6 (08:30 - 10:30)",
                  //               style: defaultText14M),
                  //         ),
                  //       ],
                  //     ),
                  //   ),
                  // ),

                  // --- nhập lý do ---
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.grey.shade100,
                      borderRadius: BorderRadius.circular(12.r),
                    ),
                    child: TextField(
                      maxLines: 4,
                      controller: reasonController,
                      decoration: InputDecoration(
                        hintText: "Lý do của bạn",
                        hintStyle: defaultText14M.copyWith(color: Colors.grey),
                        border: InputBorder.none,
                        contentPadding: EdgeInsets.symmetric(
                            horizontal: 12.w, vertical: 10.h),
                      ),
                    ),
                  ),

                  SizedBox(height: 16.h),

                  // --- nút gửi ---
                  SizedBox(
                    width: double.infinity,
                    height: 45.h,
                    child: ElevatedButton(
                      onPressed: () {
                        MycourseRepo().takeADayOff(
                          typeLearn: typeLearn,
                          checkinOffId: checkinOffId,
                          meetingId: meetingId,
                          reason: reasonController.text,
                        );
                        Navigator.pop(context);
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.red,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12.r),
                        ),
                      ),
                      child: Text(
                        "Gửi",
                        style: defaultText16B.copyWith(color: Colors.white),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      );
    },
  );
}

void showTeachingDialog(
  BuildContext context,
  String title,
  String id,
  String? content,
  String? linkRecording,
) {
  final TextEditingController contentController = TextEditingController(text: content);
  final TextEditingController linkController = TextEditingController(text: linkRecording);

  showDialog(
    context: context,
    barrierDismissible: true,
    builder: (context) {
      return Dialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16.r),
        ),
        insetPadding: EdgeInsets.symmetric(horizontal: 24.w),
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16.r),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header
              Container(
                padding: EdgeInsets.symmetric(vertical: 10.h, horizontal: 12.w),
                decoration: BoxDecoration(
                  color: mainGreen,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(12.r),
                    topRight: Radius.circular(12.r),
                  ),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(title,
                        style: defaultText16B.copyWith(color: Colors.white)),
                    GestureDetector(
                      onTap: () => Navigator.pop(context),
                      child: const Icon(Icons.close, color: Colors.white),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 16.h),
              Padding(
                padding: EdgeInsetsGeometry.symmetric(horizontal: 16.w),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Nội dung giảng dạy
                    Text(
                      "Nội dung giảng dạy",
                      style: defaultText14M.copyWith(
                        color: colorText.withValues(alpha: 0.6),
                      ),
                    ),
                    SizedBox(height: 6.h),
                    TextField(
                      controller: contentController,
                      maxLines: 4,
                      decoration: InputDecoration(
                        hintText: content,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8.r),
                          borderSide: BorderSide(color: Colors.grey.shade100),
                        ),
                      ),
                    ),
                    SizedBox(height: 12.h),

                    // Link recording
                    Text(
                      "Link recording",
                      style: defaultText14M.copyWith(
                        color: colorText.withValues(alpha: 0.6),
                      ),
                    ),
                    SizedBox(height: 6.h),
                    TextField(
                      controller: linkController,
                      decoration: InputDecoration(
                        hintText: linkRecording,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8.r),
                          borderSide: BorderSide(color: Colors.grey.shade100),
                        ),
                      ),
                    ),
                    SizedBox(height: 20.h),

                    // Button Lưu
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: () {
                          TeacherClassRepo()
                              .updateContentOff(
                            content: contentController.text,
                            linkRecording: linkController.text,
                            id: id,
                          )
                              .then((value) {
                            if (!context.mounted) return;
                            Navigator.pop(context);
                          });
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: mainGreen,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8.r),
                          ),
                          padding: EdgeInsets.symmetric(vertical: 12.h),
                        ),
                        child: Text("Lưu",
                            style:
                                defaultText16B.copyWith(color: Colors.white)),
                      ),
                    ),
                    SizedBox(height: 20.h),
                  ],
                ),
              ),
            ],
          ),
        ),
      );
    },
  );
}

void appointmentInfo(BuildContext context, String title) {
  showDialog(
    context: context,
    barrierDismissible: true,
    builder: (context) {
      return Dialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16.r),
        ),
        insetPadding: EdgeInsets.symmetric(horizontal: 24.w),
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16.r),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header
              Container(
                padding: EdgeInsets.symmetric(vertical: 10.h, horizontal: 12.w),
                decoration: BoxDecoration(
                  color: mainOrange,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(12.r),
                    topRight: Radius.circular(12.r),
                  ),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('Thông tin lịch hẹn',
                        style: defaultText16B.copyWith(color: Colors.white)),
                    GestureDetector(
                      onTap: () => Navigator.pop(context),
                      child: const Icon(Icons.close, color: Colors.white),
                    ),
                  ],
                ),
              ),

              Padding(
                padding: EdgeInsetsGeometry.only(
                  left: 16.w,
                  right: 16.w,
                  bottom: 16.h,
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      height: 180.h,
                      width: 303.w,
                      child: Row(
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              Text(
                                'Cơ sở :',
                                style: defaultText16M.copyWith(
                                  color: colorText.withValues(alpha: 0.6),
                                ),
                              ),
                              Text(
                                'Học viên : ',
                                style: defaultText16M.copyWith(
                                  color: colorText.withValues(alpha: 0.6),
                                ),
                              ),
                              Text(
                                'CM :',
                                style: defaultText16M.copyWith(
                                  color: colorText.withValues(alpha: 0.6),
                                ),
                              ),
                              Text(
                                'Thời gian :',
                                style: defaultText16M.copyWith(
                                  color: colorText.withValues(alpha: 0.6),
                                ),
                              ),
                            ],
                          ),
                          SizedBox(
                            width: 30.w,
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              Text(
                                'Cơ sở 1',
                                style: defaultText14SB.copyWith(
                                  fontSize: 16.sp,
                                ),
                              ),
                              Text(
                                'Nguyễn Lâm Anh',
                                style: defaultText14SB.copyWith(
                                  fontSize: 16.sp,
                                ),
                              ),
                              Text(
                                'Sale Phan Anh A',
                                style: defaultText14SB.copyWith(
                                  fontSize: 16.sp,
                                ),
                              ),
                              Text(
                                '17:30 28/02/2024',
                                style: defaultText14SB.copyWith(
                                  fontSize: 16.sp,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    Text(
                      'Ghi chú :',
                      style: defaultText16M.copyWith(
                        color: colorText.withValues(alpha: 0.6),
                      ),
                    ),
                    SizedBox(
                      height: 6.h,
                    ),
                    Container(
                      width: 303.w,
                      height: 120.h,
                      padding: EdgeInsets.symmetric(
                        horizontal: 16.w,
                        vertical: 12.h,
                      ),
                      decoration: BoxDecoration(
                        color: Color(0xffF5F7FA),
                        borderRadius: BorderRadius.all(
                          Radius.circular(
                            16.r,
                          ),
                        ),
                      ),
                      child: Text(
                        'Khách hẹn đến trung tâm',
                        style: defaultText14M,
                      ),
                    )
                  ],
                ),
              ),
            ],
          ),
        ),
      );
    },
  );
}

Future<bool?> showConfirmDialog({
  required BuildContext context,
  String title = "Xác nhận",
  required String content,
  String confirmText = "Có",
  String cancelText = "Không",
}) {
  return showDialog<bool>(
    context: context,
    barrierDismissible: false, // Không cho tắt khi bấm ra ngoài
    builder: (context) {
      return Dialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12.r),
        ),
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                title,
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 10),
              Text(
                content,
                textAlign: TextAlign.center,
                style: const TextStyle(fontSize: 16),
              ),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  // Nút không
                  TextButton(
                    onPressed: () => Navigator.of(context).pop(false),
                    child: Text(
                      cancelText,
                      style: const TextStyle(fontSize: 16),
                    ),
                  ),

                  // Nút có
                  ElevatedButton(
                    onPressed: () => Navigator.of(context).pop(true),
                    child: Text(
                      confirmText,
                      style: const TextStyle(fontSize: 16),
                    ),
                  ),
                ],
              )
            ],
          ),
        ),
      );
    },
  );
}

void showLanguageDialog(BuildContext context) {
  showDialog(
    context: context,
    builder: (_) {
      return AlertDialog(
        title: Text(L10n.of(context).chooseLanguage),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _LanguageItem(
              title: 'Tiếng Việt',
              locale: const Locale('vi'),
            ),
            _LanguageItem(
              title: 'English',
              locale: const Locale('en'),
            ),
          ],
        ),
      );
    },
  );
}

class _LanguageItem extends StatelessWidget {
  final String title;
  final Locale locale;

  const _LanguageItem({
    required this.title,
    required this.locale,
  });

  @override
  Widget build(BuildContext context) {
    final current = context.watch<LanguageCubit>().state;

    return ListTile(
      title: Text(title),
      trailing: current.languageCode == locale.languageCode
          ? const Icon(Icons.check, color: Colors.green)
          : null,
      onTap: () {
        context.read<LanguageCubit>().changeLanguage(locale);
        Navigator.pop(context);
      },
    );
  }
}
