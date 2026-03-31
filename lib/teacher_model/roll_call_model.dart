class ViolationError {
  final String id;
  final String name;

  ViolationError({
    required this.id,
    required this.name,
  });

  factory ViolationError.fromJson(Map<String, dynamic> json) {
    return ViolationError(
      id: json['id'],
      name: json['name'],
    );
  }
}

class ClassLessonViolationError {
  final String violationErrorId;
  final String buoiHocId;

  ClassLessonViolationError({
    required this.violationErrorId,
    required this.buoiHocId,
  });

  factory ClassLessonViolationError.fromJson(Map<String, dynamic> json) {
    return ClassLessonViolationError(
      violationErrorId: json['violation_error_id'],
      buoiHocId: json['id'], // chính là buoi_hoc_id
    );
  }
}

class ValueAttitudeModel {
  final String fullName;
  final String customerId;
  final String buoiHocId;
  String content;

  /// thêm 2 field mới
  String? violationErrorId;
  final String? violationErrorName;

  List<ViolationError>? listError = [];

  ValueAttitudeModel({
    required this.fullName,
    required this.customerId,
    required this.buoiHocId,
    required this.content,
    this.violationErrorId,
    this.violationErrorName,
    this.listError,
  });

  factory ValueAttitudeModel.fromJson(Map<String, dynamic> json) {
    return ValueAttitudeModel(
      fullName: json['full_name'] ?? '',
      customerId: json['customer_id'] ?? '',
      buoiHocId: json['buoi_hoc_id'] ?? '',
      content: json['content'] ?? 'Chưa có nhận xét',
      listError: [],
    );
  }

  /// hàm copy để thêm violation info sau khi mapping
  ValueAttitudeModel copyWith({
    String? violationErrorId,
    String? violationErrorName,
    List<ViolationError>? listError,
  }) {
    return ValueAttitudeModel(
      fullName: fullName,
      customerId: customerId,
      buoiHocId: buoiHocId,
      content: content,
      violationErrorId: violationErrorId ?? this.violationErrorId,
      violationErrorName: violationErrorName ?? this.violationErrorName,
      listError: listError ?? this.listError,
    );
  }
}

class DataBaoCaoModel {
  final InfoReportModel infoReport;
  final int cntToday;
  final List<ResultReportModel> teachingHourReport;

  DataBaoCaoModel({
    required this.infoReport,
    required this.cntToday,
    required this.teachingHourReport,
  });

  factory DataBaoCaoModel.fromJson(Map<String, dynamic> json) {
    return DataBaoCaoModel(
      infoReport: InfoReportModel.fromJson(json['info'] ?? {}),
      cntToday: json['cnt_today'] ?? 0,
      teachingHourReport: (json['result'] as List<dynamic>?)
              ?.map((e) => ResultReportModel.fromJson(e))
              .toList() ??
          [],
    );
  }
}

class InfoReportModel {
  final int total;
  final int off;
  final int zoom;

  InfoReportModel({
    required this.total,
    required this.off,
    required this.zoom,
  });

  factory InfoReportModel.fromJson(Map<String, dynamic> json) {
    return InfoReportModel(
      total: json['totalClass'] ?? 0,
      off: json['cntOff'] ?? 0,
      zoom: json['cntZoom'] ?? 0,
    );
  }
}

class ResultReportModel {
  final String courseScheduleId;
  final String typeTeacher;
  ResultReportModel({
    required this.courseScheduleId,
    required this.typeTeacher,
  });
  factory ResultReportModel.fromJson(Map<String, dynamic> json) {
    return ResultReportModel(
      courseScheduleId: json['course_schedule_id'] ?? '',
      typeTeacher: json['type_teacher'] ?? '',
    );
  }
}

class TeachingHourReportModel {
  final String createdDate;
  final String timeStart;
  final String timeEnd;

  TeachingHourReportModel({
    required this.createdDate,
    required this.timeStart,
    required this.timeEnd,
  });

  factory TeachingHourReportModel.fromJson(Map<String, dynamic> json) {
    return TeachingHourReportModel(
      createdDate: json['created_date'] ?? '',
      timeStart: json['time_start'] ?? '',
      timeEnd: json['time_end'] ?? '',
    );
  }
}

List<TeachingHourReportModel> removeDuplicateLessons(
    List<TeachingHourReportModel> lessons) {
  final seen = <String>{};

  return lessons.where((lesson) {
    final key = "${lesson.createdDate}_${lesson.timeStart}_${lesson.timeEnd}";

    if (seen.contains(key)) {
      return false; // trùng -> bỏ
    } else {
      seen.add(key);
      return true; // giữ lại
    }
  }).toList();
}

int calculateTotalMinutes(List<TeachingHourReportModel> lessons) {
  int total = 0;

  for (var lesson in lessons) {
    final start = _parseTime(lesson.timeStart);
    final end = _parseTime(lesson.timeEnd);

    total += end.difference(start).inMinutes;
  }

  return total;
}

DateTime _parseTime(String time) {
  final parts = time.split(":");
  return DateTime(
    0,
    1,
    1,
    int.parse(parts[0]),
    int.parse(parts[1]),
    int.parse(parts[2]),
  );
}
