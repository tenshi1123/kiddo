import 'package:kiddo/teacher_model/teacher_class_model.dart';

class ListExcerciseModel {
  final int dungHan;
  final int quaHan;
  final int chuaLam;
  final int daLam;
  final int persent;
  final int tongbai;
  final List<ExcerciseValueModel> sapDenHan;
  final List<ExcerciseValueModel> value;
  ListExcerciseModel({
    required this.dungHan,
    required this.quaHan,
    required this.chuaLam,
    required this.daLam,
    required this.persent,
    required this.tongbai,
    required this.sapDenHan,
    required this.value,
  });
  factory ListExcerciseModel.fromJson(Map<String, dynamic> json) {
    return ListExcerciseModel(
      dungHan: json['dung_han'] ?? '',
      quaHan: json['qua_han'] ?? '',
      chuaLam: json['chua_lam'] ?? '',
      daLam: json['da_lam'] ?? '',
      persent: json['ti_le_lam_bai'] ?? '',
      tongbai: json['tong_bai'] ?? '',
      sapDenHan: ((json['data_sap_den_han'] as List)
          .map((e) => ExcerciseValueModel.fromJson(e))
          .toList()),
      value: ((json['value'] as List)
          .map((e) => ExcerciseValueModel.fromJson(e))
          .toList()),
    );
  }
}

//value, sắp đến hạn
class ExcerciseValueModel {
  final String id;
  final String customerCourseScheduleId;
  final String name;
  final String timeDeadline;
  final String type;
  final String typeName;
  final int status;
  final String note;
  ExcerciseValueModel(
      {required this.id,
      required this.customerCourseScheduleId,
      required this.name,
      required this.timeDeadline,
      required this.type,
      required this.typeName,
      required this.status,
      required this.note});
  factory ExcerciseValueModel.fromJson(Map<String, dynamic> json) {
    return ExcerciseValueModel(
      id: json['id'] ?? '',
      customerCourseScheduleId: json['customer_course_schedule_id'] ?? '',
      name: json['name'] ?? '',
      timeDeadline: json['time_deadline'] ?? '',
      type: json['type'] ?? '',
      typeName: json['type_name'] ?? '',
      status: json['status'] ?? '',
      note: json['note'] ?? '',
    );
  }
}

//Chi tiết bài tập
class DetailExcerciseModel {
  final DeValueModel valueModel;
  final List<DeDetailModel> detail;
  final DocumentModel? document;
  DetailExcerciseModel(
      {required this.valueModel, required this.detail, this.document});
  factory DetailExcerciseModel.fromJson(Map<String, dynamic> json) {
    return DetailExcerciseModel(
      valueModel: DeValueModel.fromJson(json['value']),
      detail: (json['value']['type'] == '1')
          ? ((json['detail'] as List)
              .map((e) => DeDetailModel.fromJson(e))
              .toList())
          : [],
      document: (json['value']['type'] == '2')
          ? DocumentModel.fromJson(json['detail'])
          : null,
    );
  }
}

//Chi tiết bài tập
class DeValueModel {
  final String name;
  final String examId;
  final String urlFile;
  final String type;
  final String id;
  final String timeDeadline;
  final String customerCourseScheduleId;
  final String description;
  DeValueModel({
    required this.name,
    required this.examId,
    required this.urlFile,
    required this.type,
    required this.id,
    required this.timeDeadline,
    required this.customerCourseScheduleId,
    required this.description,
  });
  factory DeValueModel.fromJson(Map<String, dynamic> json) {
    return DeValueModel(
      name: json['name'] ?? '',
      examId: json['exam_id'] ?? '',
      urlFile: json['url_file'] ?? '',
      type: json['type'] ?? '',
      id: json['id'] ?? '',
      timeDeadline: json['time_deadline'] ?? '',
      customerCourseScheduleId: json['customer_course_schedule_id'] ?? '',
      description: json['description'] ?? '',
    );
  }
}

