class ReviewModels {
  final String id;
  final String monthName;
  final String months;
  final String teacherName;
  final String courseName;
  final String alias;
  ReviewModels({
    required this.id,
    required this.monthName,
    required this.months,
    required this.teacherName,
    required this.courseName,
    required this.alias,
  });
  factory ReviewModels.fromJson(Map<String, dynamic> json) {
    return ReviewModels(
      id: json['id'] ?? '',
      monthName: json['evaluation_month_name'] ?? '',
      months: json['months'] ?? '',
      teacherName: json['teachers_full_name'] ?? '',
      courseName: json['course_schedule_name'] ?? '',
      alias: json['alias'] ?? '',
    );
  }
}

class ReviewDetailModels {
  final String monthName;
  final String months;
  final String teacherName;
  final String courseName;
  final String alias;
  final String content;
  final String id;
  final String cc;
  final String bt;
  final List<ValueModel> listValue;
  ReviewDetailModels({
    required this.monthName,
    required this.months,
    required this.teacherName,
    required this.courseName,
    required this.alias,
    required this.content,
    required this.id,
    required this.cc,
    required this.bt,
    required this.listValue,
  });
  factory ReviewDetailModels.fromJson(Map<String, dynamic> json) {
    return ReviewDetailModels(
      id: json['id'] ?? '',
      monthName: json['evaluation_month_name'] ?? '',
      months: json['months'] ?? '',
      teacherName: json['teachers_full_name'] ?? '',
      courseName: json['course_schedule_name'] ?? '',
      alias: json['alias'] ?? '',
      content: json['content'] ?? '',
      cc: json['cc'] ?? '',
      bt: json['bt'] ?? '',
      listValue: (json['value'] as List)
          .map((item) => ValueModel.fromJson(item))
          .toList(),
      // json['list_value']
      // .map<ValueModel>((item) => ValueModel.fromJson(item))
      // .toList() ?? [],
    );
  }
}

class ValueModel {
  final String name;
  final String type;
  final String value;
  ValueModel({
    required this.name,
    required this.type,
    required this.value,
  });
  factory ValueModel.fromJson(Map<String, dynamic> json) {
    return ValueModel(
      name: json['name'] ?? '',
      type: json['type'] ?? '',
      value: json['value'] ?? '',
    );
  }
}

class ListFeedBackModel {
  final List<FeedbackDinhKyModel> listFbDaily;
  final List<FeedbackDinhKyModel> listFbDinhKy;
  final List<FeedbackDinhKyModel> listMidMonth;
  final List<FeedbackDinhKyModel> listEndMonth;
  ListFeedBackModel({
    required this.listFbDaily,
    required this.listFbDinhKy,
    required this.listMidMonth,
    required this.listEndMonth,
  });
  factory ListFeedBackModel.fromJson(Map<String, dynamic> json) {
    return ListFeedBackModel(
      listFbDaily: (json['hang_ngay'] != null)
          ? (json['hang_ngay'] as List)
              .map((e) => FeedbackDinhKyModel.fromJson(e))
              .toList()
          : [],
      listFbDinhKy: (json['dinh_ky'] != null)
          ? (json['dinh_ky'] as List)
              .map((e) => FeedbackDinhKyModel.fromJson(e))
              .toList()
          : [],
      listMidMonth: [],
      listEndMonth: [],
    );
  }
}

class FeedbackHangNgayModel {
  final String name;
  final String content;
  final String violationErrorName;
  FeedbackHangNgayModel({
    required this.name,
    required this.content,
    required this.violationErrorName,
  });
  factory FeedbackHangNgayModel.fromJson(Map<String, dynamic> json) {
    return FeedbackHangNgayModel(
      name: json['name_buoi_hoc'] ?? 'Buổi học không xác định',
      content: json['content'] ?? '',
      violationErrorName: json['violation_error_name'] ?? '',
    );
  }
}

class FeedbackDinhKyModel {
  final String name;
  final String content;
  final String violationErrorName;
  final String type;
  final DateTime createAt;
  FeedbackDinhKyModel({
    required this.name,
    required this.content,
    required this.violationErrorName,
    required this.type,
    required this.createAt,
  });
  factory FeedbackDinhKyModel.fromJson(Map<String, dynamic> json) {
    return FeedbackDinhKyModel(
        name: json['name_buoi_hoc'] ??
            json['type_name'] ??
            'Buổi học không xác định',
        content: json['content'] ?? '',
        violationErrorName: json['violation_error_name'] ?? '',
        type: json['type'] ?? 'ck',
        createAt: DateTime.parse(json['created_at'] ?? '20000328'));
  }
}

class DiscountModels {
  final String id;
  final String title;
  final String expiryDate;
  final String code;

  DiscountModels({
    required this.id,
    required this.title,
    required this.expiryDate,
    required this.code,
  });
  factory DiscountModels.fromJson(Map<String, dynamic> json) {
    return DiscountModels(
      id: json['id'] ?? '',
      title: json['title'] ?? '',
      expiryDate: json['expiry_date'] ?? '',
      code: json['code'] ?? '',
    );
  }
}

class DetailDiscountModels {
  final String title;
  final String expiryDate;
  final String code;
  final String content;

  DetailDiscountModels({
    required this.title,
    required this.expiryDate,
    required this.code,
    required this.content,
  });
  factory DetailDiscountModels.fromJson(Map<String, dynamic> json) {
    return DetailDiscountModels(
      title: json['title'] ?? '',
      expiryDate: json['expiry_date'] ?? '',
      code: json['code'] ?? '',
      content: json['content'] ?? '',
    );
  }
}
