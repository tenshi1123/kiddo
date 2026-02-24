import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:intl/intl.dart';
import 'package:kiddo/main.dart';
import 'package:kiddo/modules/lesson/detail_lesson_screen.dart';
import 'package:kiddo/modules/notification/notification.dart';
import 'package:kiddo/student_models/customer_models.dart';
import 'package:kiddo/student_models/diem_danh_model.dart';
import 'package:kiddo/student_models/home_model.dart';
import 'package:kiddo/student_models/profile_model.dart';
import 'package:kiddo/student_repo/customer_repo.dart';
import 'package:kiddo/student_repo/home_repo.dart';
import 'package:kiddo/teacher_modules/teacher_bottombar/screen/bao_cao/bao_cao_screen.dart';
import 'package:kiddo/teacher_modules/teacher_bottombar/screen/document_screen.dart';
import 'package:kiddo/teacher_modules/teacher_bottombar/screen/feedback_user.dart';
import 'package:kiddo/teacher_modules/teacher_bottombar/screen/teacher_calendar.dart';
import 'package:kiddo/teacher_modules/teacher_bottombar/screen/teacher_lophoc.dart';
import 'package:kiddo/teacher_repo/teacher_schedule_repo.dart';
import 'package:kiddo/utils/constants/color.dart';
import 'package:kiddo/utils/constants/styles.dart';
import 'package:kiddo/utils/widget/custom_widget.dart';
import 'package:kiddo/utils/widget/app_image.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class TeacherHomeScreen extends StatefulWidget {
  const TeacherHomeScreen({
    super.key,
    required this.model,
  });
  final ProfileModel model;
  @override
  State<TeacherHomeScreen> createState() => _TeacherHomeScreenState();
}

class _TeacherHomeScreenState extends State<TeacherHomeScreen> {
  final controller1 = PageController(viewportFraction: 1, keepPage: true);
  final controller3 = PageController(viewportFraction: 0.75, keepPage: true);
  final ValueNotifier<int> _centralBoard = ValueNotifier<int>(0);
  String selectedCategory = 'Tất cả';
  bool isLoading = true;
  List<ScheduleModel> listLichHoc = [];
  List<ChildrenModel> listChild = [];
  @override
  void initState() {
    super.initState();
    _fetchData();
  }

