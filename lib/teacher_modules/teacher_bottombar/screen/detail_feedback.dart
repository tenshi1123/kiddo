import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:kiddo/modules/notification/notification.dart';
import 'package:kiddo/teacher_model/feed_back_model.dart';
import 'package:kiddo/teacher_repo/teacher_class_repo.dart';
import 'package:kiddo/utils/constants/color.dart';
import 'package:kiddo/utils/constants/styles.dart';
import 'package:webview_flutter/webview_flutter.dart';

class DetailFeedbackScreen extends StatefulWidget {
  const DetailFeedbackScreen({
    super.key,
    required this.typeTeacher,
    required this.courseScheduleId,
    required this.name,
  });
  final String typeTeacher;
  final String courseScheduleId;
  final String name;
  @override
  State<DetailFeedbackScreen> createState() => _DetailFeedbackScreenState();
}

class _DetailFeedbackScreenState extends State<DetailFeedbackScreen> {
  int selectedTab = 0;
  bool isLoading = true;
  List<FeedbackTermModel> feedBackGk = [];
  List<FeedbackTermModel> feedBackCk = [];
  @override
  void initState() {
    super.initState();
    fetchData();
  }

  Future<void> fetchData() async {
    try {
      final response = await TeacherClassRepo().getListNhanXet(
          courseScheduleId: widget.courseScheduleId,
          typeTeacher: widget.typeTeacher,
          type: 'gk');
      final responseCk = await TeacherClassRepo().getListNhanXet(
          courseScheduleId: widget.courseScheduleId,
          typeTeacher: widget.typeTeacher,
          type: 'ck');
      setState(() {
        feedBackGk = response;
        feedBackCk = responseCk;
        isLoading = false;
      });
    } catch (e) {
      debugPrint('Lỗi khi gọi API: $e');
      setState(() {
        isLoading = false;
      });
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
            widget.name,
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
              CustomTabs(
                onChanged: (index) {
                  setState(() => selectedTab = index);
                },
              ),
              Expanded(
                child: ListView.builder(
                  itemCount:
                      selectedTab == 0 ? feedBackGk.length : feedBackCk.length,
                  itemBuilder: (context, index) {
                    var item = selectedTab == 0
                        ? feedBackGk[index]
                        : feedBackCk[index];

                    return GestureDetector(
                      onTap: () {
                        showDialog(
                          context: context,
                          builder: (_) => MidtermReviewDialog(
                            model: item,
                          ),
                        );
                      },
                      child: Container(
                        height: 64.h,
                        width: 343.w,
                        margin: EdgeInsets.symmetric(
                            horizontal: 16.w, vertical: 8.h),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(16.r),
                          color: Colors.white,
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey.withValues(alpha: 0.2),
                              spreadRadius: 5,
                              blurRadius: 7,
                              offset: const Offset(0, 2),
                            ),
                          ],
                        ),
                        child: Row(
                          children: [
                            Container(
                              width: 40.w,
                              height: 40.h,
                              margin: EdgeInsets.symmetric(horizontal: 16.w),
                              padding: EdgeInsets.all(8.dm),
                              decoration: BoxDecoration(
                                color: mainPurple,
                                shape: BoxShape.circle,
                              ),
                              child: Image.asset('assets/images/study.png'),
                            ),
                            SizedBox(
                              width: 200.w,
                              child: RichText(
                                text: TextSpan(
                                  children: [
                                    TextSpan(
                                      text: item.fullName,
                                      style: defaultText14SB,
                                    ),
                                    if (item.fullNameAlias.isNotEmpty)
                                      TextSpan(
                                        text: ' - ${item.fullNameAlias}',
                                        style: defaultText14SB.copyWith(
                                          color: Colors.red,
                                        ),
                                      ),
                                  ],
                                ),
                              ),
                            ),
                            const Spacer(),
                            SvgPicture.asset('assets/icons/view.svg'),
                            Text(
                              ' View',
                              style: defaultText14SB.copyWith(
                                color: mainOrange,
                              ),
                            ),
                            SizedBox(width: 16.w),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ));
  }
}

class CustomTabs extends StatefulWidget {
  const CustomTabs({super.key, this.onChanged});
  final ValueChanged<int>? onChanged;
  @override
  State<CustomTabs> createState() => _CustomTabsState();
}

class _CustomTabsState extends State<CustomTabs> {
  int selectedIndex = 0;
  final List<String> tabs = ['Giữa kỳ', 'Cuối kỳ'];

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
      child: Container(
        decoration: BoxDecoration(
          color: Color(0xffF2E8E8),
          borderRadius: BorderRadius.circular(50.r),
        ),
        padding: EdgeInsets.symmetric(horizontal: 6.w, vertical: 6.h),
        child: Row(
          children: List.generate(
            tabs.length,
            (index) => Expanded(
              child: GestureDetector(
                onTap: () {
                  setState(() {
                    selectedIndex = index;
                  });
                  widget.onChanged?.call(index);
                },
                child: Container(
                  height: 44.h,
                  padding:
                      const EdgeInsets.symmetric(vertical: 10, horizontal: 8),
                  decoration: BoxDecoration(
                    color: selectedIndex == index
                        ? Colors.white
                        : Colors.transparent,
                    borderRadius: BorderRadius.circular(50),
                  ),
                  alignment: Alignment.center,
                  child: Text(
                    tabs[index],
                    style: defaultText12M,
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class MidtermReviewDialog extends StatefulWidget {
  const MidtermReviewDialog({super.key, required this.model});
  final FeedbackTermModel model;
  @override
  State<MidtermReviewDialog> createState() => _MidtermReviewDialogState();
}

class _MidtermReviewDialogState extends State<MidtermReviewDialog> {
  bool isEditing = false;
  final TextEditingController _controller = TextEditingController();
  late WebViewController _webViewController;

  @override
  void initState() {
    super.initState();
    _controller.text = widget.model.content;
    _initWebView();
  }

  void _initWebView() {
    String htmlContent = _controller.text
        .replaceAll(RegExp(r'<p>\s*<li>'), '<ul><li>')
        .replaceAll(RegExp(r'</li>\s*</p>'), '</li></ul>');

    _webViewController = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setBackgroundColor(const Color(0x00000000))
      ..loadHtmlString('''
        <!DOCTYPE html>
        <html>
        <head>
          <meta name="viewport" content="width=device-width, initial-scale=1.0, maximum-scale=1.0, user-scalable=no">
          <style>
            body { 
              font-family: -apple-system, sans-serif; 
              padding: 0; 
              margin: 0; 
              font-size: 15px;
              color: #333;
            }
            #editor { 
              width: 100%; 
              min-height: 200px;
              outline: none; 
            }
            ul { padding-left: 20px; }
          </style>
        </head>
        <body>
          <div id="editor" contenteditable="true">$htmlContent</div>
          <script>
             document.getElementById("editor").focus();
          </script>
        </body>
        </html>
      ''');
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.r)),
      child: Padding(
        padding: EdgeInsets.all(20.w),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // ====== HEADER ======
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                SizedBox(width: 32.w), // Để căn giữa tiêu đề
                Text(
                  "Đánh giá giữa kỳ",
                  style: TextStyle(
                    fontSize: 16.sp,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                IconButton(
                  onPressed: () => Navigator.pop(context),
                  icon: const Icon(Icons.close, color: Colors.black54),
                ),
              ],
            ),
            SizedBox(height: 12.h),

            // ====== NỘI DUNG ======
            Flexible(
              child: SingleChildScrollView(
                child: Container(
                  width: double.infinity,
                  padding: EdgeInsets.all(14.w),
                  decoration: BoxDecoration(
                    color: const Color(0xffF6F6F6),
                    borderRadius: BorderRadius.circular(14.r),
                  ),
                  child: Html(
                    data: _controller.text
                        .replaceAll(RegExp(r'<p>\s*<li>'), '<ul><li>')
                        .replaceAll(RegExp(r'</li>\s*</p>'), '</li></ul>'),
                    onLinkTap: (url, attributes, element) async {
                      if (url != null) {
                        final Uri uri = Uri.parse(url);
                        try {
                          await launchUrl(uri,
                              mode: LaunchMode.externalApplication);
                        } catch (e) {
                          debugPrint('Could not launch $url: $e');
                        }
                      }
                    },
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
