import 'package:flutter/material.dart';
import 'package:kiddo/l10n/app_localizations.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:kiddo/modules/notification/detail_notification.dart';
import 'package:kiddo/utils/constants/color.dart';
import 'package:kiddo/utils/constants/styles.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:kiddo/student_repo/customer_repo.dart';
import 'package:kiddo/teacher_repo/teacher_repo.dart';
import 'package:kiddo/student_models/profile_model.dart';
import 'package:kiddo/utils/constants/const_string.dart';

class NotificationModel {
  final String title;
  final String message;
  final String time;
  bool isRead;

  NotificationModel({
    required this.title,
    required this.message,
    required this.time,
    this.isRead = false,
  });
}

class NotificationGroup {
  final String dateTitle;
  final List<NotificationModel> items;

  NotificationGroup({required this.dateTitle, required this.items});
}

class NotificationScreen extends StatefulWidget {
  const NotificationScreen({super.key});

  @override
  State<NotificationScreen> createState() => _NotificationScreenState();
}

class _NotificationScreenState extends State<NotificationScreen> {
  List<NotificationModel> notifications = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchNotifications();
  }

  Future<void> _fetchNotifications() async {
    try {
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      final String? type = prefs.getString(ConstString.type);
      List<NotiModel> data = [];
      if (type == 'teacher') {
        data = await TeacherRepo().getListNoti();
      } else {
        data = await CustomerRepo().getListNoti();
      }

      if (mounted) {
        setState(() {
          notifications = data
              .map((noti) => NotificationModel(
                    title: noti.title,
                    message: noti.content,
                    time: noti.createdAt,
                    isRead: true,
                  ))
              .toList();
          isLoading = false;
        });
      }
    } catch (e) {
      print('Error fetching notifications: $e');
      if (mounted) {
        setState(() {
          isLoading = false;
        });
      }
    }
  }

  void markAllAsRead() {
    setState(() {
      for (var item in notifications) {
        item.isRead = true;
      }
    });
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
          'Thông báo',
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
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(26.r),
            topRight: Radius.circular(26.r),
          ),
        ),
        child: Column(
          children: [
            Expanded(
              child: isLoading
                  ? const Center(child: CircularProgressIndicator())
                  : notifications.isEmpty
                      ? Center(
                          child:
                              Text(AppLocalizations.of(context).noNotification))
                      : ListView.builder(
                          itemCount: notifications.length,
                          itemBuilder: (context, index) {
                            return NotificationItem(item: notifications[index]);
                          },
                        ),
            ),
            SizedBox(height: 12.h),
            Center(
              child: OutlinedButton(
                onPressed: markAllAsRead,
                style: OutlinedButton.styleFrom(
                  side: BorderSide(color: mainOrange, width: 1.4),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12.r)),
                  padding:
                      EdgeInsets.symmetric(horizontal: 24.w, vertical: 10.h),
                ),
                child: Text("Đọc tất cả",
                    style: defaultText14B.copyWith(color: mainOrange)),
              ),
            ),
            SizedBox(height: 12.h),
          ],
        ),
      ),
    );
  }
}

class NotificationItem extends StatelessWidget {
  final NotificationModel item;

  const NotificationItem({super.key, required this.item});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => DetailNotiScreen(
                    item: item,
                  )),
        );
      },
      child: Container(
        margin: EdgeInsets.only(bottom: 10.h),
        decoration: BoxDecoration(
          color: item.isRead ? Colors.white : const Color(0xFFDFF2FF),
          borderRadius: BorderRadius.circular(10.r),
        ),
        child: Padding(
          padding: EdgeInsets.all(12.w),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CircleAvatar(
                backgroundColor: Color(0xffF8EDE4),
                radius: 16.r,
                child: SvgPicture.asset('assets/icons/icon.svg'),
              ),
              SizedBox(width: 10.w),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(item.title, style: defaultText14B),
                    SizedBox(height: 4.h),
                    Text(item.message, style: defaultText14Re),
                    SizedBox(height: 6.h),
                    Text(item.time,
                        style: defaultText14Re.copyWith(
                            color: colorText.withValues(alpha: 0.8))),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
