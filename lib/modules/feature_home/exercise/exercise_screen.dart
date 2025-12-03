import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:kiddo/modules/feature_home/exercise/detail_exam_screen.dart';
import 'package:kiddo/modules/feature_home/exercise/exercise_detail_screen.dart';
import 'package:kiddo/student_repo/home_repo.dart';
import 'package:kiddo/student_models/home_model.dart';
import 'package:kiddo/utils/constants/color.dart';
import 'package:kiddo/utils/constants/styles.dart';
import 'package:kiddo/utils/widget/custom_widget.dart';

class ExerciseScreen extends StatelessWidget {
  const ExerciseScreen({super.key, required this.model});
  final ListExcerciseModel model;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(
              height: 150.h,
              width: 390.w,
              child: Stack(
                children: [
                  Positioned(
                    top: 0,
                    child: Container(
                      width: 390.w,
                      height: 130.h,
                      decoration: BoxDecoration(gradient: mainGradient),
                    ),
                  ),
                  Positioned(
                    bottom: 30.h,
                    left: 20.w,
                    child: GestureDetector(
                      onTap: () {
                        Navigator.pop(context);
                      },
                      child: Row(
                        children: [
                          Icon(
                            Icons.keyboard_arrow_left,
                            size: 30.h,
                            color: Colors.white,
                          ),
                          Text(
                            'Bài tập',
                            style: defaultText20B.copyWith(
                              color: Colors.white,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Positioned(
                    bottom: 0,
                    right: 0,
                    child: Image.asset(
                      'assets/images/bai_tap.png',
                      width: 125.w,
                      height: 125.h,
                      fit: BoxFit.fill,
                    ),
                  )
                ],
              ),
            ),
            SizedBox(
              width: 350.w,
              child: Text(
                'Thống kê',
                style: defaultText16B,
                textAlign: TextAlign.left,
              ),
            ),
            Row(
              children: [
                SizedBox(
                  height: 90.h,
                  width: 130.w,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Đúng hạn',
                            style: defaultText14B.copyWith(color: mainOrange),
                          ),
                          Text(
                            '${model.dungHan}/${model.tongbai}',
                            style: defaultText14B.copyWith(color: mainOrange),
                          ),
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Quá hạn',
                            style: defaultText14B.copyWith(color: mainRed),
                          ),
                          Text(
                            '${model.quaHan}/${model.tongbai}',
                            style: defaultText14B.copyWith(color: mainRed),
                          ),
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Chưa làm',
                            style: defaultText14B.copyWith(
                              color: mainBlue.withOpacity(0.5),
                            ),
                          ),
                          Text(
                            '${model.chuaLam}/${model.tongbai}',
                            style: defaultText14B.copyWith(
                              color: mainBlue.withOpacity(0.5),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  width: 20.w,
                ),
              ],
            ),
            SizedBox(
              width: 350.w,
              child: Text(
                'Sắp đến hạn',
                style: defaultText16B,
                textAlign: TextAlign.left,
              ),
            ),
            SizedBox(
              height: 5.h,
            ),
            SizedBox(
              width: 375.w,
              height: 70.h,
              child:
                  // model.sapDenHan.isNotEmpty
                  //     ? ListView.builder(
                  //         shrinkWrap: true,
                  //         physics: const ClampingScrollPhysics(),
                  //         scrollDirection: Axis.horizontal,
                  //         itemCount: model.sapDenHan.length,
                  //         itemBuilder: (BuildContext context, int index) {
                  //           return GestureDetector(
                  //             onTap: () {
                  //               Navigator.of(context).push(
                  //                 MaterialPageRoute(
                  //                   builder: (context) => const TestScreen(),
                  //                 ),
                  //               );
                  //             },
                  //             child: const _ExcerciseItem(
                  //               isComplete: false,
                  //             ),
                  //           );
                  //         })
                  //     :
                  Center(
                child: Text(
                  'Không có bài tập sắp đến hạn',
                  style: defaultText14M,
                ),
              ),
            ),
            SizedBox(
              height: 10.h,
            ),
            SizedBox(
              height: 450.h,
              width: 390.w,
              child: _ExcerciseTabBar(model.value),
            ),
          ],
        ),
      ),
    );
  }
}

class _ExcerciseTabBar extends StatefulWidget {
  const _ExcerciseTabBar(this.listModel);
  final List<ExcerciseValueModel> listModel;
  @override
  State<_ExcerciseTabBar> createState() => _ExcerciseTabBarState();
}

