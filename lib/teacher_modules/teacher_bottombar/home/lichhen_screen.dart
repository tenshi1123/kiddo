import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import 'package:kiddo/teacher_model/home_teacher_model.dart';
import 'package:kiddo/utils/constants/styles.dart';
import '../../../utils/widget/custom_widget.dart';

class LichHenScreen extends StatefulWidget {
  const LichHenScreen({super.key, required this.listLichHen});
  final List<LichHenModel> listLichHen;
  @override
  State<LichHenScreen> createState() => _LichHenScreenState();
}

class _LichHenScreenState extends State<LichHenScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  int activeTabIndex = 0;
  @override
  void initState() {
    super.initState();
    _tabController = TabController(
      length: 2,
      vsync: this,
      initialIndex: 0,
    );
    _tabController.addListener(() {
      setState(() {
        activeTabIndex = _tabController.index;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xff00AEEF),
      appBar: AppBar(
        backgroundColor: const Color(0xff00AEEF),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, color: Colors.white),
          onPressed: () {
            Navigator.of(context).pop(false);
          },
        ),
        title: Text(
          '    Danh sách lịch hẹn học viên',
          style: defaultText18B.copyWith(
            color: Colors.white,
          ),
        ),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Container(
              width: MediaQuery.of(context).size.width,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(32.r),
                  topRight: Radius.circular(32.r),
                ),
              ),
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      height: 16.h,
                    ),
                    widget.listLichHen.isNotEmpty
                        ? ListView.builder(
                            shrinkWrap: true,
                            physics: const ClampingScrollPhysics(),
                            itemCount: widget.listLichHen.length,
                            itemBuilder: (BuildContext context, int index) {
                              return _ItemLichHen(model: widget.listLichHen[0]);
                            })
                        : Center(
                            child: Image.asset(
                              'assets/images/empty2.png',
                              scale: 2,
                            ),
                          ),

                    SizedBox(
                      height: 16.h,
                    ),
                    // GestureDetector(
                    //   onTap: () {
                    //     showDialog<String>(
                    //         context: context,
                    //         builder: (BuildContext context) =>
                    //             const InfoLichhen(
                    //               type: '1',
                    //             ));
                    //   },
                    //   child: Container(
                    //     padding: EdgeInsets.symmetric(
                    //       horizontal: 16.w,
                    //       vertical: 12.h,
                    //     ),
                    //     margin: EdgeInsets.symmetric(horizontal: 16.w),
                    //     decoration: BoxDecoration(
                    //       borderRadius: BorderRadius.all(
                    //         Radius.circular(12.r),
                    //       ),
                    //       color: const Color(0xffF5F7FA),
                    //     ),
                    //     child: Row(
                    //       children: [
                    //         Image.asset(
                    //           'assets/images/little_avatar.png',
                    //           width: 40.w,
                    //           height: 40.h,
                    //         ),
                    //         SizedBox(
                    //           width: 8.w,
                    //         ),
                    //         Column(
                    //           crossAxisAlignment: CrossAxisAlignment.start,
                    //           children: [
                    //             Text(
                    //               'Nguyễn Lâm Anh',
                    //               style: defaultText16M.copyWith(
                    //                 color: Colors.black,
                    //               ),
                    //             ),
                    //             Text(
                    //               '17:30 - 28/10/2024',
                    //               style: defaultText14Re.copyWith(
                    //                 color: const Color(
                    //                   0xff09204E,
                    //                 ),
                    //               ),
                    //             )
                    //           ],
                    //         ),
                    //       ],
                    //     ),
                    //   ),
                    // ),
                    // Padding(
                    //   padding: EdgeInsets.only(left: 16.w, top: 16.h),
                    //   child: Text(
                    //     'Thứ hai - 27/10/2022',
                    //     style: defaultText16B.copyWith(
                    //       color: const Color(0xff09204E),
                    //     ),
                    //   ),
                    // ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _ItemLichHen extends StatelessWidget {
  const _ItemLichHen({required this.model});
  final LichHenModel model;
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        showDialog<String>(
            context: context,
            builder: (BuildContext context) => InfoLichhen(
                  model: model,
                ));
      },
      child: Container(
        padding: EdgeInsets.symmetric(
          horizontal: 16.w,
          vertical: 12.h,
        ),
        margin: EdgeInsets.symmetric(horizontal: 16.w),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.all(
            Radius.circular(12.r),
          ),
          color: const Color(0xffF5F7FA),
        ),
        child: Row(
          children: [
            Image.asset(
              'assets/images/little_avatar.png',
              width: 40.w,
              height: 40.h,
            ),
            SizedBox(
              width: 8.w,
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  model.fullName,
                  style: defaultText16M.copyWith(
                    color: Colors.black,
                  ),
                ),
                Text(
                  DateFormat("HH:mm - dd/MMyyyy").format(model.appointmentDate),
                  style: defaultText14Re.copyWith(
                    color: const Color(
                      0xff09204E,
                    ),
                  ),
                )
              ],
            ),
          ],
        ),
      ),
    );
  }
}
