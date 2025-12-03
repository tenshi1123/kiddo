import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:kiddo/student_models/review_models.dart';
import 'package:kiddo/utils/constants/color.dart';
import 'package:kiddo/utils/constants/styles.dart';

class DetailEvaluateScreen extends StatelessWidget {
  const DetailEvaluateScreen({super.key, required this.model});
  final ReviewDetailModels model;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.keyboard_arrow_left, color: Colors.white),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Text(
          'Chi tiết đánh giá',
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
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 20.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              height: 10.h,
            ),
            Text(
              'Đánh giá định kỳ ${model.monthName}',
              style: defaultText18B,
            ),
            SizedBox(
              height: 10.h,
            ),
            Row(
              children: [
                SizedBox(
                  width: 120.w,
                  child: Text(
                    'Giảng viên',
                    style: defaultText14Re,
                  ),
                ),
                SizedBox(
                  width: 160.w,
                  child: Text(
                    model.teacherName,
                    style: defaultText14B,
                  ),
                ),
              ],
            ),
            SizedBox(
              height: 10.h,
            ),
            Row(
              children: [
                SizedBox(
                  width: 120.w,
                  child: Text(
                    'Khóa học',
                    style: defaultText14Re,
                  ),
                ),
                SizedBox(
                  width: 160.w,
                  child: Text(
                    model.courseName,
                    style: defaultText14B,
                  ),
                ),
              ],
            ),
            SizedBox(
              height: 10.h,
            ),
            Row(
              children: [
                SizedBox(
                  width: 120.w,
                  child: Text(
                    'Lớp',
                    style: defaultText14Re,
                  ),
                ),
                SizedBox(
                  width: 160.w,
                  child: Text(
                    ': ${model.alias}',
                    style: defaultText14B,
                  ),
                ),
              ],
            ),
            SizedBox(
              height: 10.h,
            ),
            const Divider(
              thickness: 2,
            ),
            SizedBox(
              height: 10.h,
            ),

            // chartItem(width: 350, percents: 92, title: 'Chuyên cần'),
            // chartItem(width: 350, percents: 75, title: 'Bài tập'),
            //chartItem(width: 350, percents: 100, title: 'Thái độ'),
            ListView.builder(
                shrinkWrap: true,
                physics: const ClampingScrollPhysics(),
                itemCount: model.listValue.length,
                itemBuilder: (BuildContext context, int index) {
                  return Padding(
                    padding: EdgeInsets.symmetric(
                      vertical: 8.h,
                      horizontal: 16.w,
                    ),
                    child: Text(
                      '${model.listValue[index].name}${model.listValue[index].type == '2' ? ': ${model.listValue[index].value}' : ''}',
                      style: model.listValue[index].type == '1'
                          ? defaultText14M
                          : defaultText16B.copyWith(
                              color: model.listValue[index].type == '0'
                                  ? mainOrange
                                  : mainYellow,
                            ),
                    ),
                  );
                }),
          ],
        ),
      ),
    );
  }
}

class UnorderedList extends StatelessWidget {
  const UnorderedList(this.texts, {super.key, required this.icon});
  final List<String> texts;
  final int icon;
  @override
  Widget build(BuildContext context) {
    var widgetList = <Widget>[];
    for (var text in texts) {
      // Add list item
      widgetList.add(UnorderedListItem(
        text,
        icon: icon,
      ));
      // Add space between items
      widgetList.add(const SizedBox(height: 5.0));
    }

    return Column(children: widgetList);
  }
}

class UnorderedListItem extends StatelessWidget {
  const UnorderedListItem(this.text, {super.key, required this.icon});
  final String text;
  final int icon;
  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(
          "• ",
          style: defaultText14M,
        ),
        Expanded(
          child: Text(
            text,
            style: defaultText14M,
          ),
        ),
        (icon == 1)
            ? const Icon(
                Icons.done,
                color: Colors.green,
              )
            : const SizedBox()
      ],
    );
  }
}
