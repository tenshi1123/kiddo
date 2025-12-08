class TeacherClassModel {
  final String courseScheduleId;
  final String name;
  final String typeTeacher;
  TeacherClassModel({
    required this.courseScheduleId,
    required this.name,
    required this.typeTeacher,
  });
  factory TeacherClassModel.fromJson(Map<String, dynamic> json) {
    return TeacherClassModel(
      courseScheduleId: json['course_schedule_id'] ?? '',
      name: json['name'] ?? '',
      typeTeacher: json['type_teacher'] ?? '',
    );
  }
}

class PhuDaoClassModel {
  final String id;
  final String customerName;
  final String customernameAlias;
  final String phone;
  final String email;
  final String name;
  final String timeStart;
  final String timeEnd;
  final String dayPhuDao;
  final String settingCourseTypeId;
  final String phongHoc;
  final String address;
  final String zoomLink;
  final String typeLearn;
  String status;
  final String createdAt;
  PhuDaoClassModel({
    required this.id,
    required this.customerName,
    required this.customernameAlias,
    required this.phone,
    required this.email,
    required this.name,
    required this.timeStart,
    required this.timeEnd,
    required this.dayPhuDao,
    required this.settingCourseTypeId,
    required this.phongHoc,
    required this.address,
    required this.zoomLink,
    required this.typeLearn,
    required this.status,
    required this.createdAt,
  });
  factory PhuDaoClassModel.fromJson(Map<String, dynamic> json) {
    return PhuDaoClassModel(
      id: json['id'] ?? '',
      customerName: json['customer_name'] ?? '',
      customernameAlias: json['customer_name_alias'] ?? '',
      phone: json['phone'] ?? '',
      email: json['email'] ?? '',
      name: json['name'] ?? '',
      timeStart: json['time_start'] ?? '',
      timeEnd: json['time_end'] ?? '',
      dayPhuDao: json['day_phu_dao'] ?? json['day_xep_bu'] ?? '',
      settingCourseTypeId: json['setting_course_type_id'] ?? '',
      phongHoc: json['phonghoc'] ?? '',
      address: json['address'] ?? '',
      zoomLink: json['zoom_link'] ?? '',
      typeLearn: json['type_learn'] ?? '',
      status: json['status'] ?? '',
      createdAt: json['created_at'] ?? '',
    );
  }
}

class DetailClass {
  final String hinhThucHoc;
  final String id;
  final String name;
  final String alias;
  final String settingCourseTypeId;
  final List<DetailBuoiHoc> dsBuoiHoc;
  DetailClass({
    required this.hinhThucHoc,
    required this.id,
    required this.name,
    required this.alias,
    required this.settingCourseTypeId,
    required this.dsBuoiHoc,
  });
  factory DetailClass.fromJson(Map<String, dynamic> json) {
    return DetailClass(
      hinhThucHoc: json['courseSchedule']['hinh_thuc_hoc'] ?? '',
      id: json['courseSchedule']['id'] ?? '',
      name: json['courseSchedule']['name'] ?? '',
      alias: json['courseSchedule']['alias'] ?? '',
      settingCourseTypeId:
          json['courseSchedule']['setting_course_type_id'] ?? '',
      dsBuoiHoc: (json['danh_sach_buoi_hoc'] as List)
          .map((data) => DetailBuoiHoc.fromJson(data))
          .toList(),
    );
  }
}

class DetailBuoiHoc {
  final String id;
  final String name;
  final String teachingContent;
  final DateTime day;
  final String timeStart;
  final String timeEnd;
  final String classRoomName;
  final String address;
  final String noiDungBuoiHoc;
  DetailBuoiHoc({
    required this.id,
    required this.name,
    required this.teachingContent,
    required this.day,
    required this.timeStart,
    required this.timeEnd,
    required this.classRoomName,
    required this.address,
    required this.noiDungBuoiHoc,
  });
  factory DetailBuoiHoc.fromJson(Map<String, dynamic> json) {
    return DetailBuoiHoc(
      id: json['id'] ?? '',
      name: json['name'] ?? '',
      teachingContent: json['teaching_content'] ?? '',
      day: DateTime.parse(json['day']),
      timeStart: json['time_start'] ?? '',
      timeEnd: json['time_end'] ?? '',
      classRoomName: json['class_room_name'] ?? '',
      address: json['coso_address'] ?? '',
      noiDungBuoiHoc: json['noi_dung_buoi_hoc'] ?? '',
    );
  }
}

