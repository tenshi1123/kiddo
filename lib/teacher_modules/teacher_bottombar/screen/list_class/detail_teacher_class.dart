import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:kiddo/modules/bottombar/utils.dart';
import 'package:kiddo/modules/notification/notification.dart';
import 'package:kiddo/teacher_model/teacher_class_model.dart';
import 'package:kiddo/teacher_repo/teacher_class_repo.dart';
import 'package:kiddo/utils/constants/color.dart';
import 'package:kiddo/utils/constants/styles.dart';
import 'package:kiddo/utils/widget/custom_dialog.dart';
import 'package:kiddo/utils/widget/upload_document_dialog.dart';
import 'package:kiddo/utils/widget/webview_screen.dart';

class DetailTeacherClass extends StatefulWidget {
  const DetailTeacherClass({
    super.key,
    required this.model,
  });
  final TeacherClassModel model;
  @override
  State<DetailTeacherClass> createState() => _DetailTeacherClassState();
}

class _DetailTeacherClassState extends State<DetailTeacherClass> {
  List<DetailBuoiHocExtendedModel> teachingSessions = [];
  List<BaoCaoModel> reports = [];
  List<ListDocumentModel> documents = [];
  String selectedTopTab = 'Lịch dạy';
  bool isLoading = true;
  @override
  void initState() {
    fetchData();
    super.initState();
  }