class _ExcerciseTabBarState extends State<_ExcerciseTabBar>
    with TickerProviderStateMixin {
  late final TabController _tabController;
  late final List<ExcerciseValueModel> listTotal;
  late final List<ExcerciseValueModel> listChuaLam;
  late final List<ExcerciseValueModel> listHoanThanh;
  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    listTotal = widget.listModel;
    listChuaLam = widget.listModel.where((e) => e.status == 0).toList();
    listHoanThanh = widget.listModel.where((e) => e.status == 1).toList();
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        TabBar.secondary(
          tabAlignment: TabAlignment.start,
          padding: EdgeInsets.zero,
          indicatorPadding: EdgeInsets.zero,
          labelPadding: EdgeInsets.symmetric(horizontal: 10.w),
          isScrollable: true,
          indicatorColor: colorText,
          indicatorSize: TabBarIndicatorSize.label,
          indicator: UnderlineTabIndicator(
            borderSide: BorderSide(width: 2.w), //hight of indicator
            insets: EdgeInsets.symmetric(
                horizontal:
                    20.w), //give some padding to reduce the size of indicator
          ),
          unselectedLabelColor: colorText.withValues(alpha: 0.3),
          labelStyle: defaultText14M,
          labelColor: colorText,
          controller: _tabController,
          tabs: <Widget>[
            homeTab(
                title: 'Toàn bộ', number: listTotal.length, isSeprator: false),
            homeTab(title: 'Chưa làm', number: listChuaLam.length),
            homeTab(title: 'Hoàn thành', number: listHoanThanh.length),
          ],
        ),
        Expanded(
          child: TabBarView(
            controller: _tabController,
            children: <Widget>[
              ListView.builder(
                  shrinkWrap: true,
                  physics: const ClampingScrollPhysics(),
                  itemCount: listTotal.length,
                  itemBuilder: (BuildContext context, int index) {
                    return _ExcerciseItem(
                      isComplete: true,
                      model: listTotal[index],
                    );
                  }),
              ListView.builder(
                  shrinkWrap: true,
                  physics: const ClampingScrollPhysics(),
                  itemCount: listChuaLam.length,
                  itemBuilder: (BuildContext context, int index) {
                    return _ExcerciseItem(
                      isComplete: false,
                      model: listChuaLam[index],
                    );
                  }),
              ListView.builder(
                  shrinkWrap: true,
                  physics: const ClampingScrollPhysics(),
                  itemCount: listHoanThanh.length,
                  itemBuilder: (BuildContext context, int index) {
                    return _ExcerciseItem(
                      isComplete: false,
                      model: listHoanThanh[index],
                    );
                  }),
            ],
          ),
        ),
      ],
    );
  }
}

class _ExcerciseItem extends StatelessWidget {
  const _ExcerciseItem({required this.isComplete, required this.model});
  final ExcerciseValueModel model;
  final bool isComplete;
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () async {
        DetailExcerciseModel detailExcerciseModel =
            await HomeRepo().getDetailExsercise(
          id: model.id,
          customerCourseScheduleId: model.customerCourseScheduleId,
        );
        if (model.type == '1') {
          Navigator.of(context).push(MaterialPageRoute(
            builder: (context) => TestScreen(
              excerciseModel: detailExcerciseModel,
            ),
          ));
        } else {
          Navigator.of(context).push(MaterialPageRoute(
            builder: (context) => DetailTuLuanScreen(
              documentModel: detailExcerciseModel.document,
              valueModel: detailExcerciseModel.valueModel,
            ),
          ));
        }
      },
      child: Container(
        //height: 66.h,
        width: 350.w,
        margin:
            EdgeInsets.only(bottom: 10.h, right: 10.w, left: 10.w, top: 10.h),
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.2),
              spreadRadius: 5,
              blurRadius: 7,
              offset: const Offset(0, 1), // changes position of shadow
            ),
          ],
          borderRadius: BorderRadius.circular(10),
        ),
        child: Row(
          children: [
            SizedBox(
              width: 10.w,
            ),
            Container(
              height: 45.h,
              width: 45.w,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: isComplete ? mainGradient2 : mainGradient4,
              ),
              child: SvgPicture.asset(
                'assets/icons/excercise.svg',
                height: 18.h,
                width: 18.w,
                fit: BoxFit.scaleDown,
              ),
            ),
            SizedBox(
              width: 15.w,
            ),
            SizedBox(
              height: 70.h,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Text(
                    model.name,
                    style: defaultText16B,
                  ),
                  Text(
                    model.typeName,
                    style: defaultText14Re,
                    overflow: TextOverflow.ellipsis,
                    maxLines: 2,
                  ),
                  if (model.note == '')
                    Text(
                      model.timeDeadline,
                      style: defaultText14Re,
                      overflow: TextOverflow.ellipsis,
                      maxLines: 2,
                    )
                  else
                    Text(
                      model.note,
                      style: defaultText14Re,
                      overflow: TextOverflow.ellipsis,
                      maxLines: 2,
                    ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