//Chi tiết bài tập
class DeDetailModel {
  final String id;
  final String slug;
  final String examDetailId;
  final String name;
  final String skills;
  final String totalQuestions;
  final String ccseeId;
  final String examDetilResultsId;
  final String ccseeFinalMark;
  final String note;
  final String createAt;
  final String finalMark;
  final String numberCorrect;
  DeDetailModel({
    required this.id,
    required this.slug,
    required this.examDetailId,
    required this.name,
    required this.skills,
    required this.totalQuestions,
    required this.ccseeId,
    required this.examDetilResultsId,
    required this.ccseeFinalMark,
    required this.note,
    required this.createAt,
    required this.finalMark,
    required this.numberCorrect,
  });
  factory DeDetailModel.fromJson(Map<String, dynamic> json) {
    return DeDetailModel(
      id: json['id'] ?? '',
      slug: json['slug'] ?? '',
      examDetailId: json['exam_detail_id'] ?? '',
      name: json['name'] ?? '',
      skills: json['skills'] ?? '',
      totalQuestions: json['total_questions'] ?? '',
      ccseeId: json['ccsee_id'] ?? '',
      examDetilResultsId: json['exam_detail_results_id'] ?? '',
      ccseeFinalMark: json['ccsee_final_mark'] ?? '',
      note: json['note'] ?? '',
      createAt: json['created_at'] ?? '',
      finalMark: json['final_mark'] ?? '',
      numberCorrect: json['number_correct'] ?? '',
    );
  }
}

//Báo cáo học tập
class BaoCaoHocTapModel {
  final int chuyenCan;
  final int baitap;
  final List<ExamScheduleModel> schedules;
  BaoCaoHocTapModel({
    required this.baitap,
    required this.chuyenCan,
    required this.schedules,
  });
  factory BaoCaoHocTapModel.fromJson(Map<String, dynamic> json) {
    return BaoCaoHocTapModel(
      chuyenCan: json["cc"] ?? '',
      baitap: json["bt"] ?? '',
      schedules: ((json['orderOfflineExamSchedule'] as List)
          .map((e) => ExamScheduleModel.fromJson(e))
          .toList()),
    );
  }
}

class ExamScheduleModel {
  final String id;
  final String cosoName;
  final String cosoAddress;
  final String name;
  final String description;
  final String day;
  final String type;
  final String score;
  ExamScheduleModel(
      {required this.id,
      required this.cosoName,
      required this.cosoAddress,
      required this.name,
      required this.description,
      required this.day,
      required this.type,
      required this.score});
  factory ExamScheduleModel.fromJson(Map<String, dynamic> json) {
    return ExamScheduleModel(
      id: json["id"] ?? '',
      cosoName: json["coso_name"] ?? '',
      cosoAddress: json["coso_address"] ?? '',
      name: json["name"] ?? ' ',
      description: json["description"] ?? '',
      day: json["day"] ?? '',
      type: json["type"] ?? '',
      score: json["score"] ?? '',
    );
  }
}

class CategoryModel {
  final int id;
  final String categoryName;
  CategoryModel({
    required this.id,
    required this.categoryName,
  });
  factory CategoryModel.fromJson(Map<String, dynamic> json) {
    return CategoryModel(
      id: json['id'] ?? json['category_id'] ?? '',
      categoryName: json['name'] ?? '',
    );
  }
}

class PostModel {
  final int id;
  final String title;
  final String link;
  final DateTime date;
  final String img;

  PostModel({
    required this.id,
    required this.title,
    required this.link,
    required this.date,
    required this.img,
  });
  factory PostModel.fromJson(Map<String, dynamic> json) {
    return PostModel(
      id: json['id'] ?? '',
      title: json['title'] ?? '',
      link: json['link'] ?? '',
      date: DateTime.parse(json['date'] ?? ''),
      img: json['image'] ?? '',
    );
  }
}
