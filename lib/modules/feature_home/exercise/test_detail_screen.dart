import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:kiddo/l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:kiddo/student_models/excercise_model.dart';
import 'package:kiddo/student_repo/home_repo.dart';
import 'package:kiddo/utils/constants/color.dart';
import 'package:kiddo/utils/constants/styles.dart';

extension Substrings on String {
  /// Drops the last n characters.
  String dropLast(int n) {
    return n > length ? "" : substring(0, length - n);
  }
}

class TestDetailScreen extends StatefulWidget {
  const TestDetailScreen({
    super.key,
    required this.listQuestion,
    required this.title,
    required this.id,
    required this.customerCourseScheduleId,
    required this.examDetailId,
  });
  final List<QuestionGroupModel> listQuestion;
  final String title;
  final String id;
  final String customerCourseScheduleId;
  final String examDetailId;
  @override
  State<TestDetailScreen> createState() => _TestDetailScreenState();
}

class _TestDetailScreenState extends State<TestDetailScreen> {
  int _currentPage = 0;
  var countdownDuration = const Duration(minutes: 15);
  Duration duration = const Duration();
  List<QuestionGroupModel> _listQuestion = [];
  QuestionGroupModel? _selectedQuestion;
  Timer? timer;
  Timer? timer1;
  bool countDown = true;
  bool countDown1 = true;
  bool? isChecked = false;
  final ValueNotifier<Map<int, int>> _counter =
      ValueNotifier<Map<int, int>>({});
  final cauController = CauHoiHtmlController();

  late List<SubQuestionModel> allSubQuestions;
  late String selectedQuestionId = "-1";
  final PageController _pageController = PageController();

  @override
  void dispose() {
    cauController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    _listQuestion = widget.listQuestion;
    selectedQuestionId = _listQuestion.first.id;
    _selectedQuestion =
        _listQuestion.firstWhere((q) => q.id == selectedQuestionId);

    allSubQuestions =
        widget.listQuestion.expand((q) => q.value.values).toList();
    int hours1;
    int mints1;
    int secs1;
    hours1 = int.parse("00");
    mints1 = int.parse("15");
    secs1 = int.parse("00");
    countdownDuration =
        Duration(hours: hours1, minutes: mints1, seconds: secs1);
    startTimer();
    reset();

    super.initState();
  }

  Future<void> fetchPostsByCategory(String id) async {
    setState(() {
      selectedQuestionId = id;
      _selectedQuestion =
          _listQuestion.firstWhere((q) => q.id == selectedQuestionId);
    });
  }

  void startTimer() {
    timer = Timer.periodic(const Duration(seconds: 1), (_) => addTime());
  }

  void reset() {
    if (countDown) {
      setState(() => duration = countdownDuration);
    } else {
      setState(() => duration = const Duration());
    }
  }

  void stopTimer() {
    setState(
      () {
        timer1?.cancel();
      },
    );
  }