class BuoiHocModel {
  final String courseScheduleId;
  final String buoiHocId;
  final String name;
  final String createdDate;
  final String typeTeacher;
  BuoiHocModel({
    required this.courseScheduleId,
    required this.buoiHocId,
    required this.name,
    required this.createdDate,
    required this.typeTeacher,
  });
  factory BuoiHocModel.fromJson(Map<String, dynamic> json) {
    return BuoiHocModel(
      courseScheduleId: json['course_schedule_id'] ?? '',
      buoiHocId: json['buoi_hoc_id'] ?? '',
      name: json['name'] ?? '',
      createdDate: json['created_date'] ?? '',
      typeTeacher: json['type_teacher'] ?? '',
    );
  }
}

class DetailedExamModel {
  final ValueModel valueModel;
  final List<StudentExamModel> examModel;
  final List<DocumentModel> documentModel;
  DetailedExamModel({
    required this.valueModel,
    required this.examModel,
    required this.documentModel,
  });
  factory DetailedExamModel.fromJson(Map<String, dynamic> json) {
    return DetailedExamModel(
      valueModel: ValueModel.fromJson(json['value']),
      examModel: json['exam'] == null
          ? []
          : (json['exam'] as List)
              .map((data) => StudentExamModel.fromJson(data))
              .toList(),
      documentModel: json['docment'] == null
          ? []
          : (json['docment'] as List)
              .map((data) => DocumentModel.fromJson(data))
              .toList(),
    );
  }
}

class ValueModel {
  final String name;
  final String examId;
  final String urlFile;
  final String type;
  final String id;
  final String courseScheduleId;
  final String exerciseId;
  final String timeDeadline;
  final String meetingsId;
  final String createdAt;

  ValueModel({
    required this.name,
    required this.examId,
    required this.urlFile,
    required this.type,
    required this.id,
    required this.courseScheduleId,
    required this.exerciseId,
    required this.timeDeadline,
    required this.meetingsId,
    required this.createdAt,
  });
  factory ValueModel.fromJson(Map<String, dynamic> json) {
    return ValueModel(
      name: json['name'] ?? '',
      examId: json['exam_id'] ?? '',
      urlFile: json['url_file'] ?? '',
      type: json['type'] ?? '0',
      id: json['id'] ?? '',
      courseScheduleId: json['course_schedule_id'] ?? '',
      exerciseId: json['exercise_id'] ?? '',
      timeDeadline: json['time_deadline'] ?? '',
      meetingsId: json['meetings_id'] ?? '',
      createdAt: json['created_at'] ?? '',
    );
  }
}

class StudentExamModel {
  final String fullName;
  final String phone;
  final String email;
  final String name;
  final String slug;
  final List<ExamDataModel> examData;
  StudentExamModel({
    required this.fullName,
    required this.phone,
    required this.email,
    required this.name,
    required this.slug,
    required this.examData,
  });
  factory StudentExamModel.fromJson(Map<String, dynamic> json) {
    return StudentExamModel(
      fullName: json['full_name'] ?? '',
      phone: json['phone'] ?? '',
      email: json['email'] ?? '',
      name: json['name'] ?? '',
      slug: json['slug'] ?? '',
      examData: (json['exam_data'] as List)
          .map((data) => ExamDataModel.fromJson(data))
          .toList(),
    );
  }
}

class ExamDataModel {
  final String id;
  final String name;
  final String skills;
  final String ccseeId;
  final String examDetailResultsId;
  final String ccseeFinalMark;
  final String note;
  final String createdAt;
  final String finalMark;
  ExamDataModel({
    required this.id,
    required this.name,
    required this.skills,
    required this.ccseeId,
    required this.examDetailResultsId,
    required this.ccseeFinalMark,
    required this.note,
    required this.createdAt,
    required this.finalMark,
  });
  factory ExamDataModel.fromJson(Map<String, dynamic> json) {
    return ExamDataModel(
      id: json['id'] ?? '',
      name: json['name'] ?? '',
      skills: json['skills'] ?? '',
      ccseeId: json['ccsee_id'] ?? '',
      examDetailResultsId: json['exam_detail_results_id'] ?? '',
      ccseeFinalMark: json['ccsee_final_mark'] ?? '',
      note: json['note'] ?? '',
      createdAt: json['created_at'] ?? '',
      finalMark: json['final_mark'] ?? '',
    );
  }
}