  Future<void> fetchData() async {
    try {
      final response = await TeacherClassRepo().getDetailBuoiHoc(
          courseScheduleId: widget.model.courseScheduleId,
          typeTeacher: widget.model.typeTeacher);
      final response1 = await TeacherClassRepo().getBaoCao(
          courseScheduleId: widget.model.courseScheduleId,
          typeTeacher: widget.model.typeTeacher);
      final response2 = await TeacherClassRepo().getDocument(
          courseScheduleId: widget.model.courseScheduleId,
          typeTeacher: widget.model.typeTeacher);
      setState(() {
        teachingSessions = response;
        reports = response1;
        documents = response2;
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
          'Lớp Orca 56',
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
            SizedBox(
              height: 26.h,
            ),
            Container(
              color: Colors.white, // Nền trắng cho phần nút

              child: Column(
                children: [
                  // Hàng 1: Lịch dạy, Báo cáo, Đề thi
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      _buildTopTabButton('Lịch dạy'),
                      _buildTopTabButton('Báo cáo'),
                      _buildTopTabButton('Đề thi'),
                    ],
                  ),
                  SizedBox(height: 10.h),
                  // Hàng 2: Bài tập bổ trợ, Tài liệu ngoài
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      _buildTopTabButton('Bài tập bổ trợ'),
                      _buildTopTabButton('Tài liệu ngoài'),
                    ],
                  ),
                ],
              ),
            ),
            SizedBox(
              height: 20.h,
            ),
            Expanded(
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(24.r),
                  color: Color(0xffFBF0E7),
                ),
                //padding: EdgeInsets.all(16.w),
                child: selectedTopTab == 'Lịch dạy'
                    ? ListView.builder(
                        // ListView.builder sẽ tự cuộn
                        itemCount: teachingSessions.length,
                        itemBuilder: (context, index) {
                          return BuildTeachinhSessionCard(
                            sessionData: teachingSessions[index],
                          );
                        },
                      )
                    : selectedTopTab == 'Báo cáo'
                        ? ListView.builder(
                            // ListView.builder sẽ tự cuộn
                            itemCount: reports.length,
                            itemBuilder: (context, index) {
                              return StudentDetailsCard(
                                model: reports[index],
                              );
                            },
                          )
                        : selectedTopTab == 'Đề thi'
                            ? Column(
                                children: [
                                  SizedBox(
                                    height: 10.h,
                                  ),
                                  Padding(
                                    padding: EdgeInsets.symmetric(
                                      horizontal: 16.w,
                                      vertical: 12.h,
                                    ),
                                    child: SearchExamBar(),
                                  ),
                                  SizedBox(
                                    height: 10.h,
                                  ),
                                  //_dethiCard(teachingSessions.first),
                                  Spacer(),
                                  Padding(
                                    padding: EdgeInsets.symmetric(
                                        horizontal: 16.w, vertical: 12.h),
                                    child: ElevatedButton(
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: mainOrange,
                                        shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(12),
                                        ),
                                      ),
                                      onPressed: () {},
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Icon(
                                            Icons.add,
                                            color: Colors.white,
                                          ),
                                          Text(
                                            '  Thêm đề thi',
                                            style: defaultText18B.copyWith(
                                                color: Colors.white),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                  SizedBox(
                                    height: 32.h,
                                  ),
                                ],
                              )
                            : selectedTopTab == 'Bài tập bổ trợ'
                                ? Column(
                                    children: [
                                      SizedBox(
                                        height: 10.h,
                                      ),
                                      SearchFormWidget(),
                                      SizedBox(
                                        height: 10.h,
                                      ),
                                    ],
                                  )
                                : Column(
                                    children: [
                                      SizedBox(
                                        height: 10.h,
                                      ),
                                      SizedBox(
                                        height: 520.h,
                                        child: ListView.builder(
                                          // ListView.builder sẽ tự cuộn
                                          itemCount: documents.length,
                                          itemBuilder: (context, index) {
                                            return Padding(
                                              padding: EdgeInsets.symmetric(
                                                horizontal: 16.w,
                                                vertical: 16.h,
                                              ),
                                              child: _documentCard(
                                                  documents[index]),
                                            );
                                          },
                                        ),
                                      ),
                                      Spacer(),
                                      Padding(
                                        padding: EdgeInsets.symmetric(
                                            horizontal: 16.w),
                                        child: ElevatedButton(
                                          style: ElevatedButton.styleFrom(
                                            backgroundColor: mainOrange,
                                            shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(12),
                                            ),
                                          ),
                                          onPressed: () {
                                            showModalBottomSheet(
                                              context: context,
                                              isScrollControlled: true,
                                              backgroundColor:
                                                  Colors.transparent,
                                              builder: (_) => SizedBox(
                                                height: 650.h,
                                                child: AddDocumentSheet(
                                                  sessions: teachingSessions,
                                                ),
                                              ),
                                            );
                                          },
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              Icon(
                                                Icons.add,
                                                color: Colors.white,
                                              ),
                                              Padding(
                                                padding: EdgeInsets.symmetric(
                                                    vertical: 12.h),
                                                child: Text(
                                                  '  Thêm tài liệu',
                                                  style:
                                                      defaultText16B.copyWith(
                                                          color: Colors.white),
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
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Widget cho các nút tab trên cùng
  Widget _buildTopTabButton(String title) {
    final bool isSelected = selectedTopTab == title;
    return GestureDetector(
      onTap: () {
        setState(() {
          selectedTopTab = title;
        });
      },
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
        decoration: BoxDecoration(
          color: isSelected ? mainGreen : const Color(0xFFEEF5F0),
          borderRadius: BorderRadius.circular(20),
        ),
        child: Text(title,
            style: defaultText14M.copyWith(
              color: isSelected ? Colors.white : Colors.black87,
              fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
            )),
      ),
    );
  }
}

class BuildTeachinhSessionCard extends StatelessWidget {
  const BuildTeachinhSessionCard({super.key, required this.sessionData});
  final DetailBuoiHocExtendedModel sessionData;
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(top: 16.h, bottom: 10.h, left: 16.w, right: 16.w),
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
              Text(
                formatDisplay(
                  sessionData.createdDate,
                  sessionData.timeStart,
                  sessionData.timeEnd,
                ),
                style: defaultText14M,
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
              Text(
                '${sessionData.phonghocName} - ${sessionData.cosoName}',
                style: defaultText14M,
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
                width: 275.w,
                child: Text(
                  sessionData.cosoAddress,
                  style: defaultText14M,
                ),
              )
            ],
          ),
          SizedBox(
            height: 10.h,
          ),
          Container(
            width: double.infinity,
            height: 40.h,
            margin: EdgeInsets.symmetric(horizontal: 20.w),
            decoration: BoxDecoration(
              color: const Color(0xffF9F3F3),
              borderRadius: BorderRadius.circular(10.r),
              border: Border.all(
                color: mainRed.withValues(alpha: 0.12), // Màu viền đỏ
                width: 1,
              ),
            ),
            child: TextButton.icon(
              onPressed: () => showTeachingDialog(
                context,
                'Buổi 3',
                sessionData.eventCheckinOffId,
                sessionData.teachingContent,
                sessionData.linkRecord,
              ),
              icon: SvgPicture.asset('assets/icons/edit.svg'),
              label: Text(
                'Chỉnh sửa',
                style: defaultText14SB.copyWith(color: mainRed),
              ),
              // Để căn giữa icon và text
              style: TextButton.styleFrom(
                padding: EdgeInsets.zero, // Bỏ padding mặc định của TextButton
                alignment: Alignment.center, // Căn giữa nội dung
                splashFactory:
                    NoSplash.splashFactory, // Loại bỏ hiệu ứng splash khi nhấn
                backgroundColor:
                    Colors.transparent, // Nền trong suốt để thấy nền Container
              ),
            ),
          )
        ],
      ),
    );
  }
}

