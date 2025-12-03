import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import 'package:kiddo/modules/lesson/detail_lesson_screen.dart';
import 'package:kiddo/student_models/my_course_model.dart';
import 'package:kiddo/utils/constants/color.dart';
import 'package:kiddo/utils/constants/styles.dart';
import 'package:kiddo/utils/widget/custom_widget.dart';

class LichHocScreen extends StatelessWidget {
  const LichHocScreen({super.key, required this.model});
  final DetailMyCourse model;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 10.h),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Lịch học gần nhất',
              style: defaultText16B,
            ),
            model.saptoi.isEmpty
                ? Padding(
                    padding: EdgeInsets.only(top: 20.h, bottom: 20.h),
                    child: Center(
                      child: Text(
                        'Chưa có lịch học',
                        style: defaultText16M,
                      ),
                    ),
                  )
                : _ClassItem(
                    model: model.saptoi[0],
                    type: 1,
                  ),
            Text(
              'Thời khóa biểu',
              style: defaultText16B,
            ),
            SizedBox(
                height: 600.h,
                width: 390.w,
                child: LichhocTabBar(
                  model: model,
                )),
          ],
        ),
      ),
    );
  }
}

class LichhocTabBar extends StatefulWidget {
  const LichhocTabBar({
    super.key,
    required this.model,
  });
  final DetailMyCourse model;
  @override
  State<LichhocTabBar> createState() => _LichhocTabBarState();
}

class _LichhocTabBarState extends State<LichhocTabBar>
    with TickerProviderStateMixin {
  late final TabController _tabController;
  late final DetailMyCourse _detailMyCourse;
  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _detailMyCourse = widget.model;
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
          indicatorColor: mainBlack,
          indicatorSize: TabBarIndicatorSize.label,
          indicator: UnderlineTabIndicator(
            borderSide: BorderSide(width: 2.w), //hight of indicator
            insets: EdgeInsets.symmetric(
                horizontal:
                    20.w), //give some padding to reduce the size of indicator
          ),
          unselectedLabelColor: mainBlack.withValues(alpha: 0.3),
          labelColor: mainBlack,
          controller: _tabController,
          tabs: <Widget>[
            homeTab(
              title: 'Sắp tới',
              isSeprator: false,
              hasNumber: false,
            ),
            homeTab(title: 'Đã tham gia', hasNumber: false),
          ],
        ),
        Expanded(
          child: TabBarView(
            controller: _tabController,
            children: <Widget>[
              ListView.builder(
                  shrinkWrap: true,
                  physics: const ClampingScrollPhysics(),
                  itemCount: _detailMyCourse.saptoi.length,
                  itemBuilder: (BuildContext context, int index) {
                    return _ClassItem(
                      model: _detailMyCourse.saptoi[index],
                      type: 1,
                    );
                  }),
              ListView.builder(
                  shrinkWrap: true,
                  physics: const ClampingScrollPhysics(),
                  itemCount: _detailMyCourse.daqua.length,
                  itemBuilder: (BuildContext context, int index) {
                    return _ClassItem(
                      model: _detailMyCourse.daqua[index],
                      type: 2,
                    );
                  }),
            ],
          ),
        ),
      ],
    );
  }
}