class DocumentModel {
  final String fullName;
  final String id;
  final String urlFileCustomer;
  final String urlFileTeacher;
  final String finalMark;
  final String noteCustomers;
  final String noteTeacher;
  final String createdAt;
  DocumentModel({
    required this.fullName,
    required this.id,
    required this.urlFileCustomer,
    required this.urlFileTeacher,
    required this.finalMark,
    required this.noteCustomers,
    required this.noteTeacher,
    required this.createdAt,
  });
  factory DocumentModel.fromJson(Map<String, dynamic> json) {
    return DocumentModel(
      fullName: json['full_name'] ?? '',
      id: json['id'] ?? '',
      urlFileCustomer: json['url_file_customer'] ?? '',
      urlFileTeacher: json['url_file_teachers'] ?? '',
      finalMark: json['final_mark'] ?? '',
      noteCustomers: json['note_customer'] ?? 'Không có ghi chú',
      noteTeacher: json['note_teachers'] ?? 'Không có ghi chú',
      createdAt: json['created_at'] ?? '',
    );
  }
}

class DiemDanhModel {
  final String checkinOffId;
  final String fullName;
  final String fullNameAlias;
  final String avatar;
  final String customerLeaveReason;
  String status;
  final String createdAt;
  final String typeTeacher;
  DiemDanhModel({
    required this.checkinOffId,
    required this.fullName,
    required this.fullNameAlias,
    required this.avatar,
    required this.customerLeaveReason,
    required this.status,
    required this.createdAt,
    required this.typeTeacher,
  });
  factory DiemDanhModel.fromJson(Map<String, dynamic> json) {
    return DiemDanhModel(
      checkinOffId: json['checkin_off_id'] ?? '',
      fullName: json['full_name'] ?? '',
      fullNameAlias: json['full_name_alias'] ?? '',
      avatar: json['avatar'] ?? '',
      customerLeaveReason: json['customer_leave_reason'] ?? '',
      status: getStatus(json['status'] ?? ''),
      createdAt: json['created_at'] ?? '',
      typeTeacher: json['type_teacher'] ?? '',
    );
  }
}

String getStatus(String code) {
  const status = [
    "Vắng mặt",
    "Xin nghỉ",
    "Đi muộn",
    "Đúng giờ",
  ];
  final index = int.tryParse(code) ?? -1;
  if (index < 0 || index >= status.length) return "Không xác định";
  return status[index];
}

class ViolationModel {
  final String id;
  final String name;
  ViolationModel({
    required this.id,
    required this.name,
  });
  factory ViolationModel.fromJson(Map<String, dynamic> json) {
    return ViolationModel(
      id: json['id'] ?? '',
      name: json['name'] ?? '',
    );
  }
}

class ThaiDoModel {
  final String fullName;
  final String customerId;
  final String buoiHocId;
  final String content;
  ThaiDoModel({
    required this.fullName,
    required this.customerId,
    required this.buoiHocId,
    required this.content,
  });
  factory ThaiDoModel.fromJson(Map<String, dynamic> json) {
    return ThaiDoModel(
      fullName: json['full_name'] ?? '',
      customerId: json['customer_id'] ?? '',
      buoiHocId: json['buoi_hoc_id'] ?? '',
      content: json['content'] ?? '',
    );
  }
}

class DetailBuoiHocExtendedModel {
  final String courseScheduleId;
  final String eventCheckinOffId;
  final String name;
  final String? teachingContent;
  final String? linkRecord;
  final String timeStart;
  final String timeEnd;
  final String createdDate;
  final String typeTeacher;
  final String phonghocName;
  final String cosoName;
  final String cosoAddress;

  DetailBuoiHocExtendedModel({
    required this.courseScheduleId,
    required this.eventCheckinOffId,
    required this.name,
    this.teachingContent,
    this.linkRecord,
    required this.timeStart,
    required this.timeEnd,
    required this.createdDate,
    required this.typeTeacher,
    required this.phonghocName,
    required this.cosoName,
    required this.cosoAddress,
  });

  factory DetailBuoiHocExtendedModel.fromJson(Map<String, dynamic> json) {
    return DetailBuoiHocExtendedModel(
      courseScheduleId: json['course_schedule_id'] ?? '',
      eventCheckinOffId: json['event_checkin_off_id'] ?? '',
      name: json['name'] ?? '',
      teachingContent: json['teaching_content'], // Nullable
      linkRecord: json['link_record'], // Nullable
      timeStart: json['time_start'] ?? '',
      timeEnd: json['time_end'] ?? '',
      createdDate: json['created_date'] ?? '',
      typeTeacher: json['type_teacher'] ?? '',
      phonghocName: json['phonghoc_name'] ?? '',
      cosoName: json['coso_name'] ?? '',
      cosoAddress: json['coso_address'] ?? '',
    );
  }
}
