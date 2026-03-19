import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:kiddo/modules/notification/notification.dart';
import 'package:kiddo/utils/constants/color.dart';
import 'package:kiddo/utils/constants/styles.dart';

class DetailNotiScreen extends StatefulWidget {
  const DetailNotiScreen({
    super.key,
    required this.item,
  });
  final NotificationModel item;
  @override
  State<DetailNotiScreen> createState() => _DetailNotiScreenState();
}

class _DetailNotiScreenState extends State<DetailNotiScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: mainOrange,
      appBar: AppBar(
        backgroundColor: mainOrange,
        elevation: 0,
        centerTitle: true,
        title: Text(
          'Nội dung thông báo',
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
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Image.asset('assets/images/news2.png'),
            Text(
              widget.item.title,
              style: defaultText14SB.copyWith(fontSize: 16.sp),
            ),
            SizedBox(height: 8.h),
            Text(
              widget.item.time,
              style: defaultText14Re.copyWith(
                color: colorText.withValues(alpha: 0.8),
              ),
            ),
            Text(
              widget.item.message,
              style: defaultText14Re,
            ),
          ],
        ),
      ),
    );
  }
}
