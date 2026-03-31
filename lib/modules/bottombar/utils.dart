// Copyright 2019 Aleksander Woźniak
// SPDX-License-Identifier: Apache-2.0

import 'dart:collection';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:intl/intl.dart';
import 'package:kiddo/modules/lesson/detail_lesson_screen.dart';
import 'package:kiddo/student_models/diem_danh_model.dart';
import 'package:kiddo/utils/constants/styles.dart';
import 'package:table_calendar/table_calendar.dart';

/// Example event class.
class Event {
  final String title;

  const Event(this.title);

  @override
  String toString() => title;
}

/// Example events.
///
/// Using a [LinkedHashMap] is highly recommended if you decide to use a map.
final kEvents = LinkedHashMap<DateTime, List<Event>>(
  equals: isSameDay,
  hashCode: getHashCode,
)..addAll(_kEventSource);

final _kEventSource = {
  for (var item in List.generate(50, (index) => index))
    DateTime.utc(kFirstDay.year, kFirstDay.month, item * 5): List.generate(
        item % 4 + 1, (index) => Event('Event $item | ${index + 1}'))
}..addAll({
    kToday: [
      const Event('Today\'s Event 1'),
      const Event('Today\'s Event 2'),
    ],
  });

int getHashCode(DateTime key) {
  return key.day * 1000000 + key.month * 10000 + key.year;
}

/// Returns a list of [DateTime] objects from [first] to [last], inclusive.
List<DateTime> daysInRange(DateTime first, DateTime last) {
  final dayCount = last.difference(first).inDays + 1;
  return List.generate(
    dayCount,
    (index) => DateTime.utc(first.year, first.month, first.day + index),
  );
}

final kToday = DateTime.now();
final kFirstDay = DateTime(kToday.year, kToday.month - 6, kToday.day);
final kLastDay = DateTime(kToday.year, kToday.month + 6, kToday.day);

class ItemTableCalender extends StatefulWidget {
  final ScheduleModel model;
  const ItemTableCalender({super.key, required this.model});

  @override
  State<ItemTableCalender> createState() => _ItemTableCalenderState();
}

class _ItemTableCalenderState extends State<ItemTableCalender> {
  final bool _isLoading = false;
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      // onTap: () async {
      //   Navigator.push(
      //     context,
      //     MaterialPageRoute(
      //       builder: ((context) => DetailLessonScreen(
      //             typeLearn: widget.model.typeLearn,
      //             checkinOffId: widget.model.checkinOffId ?? '',
      //             meetingId: widget.model.meetingId ?? '',
      //           )),
      //     ),
      //   );
      // },
      child: _isLoading
          ? SizedBox(
              height: 136.h,
              width: 343.w,
              child: Center(
                child: SizedBox(
                  width: 40.w,
                  height: 40.h,
                  child: const CircularProgressIndicator(),
                ),
              ),
            )
          : Container(
              margin: EdgeInsets.only(
                  top: 16.h, bottom: 10.h, left: 16.w, right: 16.w),
              padding: EdgeInsets.symmetric(
                horizontal: 16.w,
                vertical: 16.h,
              ),
              width: 343.w,
              //height: 136.h,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.all(Radius.circular(12.r)),
                boxShadow: [
                  BoxShadow(
                    color: const Color(0xff273D8C).withValues(alpha: 0.12),
                    blurRadius: 16,
                    spreadRadius: 0,
                    offset: const Offset(0, 4), // Shadow position
                  ),
                ],
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '${widget.model.courseName} - ${widget.model.buoiHoc}',
                    style: defaultText16B,
                  ),
                  SizedBox(
                    height: 10.h,
                  ),
                  Row(
                    children: [
                      SvgPicture.asset('assets/icons/clock.svg'),
                      Text(
                        '    ${DateFormat("yyyy-MM-dd").format(widget.model.createdDate)} (${widget.model.timeStart.replaceRange(5, 8, '')} - ${widget.model.timeEnd.replaceRange(5, 8, '')})',
                        style: defaultText14M,
                      )
                    ],
                  ),
                  SizedBox(
                    height: 4.h,
                  ),
                  Row(
                    children: [
                      SvgPicture.asset('assets/icons/class.svg'),
                      Text(
                        '    ${widget.model.phongHocName}',
                        style: defaultText14M,
                      )
                    ],
                  ),
                  SizedBox(
                    height: 4.h,
                  ),
                  Row(
                    children: [
                      SvgPicture.asset('assets/icons/place.svg'),
                      Text(
                        widget.model.typeTeacher == 'off'
                            ? '    ${widget.model.cosoName}'
                            : 'Online',
                        style: defaultText14M,
                      )
                    ],
                  ),
                ],
              ),
            ),
    );
  }
}

String formatDisplay(String day, String start, String end) {
  final startShort = start.substring(0, 5); // "08:00"
  final endShort = end.substring(0, 5); // "09:00"

  return "$day ($startShort - $endShort)";
}
