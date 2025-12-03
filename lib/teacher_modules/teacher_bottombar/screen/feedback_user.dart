import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:kiddo/modules/feature_home/hoc_phi/confirm_screen.dart';
import 'package:kiddo/modules/notification/notification.dart';
import 'package:kiddo/student_models/profile_model.dart';
import 'package:kiddo/teacher_repo/teacher_info_repo.dart';
import 'package:kiddo/utils/constants/color.dart';
import 'package:kiddo/utils/constants/styles.dart';

class FeedbackUserScreen extends StatefulWidget {
  const FeedbackUserScreen({
    super.key,
  });

  @override
  State<FeedbackUserScreen> createState() => _FeedbackUserScreenState();
}

class _FeedbackUserScreenState extends State<FeedbackUserScreen> {
  int selectedTab = 0;
  bool isLoading = true;
  late List<GopYModel> listGopY;
  @override
  void initState() {
    super.initState();

    fetchData();
  }

  Future<void> fetchData() async {
    try {
      final response = await TeacherInfoRepo().getListGopY();
      setState(() {
        listGopY = response;
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
          'Phản hồi',
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
                child: selectedTab == 0
                    ? SizedBox()
                    : Column(
                        children: [
                          Expanded(
                            child: Padding(
                              padding: EdgeInsets.symmetric(horizontal: 16.w),
                              child: ListView.builder(
                                itemCount: listGopY.length,
                                itemBuilder: (context, index) {
                                  return FeedbackHocVien(
                                    gopYModel: listGopY[index],
                                  );
                                },
                              ),
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.symmetric(
                                horizontal: 16.w, vertical: 12.h),
                            child: GestureDetector(
                              onTap: () {
                                showFeedbackDialog(context);
                              },
                              child: Container(
                                width: double.infinity,
                                padding: EdgeInsets.all(14.w),
                                decoration: BoxDecoration(
                                  border: Border.all(
                                      color: const Color(0xffF06423)),
                                  borderRadius: BorderRadius.circular(10.r),
                                  color: Color(0xffF9F6F4),
                                ),
                                child: Text(
                                  "Thêm phản hồi - góp ý",
                                  textAlign: TextAlign.center,
                                  style: defaultText14SB.copyWith(
                                    color: mainOrange,
                                    fontSize: 16.sp,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
              )
            ],
          )),
    );
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
  final List<String> tabs = ['Feedback HV', 'Góp ý'];

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

class FeedbackHocVien extends StatelessWidget {
  const FeedbackHocVien({super.key, required this.gopYModel});
  final GopYModel gopYModel;
  @override
  Widget build(BuildContext context) {
    return Container(
      width: 343.w,
      padding: EdgeInsets.symmetric(
        horizontal: 16.w,
        vertical: 16.h,
      ),
      decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.all(
            Radius.circular(24.r),
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withValues(alpha: 0.16),
              spreadRadius: 0,
              blurRadius: 12,
              offset: const Offset(0, 2),
            ),
          ]),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            gopYModel.topic,
            style: defaultText16B,
          ),
          SizedBox(
            height: 16.h,
          ),
          Row(
            children: [
              Text(
                'Ngày:\n\nChủ đề:\n',
                style: defaultText14M.copyWith(
                    color: colorText.withValues(alpha: 0.8)),
              ),
              SizedBox(
                width: 50.w,
              ),
              Text(
                '${gopYModel.createdAt}\n\n${gopYModel.topic}\n',
                style: defaultText14SB,
              )
            ],
          ),
          Text(
            'Nội dung:\n',
            style: defaultText14M.copyWith(
              color: colorText.withValues(alpha: 0.8),
            ),
          ),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 12.h),
            decoration: BoxDecoration(
                color: Color(0xffF6F6F6),
                borderRadius: BorderRadius.circular(12.r)),
            child: Text(
              gopYModel.content,
              style: defaultText14Re,
            ),
          )
        ],
      ),
    );
  }
}

void showFeedbackDialog(BuildContext context) {
  final TextEditingController titleController = TextEditingController();
  final TextEditingController contentController = TextEditingController();

  showDialog(
    context: context,
    barrierDismissible: false,
    builder: (context) {
      return Dialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16.r),
        ),
        insetPadding: EdgeInsets.symmetric(horizontal: 20.w),
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16.r),
            color: Colors.white,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // ====== Header màu cam ======
              Container(
                width: double.infinity,
                padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 14.h),
                decoration: BoxDecoration(
                  color: mainOrange, // màu cam
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(16.r),
                    topRight: Radius.circular(16.r),
                  ),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Góp ý tới trung tâm',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16.sp,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    GestureDetector(
                      onTap: () => Navigator.pop(context),
                      child: const Icon(Icons.close, color: Colors.white),
                    ),
                  ],
                ),
              ),

              // ====== Nội dung dialog ======
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
                child: Column(
                  children: [
                    // Ô nhập chủ đề
                    TextField(
                      controller: titleController,
                      decoration: InputDecoration(
                        hintText: 'Chủ đề',
                        filled: true,
                        fillColor: const Color(0xffF7F7F7),
                        contentPadding: EdgeInsets.symmetric(
                          horizontal: 16.w,
                          vertical: 12.h,
                        ),
                        border: OutlineInputBorder(
                          borderSide: BorderSide.none,
                          borderRadius: BorderRadius.circular(10.r),
                        ),
                      ),
                    ),
                    SizedBox(height: 12.h),

                    // Ô nhập nội dung
                    TextField(
                      controller: contentController,
                      maxLines: 4,
                      decoration: InputDecoration(
                        hintText: 'Nội dung góp ý',
                        filled: true,
                        fillColor: const Color(0xffF7F7F7),
                        contentPadding: EdgeInsets.symmetric(
                          horizontal: 16.w,
                          vertical: 12.h,
                        ),
                        border: OutlineInputBorder(
                          borderSide: BorderSide.none,
                          borderRadius: BorderRadius.circular(10.r),
                        ),
                      ),
                    ),
                    SizedBox(height: 20.h),

                    // Nút Lưu
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: () {
                          // TODO: xử lý lưu góp ý

                          showSuccessDialog(context);
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: mainOrange,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10.r),
                          ),
                          padding: EdgeInsets.symmetric(vertical: 14.h),
                        ),
                        child: Text(
                          'Lưu',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 15.sp,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      );
    },
  );
}
