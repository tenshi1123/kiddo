import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:kiddo/teacher_model/home_teacher_model.dart';
import 'package:kiddo/utils/constants/styles.dart';

class InfoUser extends StatelessWidget {
  const InfoUser({
    super.key,
    required this.teacherProfileModel,
  });
  final TeacherProfileModel teacherProfileModel;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.black),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: const Text('Thông tin tài khoản'),
      ),
      body: Center(
        child: Column(
          children: [
            CircleAvatar(
              radius: 32.r,
              backgroundColor: Colors.grey,
              backgroundImage: NetworkImage(teacherProfileModel.avatar),
              //child: const Text('AH'),
            ),
            SizedBox(
              height: 320.h,
              width: 343.w,
              child: ListView.builder(
                padding: const EdgeInsets.all(8),
                itemCount: 3,
                itemBuilder: (context, idx) {
                  final children = <Widget>[
                    Container(
                      height: 56.h,
                      width: 343.w,
                      decoration: BoxDecoration(
                        color: const Color(0xffF7F7F7),
                        borderRadius: BorderRadius.all(
                          Radius.circular(
                            18.r,
                          ),
                        ),
                      ),
                      margin: EdgeInsets.only(
                        top: 18.h,
                      ),
                      child: Row(
                        children: [
                          SizedBox(
                            width: 16.w,
                          ),
                          Text(
                            teacherProfileModel.fullName,
                            style: defaultText16M.copyWith(
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      height: 56.h,
                      width: 343.w,
                      margin: EdgeInsets.only(
                        top: 18.h,
                      ),
                      decoration: BoxDecoration(
                        color: const Color(0xffF7F7F7),
                        borderRadius: BorderRadius.all(
                          Radius.circular(
                            18.r,
                          ),
                        ),
                      ),
                      child: Row(
                        children: [
                          SizedBox(
                            width: 16.w,
                          ),
                          Text(
                            teacherProfileModel.dob,
                            style: defaultText16M.copyWith(
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      height: 56.h,
                      width: 343.w,
                      margin: EdgeInsets.only(
                        top: 18.h,
                      ),
                      decoration: BoxDecoration(
                        color: const Color(0xffF7F7F7),
                        borderRadius: BorderRadius.all(
                          Radius.circular(
                            18.r,
                          ),
                        ),
                      ),
                      child: Row(
                        children: [
                          SizedBox(
                            width: 16.w,
                          ),
                          Text(
                            teacherProfileModel.phone,
                            style: defaultText16M.copyWith(
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ];
                  return children[idx];
                },
              ),
            )
          ],
        ),
      ),
    );
  }
}
