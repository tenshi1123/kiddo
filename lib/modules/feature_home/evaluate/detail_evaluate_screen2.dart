import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:intl/intl.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:kiddo/modules/notification/notification.dart';
import 'package:kiddo/student_models/diem_danh_model.dart';
import 'package:kiddo/student_models/review_models.dart';
import 'package:kiddo/student_repo/extension_repo.dart';
import 'package:kiddo/utils/constants/color.dart';
import 'package:kiddo/utils/constants/styles.dart';

class DetailEvaluateScreen extends StatefulWidget {
  const DetailEvaluateScreen({
    super.key,
    required this.model,
  });
  final ClassModel model;
  @override
  State<DetailEvaluateScreen> createState() => _DetailEvaluateScreenState();
}

class _DetailEvaluateScreenState extends State<DetailEvaluateScreen> {
  bool isLoading = true;
  ListFeedBackModel? listLichHoc;
  @override
  void initState() {
    super.initState();
    _fetchData();
  }

  Future<void> _fetchData() async {
    try {
      final data = await ExtensionRepo()
          .getListFeedback(id: widget.model.customerCourseScheduleId);
      setState(() {
        listLichHoc = data;
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        isLoading = false;
      });
      debugPrint('Error fetching data: $e');
    }
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
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(26.r),
              topRight: Radius.circular(26.r),
            ),
          ),
          child: Column(
            children: [
              Container(
                margin: EdgeInsets.only(bottom: 12.h),
                padding: EdgeInsets.all(12.w),
                child: Row(
                  children: [
                    Image.asset(
                      'assets/images/computer.png',
                      width: 40.w,
                      height: 40.h,
                    ),
                    SizedBox(width: 12.w),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          widget.model.courseName,
                          style: defaultText14SB.copyWith(fontSize: 16.sp),
                        ),
                        SizedBox(height: 4.h),
                        Text(
                          widget.model.settingCourseTypeName,
                          style: defaultText14Re,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              Expanded(
                child: isLoading
                    ? Center(
                        child: CircularProgressIndicator(
                          color: mainOrange,
                        ),
                      )
                    : listLichHoc == null
                        ? const Center(
                            child: Text("Không có dữ liệu hoặc tải thất bại"),
                          )
                        : LessonHistoryBody(
                            model: listLichHoc!,
                          ),
              ),
            ],
          ),
        ));
  }
}

class LessonHistoryBody extends StatefulWidget {
  const LessonHistoryBody({super.key, required this.model});
  final ListFeedBackModel model;
  @override
  State<LessonHistoryBody> createState() => _LessonHistoryBodyState();
}

class _LessonHistoryBodyState extends State<LessonHistoryBody> {
  int selectedTab = 0;

  @override
  Widget build(BuildContext context) {
    final filtered = selectedTab == 0
        ? widget.model.listFbDinhKy.where((item) => item.type == "gk").toList()
        : widget.model.listFbDinhKy.where((item) => item.type == "ck").toList();

    return Column(
      children: [
        // --- Thanh chọn ---
        Container(
          margin: const EdgeInsets.all(12),
          padding: const EdgeInsets.all(4),
          decoration: BoxDecoration(
            color: Color(0xffF2E8E8),
            borderRadius: BorderRadius.circular(30),
          ),
          child: Row(
            children: [
              Expanded(
                child: GestureDetector(
                  onTap: () => setState(() => selectedTab = 0),
                  child: Container(
                    padding: const EdgeInsets.symmetric(vertical: 10),
                    decoration: BoxDecoration(
                      color:
                          selectedTab == 0 ? Colors.white : Colors.transparent,
                      borderRadius: BorderRadius.circular(30),
                    ),
                    alignment: Alignment.center,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          "Giữa Kỳ",
                          style: defaultText14M.copyWith(
                            color: selectedTab == 0
                                ? colorText
                                : colorText.withValues(alpha: 0.8),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              Expanded(
                child: GestureDetector(
                  onTap: () => setState(() => selectedTab = 1),
                  child: Container(
                    padding: const EdgeInsets.symmetric(vertical: 10),
                    decoration: BoxDecoration(
                      color:
                          selectedTab == 1 ? Colors.white : Colors.transparent,
                      borderRadius: BorderRadius.circular(30),
                    ),
                    alignment: Alignment.center,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          "Cuối kỳ",
                          style: defaultText14M.copyWith(
                            color: selectedTab == 0
                                ? colorText
                                : colorText.withValues(alpha: 0.8),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
        Expanded(
          child: filtered.isEmpty
              ? Center(
                  child: Image.asset(
                    'assets/images/empty2.png',
                    height: 300.h,
                    width: 300.w,
                  ),
                )
              : ListView.builder(
                  itemCount: filtered.length,
                  padding:
                      const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  itemBuilder: (context, index) {
                    final lesson = filtered[index];
                    return Container(
                      margin: const EdgeInsets.only(bottom: 12),
                      padding: EdgeInsets.symmetric(
                          horizontal: 16.w, vertical: 16.h),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(12),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black12,
                            blurRadius: 4,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            '${lesson.name} ${DateFormat('dd/MM/yyyy').format(lesson.createAt)}',
                            style: defaultText16B,
                          ),
                          SizedBox(height: 16.h),
                          Container(
                              padding: EdgeInsets.symmetric(
                                  horizontal: 12.w, vertical: 8.h),
                              decoration: BoxDecoration(
                                color: Color(0xffF6F6F6),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Html(
                                data: cleanHtml(lesson.content),
                                onLinkTap: (url, attributes, element) async {
                                  if (url != null) {
                                    final Uri uri = Uri.parse(url);
                                    if (await canLaunchUrl(uri)) {
                                      await launchUrl(uri);
                                    }
                                  }
                                },
                              ))
                        ],
                      ),
                    );
                  },
                ),
        ),
      ],
    );
  }
}

String cleanHtml(String rawHtml) {
  String result = rawHtml;

  // 1. Xóa bỏ thẻ <div> bọc ngoài cùng (nếu có) để dễ xử lý cấu trúc bên trong
  result = result.replaceAll('<div>', '').replaceAll('</div>', '');

  // 2. Chuẩn hóa thẻ br
  result = result.replaceAll(RegExp(r'</?br>'), '<br>');

  // 3. Biến các thẻ <li> thành chấm tròn đen (bullet point) để tránh lỗi hiển thị số 0
  result = result.replaceAll('<li>', '<div>&#8226; ');
  result = result.replaceAll('</li>', '</div>');

  // 4. Tìm các link (http/https) dạng text thô và bọc vào thẻ <a> để bấm được
  result = result.replaceAllMapped(RegExp(r'(https?:\/\/[^\s<]+)'),
      (match) => '<a href="${match.group(1)}">${match.group(1)}</a>');

  // 5. Tìm đoạn text thường nằm giữa các thẻ <b> (giữ lại logic cũ cho an toàn)
  result = result.replaceAllMapped(RegExp(r'</b>\s*<br>\s*([^<]+)\s*<b>'),
      (match) => '</b><div>${match.group(1)?.trim()}</div><b>');
  result = result.replaceAllMapped(RegExp(r'</b>\s*<br>\s*([^<]+)$'),
      (match) => '</b><div>${match.group(1)?.trim()}</div>');

  // 6. Bọc lại bằng một thẻ div tổng cho an toàn
  return '<div>$result</div>';
}