  Future<void> _fetchData() async {
    try {
      final data = await TeacherScheduleRepo().getScheduleList(
        DateFormat('dd-MM-yyyy').format(DateTime.now().subtract(
          const Duration(days: 30),
        )),
        DateFormat('dd-MM-yyyy').format(
          DateTime.now().add(
            const Duration(days: 15),
          ),
        ),
      );
      final data2 = await CustomerRepo().getChilren();

      setState(() {
        listLichHoc = data;
        listChild = data2;
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
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              height: 30.h,
            ),
            Row(
              children: [
                SizedBox(
                  width: 16.w,
                ),
                Container(
                  padding: EdgeInsets.all(12.dg),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    shape: BoxShape.circle,
                  ),
                  child: AppImage(
                    url: widget.model.avatar,
                    width: 50.w,
                    height: 50.h,
                    fit: BoxFit.fill,
                  ),
                ),
                SizedBox(
                  width: 15.w,
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      width: 200.w,
                      child: Text(
                        'Hi! ${widget.model.fullName}',
                        style: defaultText18B.copyWith(color: Colors.white),
                      ),
                    ),
                    dateTimeDisplayWidget()
                  ],
                ),
                const Spacer(),
                GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => NotificationScreen(),
                      ),
                    );
                  },
                  child: SizedBox(
                    width: 37.w,
                    height: 26.h,
                    child: Stack(
                      children: [
                        Positioned(
                          left: 0,
                          bottom: 0,
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
                        // Positioned(
                        //   right: 0,
                        //   top: 0,
                        //   child: Container(
                        //     padding: EdgeInsets.symmetric(
                        //       horizontal: 8.w,
                        //       vertical: 0,
                        //     ),
                        //     decoration: BoxDecoration(
                        //       color: mainBlue,
                        //       borderRadius: BorderRadius.circular(12.r),
                        //       border: Border.all(
                        //         color: Colors.white,
                        //         width: 1.5,
                        //       ),
                        //     ),
                        //     child: Text(
                        //       '3',
                        //       style: defaultText12B.copyWith(
                        //         color: Colors.white,
                        //         fontSize: 10.sp,
                        //       ),
                        //     ),
                        //   ),
                        // ),
                      ],
                    ),
                  ),
                ),
                SizedBox(
                  width: 14.w,
                )
              ],
            ),
            SizedBox(
              height: 20.h,
            ),
            Container(
              width: double.infinity,
              height: 850.h,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(28.r),
                      topRight: Radius.circular(28.r)),
                  color: Colors.white),
              child: Column(
                children: [
                  SizedBox(
                    height: 30.h,
                  ),
                  SmoothHorizontalMenu(),
                  SizedBox(
                    height: 30.h,
                  ),
                  Row(
                    children: [
                      SizedBox(
                        width: 16.w,
                      ),
                      SvgPicture.asset(
                        'assets/icons/schedule_icon.svg',
                        width: 16.w,
                        height: 16.h,
                      ),
                      SizedBox(
                        width: 10.w,
                      ),
                      Text(
                        'Lịch dạy sắp tới',
                        style: defaultText14B,
                      ),
                      Spacer(),
                      SizedBox(
                        width: 16.w,
                      )
                    ],
                  ),
                  isLoading
                      ? CircularProgressIndicator()
                      : listLichHoc.isEmpty
                          ? Text(
                              'Chưa có lịch dạy sắp tới',
                              style: defaultText14M,
                            )
                          : ClipRRect(
                              borderRadius: BorderRadius.all(
                                Radius.circular(16.r),
                              ),
                              child: SizedBox(
                                height: 216.h,
                                width: 375.w,
                                child: PageView.builder(
                                  padEnds: false,
                                  controller: controller1,
                                  itemCount: listLichHoc.length,
                                  itemBuilder: (_, index) {
                                    return _Upcoming(listLichHoc[index]);
                                  },
                                ),
                              ),
                            ),
                  SizedBox(
                    height: 8.h,
                  ),
                  SmoothPageIndicator(
                    controller: controller1,
                    count: listLichHoc.length > 3 ? 3 : listLichHoc.length,
                    effect: CustomizableEffect(
                      activeDotDecoration: DotDecoration(
                        width: 20.w,
                        height: 8.h,
                        color: mainOrange,
                        borderRadius: BorderRadius.circular(24),
                      ),
                      dotDecoration: DotDecoration(
                        width: 8.w,
                        height: 8.h,
                        color: Colors.grey,
                        borderRadius: BorderRadius.circular(16),
                        verticalOffset: 0,
                      ),
                      spacing: 6.0,
                    ),
                    onDotClicked: (index) {
                      controller1.animateToPage(index,
                          duration: const Duration(milliseconds: 300),
                          curve: Curves.easeInOut);
                    },
                  ),
                  SizedBox(
                    height: 10.h,
                  ),
                  Padding(
                    padding: EdgeInsets.only(left: 20.w, top: 10.h),
                    child: Row(
                      children: [
                        SvgPicture.asset(
                          'assets/icons/news.svg',
                          width: 16.w,
                          height: 16.h,
                        ),
                        Text(
                          '  Bảng tin trung tâm',
                          style: defaultText14B,
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 10.h,
                  ),
                  SizedBox(
                    height: 284.h,
                    width: 375.w,
                    child: listCategory.isNotEmpty
                        ? ValueListenableBuilder<int>(
                            valueListenable: _centralBoard,
                            builder: (BuildContext context, int value,
                                Widget? child) {
                              return Column(
                                children: [
                                  SizedBox(
                                    height: 55.h,
                                    width: 350.w,
                                    child: ListView.builder(
                                      physics: const ScrollPhysics(),
                                      itemCount: listCategory.length,
                                      scrollDirection: Axis.horizontal,
                                      itemBuilder: (context, index) {
                                        return Padding(
                                          padding: EdgeInsets.only(right: 16.w),
                                          child: GestureDetector(
                                            onTap: () {
                                              _centralBoard.value = index;
                                            },
                                            child: Column(
                                              children: [
                                                feedbackItem(
                                                  value == index,
                                                  listCategory[index]
                                                      .categoryName,
                                                ),
                                                const Spacer(),
                                              ],
                                            ),
                                          ),
                                        );
                                      },
                                    ),
                                  ),
                                  SizedBox(
                                      height: 229.h,
                                      width: 350.w,
                                      child: FutureBuilder(
                                        future: HomeRepo().getListPost(
                                            id: listCategory[
                                                    _centralBoard.value]
                                                .id), // Hàm gọi API
                                        builder: (context, snapshot) {
                                          if (snapshot.connectionState ==
                                              ConnectionState.waiting) {
                                            return Center(
                                              child: SizedBox(
                                                width: 40.w,
                                                height: 40.h,
                                                child:
                                                    const CircularProgressIndicator(),
                                              ),
                                            );
                                          } else if (snapshot.hasError) {
                                            return Text(
                                              'Vui lòng kiểm tra lại kết nối internet',
                                              style: defaultText14M,
                                            );
                                          } else if (snapshot.hasData) {
                                            final listPost = snapshot.data
                                                as List<PostModel>;
                                            return SizedBox(
                                              width: 375.w,
                                              height: 166.h,
                                              child: listPost.isEmpty
                                                  ? Center(
                                                      child: Center(
                                                        child: Image.asset(
                                                          'assets/images/empty.png',
                                                          height: 200.h,
                                                          width: 200.w,
                                                        ),
                                                      ),
                                                    )
                                                  : Column(
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .center,
                                                      children: <Widget>[
                                                        ClipRRect(
                                                          borderRadius:
                                                              BorderRadius.all(
                                                            Radius.circular(
                                                                16.r),
                                                          ),
                                                          child: SizedBox(
                                                            height: 208.h,
                                                            width: 375.w,
                                                            child: PageView
                                                                .builder(
                                                              padEnds: false,
                                                              controller:
                                                                  controller3,
                                                              itemCount:
                                                                  listPost
                                                                      .length,
                                                              itemBuilder:
                                                                  (_, index) {
                                                                return PostItem(
                                                                  model:
                                                                      listPost[
                                                                          index],
                                                                );
                                                              },
                                                            ),
                                                          ),
                                                        ),
                                                        SmoothPageIndicator(
                                                          controller:
                                                              controller3,
                                                          count: listPost
                                                                  .isEmpty
                                                              ? 0
                                                              : listPost.length >
                                                                      3
                                                                  ? 3
                                                                  : listPost
                                                                      .length,
                                                          effect:
                                                              CustomizableEffect(
                                                            activeDotDecoration:
                                                                DotDecoration(
                                                              width: 20.w,
                                                              height: 8.h,
                                                              color:
                                                                  Colors.indigo,
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                          24),
                                                            ),
                                                            dotDecoration:
                                                                DotDecoration(
                                                              width: 8.w,
                                                              height: 8.h,
                                                              color:
                                                                  Colors.grey,
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                          16),
                                                              verticalOffset: 0,
                                                            ),
                                                            spacing: 6.0,
                                                          ),
                                                          onDotClicked:
                                                              (index) {
                                                            controller3.animateToPage(
                                                                index,
                                                                duration:
                                                                    const Duration(
                                                                        milliseconds:
                                                                            300),
                                                                curve: Curves
                                                                    .easeInOut);
                                                          },
                                                        ),
                                                      ],
                                                    ),
                                            );
                                          } else {
                                            return Text(
                                              'Vui lòng kiểm tra lại kết nối internet2',
                                              style: defaultText14M,
                                            );
                                          }
                                        },
                                      )),
                                ],
                              );
                            },
                          )
                        : SizedBox(),
                  ),
                  SizedBox(
                    height: 95.h,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

Widget _homeIcon({required String title, required String image}) {
  return SizedBox(
    //height: 96.h,
    width: 90.w,
    child: Column(
      children: [
        Center(
            child: Image.asset(
          image,
          //width: 65.w,
          height: 44.h,
          fit: BoxFit.fitHeight,
        )),
        SizedBox(
          height: 8.h,
        ),
        Center(
          child: Text(
            title,
            style: defaultText12B,
          ),
        ),
      ],
    ),
  );
}

class _Upcoming extends StatelessWidget {
  const _Upcoming(this.model);
  final ScheduleModel model;
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () async {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: ((context) => DetailLessonScreen(
                  typeLearn: model.typeLearn,
                  checkinOffId: model.checkinOffId ?? '',
                  meetingId: model.meetingId ?? '',
                )),
          ),
        );
      },
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 20.h),
        margin: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.all(
              Radius.circular(8.r),
            ),
            color: Colors.white,
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withValues(alpha: 0.2),
                spreadRadius: 5,
                blurRadius: 7,
                offset: const Offset(0, 2),
              ),
            ]),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding:
                      EdgeInsets.symmetric(horizontal: 12.w, vertical: 4.h),
                  decoration: BoxDecoration(
                    color: mainBlue,
                    borderRadius: BorderRadius.all(
                      Radius.circular(20.r),
                    ),
                  ),
                  child: (Text(
                    '${model.createdDate.day}, tháng ${model.createdDate.month}',
                    style: defaultText14B.copyWith(
                      color: Colors.white,
                    ),
                    textAlign: TextAlign.center,
                  )),
                ),
                Spacer(),
                SvgPicture.asset(
                  'assets/icons/video_call.svg',
                  width: 24.w,
                  height: 24.h,
                ),
                Text('Lớp học ${model.typeTeacher}',
                    style: defaultText14M.copyWith(
                      color: mainBlue,
                    )),
              ],
            ),
            Text('${model.courseName} - ${model.buoiHoc}',
                style: defaultText16B),
            (model.typeLearn == 'off' || model.typeTeacher == 'off')
                ? Text(
                    '${DateFormat('EEEE').format(model.createdDate)}  (${model.timeStart.replaceRange(5, null, '')} - ${model.timeEnd.replaceRange(5, null, '')})',
                    style: defaultText14M,
                  )
                : Text(
                    DateFormat('EEEE').format(model.createdDate),
                    style: defaultText14M,
                  ),
            Container(
              padding: EdgeInsets.symmetric(vertical: 8.h),
              decoration: BoxDecoration(
                color: mainGreen,
                borderRadius: BorderRadius.all(
                  Radius.circular(12.r),
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Vào lớp  ',
                    style: defaultText14B.copyWith(
                      color: Colors.white,
                    ),
                  ),
                  SvgPicture.asset(
                    'assets/icons/sign_out.svg',
                    width: 16.w,
                    height: 16.h,
                    colorFilter: ColorFilter.mode(
                      Colors.white,
                      BlendMode.srcIn,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

Widget dateTimeDisplayWidget() {
  final now = DateTime.now();
  final dateFormat = DateFormat("dd/MM/yyyy", "vi_VN");
  final timeFormat = DateFormat("hh:mm a", "vi_VN");
  const weekdays = {
    1: "Thứ 2",
    2: "Thứ 3",
    3: "Thứ 4",
    4: "Thứ 5",
    5: "Thứ 6",
    6: "Thứ 7",
    7: "Chủ nhật",
  };
  final weekday = weekdays[now.weekday] ?? "";
  final dateString = "$weekday, ${dateFormat.format(now)}";
  final timeString = timeFormat.format(now);

  return Row(
    mainAxisAlignment: MainAxisAlignment.center,
    children: [
      Text(dateString,
          style: defaultText12Re.copyWith(
            color: Colors.white.withValues(alpha: 0.8),
          )),
      Container(
        margin: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
        width: 1,
        height: 18.h,
        color: Colors.white.withValues(alpha: 0.8), // vạch ngăn cách
      ),
      Text(timeString,
          style: defaultText12Re.copyWith(
            color: Colors.white.withValues(alpha: 0.8),
          )),
    ],
  );
}

class SmoothHorizontalMenu extends StatefulWidget {
  const SmoothHorizontalMenu({super.key});

  @override
  State<SmoothHorizontalMenu> createState() => _SmoothHorizontalMenuState();
}

class _SmoothHorizontalMenuState extends State<SmoothHorizontalMenu> {
  final ScrollController _scrollController = ScrollController();
  double _currentPage = 0;
  int pageCount = 0;
  final List<Map<String, dynamic>> menuItems = [
    {
      "icon": 'assets/images/lich_day.png',
      "title": "Lịch dạy",
      'screen': TeacherCalender(),
    },
    {
      "icon": 'assets/images/lich_thi.png',
      "title": "Điểm danh",
      'screen': ListClassScreen(
        type: 'Điểm danh',
      ),
    },
    {
      "icon": 'assets/images/hoc_lieu.png',
      "title": "Tài liệu",
      'screen': ListClassScreen(
        type: 'Tài liệu',
      ),
    },
    {
      "icon": 'assets/images/nhan_xet.png',
      "title": "Nhận xét",
      'screen': ListClassScreen(
        type: 'Nhận xét',
      ),
    },
    {
      "icon": 'assets/images/bao_cao.png',
      "title": "Báo cáo",
      'screen': BaoCaoScreen(),
    },
    {
      "icon": 'assets/images/phan_hoi.png',
      "title": "Phản hồi",
      'screen': FeedbackUserScreen(),
    },
    // {
    //   "icon": 'assets/images/chung_nhan.png',
    //   "title": "Chứng nhận",
    //   'screen': DiemDanhScreen(),
    // },
  ];

  @override
  void initState() {
    super.initState();
    pageCount = (menuItems.length / 4).ceil();
    _scrollController.addListener(() {
      final maxScroll = _scrollController.position.maxScrollExtent;
      final progress = (_scrollController.offset / maxScroll).clamp(0.0, 1.0);

      setState(() {
        _currentPage = progress * (pageCount - 1);
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        SizedBox(
          height: 90.h,
          width: 343.w,
          child: ListView.builder(
            controller: _scrollController,
            scrollDirection: Axis.horizontal,
            itemCount: menuItems.length,
            itemBuilder: (context, index) {
              final item = menuItems[index];
              return SizedBox(
                width: 90.w,
                child: GestureDetector(
                  onTap: () async {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => item['screen'],
                      ),
                    );
                  },
                  child: _homeIcon(
                    title: item['title']!,
                    image: item['icon']!,
                  ),
                ),
              );
            },
          ),
        ),
        const SizedBox(height: 8),
        // Indicator dạng liền mạch
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 150.w),
          child: LayoutBuilder(
            builder: (context, constraints) {
              double indicatorWidth = constraints.maxWidth / pageCount;
              return Stack(
                children: [
                  // Thanh nền
                  Container(
                    height: 6,
                    decoration: BoxDecoration(
                      color: Colors.grey[300],
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  // Thanh chạy
                  AnimatedContainer(
                    duration: const Duration(milliseconds: 100),
                    margin: EdgeInsets.only(
                      left: indicatorWidth * _currentPage,
                    ),
                    height: 6,
                    width: indicatorWidth,
                    decoration: BoxDecoration(
                      color: mainOrange,
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ],
              );
            },
          ),
        ),
      ],
    );
  }
}

Widget feedbackItem(bool value, String title) {
  return Container(
    height: 34.h,
    //width: 98.w,
    padding: EdgeInsets.symmetric(horizontal: 8.w),

    decoration: BoxDecoration(
      color: value ? Colors.white : mainOrange.withValues(alpha: 0.04),
      border: Border.all(
        color: value ? mainOrange : mainOrange.withValues(alpha: 0.04),
        width: 1.w,
      ),
      borderRadius: BorderRadius.all(
        Radius.circular(12.r),
      ),
    ),
    child: Center(
        child: Text(title,
            style: defaultText14M.copyWith(
              fontWeight: value ? FontWeight.bold : FontWeight.w500,
              fontSize: 14.sp,
              color: mainOrange,
            ))),
  );
}
