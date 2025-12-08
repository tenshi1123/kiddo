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
