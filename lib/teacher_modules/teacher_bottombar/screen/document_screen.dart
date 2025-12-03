import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:kiddo/modules/notification/notification.dart';
import 'package:kiddo/utils/constants/color.dart';
import 'package:kiddo/utils/constants/styles.dart';

class DocumentScreen extends StatefulWidget {
  const DocumentScreen({
    super.key,
  });
  @override
  State<DocumentScreen> createState() => _DocumentScreenState();
}

class _DocumentScreenState extends State<DocumentScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: mainOrange,
        appBar: AppBar(
          backgroundColor: mainOrange,
          elevation: 0,
          centerTitle: true,
          title: Text(
            'Theo dõi đánh giá',
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
          actions: [
            GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => NotificationScreen(),
                  ),
                );
              },
              child: SvgPicture.asset(
                'assets/icons/bell.svg',
                width: 20.w,
                height: 20.h,
                colorFilter: ColorFilter.mode(
                  Colors.white,
                  BlendMode.srcIn,
                ),
              ),
            ),
            SizedBox(width: 16.w),
          ],
        ),
        body: Container(
            height: double.infinity,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(26.r),
                topRight: Radius.circular(26.r),
              ),
            ),
            child: SingleChildScrollView(
              padding: EdgeInsets.symmetric(
                vertical: 16.h,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "      Folder được chia sẻ",
                    style: defaultText14B,
                  ),
                  SizedBox(height: 8.h),
                  Row(
                    children: [
                      SizedBox(
                        width: 12.w,
                      ),
                      _buildFolderItem("kho_tai_lieu_trung_tam"),
                      SizedBox(width: 12.w),
                      _buildFolderItem("lc1a"),
                    ],
                  ),
                  SizedBox(height: 20.h),
                  Text(
                    "      File được chia sẻ",
                    style: defaultText14B,
                  ),
                  SizedBox(height: 8.h),
                  Padding(
                    padding: EdgeInsetsGeometry.symmetric(horizontal: 16.w),
                    child: _buildFileCard(
                      title: "01. [S] What's Your Name.mp4",
                      size: "28.7 MB",
                      date: "2025-10-12 09:44:40",
                      sharer: "HVG ADMIN",
                      showClose: false,
                    ),
                  ),
                  SizedBox(height: 24.h),
                  Container(
                    padding: EdgeInsets.all(12.w),
                    height: 350.h,
                    decoration: BoxDecoration(
                      color: Color(0xffFFF1E8),
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(16.r),
                        topRight: Radius.circular(16.r),
                      ),
                    ),
                    child: Column(
                      children: [
                        // ===== Folders =====
                        Row(
                          children: [
                            Text(
                              "  Folders",
                              style: defaultText14B,
                            ),
                          ],
                        ),
                        SizedBox(height: 8.h),
                        Row(
                          children: [
                            _buildFolderItem(" ",
                                icon: Icons.reply, isBack: true),
                            SizedBox(width: 12.w),
                            _buildFolderItem("Học liệu", showClose: true),
                          ],
                        ),
                        SizedBox(height: 20.h),

                        // ===== File của bạn =====
                        Row(
                          children: [
                            Text(
                              "  File của bạn",
                              style: defaultText14B,
                            ),
                          ],
                        ),
                        SizedBox(height: 8.h),
                        _buildFileCard(
                          title: "01. [S] What's Your Name.mp4",
                          size: "28.7 MB",
                          date: "2025-10-12 09:44:40",
                          sharer: "ILAAA",
                          showClose: true,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            )));
  }
}

Widget _buildFolderItem(
  String name, {
  IconData? icon,
  bool showClose = false,
  bool isBack = false,
}) {
  return Expanded(
    child: Stack(
      children: [
        SizedBox(
          height: 152.h,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset(
                'assets/images/file.png',
                height: 120.h,
                fit: BoxFit.fitHeight,
              ),
              SizedBox(height: 6.h),
              Text(
                name,
                style: defaultText12M,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
        if (showClose)
          Positioned(
            top: 4,
            right: 4,
            child: Container(
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white,
              ),
              child: Icon(Icons.close, size: 16.w, color: Colors.grey),
            ),
          ),
      ],
    ),
  );
}

// Widget File Card
Widget _buildFileCard({
  required String title,
  required String size,
  required String date,
  required String sharer,
  bool showClose = false,
}) {
  return Container(
    margin: EdgeInsets.symmetric(vertical: 4.h),
    padding: EdgeInsets.all(12.w),
    decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(16.r),
      boxShadow: [
        BoxShadow(
          color: Colors.black12,
          blurRadius: 4,
          offset: const Offset(0, 2),
        ),
      ],
    ),
    child: Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Image.asset('assets/images/pdf1.png'),
              Text(title, style: defaultText14M),
              (showClose)
                  ? Icon(Icons.close, size: 18.w, color: Colors.grey.shade600)
                  : SizedBox(),
            ],
          ),
          SizedBox(height: 4.h),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              RichText(
                text: TextSpan(
                  text: 'Size\n',
                  style: defaultText12Re,
                  children: <TextSpan>[
                    TextSpan(text: size, style: defaultText12B),
                  ],
                ),
              ),
              RichText(
                text: TextSpan(
                  text: 'Recent Date\n',
                  style: defaultText12Re,
                  children: <TextSpan>[
                    TextSpan(text: date, style: defaultText12B),
                  ],
                ),
              ),
              RichText(
                text: TextSpan(
                  text: 'Sharer\n',
                  style: defaultText12Re,
                  children: <TextSpan>[
                    TextSpan(text: sharer, style: defaultText12B),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    ),
  );
}
