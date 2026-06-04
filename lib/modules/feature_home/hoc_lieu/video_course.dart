import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:kiddo/modules/feature_home/hoc_lieu/detail_video.dart';
import 'package:kiddo/modules/notification/notification.dart';
import 'package:kiddo/student_models/info_class_model.dart';
import 'package:kiddo/student_models/profile_model.dart';
import 'package:kiddo/student_repo/video_repo.dart';
import 'package:kiddo/utils/constants/color.dart';
import 'package:kiddo/utils/widget/webview_screen.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:kiddo/utils/widget/app_image.dart';
import '../../../utils/constants/styles.dart';

class VideoCourse extends StatelessWidget {
  const VideoCourse(
      {super.key, required this.courseVideoModel, required this.model});
  final CourseVideoModel courseVideoModel;
  final ProfileModel? model;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: mainOrange,
      appBar: AppBar(
        backgroundColor: mainOrange,
        elevation: 0,
        centerTitle: true,
        title: Text(
          'Học liệu khoá học',
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
        width: double.infinity,
        height: double.infinity,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(26.r),
            topRight: Radius.circular(26.r),
          ),
        ),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: EdgeInsets.all(12.w),
                child: Row(
                  children: [
                    Image.asset(
                      'assets/images/computer.png',
                      width: 40.w,
                      height: 40.h,
                    ),
                    SizedBox(width: 12.w),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          courseVideoModel.detailClassModel.name,
                          style: defaultText14SB.copyWith(fontSize: 16.sp),
                        ),
                        SizedBox(height: 4.h),
                        Text(
                          courseVideoModel
                              .detailClassModel.settingCourseTypeName,
                          style: defaultText14Re,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              Container(
                margin: EdgeInsets.only(left: 16.w, right: 16.w),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(16.r)),
                  color: Colors.white,
                ),
                child: AppImage(
                  url: courseVideoModel.detailClassModel.courseImg,
                  width: 120.w,
                  //height: 160.h,
                  fit: BoxFit.fitWidth,
                ),
              ),
              Container(
                //height: 32.h,
                //width: 142.w,
                margin: EdgeInsets.only(left: 16.w),
                padding: EdgeInsets.all(8.h),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8.r),
                  color: const Color(0xff28B4E9),
                ),
                child: Text(
                  courseVideoModel.detailClassModel.settingCourseTypeName,
                  style: defaultText16M.copyWith(
                    color: Colors.white,
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.only(top: 10.h, left: 16.w),
                child: Text(
                  courseVideoModel.detailClassModel.name,
                  style: defaultText20B.copyWith(
                    color: const Color(0xff273D8C),
                  ),
                ),
              ),
              Row(
                children: [
                  Stack(
                    children: [
                      Container(
                        margin: EdgeInsets.symmetric(
                            vertical: 10.h, horizontal: 16.w),
                        height: 8.h,
                        width: 296.w,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(24.r),
                          color: const Color(0xffEDEDED),
                        ),
                      ),
                      Container(
                        margin: EdgeInsets.symmetric(
                            vertical: 10.h, horizontal: 16.w),
                        height: 8.h,
                        width: (296 *
                                courseVideoModel
                                    .detailClassModel.percentLearning /
                                100)
                            .w,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(24.r),
                          color: const Color(0xff28B4E9),
                        ),
                      ),
                    ],
                  ),
                  Text(
                    '${courseVideoModel.detailClassModel.percentLearning}%',
                    style: defaultText16B.copyWith(
                      color: const Color(0xff28B4E9),
                    ),
                  ),
                ],
              ),
              Divider(
                color: const Color(0xffEDEDED),
                thickness: 8.h,
              ),
              Padding(
                padding: EdgeInsets.only(top: 10.h, left: 16.w),
                child: Text(
                  'Nội dung',
                  style: defaultText16B,
                ),
              ),
              ListView.builder(
                  shrinkWrap: true,
                  physics: const ClampingScrollPhysics(),
                  itemCount: courseVideoModel.listTopical.length,
                  itemBuilder: (BuildContext context, int index) {
                    return LessonItem(
                      index: index,
                      topicModel: courseVideoModel.listTopical[index],
                      infoModel: model,
                    );
                  }),
              SizedBox(
                height: 80.h,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class LessonItem extends StatefulWidget {
  const LessonItem(
      {super.key,
      required this.index,
      required this.topicModel,
      this.infoModel});
  final int index;
  final TopicalModel topicModel;
  final ProfileModel? infoModel;
  @override
  State<LessonItem> createState() => _LessonItemState();
}

class _LessonItemState extends State<LessonItem> {
  bool isExpanded = false;
  bool _isLoading = false;
  List<LessonVideoModel> listLessonVideoModels = [];

  Future<void> playVideoAtIndex(int index) async {
    if (index >= listLessonVideoModels.length) return;
    final e = listLessonVideoModels[index];

    if (e.lessonType == '3') {
      setState(() {
        _isLoading = true;
      });
      try {
        BunnyModel model = await VideoRepository().getBunny(
          lessonId: e.lessonsId,
          settingCoureTypeId: e.settingCourseTypeId,
          lessonType: e.lessonType,
        );

        if (!mounted) return;

        // Tiến hành điều hướng sang màn hình mới
        final result = await Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => DetailVideo(
              bunnyModel: model,
              model: widget.infoModel,
              name: e.name,
            ),
          ),
        );

        if (result == true) {
          playVideoAtIndex(index + 1);
        }
      } catch (error) {
        print("Lỗi khi tải video: $error");
      } finally {
        if (mounted) {
          setState(() {
            _isLoading = false;
          });
        }
      }
    } else {
      String link = await VideoRepository().getLinkVideo(
        lessonId: e.lessonsId,
        settingCoureTypeId: e.settingCourseTypeId,
        lessonType: e.lessonType,
      );
      if (!mounted) return;
      if (!await launchUrl(Uri.parse(link))) {
        throw Exception('Could not launch ');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        SizedBox(
          height: 12.h,
        ),
        InkWell(
          onTap: () async {
            listLessonVideoModels = await VideoRepository().getlistLessonVideo(
              topicalId: widget.topicModel.topicalId,
              settingCoureTypeId: widget.topicModel.settingCourseTypeId,
            );
            if (!mounted) return;
            setState(() {
              isExpanded = !isExpanded;
            });
          },
          child: Row(
            children: [
              SizedBox(
                width: 16.w,
              ),
              Container(
                height: 34.h,
                width: 34.w,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: const Color(0xff2F9CD3),
                  ),
                  color: Colors.white,
                ),
                child: Center(
                  child: Text(
                    '${widget.index + 1}',
                    style: defaultText14M.copyWith(
                      color: const Color(0xff2F9CD3),
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
              SizedBox(
                width: 16.w,
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    width: 260.w,
                    child: Text(
                      widget.topicModel.nameTopical,
                      style: defaultText16M.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  Text(
                    '${widget.topicModel.numLLessson} bài',
                    style: defaultText12M.copyWith(
                      fontWeight: FontWeight.w500,
                      color: const Color(0xff3C3C3C).withValues(alpha: 0.6),
                    ),
                  ),
                ],
              ),
              const Spacer(),
              const Icon(Icons.keyboard_arrow_right_outlined),
              SizedBox(
                width: 16.w,
              ),
            ],
          ),
        ),
        const Divider(),
        if (isExpanded)
          Column(
            children: listLessonVideoModels.asMap().entries.map((entry) {
              int index = entry.key;
              var e = entry.value;
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  InkWell(
                    onTap: _isLoading
                        ? null
                        : () => playVideoAtIndex(index),
                    child: DetailItem(
                      title: e.name,
                      type: e.type,
                    ),
                  ),
                  if (e.document.isNotEmpty)
                    Padding(
                      padding: const EdgeInsets.only(
                          left: 16.0, top: 4.0, bottom: 8.0),
                      child: Column(
                        children: e.document.map((doc) {
                          return GestureDetector(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => WebViewScreen(
                                    link: doc.linkWebView.isNotEmpty
                                        ? doc.linkWebView
                                        : doc.link,
                                    title: doc.name.isNotEmpty
                                        ? doc.name
                                        : 'Tài liệu',
                                    type: 0,
                                  ),
                                ),
                              );
                            },
                            child: DetailItem(
                              title: doc.name,
                              type: doc.type, // Sẽ truyền vào 'document'
                            ),
                          );
                        }).toList(),
                      ),
                    ),
                  const Divider(),
                ],
              );
            }).toList(),
          )
      ],
    );
  }
}

