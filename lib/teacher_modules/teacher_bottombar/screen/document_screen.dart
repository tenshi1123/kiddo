import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:kiddo/modules/bottombar/utils.dart';
import 'package:kiddo/modules/notification/notification.dart';
import 'package:kiddo/teacher_model/teacher_class_model.dart';
import 'package:kiddo/teacher_repo/teacher_class_repo.dart';
import 'package:kiddo/utils/constants/color.dart';
import 'package:kiddo/utils/constants/styles.dart';
import 'package:kiddo/utils/widget/upload_document_dialog.dart';
import 'package:kiddo/utils/widget/webview_screen.dart';

class DocumentScreen extends StatefulWidget {
  const DocumentScreen({
    super.key,
    required this.typeTeacher,
    required this.courseScheduleId,
  });
  final String typeTeacher;
  final String courseScheduleId;
  @override
  State<DocumentScreen> createState() => _DocumentScreenState();
}

class _DocumentScreenState extends State<DocumentScreen> {
  List<ListDocumentModel> documents = [];
  List<DetailBuoiHocExtendedModel> teachingSessions = [];
  @override
  void initState() {
    fetchData();
    super.initState();
  }

  Future<void> fetchData() async {
    try {
      final response2 = await TeacherClassRepo().getDocument(
        courseScheduleId: widget.courseScheduleId,
        typeTeacher: widget.typeTeacher,
      );
      final response = await TeacherClassRepo().getDetailBuoiHoc(
          courseScheduleId: widget.courseScheduleId,
          typeTeacher: widget.typeTeacher);
      setState(() {
        documents = response2;
        teachingSessions = response;
      });
    } catch (e) {
      debugPrint('Lỗi khi gọi API: $e');
      setState(() {});
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
            'Tài liệu',
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
                children: [
                  SizedBox(
                    height: MediaQuery.of(context).size.height - 160.h,
                    child: ListView.builder(
                      // ListView.builder sẽ tự cuộn
                      itemCount: documents.length,
                      itemBuilder: (context, index) {
                        return Padding(
                          padding: EdgeInsets.symmetric(
                            horizontal: 16.w,
                            vertical: 16.h,
                          ),
                          child: _documentCard(documents[index]),
                        );
                      },
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal: 16.w,
                    ),
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: mainOrange,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      onPressed: () {
                        showModalBottomSheet(
                          context: context,
                          isScrollControlled: true,
                          backgroundColor: Colors.transparent,
                          builder: (_) => SizedBox(
                            height: 650.h,
                            child: AddDocumentSheet(
                              sessions: teachingSessions,
                            ),
                          ),
                        );
                      },
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.add,
                            color: Colors.white,
                          ),
                          Padding(
                            padding: EdgeInsets.symmetric(vertical: 12.h),
                            child: Text(
                              '  Thêm tài liệu',
                              style:
                                  defaultText16B.copyWith(color: Colors.white),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 32.h,
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

Widget _documentCard(ListDocumentModel sessionData) {
  return Container(
    padding: EdgeInsets.symmetric(
      horizontal: 16.w,
      vertical: 16.h,
    ),
    width: 343.w,
    decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.all(Radius.circular(12.r)),
      boxShadow: [
        BoxShadow(
          color: const Color(0xff273D8C).withValues(alpha: 0.12),
          blurRadius: 16,
          spreadRadius: 0,
          offset: const Offset(0, 4), // Shadow position
        ),
      ],
    ),
    child: Column(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          sessionData.name,
          style: defaultText16B,
        ),
        SizedBox(
          height: 10.h,
        ),
        Row(
          children: [
            SvgPicture.asset('assets/icons/clock.svg'),
            SizedBox(
              width: 10.w,
            ),
            SizedBox(
              width: 270.w,
              child: Text(
                formatDisplay(
                  sessionData.createdDate,
                  sessionData.timeStart,
                  sessionData.timeEnd,
                ),
                style: defaultText14M,
              ),
            )
          ],
        ),
        SizedBox(
          height: 4.h,
        ),
        Row(
          children: [
            SvgPicture.asset('assets/icons/class.svg'),
            SizedBox(
              width: 10.w,
            ),
            SizedBox(
              width: 270.w,
              child: Text(
                '${sessionData.phongHocName} - ${sessionData.cocoName}',
                style: defaultText14M,
              ),
            )
          ],
        ),
        SizedBox(
          height: 4.h,
        ),
        Row(
          children: [
            SvgPicture.asset('assets/icons/place.svg'),
            SizedBox(
              width: 10.w,
            ),
            SizedBox(
              width: 270.w,
              child: Text(
                sessionData.address,
                style: defaultText14M,
              ),
            )
          ],
        ),
        SizedBox(
          height: 10.h,
        ),
        Divider(),
        sessionData.listDetailDocument.isEmpty
            ? Text(
                'Chưa có tài liệu',
                style: defaultText14M,
              )
            : SizedBox(
                height: 80.h,
                child: ListView.builder(
                  // ListView.builder sẽ tự cuộn
                  itemCount: sessionData.listDetailDocument.length,
                  itemBuilder: (context, index) {
                    return Column(
                      children: [
                        Row(
                          children: [
                            SvgPicture.asset('assets/icons/pdf.svg'),
                            SizedBox(
                              width: 10.w,
                            ),
                            SizedBox(
                              width: 270.w,
                              child: Text(
                                sessionData.listDetailDocument[index].name,
                                style: defaultText14SB,
                              ),
                            )
                          ],
                        ),
                        SizedBox(
                          height: 10.h,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            GestureDetector(
                              onTap: () {
                                // Xử lý sự kiện xem tài liệu
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => WebViewScreen(
                                      link: sessionData
                                          .listDetailDocument[index]
                                          .linkWebview,
                                      title: sessionData
                                          .listDetailDocument[index].name,
                                      type: 1,
                                    ),
                                  ),
                                );
                              },
                              child: Container(
                                height: 40.h,
                                width: 95.w,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(8.r),
                                  color: mainGreen,
                                ),
                                child: Center(
                                  child: Text(
                                    'Xem',
                                    style: defaultText14SB.copyWith(
                                        color: Colors.white),
                                  ),
                                ),
                              ),
                            ),
                            Container(
                              height: 40.h,
                              width: 95.w,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(8.r),
                                color: mainBlue,
                              ),
                              child: Center(
                                child: Text(
                                  'Sửa',
                                  style: defaultText14SB.copyWith(
                                      color: Colors.white),
                                ),
                              ),
                            ),
                            GestureDetector(
                              onTap: () {
                                TeacherClassRepo().deleteDocument(
                                    classLessonDocumentId: sessionData
                                        .listDetailDocument[index]
                                        .classLessonDocumentId);
                              },
                              child: Container(
                                height: 40.h,
                                width: 95.w,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(8.r),
                                  color: mainRed,
                                ),
                                child: Center(
                                  child: Text(
                                    'Xoá',
                                    style: defaultText14SB.copyWith(
                                        color: Colors.white),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        )
                      ],
                    );
                  },
                ),
              )
      ],
    ),
  );
}