  void addTime() {
    const addSeconds = 1;
    final seconds = duration.inSeconds - addSeconds;
    if (seconds < 0) {
      timer1?.cancel();
    } else {
      setState(() {
        duration = Duration(seconds: seconds);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        //automaticallyImplyLeading: false,
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back_ios_new,
            color: Colors.white,
          ),
          onPressed: () => Navigator.of(context).pop(),
        ),
        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: mainGradient,
          ),
        ),
        title: Text(
          widget.title,
          style: defaultText18B.copyWith(
            color: Colors.white,
          ),
        ),
      ),
      body: Column(
        children: [
          SizedBox(height: 10.h),
          Row(
            children: [
              SizedBox(width: 20.w),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Thời gian còn lại', style: defaultText16B),
                  buildTime1(),
                ],
              ),
              const Spacer(),
              GestureDetector(
                onTap: () {
                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return CupertinoAlertDialog(
                        title: Text(AppLocalizations.of(context).confirmSubmit),
                        actions: <Widget>[
                          CupertinoDialogAction(
                            isDefaultAction: true,
                            child: Text('Đồng ý', style: defaultText20B),
                            onPressed: () {
                              stopTimer();
                              HomeRepo().submitTracNghiem(
                                id: widget.id,
                                examDetailId: widget.examDetailId,
                                customerCourseScheduleId:
                                    widget.customerCourseScheduleId,
                                startTime: DateTime.now().toIso8601String(),
                                data: _counter.value.entries.map((entry) {
                                  return {
                                    'id': entry.key.toString(),
                                    'answer': entry.value.toString(),
                                  };
                                }).toList(),
                              );
                              Navigator.pop(context);
                            },
                          ),
                          CupertinoDialogAction(
                            isDefaultAction: true,
                            child: Text('Hủy', style: defaultText20B),
                            onPressed: () {
                              Navigator.pop(context);
                            },
                          )
                        ],
                      );
                    },
                  );
                },
                child: Container(
                  height: 35.h,
                  width: 74.w,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(10.r)),
                    color: mainYellow,
                  ),
                  child: Center(
                    child: Text(
                      'Nộp bài',
                      style: defaultText16B.copyWith(color: Colors.white),
                    ),
                  ),
                ),
              ),
              SizedBox(width: 20.w),
            ],
          ),
          SizedBox(height: 10.h),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            padding: EdgeInsets.symmetric(horizontal: 12.w),
            child: Row(
              children: _listQuestion.map((question) {
                final bool isSelected = question.id == selectedQuestionId;
                return Padding(
                  padding: EdgeInsets.only(right: 12.w),
                  child: ChoiceChip(
                    label: Text(question.title),
                    selected: isSelected,
                    onSelected: (_) => fetchPostsByCategory(question.id),
                    selectedColor: Colors.white,
                    labelStyle: defaultText14M.copyWith(
                      color: isSelected
                          ? Colors.lightBlue
                          : const Color(0xff8A8A8A),
                      fontWeight:
                          isSelected ? FontWeight.bold : FontWeight.w600,
                    ),
                    shape: RoundedRectangleBorder(
                      side: BorderSide(
                        color: isSelected
                            ? Colors.lightBlue
                            : Colors.grey.shade300,
                      ),
                      borderRadius: BorderRadius.circular(10.r),
                    ),
                    backgroundColor: Colors.white,
                  ),
                );
              }).toList(),
            ),
          ),
          if (selectedQuestionId != "-1")
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 12.w),
              child: HtmlContentWidget(
                htmlContent: _selectedQuestion?.content ?? '',
              ),
            ),
          Expanded(
            child: PageView.builder(
              controller: _pageController,
              itemCount:
                  _selectedQuestion?.value.values.toList().first.type != '5'
                      ? _selectedQuestion?.value.values.toList().length
                      : 1,
              onPageChanged: (index) {
                setState(() {
                  _currentPage = index;
                });
              },
              itemBuilder: (context, index) {
                return CauHoiPage(
                  index: index,
                  question: _listQuestion
                      .firstWhere((q) => q.id == selectedQuestionId)
                      .value
                      .values
                      .toList()[index],
                  cauController: cauController,
                  counter: _counter,
                  answerGroup: _listQuestion.first.value,
                );
              },
            ),
          ),
          SizedBox(
            height: 60,
            child: Row(
              children: [
                IconButton(
                  icon: const Icon(Icons.chevron_left),
                  onPressed: _currentPage > 0
                      ? () {
                          _pageController.previousPage(
                            duration: const Duration(milliseconds: 300),
                            curve: Curves.ease,
                          );
                        }
                      : null,
                ),
                Expanded(
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount:
                        _selectedQuestion?.value.values.toList().first.type !=
                                '5'
                            ? _selectedQuestion?.value.values.toList().length
                            : 1,
                    itemBuilder: (context, index) {
                      final bool isSelected = index == _currentPage;
                      return GestureDetector(
                        onTap: () {
                          _pageController.animateToPage(
                            index,
                            duration: const Duration(milliseconds: 300),
                            curve: Curves.ease,
                          );
                        },
                        child: Container(
                          width: 36,
                          height: 36,
                          margin: const EdgeInsets.symmetric(horizontal: 4),
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: isSelected
                                ? Colors.lightBlue
                                : Colors.grey[300],
                            border: isSelected
                                ? Border.all(color: Colors.blue, width: 2)
                                : null,
                          ),
                          child: Text('${index + 1}',
                              style: defaultText14B.copyWith(
                                color:
                                    isSelected ? Colors.white : Colors.black54,
                              )),
                        ),
                      );
                    },
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.chevron_right),
                  onPressed: _currentPage <
                          (_selectedQuestion?.value.values.toList().length ??
                                  0) -
                              1
                      ? () {
                          _pageController.nextPage(
                            duration: const Duration(milliseconds: 100),
                            curve: Curves.ease,
                          );
                        }
                      : null,
                ),
              ],
            ),
          ),
        ],
      ),

      // card for elevation
      // bottomNavigationBar: Card(
      //   margin: EdgeInsets.zero,
      //   elevation: 4,
      //   child: NumberPaginator(
      //     // by default, the paginator shows numbers as center content
      //     numberPages: allSubQuestions.length,
      //     onPageChange: (int index) {
      //       setState(() {
      //         _currentPage = index;
      //       });
      //     },
      //   ),
      // ),
    );
  }

  Widget buildTime1() {
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    final hours = twoDigits(duration.inHours);
    final minutes = twoDigits(duration.inMinutes.remainder(60));
    final seconds = twoDigits(duration.inSeconds.remainder(60));
    return Row(mainAxisAlignment: MainAxisAlignment.center, children: [
      buildTimeCard(
        time: hours,
      ),
      Text(
        ':',
        style: defaultText20B.copyWith(
          color: mainYellow,
          fontSize: 20.sp,
        ),
      ),
      buildTimeCard(
        time: minutes,
      ),
      Text(
        ':',
        style: defaultText20B.copyWith(
          color: mainYellow,
          fontSize: 20.sp,
        ),
      ),
      buildTimeCard(
        time: seconds,
      ),
    ]);
  }

  Widget buildTimeCard({
    required String time,
  }) =>
      Text(
        time,
        style: defaultText20B.copyWith(
          color: mainYellow,
        ),
      );
}

