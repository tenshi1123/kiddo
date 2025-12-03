import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:kiddo/modules/notification/notification.dart';
import 'package:kiddo/student_models/diem_danh_model.dart';
import 'package:kiddo/student_repo/diemdanh_repo.dart';
import 'package:kiddo/utils/constants/color.dart';
import 'package:kiddo/utils/constants/styles.dart';

class DetailDiemDanhScreen extends StatefulWidget {
  const DetailDiemDanhScreen({
    super.key,
    required this.id,
  });
  final String id;
  @override
  State<DetailDiemDanhScreen> createState() => _DetailDiemDanhScreenState();
}

class _DetailDiemDanhScreenState extends State<DetailDiemDanhScreen> {
  bool isLoading = true;
  late InfoDiemDanh data;
  @override
  void initState() {
    super.initState();
    fetchData();
  }

  Future<void> fetchData() async {
    try {
      final response = await DiemdanhRepo().getDetailDiemDanh(widget.id);
      setState(() {
        data = response;
        isLoading = false;
      });
    } catch (e) {
      // Xử lý lỗi nếu cần
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
            'Theo dõi điểm danh',
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
        body: isLoading
            ? Center(child: CircularProgressIndicator())
            : Container(
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
                              Text(data.name, style: defaultText16B),
                              SizedBox(height: 4.h),
                              Text(data.type,
                                  style: defaultText14M.copyWith(
                                    color: Colors.grey.shade600,
                                  )),
                            ],
                          ),
                        ],
                      ),
                    ),
                    Expanded(
                      child: LessonHistoryBody(
                        infoDiemDanh: data,
                      ),
                    ),
                  ],
                ),
              ));
  }
}

class ClassItem {
  final String title;
  final String subtitle;

  ClassItem({required this.title, required this.subtitle});
}

class LessonStatus {
  final String date;
  final String time;
  final String teacher;
  final String status;
  final bool isPast; // true = Đã diễn ra, false = Chưa diễn ra

  LessonStatus({
    required this.date,
    required this.time,
    required this.teacher,
    required this.status,
    required this.isPast,
  });
}

class LessonHistoryBody extends StatefulWidget {
  const LessonHistoryBody({super.key, required this.infoDiemDanh});
  final InfoDiemDanh infoDiemDanh;
  @override
  State<LessonHistoryBody> createState() => _LessonHistoryBodyState();
}

class _LessonHistoryBodyState extends State<LessonHistoryBody> {
  int selectedTab = 0;
  @override
  Widget build(BuildContext context) {
    final filtered = selectedTab == 0
        ? widget.infoDiemDanh.daqua
        : widget.infoDiemDanh.saptoi;

    return Column(
      children: [
        // --- Thanh chọn ---
        Container(
          margin: EdgeInsets.all(12.dm),
          padding: EdgeInsets.all(4.dm),
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
                          "Đã diễn ra ",
                          style: defaultText14M.copyWith(
                            color: selectedTab == 0
                                ? colorText
                                : colorText.withValues(alpha: 0.8),
                          ),
                        ),
                        Container(
                          margin: const EdgeInsets.only(left: 6),
                          padding: EdgeInsets.symmetric(
                              horizontal: 8.w, vertical: 2.h),
                          decoration: BoxDecoration(
                            color: selectedTab == 0
                                ? mainOrange
                                : Color(0xffC9B2A5),
                            borderRadius: BorderRadius.circular(24.r),
                          ),
                          child: Text(
                            " ${widget.infoDiemDanh.cntDaDienRa} ",
                            style: defaultText14SB.copyWith(
                              color: Colors.white,
                              fontSize: 12.sp,
                            ),
                          ),
                        )
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
                          "Chưa diễn ra ",
                          style: defaultText14M.copyWith(
                            color: selectedTab == 1
                                ? colorText
                                : colorText.withValues(alpha: 0.8),
                          ),
                        ),
                        Container(
                          margin: const EdgeInsets.only(left: 6),
                          padding: const EdgeInsets.symmetric(
                              horizontal: 8, vertical: 2),
                          decoration: BoxDecoration(
                            color: selectedTab == 1
                                ? mainOrange
                                : Color(0xffC9B2A5),
                            borderRadius: BorderRadius.circular(24.r),
                          ),
                          child: Text(
                            " ${widget.infoDiemDanh.cntChuaDienRa} ",
                            style: defaultText14SB.copyWith(
                              color: Colors.white,
                              fontSize: 12.sp,
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),

        // --- Danh sách ---
        Expanded(
          child: ListView.builder(
            itemCount: filtered.length,
            padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.h),
            itemBuilder: (context, index) {
              final lesson = filtered[index];
              return LessonItem(
                lesson: lesson,
              );
            },
          ),
        ),
      ],
    );
  }
}

