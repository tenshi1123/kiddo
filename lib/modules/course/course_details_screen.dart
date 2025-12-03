import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:kiddo/modules/course/lich_hoc.dart';
import 'package:kiddo/modules/course/reportage.dart';
import 'package:kiddo/student_models/my_course_model.dart';
import 'package:kiddo/utils/constants/color.dart';
import 'package:kiddo/utils/constants/styles.dart';

import 'excercise_screen.dart';

class CourseDetails extends StatefulWidget {
  const CourseDetails(
      {super.key,
      required this.detailMyCourse,
      required this.detailBaoCao,
      required this.baiTapModel});
  final DetailMyCourse detailMyCourse;
  final MycourseBaiTapModel baiTapModel;
  final DetailBaoCaoModel detailBaoCao;
  @override
  State<CourseDetails> createState() => _CourseDetailsState();
}

class _CourseDetailsState extends State<CourseDetails>
    with TickerProviderStateMixin {
  late TabController _tabController;
  late final DetailMyCourse model;
  final _tabs = [
    const Tab(text: 'Lịch học'),
    const Tab(text: 'Bài tập'),
    const Tab(text: 'Báo cáo'),
  ];
  @override
  void initState() {
    _tabController = TabController(length: 3, vsync: this);
    model = widget.detailMyCourse;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        children: [
          SizedBox(
            height: 180.h,
            child: Stack(
              children: [
                Positioned(
                  top: 0,
                  child: Container(
                    width: 390.w,
                    height: 140.h,
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        image: NetworkImage(
                          'https://lms.kiddoenglish.edu.vn/images/${model.img}',
                        ),
                        fit: BoxFit.cover,
                        colorFilter: ColorFilter.mode(
                          Colors.black.withValues(alpha: 0.5),
                          BlendMode.darken,
                        ),
                      ),
                    ),
                  ),
                ),
                Positioned(
                  top: 110.h,
                  left: 20.h,
                  child: Container(
                    width: 350.w,
                    height: 66.h,
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(12.0),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withValues(alpha: 0.2),
                            spreadRadius: 5,
                            blurRadius: 7,
                            offset: const Offset(
                                0, 2), // changes position of shadow
                          ),
                        ]),
                    child: TabBar(
                      controller: _tabController,
                      dividerColor: Colors.transparent,
                      indicatorSize: TabBarIndicatorSize.tab,
                      indicator: BoxDecoration(
                          borderRadius: BorderRadius.circular(8.0),
                          gradient: mainGradient2),
                      labelStyle: defaultText14M,
                      labelColor: Colors.white,
                      unselectedLabelColor: Colors.black,
                      tabs: _tabs,
                    ),
                  ),
                ),
                Positioned(
                  bottom: 70.h,
                  left: 22.w,
                  child: Row(
                    children: [
                      IconButton(
                        icon: const Icon(
                          Icons.arrow_back_ios,
                          color: Colors.white,
                        ),
                        onPressed: () => Navigator.of(context).pop(),
                      ),
                      SizedBox(
                        width: 50.w,
                      ),
                      Text(
                        model.name,
                        style: defaultText20B.copyWith(
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                LichHocScreen(
                  model: model,
                ),
                ExcerciseScreen(
                  baiTapModel: widget.baiTapModel,
                ),
                ReportageScreen(
                  detailBaoCao: widget.detailBaoCao,
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