class HtmlContentWidget extends StatelessWidget {
  final String htmlContent;

  const HtmlContentWidget({
    super.key,
    required this.htmlContent,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Html(
        data: htmlContent,
      ),
    );
  }
}

class CauHoiHtmlController {
  final Map<int, TextEditingController> _controllers = {};

  TextEditingController controllerOf(int index) {
    return _controllers.putIfAbsent(index, () => TextEditingController());
  }

  Map<int, String> get values =>
      _controllers.map((k, v) => MapEntry(k, v.text));

  void dispose() {
    for (final c in _controllers.values) {
      c.dispose();
    }
  }
}

class CauHoiHtmlWidget extends StatefulWidget {
  final String htmlContent;
  final CauHoiHtmlController controller;

  const CauHoiHtmlWidget({
    super.key,
    required this.htmlContent,
    required this.controller,
  });

  @override
  State<CauHoiHtmlWidget> createState() => _CauHoiHtmlWidgetState();
}

class _CauHoiHtmlWidgetState extends State<CauHoiHtmlWidget> {
  late final String _transformedHtml;

  @override
  void initState() {
    super.initState();
    _transformedHtml = _injectPlaceholders(widget.htmlContent);
  }

  String _injectPlaceholders(String html) {
    final regex = RegExp(r'\{cau\}');
    int i = 0;
    return html.replaceAllMapped(regex, (_) {
      final tag = '<input-placeholder data-index="$i"></input-placeholder>';
      i++;
      return tag;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Html(
      data: _transformedHtml,
      style: {
        'p': Style(margin: Margins.only(bottom: 12)),
      },
      extensions: [
        TagExtension(
          tagsToExtend: {'input-placeholder'},
          builder: (context) {
            // lấy index từ attribute
            final el = context.element;
            final idx = int.tryParse(el?.attributes['data-index'] ?? '0') ?? 0;
            final controller = widget.controller.controllerOf(idx);

            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: SizedBox(
                width: 200,
                child: TextField(
                  controller: controller,
                  decoration: const InputDecoration(
                    hintText: 'Nhập câu trả lời',
                    border: OutlineInputBorder(),
                    isDense: true,
                  ),
                  onChanged: (_) {
                    // nếu muốn notify ra ngoài, bạn có thể thêm callback
                    // hoặc dùng ValueNotifier/Provider/BLoC...
                    setState(() {});
                  },
                ),
              ),
            );
          },
        ),
      ],
    );
  }

  @override
  void dispose() {
    super.dispose();
  }
}

class CauHoiPage extends StatefulWidget {
  final int index;
  final SubQuestionModel question;
  final CauHoiHtmlController cauController;
  final ValueNotifier<Map<int, int>> counter;
  final Map<String, SubQuestionModel> answerGroup;

  const CauHoiPage({
    super.key,
    required this.index,
    required this.question,
    required this.cauController,
    required this.counter,
    required this.answerGroup,
  });

  @override
  State<CauHoiPage> createState() => _CauHoiPageState();
}

class _CauHoiPageState extends State<CauHoiPage>
    with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    super.build(context); // Đừng quên dòng này!
    return SingleChildScrollView(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
      ),
      child: Column(
        children: [
          Row(
            children: [
              Container(
                margin: const EdgeInsets.all(8),
                padding: const EdgeInsets.all(8),
                decoration: const BoxDecoration(
                    shape: BoxShape.circle, color: Colors.blue),
                child: Text(
                  '${widget.index + 1}',
                  style: defaultText14M.copyWith(color: Colors.white),
                ),
              ),
              Expanded(
                child: widget.question.type == '2'
                    ? HtmlContentWidget(htmlContent: widget.question.content)
                    : CauHoiHtmlWidget(
                        htmlContent: widget.question.content,
                        controller: widget.cauController,
                      ),
              ),
            ],
          ),
          ValueListenableBuilder(
            valueListenable: widget.counter,
            builder: (_, value, __) {
              return ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: widget.question.choices.length,
                itemBuilder: (context, answer) {
                  final isSelected = value[widget.index] == answer;
                  return GestureDetector(
                    onTap: () {
                      widget.counter.value = {
                        ...widget.counter.value,
                        widget.index: answer
                      };
                    },
                    child: Container(
                      margin: const EdgeInsets.symmetric(vertical: 4),
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8),
                        color: isSelected
                            ? Colors.lightBlueAccent.withOpacity(0.3)
                            : Colors.white,
                      ),
                      child: Row(
                        children: [
                          Checkbox(
                            value: isSelected,
                            shape: const CircleBorder(),
                            onChanged: (_) {
                              widget.counter.value = {
                                ...widget.counter.value,
                                widget.index: answer
                              };
                            },
                          ),
                          Expanded(
                            child: HtmlContentWidget(
                              htmlContent: widget
                                      .answerGroup[
                                          (widget.index + 1).toString()]
                                      ?.choices[answer]
                                      .text ??
                                  '',
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              );
            },
          )
        ],
      ),
    );
  }
}