class LessonItem extends StatefulWidget {
  final DetailDiemDanh lesson;
  const LessonItem({super.key, required this.lesson});

  @override
  State<LessonItem> createState() => _LessonItemState();
}

class _LessonItemState extends State<LessonItem> {
  bool isExpanded = false;

  @override
  Widget build(BuildContext context) {
    final lesson = widget.lesson;

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: const [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 4,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          /// ---- Tiêu đề và icon ----
          Row(
            children: [
              Expanded(
                child: Text(
                  lesson.nameBuoiHoc,
                  style: defaultText16B,
                ),
              ),
              GestureDetector(
                onTap: () {
                  setState(() => isExpanded = !isExpanded);
                },
                child: AnimatedRotation(
                  turns: isExpanded ? 0.5 : 0.0,
                  duration: const Duration(milliseconds: 200),
                  child: const Icon(Icons.keyboard_arrow_down),
                ),
              ),
            ],
          ),
          SizedBox(height: 6.h),
          Row(
            children: [
              Text("Ca học: ", style: defaultText14Re),
              Text(
                  '${lesson.timeStart.replaceRange(5, 8, '')} - ${lesson.timeEnd.replaceRange(5, 8, '')}  ${lesson.day}'),
            ],
          ),

          /// ---- Nội dung chi tiết (ẩn/hiện) ----
          AnimatedCrossFade(
            firstChild: const SizedBox.shrink(),
            secondChild: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: 4.h),
                SizedBox(
                  height: lesson.giaoVien.length * 22.h,
                  child: ListView.builder(
                      itemCount: lesson.giaoVien.length,
                      itemBuilder: (BuildContext context, int index) {
                        return Row(
                          children: [
                            Text("Giảng viên: ", style: defaultText14Re),
                            Text(lesson.giaoVien[index].fullName),
                          ],
                        );
                      }),
                ),
                SizedBox(height: 6.h),
                Align(
                  alignment: Alignment.centerRight,
                  child: Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(
                      color: getStatusColor(lesson.gvStatusName),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      lesson.gvStatusName,
                      style: defaultText12M.copyWith(color: Colors.white),
                    ),
                  ),
                ),
                SizedBox(height: 6.h),
                Row(
                  children: [
                    Text("Nhận xét: ", style: defaultText14Re),
                    SizedBox(
                      width: 240.w,
                      child: Text(
                        lesson.content,
                        style: defaultText14B,
                      ),
                    ),
                  ],
                ),
              ],
            ),
            crossFadeState: isExpanded
                ? CrossFadeState.showSecond
                : CrossFadeState.showFirst,
            duration: const Duration(milliseconds: 250),
          ),
        ],
      ),
    );
  }
}

Color getStatusColor(String status) {
  switch (status) {
    case "Đúng giờ":
      return mainGreen;
    case "Xin nghỉ":
      return mainBlue;
    case "Đi muộn":
      return mainOrange;
    case "Vắng mặt":
      return mainRed;
    default:
      return Colors.grey;
  }
}