class _ClassItem extends StatelessWidget {
  const _ClassItem({required this.model, required this.type});
  final DetailCourse model;
  final int type;
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () async {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: ((context) => DetailLessonScreen(
                  typeLearn: '',
                  checkinOffId: '',
                  meetingId: '',
                )),
          ),
        );
      },
      child: Container(
        margin: EdgeInsets.symmetric(vertical: 20.h),
        //height: 222.h,
        width: 349.w,
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
                offset: const Offset(0, 2), // changes position of shadow
              ),
            ]),
        child: Column(
          //mainAxisAlignment: MainAxisAlignment.spaceAround,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              height: 10.h,
            ),
            Row(
              children: [
                SizedBox(
                  width: 10.w,
                ),
                Container(
                  height: 70.h,
                  width: 70.w,
                  decoration: BoxDecoration(
                    gradient: type == 1 ? mainGradient2 : mainGradientgray,
                    borderRadius: BorderRadius.all(
                      Radius.circular(12.r),
                    ),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        model.day.day.toString(),
                        style: defaultText20B.copyWith(
                          color: Colors.white,
                        ),
                      ),
                      SizedBox(
                        height: 2.h,
                      ),
                      Text(
                        'Tháng ${model.day.month}',
                        style: defaultText16M.copyWith(
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  width: 15.w,
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Text(
                      model.name,
                      style: defaultText16B,
                    ),
                    Text(
                      DateFormat("dd/MM/yyyy").format(model.day),
                      style: defaultText14Re,
                    ),
                    Text(
                      model.time,
                      style: defaultText14Re,
                    ),
                  ],
                )
              ],
            ),
            SizedBox(
              height: 10.h,
            ),
            Container(
              //height: 74.h,
              width: 325.w,
              margin: EdgeInsets.only(left: 12.w),
              padding: EdgeInsets.symmetric(horizontal: 20.w),
              decoration: BoxDecoration(
                color: mainOrange.withOpacity(0.1),
                borderRadius: BorderRadius.all(
                  Radius.circular(8.r),
                ),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    height: 4.h,
                  ),
                  Row(
                    children: [
                      SizedBox(
                        width: 80.w,
                        child: Text(
                          'Phòng học',
                          style: defaultText14Re,
                        ),
                      ),
                      Text(
                        model.phongHoc,
                        style: defaultText14B,
                      ),
                    ],
                  ),
                  const Divider(
                    color: Colors.white,
                    thickness: 2,
                  ),
                  Row(
                    children: [
                      SizedBox(
                        width: 80.w,
                        child: Text(
                          'Cơ sở',
                          style: defaultText14Re,
                        ),
                      ),
                      Text(
                        model.cosoName,
                        style: defaultText14B,
                      ),
                    ],
                  ),
                  const Divider(
                    color: Colors.white,
                    thickness: 2,
                  ),
                  Row(
                    children: [
                      SizedBox(
                        width: 80.w,
                        child: Text(
                          'Địa chỉ',
                          style: defaultText14Re,
                        ),
                      ),
                      SizedBox(
                        width: 200.w,
                        child: Text(
                          model.cosoAddress,
                          style: defaultText14B,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 4.h,
                  ),
                ],
              ),
            ),
            SizedBox(
              height: 10.h,
            ),
            model.ccsmslId == null
                ? Row(
                    children: [
                      SizedBox(
                        width: 32.w,
                      ),
                      SizedBox(
                        width: 80.w,
                      ),
                      type == 1
                          ? InkWell(
                              onTap: () {
                                // showDialog(
                                //   context: context,
                                //   builder: (context) => LeaveRequestDialog(

                                //     time: model.day, typeLearn: model., checkinOffId: '', meetingId: '',
                                //   ),
                                // );
                              },
                              child: Container(
                                height: 29.h,
                                width: 90.w,
                                decoration: BoxDecoration(
                                  color: mainRed,
                                  borderRadius: BorderRadius.all(
                                    Radius.circular(4.r),
                                  ),
                                ),
                                child: Center(
                                  child: Text(
                                    'Xin nghỉ',
                                    style: defaultText14B.copyWith(
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                              ),
                            )
                          : SizedBox(),
                    ],
                  )
                : RichText(
                    text: TextSpan(
                      text: 'Xin nghỉ: ',
                      style: defaultText16M,
                      children: [
                        TextSpan(
                            text: model.reason,
                            style: defaultText16B.copyWith(color: mainRed)),
                      ],
                    ),
                  ),
            SizedBox(
              height: 10.h,
            ),
          ],
        ),
      ),
    );
  }
}