class StudentDetailsCard extends StatelessWidget {
  const StudentDetailsCard({super.key, required this.model});
  final BaoCaoModel model;
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: EdgeInsetsGeometry.symmetric(vertical: 12.h, horizontal: 16.w),
        // Sử dụng Card để tạo hiệu ứng bo góc và đổ bóng nhẹ
        child: Card(
          elevation: 4,
          color: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16.r),
          ),
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min, // Chiếm không gian tối thiểu
              children: [
                // _buildInfoRow("STT", model.toString(), isBold: true),
                const SizedBox(height: 10),
                _buildInfoRow("Họ tên:", model.fullName),
                _buildInfoRow("SĐT:", model.phone),
                _buildInfoRow("Số buổi học:", model.soBuoiHoc),
                _buildInfoRow("Vắng mặt:", model.vangMat),
                _buildInfoRow("Xin nghỉ:", model.xinNghi),
                _buildInfoRow("Đi muộn:", model.diMuon),
                _buildInfoRow("Đúng giờ:", model.dungGio),
                _buildInfoRow("Điểm đầu vào:", model.entryPoint),
                _buildInfoRow("Điểm bài tập:", model.pointBt),
                _buildInfoRow("Điểm bt online:", model.pointBtOnline),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // Widget trợ giúp để xây dựng mỗi hàng thông tin
  Widget _buildInfoRow(String label, String value, {bool isBold = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        //mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          SizedBox(
            width: 130.w,
            child: Text(label,
                style: defaultText14M.copyWith(
                  color: colorText.withValues(alpha: 0.8),
                  fontWeight: isBold ? FontWeight.bold : FontWeight.normal,
                )),
          ),
          // Value (Giá trị, căn phải và luôn đậm)
          SizedBox(
            width: 160.w,
            child: Text(value, style: defaultText14SB),
          ),
        ],
      ),
    );
  }
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

Widget _dethiCard(DetailBuoiHocExtendedModel sessionData) {
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
          'Buổi 3 - Week 1 Reading practice ',
          style: defaultText16B,
        ),
        SizedBox(
          height: 10.h,
        ),
        Row(
          children: [
            SvgPicture.asset('assets/icons/clock.svg'),
            Text(
              '    2025-10-14 (13:30 - 15:30)',
              style: defaultText14M,
            )
          ],
        ),
        SizedBox(
          height: 4.h,
        ),
        Row(
          children: [
            SvgPicture.asset('assets/icons/class.svg'),
            Text(
              '    Phòng học 101 - HN',
              style: defaultText14M,
            )
          ],
        ),
        SizedBox(
          height: 4.h,
        ),
        Row(
          children: [
            SvgPicture.asset('assets/icons/place.svg'),
            Text(
              '    33 Trung Kính, Trung Hòa, \n    Cầu Giấy, Hà Nội',
              style: defaultText14M,
            )
          ],
        ),
        SizedBox(
          height: 10.h,
        ),
        Divider(),
        Row(
          children: [
            SvgPicture.asset('assets/icons/pdf.svg'),
            Text(
              '    Tên tài liệu',
              style: defaultText14SB,
            )
          ],
        ),
        SizedBox(
          height: 10.h,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Container(
              height: 40.h,
              width: 95.w,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8.r),
                color: mainGreen,
              ),
              child: Center(
                child: Text(
                  'Xem',
                  style: defaultText14SB.copyWith(color: Colors.white),
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
                  style: defaultText14SB.copyWith(color: Colors.white),
                ),
              ),
            ),
            Container(
              height: 40.h,
              width: 95.w,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8.r),
                color: mainRed,
              ),
              child: Center(
                child: Text(
                  'Xoá',
                  style: defaultText14SB.copyWith(color: Colors.white),
                ),
              ),
            ),
          ],
        )
      ],
    ),
  );
}

