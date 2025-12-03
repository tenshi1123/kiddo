import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:kiddo/utils/constants/color.dart';
import 'package:kiddo/utils/constants/styles.dart';

class ForgotPassScreen extends StatefulWidget {
  const ForgotPassScreen({super.key});
  @override
  State<ForgotPassScreen> createState() => _ForgotPassScreenState();
}

class _ForgotPassScreenState extends State<ForgotPassScreen> {
  final _focusNode = FocusNode();
  final _focusNode1 = FocusNode();
  TextEditingController? passController = TextEditingController();
  TextEditingController? studenIdController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      backgroundColor: Colors.white,
      body: GestureDetector(
        onTap: () {
          _focusNode.unfocus();
        },
        child: Padding(
          padding: EdgeInsets.only(
            left: 20.w,
            right: 20.w,

            //bottom: MediaQuery.of(context).viewInsets.bottom,
          ),
          child: SingleChildScrollView(
            child: Column(
              children: [
                SizedBox(height: 20.h),
                SizedBox(
                  width: 340.w,
                  height: 309.h,
                  // decoration: const BoxDecoration(
                  //   image: DecorationImage(
                  //       image: AssetImage('assets/images/forgot_pass.png'),
                  //       fit: BoxFit.fitWidth),
                  // ),
                ),
                Text(
                  'Quên mật khẩu ?',
                  textAlign: TextAlign.right,
                  overflow: TextOverflow.clip,
                  style: defaultText18B,
                ),
                Text(
                  'Nhập email đã đăng kí với trung tâm',
                  textAlign: TextAlign.right,
                  style: TextStyle(
                    color: const Color(0xff999999),
                    fontSize: 13.sp,
                    fontWeight: FontWeight.normal,
                  ),
                  overflow: TextOverflow.clip,
                ),
                SizedBox(
                  height: 30.h,
                ),
                Row(
                  children: [
                    Text(
                      'Nhập số điện thoại',
                      style: defaultText14M,
                    ),
                    const Spacer()
                  ],
                ),
                SizedBox(
                  height: 5.h,
                ),
                Container(
                  width: 350.w,
                  height: 58.h,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(8.r)),
                    color: const Color(0xffF4F1F3),
                  ),
                  child: TextField(
                    keyboardType: const TextInputType.numberWithOptions(),
                    controller: studenIdController,
                    focusNode: _focusNode1,
                    scrollPadding: EdgeInsets.symmetric(
                        vertical: MediaQuery.of(context).viewInsets.bottom),
                    decoration: InputDecoration(
                      border:
                          const OutlineInputBorder(borderSide: BorderSide.none),
                      hintStyle: TextStyle(
                        fontSize: 16.sp,
                        color: Colors.black,
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  height: 10.h,
                ),
                SizedBox(
                  height: 30.h,
                ),
                GestureDetector(
                  onTap: () {},
                  child: Container(
                    height: 48.h,
                    width: 191.w,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(9.r),
                        color: mainOrange),
                    child: Center(
                      child: Text(
                        'Xác nhận',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 14.sp,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  height: 200.h,
                ),
                GestureDetector(
                  onTap: () {
                    Navigator.of(context).pop();
                  },
                  child: Text(
                    'Quay lại',
                    style: TextStyle(
                      color: mainOrange,
                      fontSize: 14.sp,
                      decoration: TextDecoration.underline,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
