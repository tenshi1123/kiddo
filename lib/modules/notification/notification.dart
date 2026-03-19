import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:kiddo/modules/notification/detail_notification.dart';
import 'package:kiddo/utils/constants/color.dart';
import 'package:kiddo/utils/constants/styles.dart';

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
  late List<NotificationGroup> notifications;

  @override
  void initState() {
    super.initState();
    notifications = [
      NotificationGroup(
        dateTitle: "Hôm nay",
        items: [
          NotificationModel(
            title: "Đến giờ học rồi bạn ơi!",
            message:
                "Xin chào Hải, Buổi học ôn luyện nâng cao sắp diễn ra. Tham gia ngay bạn nhé?",
            time: "2 phút trước",
            isRead: true,
          ),
          NotificationModel(
            title: "Ra mắt khóa học ôn luyện cấp tốc",
            message:
                "Khóa học sẽ mang đến cho bạn Kiến thức vững vàng để có thể tự tin bước vào kì kiểm tra đánh giá giữa tháng",
            time: "15 phút trước",
            isRead: false,
          ),
        ],
      ),
      NotificationGroup(
        dateTitle: "Hôm qua",
        items: [
          NotificationModel(
            title: "Học ngay thôi nào!",
            message:
                "Bạn Hải ơi! Đã đến giờ học Tiếng Anh rồi nè, ngồi vào bàn học ngay thôi!!!",
            time: "20:05 - 28/10/2022",
            isRead: true,
          ),
          NotificationModel(
            title: "Đăng ký khóa học thành công",
            message:
                "Chào mừng bạn đến với khóa học TOEIC. Cảm ơn bạn đã tin tưởng lựa chọn khóa học Tiếng Anh cùng KIDDO nha",
            time: "12:30 - 28/10/2022",
            isRead: true,
          ),
        ],
      ),
      NotificationGroup(
        dateTitle: "Thứ hai - 27/10/2022",
        items: [
          NotificationModel(
            title: "Học cùng KIDDO ENGLISH",
            message:
                "Hi Hải. Giờ ôn thi môn toán đến rồi, một bài nữa bạn nhé. Cheer!",
            time: "20:05 - 27/10/2022",
            isRead: true,
          ),
        ],
      ),
    ];
  }

  void markAllAsRead() {
    setState(() {
      for (var group in notifications) {
        for (var item in group.items) {
          item.isRead = true;
        }
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
              child: ListView.builder(
                itemCount: notifications.length,
                itemBuilder: (context, index) {
                  final group = notifications[index];
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(group.dateTitle, style: defaultText16B),
                      SizedBox(height: 8.h),
                      ...group.items.map((n) => NotificationItem(item: n)),
                      SizedBox(height: 12.h),
                    ],
                  );
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
