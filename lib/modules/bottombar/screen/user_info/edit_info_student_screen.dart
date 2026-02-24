import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:kiddo/student_models/profile_model.dart';
import 'package:kiddo/student_repo/customer_repo.dart';
import 'package:kiddo/utils/constants/color.dart';
import 'package:kiddo/utils/constants/styles.dart';

class EditInfoStudentScreen extends StatefulWidget {
  final ProfileModel profileModel;
  const EditInfoStudentScreen({super.key, required this.profileModel});

  @override
  State<EditInfoStudentScreen> createState() => _EditInfoStudentScreenState();
}

class _EditInfoStudentScreenState extends State<EditInfoStudentScreen> {
  TextEditingController nameController = TextEditingController();
  TextEditingController phoneController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController birthdayController = TextEditingController();
  TextEditingController addressController = TextEditingController();

  @override
  void initState() {
    nameController.text = widget.profileModel.email;
    phoneController.text = widget.profileModel.phone;
    emailController.text = widget.profileModel.email;

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('Thông tin cá nhân'),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.symmetric(horizontal: 20.w),
        child: Column(
          children: [
            // Avatar + nút thêm
            Stack(
              alignment: Alignment.bottomRight,
              children: [
                CircleAvatar(
                    radius: 60,
                    backgroundImage: NetworkImage(
                      'https://lms.kiddoenglish.edu.vn/images/${widget.profileModel.avatar}',
                    ) // hoặc NetworkImage
                    ),
                Positioned(
                  bottom: 4,
                  right: 4,
                  child: Container(
                    padding: const EdgeInsets.all(6),
                    decoration: const BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.blue,
                    ),
                    child: const Icon(
                      Icons.add,
                      size: 18,
                      color: Colors.white,
                    ),
                  ),
                ),
              ],
            ),

            SizedBox(height: 24.h),
            buildLabeledField(
              label: 'Họ và tên',
              controller: nameController,
              context: context,
            ),
            SizedBox(height: 16.h),
            buildLabeledField(
              label: 'Số điện thoại',
              controller: phoneController,
              context: context,
            ),
            SizedBox(height: 16.h),
            buildLabeledField(
              label: 'Email',
              controller: emailController,
              context: context,
            ),
            SizedBox(height: 16.h),
            buildLabeledField(
              label: 'Sinh nhật',
              controller: birthdayController,
              context: context,
              isDateField: true,
            ),
            SizedBox(height: 16.h),
            buildLabeledField(
              label: 'Địa chỉ',
              controller: addressController,
              context: context,
            ),
            SizedBox(height: 32.h),
            // Nút lưu
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () async {
                  // Lưu dữ liệu
                  String message = await CustomerRepo().changeInfo(
                    name: nameController.text,
                    email: emailController.text,
                    dob: birthdayController.text,
                  );
                  if (!context.mounted) return;
                  //show dialog
                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        title: Text(
                          message,
                          style: defaultText16M.copyWith(
                            color: const Color.fromARGB(255, 29, 29, 29),
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        actionsPadding:
                            const EdgeInsets.symmetric(horizontal: 10.0),
                        actions: <Widget>[
                          TextButton(
                            child: Text(
                              'ok',
                              style: defaultText16M.copyWith(
                                  color: const Color(0xff3C3C3C)),
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
                  backgroundColor: Color(0xFF00B0F0),
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: Text('Lưu thay đổi',
                    style: defaultText16B.copyWith(color: Colors.white)),
              ),
            ),
            SizedBox(height: 32.h),
          ],
        ),
      ),
    );
  }
}

Widget buildLabeledField({
  required BuildContext context,
  required String label,
  required TextEditingController controller,
  bool isDateField = false,
  void Function(DateTime)? onDateSelected,
}) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text(
        label,
        style: defaultText14B.copyWith(color: const Color(0xFF102B61)),
      ),
      const SizedBox(height: 8),
      GestureDetector(
        onTap: isDateField
            ? () async {
                FocusScope.of(context).unfocus();
                final selectedDate = await showDatePicker(
                  context: context,
                  initialDate: DateTime.now(),
                  firstDate: DateTime(1900),
                  lastDate: DateTime(2100),
                );
                if (!context.mounted) return;
                if (selectedDate != null) {
                  controller.text =
                      '${selectedDate.day.toString().padLeft(2, '0')}-${selectedDate.month.toString().padLeft(2, '0')}-${selectedDate.year}';
                  if (onDateSelected != null) onDateSelected(selectedDate);
                }
              }
            : null,
        child: AbsorbPointer(
          absorbing: isDateField,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
            decoration: BoxDecoration(
              color: const Color(0xFFF5F2F6).withValues(alpha: 0.2),
              border: Border.all(
                color: Color(0xFFF5F2F6).withValues(alpha: 0.8),
              ),
              borderRadius: BorderRadius.circular(8),
            ),
            child: TextField(
              controller: controller,
              style: defaultText14M.copyWith(color: mainBlue),
              decoration: const InputDecoration.collapsed(hintText: ''),
            ),
          ),
        ),
      ),
    ],
  );
}