class SearchExamBar extends StatelessWidget {
  const SearchExamBar({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(36.r),
        border: Border.all(
          color: const Color(0xFFF0E0D8),
          width: 2,
        ),
      ),
      child: TextField(
        decoration: InputDecoration(
          hintText: 'Tìm kiếm đề thi',
          hintStyle:
              defaultText14M.copyWith(color: colorText.withValues(alpha: 0.5)),
          prefixIcon: Icon(
            Icons.search,
            color: Colors.grey.shade500,
            size: 20,
          ),
          border: InputBorder.none,
          focusedBorder: InputBorder.none,
          enabledBorder: InputBorder.none,
          //contentPadding: EdgeInsets.symmetric(vertical: 6.h),
        ),
        onChanged: (value) {},
      ),
    );
  }
}

class SearchFormWidget extends StatefulWidget {
  const SearchFormWidget({super.key});

  @override
  State<SearchFormWidget> createState() => _SearchFormWidgetState();
}

class _SearchFormWidgetState extends State<SearchFormWidget> {
  // Danh sách các bài tập
  final List<String> exercises =
      List.generate(10, (index) => 'Bài tập ${index + 1}');

  // Giá trị bài tập đang được chọn
  String? selectedExercise;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        _buildInputField(hintText: 'Họ tên, Phone, mail'),
        SizedBox(height: 14.h),
        _buildDropdownField(),
        SizedBox(height: 28.h),
        _buildSearchButton(),
      ],
    );
  }

  Widget _buildInputField({required String hintText}) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(44.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            spreadRadius: 1,
            blurRadius: 3,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: TextField(
        decoration: InputDecoration(
          hintText: hintText,
          hintStyle: defaultText16M.copyWith(
            color: Colors.grey.shade400,
          ),
          border: InputBorder.none,
          contentPadding:
              EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
        ),
      ),
    );
  }

  // Widget cho ô chọn bài tập (Dropdown)
  Widget _buildDropdownField() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(44.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            spreadRadius: 1,
            blurRadius: 3,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: DropdownButtonFormField<String>(
        value: selectedExercise,
        isExpanded: true,
        decoration: InputDecoration(
          hintText: 'Chọn bài tập',
          hintStyle: defaultText16M.copyWith(
            color: Colors.grey.shade400,
          ),
          // Loại bỏ viền mặc định của DropdownButtonFormField
          border: InputBorder.none,
          focusedBorder: InputBorder.none,
          enabledBorder: InputBorder.none,
          contentPadding:
              const EdgeInsets.symmetric(horizontal: 20.0, vertical: 18.0),
          // Thêm icon mũi tên tùy chỉnh nếu cần, nhưng DropdownButtonFormField đã có
        ),
        icon: SvgPicture.asset('assets/icons/arrow.svg'),
        onChanged: (String? newValue) {
          setState(() {
            selectedExercise = newValue;
          });
        },
        items: exercises.map<DropdownMenuItem<String>>((String value) {
          return DropdownMenuItem<String>(
            value: value,
            child: Text(value, style: defaultText14M),
          );
        }).toList(),
      ),
    );
  }

  // Widget cho nút Tìm kiếm
  Widget _buildSearchButton() {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton.icon(
        onPressed: () {},
        icon: const Icon(Icons.search, color: Colors.white, size: 24),
        label: Text('Tìm kiếm',
            style: defaultText16B.copyWith(color: Colors.white)),
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFFEF6C2C), // Màu cam đậm
          padding: EdgeInsets.symmetric(vertical: 12.h),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15.0), // Bo tròn góc
          ),
          elevation: 4, // Đổ bóng nhẹ
        ),
      ),
    );
  }
}