class DetailItem extends StatelessWidget {
  const DetailItem({super.key, required this.title, required this.type});
  final String title;
  final String type;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        SizedBox(
          width: 16.w,
        ),
        Column(
          children: [
            Icon(
              Icons.check_circle,
              color: mainGreen,
            ),
            Container(
              height: 32.h,
              width: 1.w,
              margin: EdgeInsets.symmetric(vertical: 8.h),
              decoration: const BoxDecoration(
                color: Colors.green,
              ),
            ),
          ],
        ),
        SizedBox(
          width: 16.w,
        ),
        Icon(
          Icons.play_circle_fill,
          color: Colors.blue,
        ),
        SizedBox(
          width: 16.w,
        ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              width: 267.w,
              child: Text(
                title,
                style: defaultText14M,
              ),
            ),
            SizedBox(
              width: 267.w,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    type,
                    style: defaultText12M.copyWith(
                      fontWeight: FontWeight.w500,
                      color: const Color(0xff3C3C3C).withValues(alpha: 0.6),
                    ),
                  ),
                ],
              ),
            ),
            Container(
              height: 1.h,
              width: 267.w,
              margin: EdgeInsets.symmetric(vertical: 4.h),
              decoration: const BoxDecoration(
                color: Color(0xffEDEDED),
              ),
            )
          ],
        ),
      ],
    );
  }
}
