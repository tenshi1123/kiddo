import 'dart:io';
import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:image_picker/image_picker.dart';
import 'package:kiddo/l10n/l10n.dart';
import 'package:kiddo/modules/notification/notification.dart';
import 'package:kiddo/student_models/excercise_model.dart';
import 'package:kiddo/student_repo/mycourse_repo.dart';
import 'package:kiddo/utils/constants/color.dart';
import 'package:kiddo/utils/constants/styles.dart';
import 'package:url_launcher/url_launcher.dart';

class DetailLessonScreen extends StatefulWidget {
  const DetailLessonScreen({
    super.key,
    required this.typeLearn,
    required this.checkinOffId,
    required this.meetingId,
  });
  final String typeLearn;
  final String checkinOffId;
  final String meetingId;
  @override
  State<DetailLessonScreen> createState() => _DetailLessonScreenState();
}

class _DetailLessonScreenState extends State<DetailLessonScreen> {
  int selectedTab = 0;
  bool isLoading = true;
  List<File> photos = <File>[];
  DetailBuoiHocModel? detailBuoiHocModel;
  @override
  void initState() {
    super.initState();
    fetchData();
  }

  Future _pickImageFromGallery(String id) async {
    final returnedImage = await ImagePicker().pickMultiImage();
    photos = List<File>.from(
      (returnedImage).map(
        (e) => File(e.path),
      ),
    );
    //File(returnedImage!.path);
    if (photos.isNotEmpty) {
      var message = await MycourseRepo().uploadBtvn(id: id, photos: photos);
      if (!mounted) return;
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return CupertinoAlertDialog(
            title: Text(
              message,
              style: defaultText14SB,
            ),
            actions: <Widget>[
              CupertinoDialogAction(
                isDefaultAction: true,
                child: Text(
                  'ok',
                  style: TextStyle(fontSize: 20, color: mainOrange),
                ),
                onPressed: () {
                  Navigator.pop(context);
                },
              )
            ],
          );
        },
      );
    }
    setState(() {});
  }

  Future<void> fetchData() async {
    try {
      final response = await MycourseRepo().getDetailBuoiHoc(
        typeLearn: widget.typeLearn,
        checkinOffId: widget.checkinOffId,
        meetingId: widget.meetingId,
      );
      setState(() {
        detailBuoiHocModel = response;
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
        title: Text(L10n.of(context).detailLesson,
            style: defaultText18B.copyWith(color: Colors.white)),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, color: Colors.white),
          onPressed: () => Navigator.pop(context),
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
          : detailBuoiHocModel == null
              ? Center(child: Text('Không thể tải dữ liệu'))
              : Container(
                  width: double.infinity,
                  height: double.infinity,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(16.r),
                      topRight: Radius.circular(16.r),
                    ),
                  ),
                  child: SingleChildScrollView(
                    padding:
                        EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              '${detailBuoiHocModel!.infoLesson.namePhonghoc} ${detailBuoiHocModel!.infoLesson.cosoName}',
                              style: defaultText14B,
                            ),
                          ],
                        ),
                        SizedBox(height: 10.h),

                        Text(
                            '${detailBuoiHocModel!.infoLesson.nameLesson} ${detailBuoiHocModel!.infoLesson.topic}',
                            style: defaultText16B),
                        SizedBox(height: 6.h),

                        Text(
                            "Nội dung buổi học: ${detailBuoiHocModel!.infoLesson.lessonContent} + anksdasodjsdksadkasjdkasdjkasBước ngoặt đến với Lamborghini khi ông phát hiện bộ ly hợp trên chiếc Ferrari của mình bị hỏng, ông thấy nó giống với bộ ly hợp mà ông thường sử dụng trên những chiếc máy kéo, ông đến công ty Ferrari và yêu cầu họ thay thế bộ ly hợp tốt hơn. Tuy nhiên, Enzo Ferrari nói rằng: Ông chỉ là người sản xuất máy kéo và không biết gì về những chiếc xe thể thao. Ngay lập tức Lamborghin Bước ngoặt đến với Lamborghini khi ông phát hiện bộ ly hợp trên chiếc Ferrari của mình bị hỏng, ông thấy nó giống với bộ ly hợp mà ông thường sử dụng trên những chiếc máy kéo, ông đến công ty Ferrari và yêu cầu họ thay thế bộ ly hợp tốt hơn. Tuy nhiên, Enzo Ferrari nói rằng: Ông chỉ là người sản xuất máy kéo và không biết gì về những chiếc xe thể thao. Ngay lập tức Lamborghin Bước ngoặt đến với Lamborghini khi ông phát hiện bộ ly hợp trên chiếc Ferrari của mình bị hỏng, ông thấy nó giống với bộ ly hợp mà ông thường sử dụng trên những chiếc máy kéo, ông đến công ty Ferrari và yêu cầu họ thay thế bộ ly hợp tốt hơn. Tuy nhiên, Enzo Ferrari nói rằng: Ông chỉ là người sản xuất máy kéo và không biết gì về những chiếc xe thể thao. Ngay lập tức Lamborghin",
                            style: defaultText14M),
                        SizedBox(height: 20.h),

                        // --- Tabs ---
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            _buildTabButton("Bài tập", 0),
                            _buildTabButton("Tài liệu", 1),
                            _buildTabButton("Đánh giá", 2),
                          ],
                        ),
                        SizedBox(height: 20.h),
                        (selectedTab == 0 &&
                                detailBuoiHocModel!.listHomeWork.isNotEmpty)
                            ? Column(
                                children: [
                                  Center(
                                    child: Column(
                                      children: [
                                        SizedBox(
                                          width: 180.w,
                                          height: 180.h,
                                          child: CustomGapCircle(
                                            percent: double.parse(
                                                    detailBuoiHocModel!
                                                        .listHomeWork
                                                        .first
                                                        .finalMark) /
                                                10,
                                          ),
                                        ),
                                        Text(
                                          "Hoàn thành bài tập nào!",
                                          style: defaultText18B,
                                        ),
                                        SizedBox(height: 4.h),
                                        Text(
                                          "Bài tập của buổi học đã có bên dưới.",
                                          style: defaultText14Re,
                                        ),
                                      ],
                                    ),
                                  ),
                                  SizedBox(height: 20.h),
                                  Container(
                                    width: double.infinity,
                                    padding: EdgeInsets.all(14.w),
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.circular(16.r),
                                      boxShadow: [
                                        BoxShadow(
                                          color: Colors.black
                                              .withValues(alpha: 0.05),
                                          blurRadius: 10,
                                          offset: const Offset(0, 4),
                                        )
                                      ],
                                    ),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Row(
                                          children: [
                                            Icon(Icons.folder,
                                                color: Colors.blue,
                                                size: 26.sp),
                                            SizedBox(width: 8.w),
                                            Expanded(
                                              child: Text(
                                                  detailBuoiHocModel!
                                                      .listHomeWork.first.name,
                                                  style: defaultText16B),
                                            ),
                                            // Text("chọn bài tập bạn muốn xem",
                                            //     style: defaultText14Re),
                                          ],
                                        ),
                                        SizedBox(height: 12.h),
                                        Text(
                                          "Hạn nộp bài: ${detailBuoiHocModel?.listHomeWork.first.timeDeadline}",
                                          style: defaultText14SB,
                                        ),
                                        SizedBox(height: 12.h),
                                        SizedBox(
                                          height: 108.h,
                                          child: ListView.separated(
                                            shrinkWrap: true,
                                            physics:
                                                const NeverScrollableScrollPhysics(),
                                            scrollDirection: Axis.horizontal,
                                            itemCount: detailBuoiHocModel!
                                                .listHomeWork.length,
                                            separatorBuilder: (_, __) =>
                                                SizedBox(width: 8.w),
                                            itemBuilder: (_, i) => Column(
                                              children: [
                                                GestureDetector(
                                                  onTap: () async {
                                                    if (!await launchUrl(Uri
                                                        .parse(detailBuoiHocModel!
                                                            .listHomeWork[i]
                                                            .urlFileLesson))) {
                                                      throw Exception(
                                                          'Could not launch ');
                                                    }
                                                  },
                                                  child: Container(
                                                    width: 120.w,
                                                    height: 80.h,
                                                    decoration: BoxDecoration(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              8.r),
                                                      image: DecorationImage(
                                                        image: AssetImage(
                                                            'assets/images/pdf_sample.png'),
                                                        fit: BoxFit.fitWidth,
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                                Text(
                                                  detailBuoiHocModel!
                                                      .listHomeWork[i].name,
                                                  style: defaultText14SB,
                                                )
                                              ],
                                            ),
                                          ),
                                        ),
                                        SizedBox(height: 10.h),
                                        Text("Ghi chú:",
                                            style: defaultText14SB),
                                        SizedBox(height: 4.h),
                                        Text(
                                          detailBuoiHocModel!
                                              .listHomeWork.first.note,
                                          style: defaultText14SB,
                                        ),
                                      ],
                                    ),
                                  ),
                                  SizedBox(height: 24.h),
                                  Row(
                                    children: [
                                      SizedBox(
                                        width: 8.w,
                                      ),
                                      Text(
                                        "Bài làm",
                                        style: defaultText14SB.copyWith(
                                          fontSize: 16.sp,
                                        ),
                                      ),
                                    ],
                                  ),
                                  SizedBox(height: 6.h),
                                  (detailBuoiHocModel!.listHomeWork.isEmpty &&
                                          detailBuoiHocModel?.listHomeWork.first
                                                  .isSubmitHomework !=
                                              '1')
                                      ? Container(
                                          width: double.infinity,
                                          padding: EdgeInsets.symmetric(
                                              vertical: 20.h),
                                          decoration: BoxDecoration(
                                            color: Colors.grey[100],
                                            borderRadius:
                                                BorderRadius.circular(12.r),
                                          ),
                                          child: Center(
                                            child: Text(
                                                "Chưa có bài làm nào được tải lên",
                                                style: defaultText14Re),
                                          ),
                                        )
                                      : SizedBox(
                                          height: 108.h,
                                          child: ListView.separated(
                                            shrinkWrap: true,
                                            physics:
                                                const NeverScrollableScrollPhysics(),
                                            scrollDirection: Axis.horizontal,
                                            itemCount: detailBuoiHocModel!
                                                .listHomeWork
                                                .first
                                                .urlFileCustomer
                                                .length,
                                            separatorBuilder: (_, __) =>
                                                SizedBox(width: 8.w),
                                            itemBuilder: (_, i) => Column(
                                              children: [
                                                GestureDetector(
                                                    onTap: () async {
                                                      if (!await launchUrl(
                                                          Uri.parse(
                                                              'https://lms.kiddo.hvg.edu.vn/${detailBuoiHocModel?.listHomeWork.first.urlFileCustomer[i]}'))) {
                                                        throw Exception(
                                                            'Could not launch ');
                                                      }
                                                    },
                                                    child: detailBuoiHocModel!
                                                            .listHomeWork
                                                            .first
                                                            .urlFileCustomer
                                                            .isNotEmpty
                                                        ? Container(
                                                            width: 120.w,
                                                            height: 80.h,
                                                            decoration:
                                                                BoxDecoration(
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                          8.r),
                                                              image:
                                                                  DecorationImage(
                                                                image: AssetImage(
                                                                    'assets/images/pdf_sample.png'),
                                                                fit: BoxFit
                                                                    .fitWidth,
                                                              ),
                                                            ),
                                                          )
                                                        : SizedBox(
                                                            width: 343.w,
                                                            height: 100.h,
                                                            child: GridView
                                                                .builder(
                                                              padding:
                                                                  const EdgeInsets
                                                                      .all(8),
                                                              gridDelegate:
                                                                  SliverGridDelegateWithFixedCrossAxisCount(
                                                                crossAxisCount:
                                                                    1,
                                                              ),
                                                              itemCount:
                                                                  photos.length,
                                                              itemBuilder:
                                                                  (context,
                                                                      index) {
                                                                final file =
                                                                    photos[
                                                                        index];

                                                                return GestureDetector(
                                                                  child:
                                                                      ClipRRect(
                                                                    borderRadius:
                                                                        BorderRadius
                                                                            .circular(8),
                                                                    child: Image
                                                                        .file(
                                                                      file,
                                                                      fit: BoxFit
                                                                          .cover,
                                                                    ),
                                                                  ),
                                                                );
                                                              },
                                                            ),
                                                          )),
                                                // Text(
                                                //   detailBuoiHocModel
                                                //       .listHomeWork[i].name,
                                                //   style: defaultText14SB,
                                                // )
                                              ],
                                            ),
                                          ),
                                        ),
                                  SizedBox(height: 10.h),
                                  Center(
                                    child: OutlinedButton.icon(
                                      onPressed: () {
                                        _pickImageFromGallery(
                                            detailBuoiHocModel!.listHomeWork
                                                .first.classLessonDocumentId);
                                      },
                                      icon: Icon(Icons.cloud_upload_outlined,
                                          color: mainOrange, size: 20.sp),
                                      label: Text("Upload bài tập",
                                          style: defaultText14B.copyWith(
                                              color: mainOrange)),
                                      style: OutlinedButton.styleFrom(
                                        side: BorderSide(
                                            color: mainOrange, width: 1.4),
                                        shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(12.r),
                                        ),
                                        padding: EdgeInsets.symmetric(
                                            horizontal: 24.w, vertical: 10.h),
                                      ),
                                    ),
                                  ),
                                ],
                              )
                            : (selectedTab == 0 &&
                                    detailBuoiHocModel!.listHomeWork.isEmpty)
                                ? Text(
                                    'Chưa có bài tập về nhà',
                                    style: defaultText16M,
                                  )
                                : selectedTab == 1
                                    ? TaiLieuTab(
                                        taiLieu:
                                            detailBuoiHocModel!.listDocument,
                                      )
                                    : DanhGiaTab(
                                        feedback:
                                            detailBuoiHocModel!.listFeedBack,
                                      ),
                        SizedBox(height: 20.h),
                      ],
                    ),
                  ),
                ),
    );
  }

  Widget _buildTabButton(String text, int index) {
    bool isSelected = selectedTab == index;
    return Expanded(
      child: GestureDetector(
        onTap: () => setState(() => selectedTab = index),
        child: Container(
          padding: EdgeInsets.symmetric(vertical: 10.h),
          margin: EdgeInsets.symmetric(horizontal: 4.w),
          decoration: BoxDecoration(
            color: isSelected ? mainOrange : Colors.grey[100],
            borderRadius: BorderRadius.circular(10.r),
          ),
          child: Center(
            child: Text(
              text,
              style: defaultText14SB.copyWith(
                color: isSelected ? Colors.white : colorText,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class CustomGapCircle extends StatelessWidget {
  final double percent;
  const CustomGapCircle({super.key, required this.percent});

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      size: Size(180.w, 180.h),
      painter: GapCirclePainter(percent),
      child: Center(
        child: Text(
          "${percent * 10}\nĐiểm số của bạn",
          textAlign: TextAlign.center,
        ),
      ),
    );
  }
}

class GapCirclePainter extends CustomPainter {
  final double percent;
  GapCirclePainter(this.percent);

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width / 2 - 10;
    const startAngle = 3 * pi / 4; // bắt đầu bên trái trên
    const sweepTotal = 3 * pi / 2; // 270 độ, để lại 90 độ hở ở đáy

    final backgroundPaint = Paint()
      ..color = Colors.grey.shade300
      ..style = PaintingStyle.stroke
      ..strokeWidth = 10
      ..strokeCap = StrokeCap.round;

    final progressPaint = Paint()
      ..color = mainOrange
      ..style = PaintingStyle.stroke
      ..strokeWidth = 10
      ..strokeCap = StrokeCap.round;

    // vẽ nền
    canvas.drawArc(Rect.fromCircle(center: center, radius: radius), startAngle,
        sweepTotal, false, backgroundPaint);

    // vẽ progress
    canvas.drawArc(Rect.fromCircle(center: center, radius: radius), startAngle,
        sweepTotal * percent, false, progressPaint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => true;
}

class TaiLieuTab extends StatelessWidget {
  const TaiLieuTab({super.key, required this.taiLieu});
  final List<DocumentModel> taiLieu;
  // final List<Map<String, dynamic>> documents = const [
  //   {
  //     'icon': Icons.picture_as_pdf,
  //     'color': Color(0xFFE74C3C),
  //     'title': 'Tailieubuoi1.PDF',
  //     'subtitle': 'Nhấp vào để xem',
  //   },
  //   {
  //     'icon': Icons.image,
  //     'color': Color(0xFF5DADE2),
  //     'title': 'Image',
  //     'subtitle': 'Nhấp vào để xem',
  //   },
  //   {
  //     'icon': Icons.description,
  //     'color': Color(0xFF48C9B0),
  //     'title': 'Tailieu.doc',
  //     'subtitle': 'Nhấp vào để xem',
  //   },
  // ];

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: taiLieu.isEmpty
          ? Text('Không có tài liệu')
          : ListView.separated(
              shrinkWrap: true,
              itemCount: taiLieu.length,
              physics: const NeverScrollableScrollPhysics(),
              padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
              itemBuilder: (context, index) {
                final doc = taiLieu[index];
                return GestureDetector(
                  onTap: () async {
                    if (!await launchUrl(Uri.parse(doc.courseScheduleImg))) {
                      throw Exception('Could not launch');
                    }
                  },
                  child: Container(
                    padding: EdgeInsets.all(14.w),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16.r),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.05),
                          blurRadius: 6,
                          offset: const Offset(0, 3),
                        ),
                      ],
                    ),
                    child: Row(
                      children: [
                        Container(
                          width: 48.w,
                          height: 48.w,
                          decoration: BoxDecoration(
                            color: Color(0xFF48C9B0).withValues(alpha: 0.1),
                            borderRadius: BorderRadius.circular(12.r),
                          ),
                          child: Icon(Icons.description,
                              color: Color(0xFF48C9B0), size: 28.w),
                        ),
                        SizedBox(width: 12.w),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(doc.name, style: defaultText16B),
                              SizedBox(height: 2.h),
                              Text('Nhấn vào để xem', style: defaultText14Re),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
              separatorBuilder: (_, __) => SizedBox(height: 12.h),
            ),
    );
  }
}

class DanhGiaTab extends StatelessWidget {
  const DanhGiaTab({super.key, required this.feedback});
  final List<FeedbackModel> feedback;
  @override
  Widget build(BuildContext context) {
    return feedback.isEmpty
        ? Text(
            'Không có đánh giá',
            style: defaultText14M,
          )
        : SingleChildScrollView(
            child: ListView.separated(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
              itemBuilder: (context, index) {
                return Container(
                  padding: EdgeInsets.all(16.w),
                  decoration: BoxDecoration(
                    color: const Color(0xFFF9F9F9),
                    borderRadius: BorderRadius.circular(16.r),
                  ),
                  child: Text(
                    feedback.first.content,
                    style: defaultText14M,
                  ),
                );
              },
              separatorBuilder: (_, __) => SizedBox(height: 12.h),
              itemCount: feedback.length,
            ),
          );
    // return Padding(
    //   padding: EdgeInsets.all(16.w),
    //   child: Container(
    //     padding: EdgeInsets.all(16.w),
    //     decoration: BoxDecoration(
    //       color: const Color(0xFFF9F9F9),
    //       borderRadius: BorderRadius.circular(16.r),
    //     ),
    //     child: Text(
    //       'Làm bài tốt, cố gắng phát huy và duy trì trong những buổi học tiếp theo',
    //       style: defaultText14M,
    //     ),
    //   ),
    // );
  }
}
