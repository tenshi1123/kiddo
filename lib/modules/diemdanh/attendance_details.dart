import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:kiddo/l10n/l10n.dart';
import 'package:kiddo/student_models/diem_danh_model.dart';
import 'package:kiddo/utils/constants/color.dart';
import 'package:kiddo/utils/constants/styles.dart';
import 'package:kiddo/utils/widget/custom_widget.dart';

class AttendanceDetails extends StatelessWidget {
  const AttendanceDetails({super.key, required this.infoModel});
  final InfoDiemDanh infoModel;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      // appBar: AppBar(
      //   backgroundColor: Colors.blue,
      //   leading: IconButton(
      //     icon: const Icon(Icons.arrow_back, color: Colors.white),
      //     onPressed: () => Navigator.of(context).pop(),
      //   ),
      //   title: Text('Chi tiết điểm danh',
      //       textAlign: TextAlign.right,
      //       style: defaultText20B.copyWith(color: Colors.white)),
      // ),
      body: SafeArea(
        child: SingleChildScrollView(
          physics: const NeverScrollableScrollPhysics(),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                height: 50.h,
                width: 390.w,
                decoration: BoxDecoration(gradient: mainGradient),
                child: Row(
                  children: [
                    IconButton(
                      icon: const Icon(Icons.arrow_back, color: Colors.white),
                      onPressed: () => Navigator.of(context).pop(),
                    ),
                    SizedBox(
                      width: 6.w,
                    ),
                    Text('Chi tiết điểm danh',
                        textAlign: TextAlign.right,
                        style: defaultText20B.copyWith(color: Colors.white)),

                    //SvgPicture.asset('assets/icons/three_dots_icon.svg'),
                  ],
                ),
              ),
              Padding(
                padding: EdgeInsets.only(left: 20.w, top: 20.h),
                child: Text(
                  infoModel.name,
                  style: defaultText16B,
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
                              L10n.of(context).lophoc,
                              style: defaultText12Re,
                            ),
                            Text(
                              infoModel.type,
                              style: defaultText12B,
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    width: 20.w,
                  ),
                  SizedBox(
                    height: 90.h,
                    width: 100.w,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              L10n.of(context).join,
                              style: defaultText14Re,
                            ),
                            Container(
                              //height: 17.h,
                              width: 24.w,
                              decoration: BoxDecoration(
                                gradient: mainGradient,
                              ),
                              child: Center(
                                child: Text(
                                  infoModel.cntDaDienRa.toString(),
                                  style: defaultText14B.copyWith(
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              L10n.of(context).notYetStudied,
                              style: defaultText14Re,
                            ),
                            Container(
                              //height: 17.h,
                              width: 24.w,
                              decoration: BoxDecoration(
                                color: mainBlue.withValues(alpha: 0.3),
                              ),
                              child: Center(
                                child: Text(
                                  infoModel.cntChuaDienRa.toString(),
                                  style: defaultText14B.copyWith(
                                      color: Colors.white),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              _TabSection(infoModel),
            ],
          ),
        ),
      ),
    );
  }
}

class _TabSection extends StatelessWidget {
  const _TabSection(this.infoModel);
  final InfoDiemDanh infoModel;
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          TabBar(
              unselectedLabelColor: colorText.withValues(alpha: 0.3),
              labelColor: mainOrange,
              labelStyle: defaultText14B,
              indicatorColor: mainOrange,
              //indicatorSize: TabBarIndicatorSize(),
              tabs: [
                homeTab(
                  title: "Đã qua",
                  isSeprator: false,
                  number: infoModel.daqua.length,
                ),
                homeTab(
                  title: "Sắp tới",
                  number: infoModel.saptoi.length,
                ),
              ]),
          SizedBox(
            //Add this to give height
            height: MediaQuery.of(context).size.height * 0.8,
            child: TabBarView(children: [
              ListView.builder(
                  shrinkWrap: true,
                  physics: const ClampingScrollPhysics(),
                  itemCount: infoModel.daqua.length,
                  itemBuilder: (BuildContext context, int index) {
                    return CaseStudy(
                      index: index,
                      isCompleted: true,
                      detailModel: infoModel.daqua[index],
                    );
                  }),
              ListView.builder(
                  shrinkWrap: true,
                  physics: const ClampingScrollPhysics(),
                  itemCount: infoModel.saptoi.length,
                  itemBuilder: (BuildContext context, int index) {
                    return CaseStudy(
                      index: index,
                      isCompleted: false,
                      detailModel: infoModel.saptoi[index],
                    );
                  }),
            ]),
          ),
        ],
      ),
    );
  }
}

class CaseStudy extends StatelessWidget {
  const CaseStudy({
    super.key,
    required this.index,
    required this.isCompleted,
    required this.detailModel,
  });
  final int index;
  final bool isCompleted;
  final DetailDiemDanh detailModel;
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 90.h,
      width: 390.w,
      child: Column(
        children: [
          SizedBox(
            height: 10.h,
          ),
          Row(
            children: [
              SizedBox(width: 20.w),
              SizedBox(
                height: 60.h,
                width: 90.w,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      detailModel.day,
                      style: defaultText14B,
                    ),
                    const Spacer(),
                    Text(
                      'Ca học',
                      style: defaultText14Re,
                    ),
                    Text(
                      'Giảng viên',
                      style: defaultText14Re,
                    ),
                  ],
                ),
              ),
              SizedBox(width: 10.w),
              const Spacer(),
              Image.asset(
                (detailModel.gvStatus == '3')
                    ? 'assets/images/complete.png'
                    : (detailModel.gvStatus == '0')
                        ? 'assets/images/miss.png'
                        : 'assets/images/iscomming.png',
                width: 36.w,
                height: 36.h,
                fit: BoxFit.fill,
              ),
              SizedBox(
                width: 20.w,
              )
            ],
          ),
          SizedBox(
            height: 10.h,
          ),
          Divider(
            thickness: 1,
            indent: 15.w,
            endIndent: 15.w,
            height: 1,
            color: Colors.black.withOpacity(0.5),
          ),
        ],
      ),
    );
  }
}
