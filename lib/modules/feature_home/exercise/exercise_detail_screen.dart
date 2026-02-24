import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:kiddo/modules/feature_home/exercise/test_detail_screen.dart';
import 'package:kiddo/student_models/excercise_model.dart';
import 'package:kiddo/student_models/home_model.dart';
import 'package:kiddo/student_repo/home_repo.dart';
import 'package:kiddo/utils/constants/color.dart';
import 'package:kiddo/utils/constants/styles.dart';

class TestScreen extends StatelessWidget {
  const TestScreen({
    super.key,
    required this.excerciseModel,
  });
  final DetailExcerciseModel excerciseModel;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.white),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Text(
          'Chi tiết bài tập',
          style: defaultText18B.copyWith(
            color: Colors.white,
          ),
        ),
        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: mainGradient,
          ),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: excerciseModel.detail.length,
                padding: EdgeInsets.symmetric(
                  horizontal: 20.w,
                ),
                itemBuilder: (context, index) {
                  return _InfoTest(
                    model: excerciseModel.detail[index],
                    timeDeadline: excerciseModel.valueModel.timeDeadline,
                    customerCourseScheduleId:
                        excerciseModel.valueModel.customerCourseScheduleId,
                  );
                },
              ),
              // _InfoTest(
              //   isComplete: true,
              //   model: excerciseModel,
              // ),
              SizedBox(
                height: 16.h,
              ),
              Text(
                'Báo cáo kết quả',
                style: defaultText18B.copyWith(
                  decoration: TextDecoration.underline,
                ),
              ),
              //_resultTest(),
              SizedBox(
                height: 16.h,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _InfoTest extends StatelessWidget {
  const _InfoTest({
    required this.model,
    required this.timeDeadline,
    required this.customerCourseScheduleId,
  });

  final String timeDeadline;
  final DeDetailModel model;
  final String customerCourseScheduleId;
  @override
  Widget build(BuildContext context) {
    return Container(
      width: 350.w,
      height: 225.h,
      margin: EdgeInsets.only(
        top: 16.h,
      ),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.all(
          Radius.circular(8.r),
        ),
        boxShadow: [
          BoxShadow(
            color: mainBlue.withValues(alpha: 0.1),
            spreadRadius: 5,
            blurRadius: 7,
            offset: const Offset(4, 5), // changes position of shadow
          ),
        ],
      ),
      child: GestureDetector(
        onTap: () async {
          //comment qua dot review apple
        },
        child: Stack(
          children: [
            // Positioned(
            //   right: 12.w,
            //   top: 12.h,
            //   child: Container(
            //     height: 63.h,
            //     width: 63.w,
            //     decoration: BoxDecoration(
            //         color: Colors.white,
            //         shape: BoxShape.circle,
            //         boxShadow: [
            //           BoxShadow(
            //             color: Colors.grey.shade100,
            //             spreadRadius: 5,
            //             blurRadius: 7,
            //             offset: const Offset(4, 5),
            //           )
            //         ]),
            //     child: Center(
            //       child: Text(
            //         '--.--',
            //         style: defaultText18B.copyWith(color: mainOrange),
            //       ),
            //     ),
            //   ),
            // ),
            Positioned(
              top: 10.h,
              left: 10.w,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    height: 10.h,
                  ),
                  SizedBox(
                    width: 253.w,
                    child: Text(
                      model.name,
                      style: defaultText18B,
                      overflow: TextOverflow.ellipsis,
                      maxLines: 2,
                    ),
                  ),
                  SizedBox(
                    height: 8.h,
                  ),
                  Text(
                    'Thời lượng: ${model.totalQuestions} Câu',
                    style: defaultText12Re,
                    overflow: TextOverflow.ellipsis,
                    maxLines: 2,
                  ),
                  SizedBox(
                    height: 2.h,
                  ),
                  Text(
                    'Ngày giao: ${model.createAt}',
                    style: defaultText12Re,
                    overflow: TextOverflow.ellipsis,
                    maxLines: 2,
                  ),
                  SizedBox(
                    height: 8.h,
                  ),
                  if (timeDeadline.contains('0000'))
                    Text(
                      'Hạn hoàn thành: Không giới hạn',
                      style: defaultText12B,
                      overflow: TextOverflow.ellipsis,
                      maxLines: 2,
                    )
                  else
                    Text(
                      'Hạn hoàn thành: $timeDeadline',
                      style: defaultText12B,
                      overflow: TextOverflow.ellipsis,
                      maxLines: 2,
                    ),
                  Text(
                    'Điểm : ${model.finalMark}',
                    style: defaultText12B,
                    overflow: TextOverflow.ellipsis,
                    maxLines: 2,
                  ),
                  Container(
                    margin: EdgeInsets.symmetric(vertical: 6.h),
                    height: 1.h,
                    width: 300.w,
                    decoration: const BoxDecoration(
                      color: Colors.grey,
                    ),
                  ),
                  SizedBox(
                    height: 20.h,
                  ),
                  model.ccseeId.isNotEmpty
                      ? Container(
                          width: 326.w,
                          height: 51.h,
                          decoration: BoxDecoration(
                            color: const Color(0xffDEE4ED),
                            borderRadius:
                                BorderRadius.all(Radius.circular(10.r)),
                          ),
                          child: Center(
                              child: Text('Đã hoàn thành',
                                  style: defaultText20B.copyWith(
                                      color: Colors.white))),
                        )
                      : GestureDetector(
                          onTap: () async {
                            List<QuestionGroupModel> detailExcerciseModel =
                                await HomeRepo().viewTracNghiem(
                              id: model.id,
                              customerCourseScheduleId:
                                  customerCourseScheduleId,
                              examDetailId: model.examDetailId,
                            );
                            if (!context.mounted) return;
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (context) => TestDetailScreen(
                                  listQuestion: detailExcerciseModel,
                                  title: model.name,
                                  id: model.id,
                                  customerCourseScheduleId:
                                      customerCourseScheduleId,
                                  examDetailId: model.examDetailId,
                                ),
                              ),
                            );
                          },
                          child: Container(
                            width: 326.w,
                            height: 51.h,
                            decoration: BoxDecoration(
                              gradient: mainGradient,
                              borderRadius:
                                  BorderRadius.all(Radius.circular(10.r)),
                            ),
                            child: Center(
                              child: Text(
                                'Làm bài',
                                style: defaultText20B.copyWith(
                                    color: Colors.white),
                              ),
                            ),
                          ),
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
