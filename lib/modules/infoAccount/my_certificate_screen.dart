import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:kiddo/utils/constants/color.dart';
import 'package:kiddo/utils/constants/styles.dart';

class MyCertificateScreen extends StatefulWidget {
  const MyCertificateScreen({super.key});

  @override
  State<MyCertificateScreen> createState() => _MyCertificateScreenState();
}

class _MyCertificateScreenState extends State<MyCertificateScreen> {
  TextEditingController messageController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text(
          'Chứng chỉ của tôi',
          style: defaultText18B,
        ),
        toolbarHeight: 60.h,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios_new, color: mainBlue),
          onPressed: () => Navigator.of(context).pop(),
        ),
        backgroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            ListView.builder(
                shrinkWrap: true,
                physics: const ClampingScrollPhysics(),
                itemCount: 5,
                itemBuilder: (BuildContext context, int index) {
                  return CertificateItem(
                    title: 'Chứng chỉ ${index + 1}',
                  );
                }),
          ],
        ),
      ),
    );
  }
}

class CertificateItem extends StatelessWidget {
  const CertificateItem({super.key, required this.title});
  final String title;
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(
        horizontal: 20.w,
        vertical: 15.h,
      ),
      width: 350.w,
      height: 208.h,
      padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 10.h),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.2),
            spreadRadius: 5,
            blurRadius: 7,
            offset: const Offset(0, 2), // changes position of shadow
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          Container(
            height: 124.h,
            width: 322.w,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8.r),
              color: const Color(0xffD9D9D9),
            ),
          ),
          Text(
            title,
            style: defaultText18B,
          ),
          Text(
            'Ngày cấp',
            style: defaultText14Re,
          ),
        ],
      ),
    );
  }
}
