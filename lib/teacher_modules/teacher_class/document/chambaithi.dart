import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:kiddo/teacher_model/teacher_class_model.dart';
import 'package:kiddo/utils/constants/styles.dart';
import 'package:url_launcher/url_launcher.dart';

class BaiThiScreen extends StatefulWidget {
  const BaiThiScreen({super.key, required this.examModel, required this.slug});
  final StudentExamModel? examModel;
  final String? slug;
  @override
  State<BaiThiScreen> createState() => _BaiThiScreenState();
}

class _BaiThiScreenState extends State<BaiThiScreen> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: const Color(0xff00AEEF),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, color: Colors.white),
          onPressed: () {
            Navigator.of(context).pop(false);
          },
        ),
        title: Text(
          '    Chấm điểm bài tập',
          style: defaultText18B.copyWith(
            color: Colors.white,
          ),
        ),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: double.infinity,
            height: 20.h,
            color: const Color(0xff00AEEF),
            child: Container(
              width: double.infinity,
              height: 20.h,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.vertical(top: Radius.circular(20.r)),
                color: Colors.white,
              ),
            ),
          ),
          ListView.builder(
              shrinkWrap: true,
              physics: const ClampingScrollPhysics(),
              itemCount: widget.examModel?.examData.length ?? 0,
              itemBuilder: (BuildContext context, int index) {
                return _StudentItem(
                    slug: widget.slug,
                    examModel: widget.examModel!.examData[index]);
              })
        ],
      ),
    );
  }
}

class _StudentItem extends StatelessWidget {
  const _StudentItem({required this.examModel, this.slug});
  final String? slug;
  final ExamDataModel examModel;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () async {
        if (!await launchUrl(Uri.parse(
            'https://lms.kiddoenglish.edu.vn/exercise/result/$slug-${examModel.ccseeId}'))) {
          throw Exception('Could not launch ');
        }
      },
      child: Container(
        margin: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
        padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 10.h),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.all(
              Radius.circular(12.r),
            ),
            color: const Color(0xffF5F7FA)),
        child: Row(
          children: [
            Image.asset(
              'assets/images/document.png',
              width: 28.w,
              height: 28.h,
            ),
            SizedBox(
              width: 8.w,
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  examModel.name,
                  style: defaultText16M,
                ),
                Text(
                  'Kỹ năng :  ${skills[examModel.skills]}',
                  style: defaultText16M,
                ),
                Text(
                  'Điểm : ${examModel.finalMark}',
                  style: defaultText16M,
                ),
              ],
            ),
            const Spacer(),
          ],
        ),
      ),
    );
  }
}

Map<String, String> skills = {
  '1': "Listening ",
  '2': "Reading",
  '3': "Writing",
  '4': "Speaking",
};
