import 'package:intl/intl.dart';

class ClassModel {
  final String courseName;
  final String courseId;
  final String courseScheduleName;
  final String customerCourseScheduleId;
  final String courseImg;
  final String courseScheduleId;
  final String settingCourseTypeId;
  final String settingCourseTypeName;
  final String settingCourseTypeType;
  final String customerZoomGoogleOfflineId;
  ClassModel({
    required this.courseName,
    required this.courseId,
    required this.courseScheduleName,
    required this.customerCourseScheduleId,
    required this.courseImg,
    required this.courseScheduleId,
    required this.settingCourseTypeId,
    required this.settingCourseTypeName,
    required this.settingCourseTypeType,
    required this.customerZoomGoogleOfflineId,
  });
  factory ClassModel.fromJson(Map<String, dynamic> json) {
    return ClassModel(
      courseName: json['course_name'] ?? '',
      courseId: json['course_id'] ?? '',
      courseScheduleName: json['course_schedule_name'] ?? '',
      customerCourseScheduleId: json['customer_course_schedule_id'] ?? '',
      courseImg: json['course_img'] ?? '',
      courseScheduleId: json['course_schedule_id'] ?? '',
      settingCourseTypeId: json['setting_course_type_id'] ?? '',
      settingCourseTypeName: json['setting_course_type_name'] ?? '',
      settingCourseTypeType: json['setting_course_type_type'] ?? '',
      customerZoomGoogleOfflineId:
          json['customer_zoom_google_offline_id'] ?? '',
    );
  }
}

class DetailDiemDanh {
  final String nameBuoiHoc;
  final String day;
  final String timeStart;
  final String timeEnd;
  final String gvStatus;
  final String gvStatusName;
  final String? customerLeaveId;
  final String? customerLeaveReason;
  final String? customerLeaveCreatedAt;
  final String urlFile;
  final String typeLearn;
  final String content;
  final String violationErrorName;
  final List<GiaoVienModel> troGiang;
  final List<GiaoVienModel> giaoVien;

  DetailDiemDanh({
    required this.nameBuoiHoc,
    required this.day,
    required this.timeStart,
    required this.timeEnd,
    required this.gvStatus,
    required this.gvStatusName,
    this.customerLeaveId,
    this.customerLeaveReason,
    this.customerLeaveCreatedAt,
    required this.urlFile,
    required this.typeLearn,
    required this.content,
    required this.violationErrorName,
    required this.troGiang,
    required this.giaoVien,
  });

  factory DetailDiemDanh.fromJson(Map<String, dynamic> json) {
    return DetailDiemDanh(
      nameBuoiHoc: json['name_buoi_hoc'] ?? '',
      day: json['day'] ?? '',
      timeStart: json['time_start'] ?? '',
      timeEnd: json['time_end'] ?? '',
      gvStatus: json['gv_status'] ?? '',
      gvStatusName: json['gv_status_name'] ?? '',
      customerLeaveId: json['customer_leave_id'] ?? '',
      customerLeaveReason: json['customer_leave_reason'] ?? '',
      customerLeaveCreatedAt: json['customer_leave_created_at'] ?? '',
      urlFile: json['url_file'] ?? '',
      typeLearn: json['type_learn'] ?? '',
      content: json['content'] ?? '',
      violationErrorName: json['violation_error_name'] ?? '',
      troGiang: (json['tro_giang'] as List<dynamic>?)
              ?.map((e) => GiaoVienModel.fromJson(e))
              .toList() ??
          [],
      giaoVien: (json['giao_vien'] as List<dynamic>?)
              ?.map((e) => GiaoVienModel.fromJson(e))
              .toList() ??
          [],
    );
  }
}

class GiaoVienModel {
  final String fullName;
  final String totalTime;

  GiaoVienModel({
    required this.fullName,
    required this.totalTime,
  });

  factory GiaoVienModel.fromJson(Map<String, dynamic> json) {
    return GiaoVienModel(
      fullName: json['full_name'] ?? '',
      totalTime: json['total_time'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'full_name': fullName,
      'total_time': totalTime,
    };
  }
}

class InfoDiemDanh {
  final String name;
  final String type;
  final int cntDaDienRa;
  final int cntChuaDienRa;
  final List<DetailDiemDanh> daqua;
  final List<DetailDiemDanh> saptoi;
  InfoDiemDanh({
    required this.name,
    required this.type,
    required this.cntDaDienRa,
    required this.cntChuaDienRa,
    required this.daqua,
    required this.saptoi,
  });
  factory InfoDiemDanh.fromJson(Map<String, dynamic> json) {
    return InfoDiemDanh(
      name: json['name'] ?? 'Không có dữ liệu',
      type: json['type'] ?? 'Không có dữ liệu',
      cntDaDienRa: json['cnt_da_dien_ra'] ?? 0,
      cntChuaDienRa: json['cnt_chua_dien_ra'] ?? 0,
      daqua: ((json['da_dien_ra'] as List)
          .map((e) => DetailDiemDanh.fromJson(e))
          .toList()),
      saptoi: ((json['chua_dien_ra'] as List)
          .map((e) => DetailDiemDanh.fromJson(e))
          .toList()),
    );
  }
}

class ScheduleModel implements BaseCalendarEvent {
  @override
  DateTime get date => createdDate;

  @override
  String get title => courseName;

  final String courseName;
  final String buoiHoc;
  final DateTime createdDate;
  final String timeStart;
  final String timeEnd;
  final String? phongHocName;
  final String? cosoName;
  final String? checkinOffId;
  final String? linkZoom;
  final String? meetingId;
  final String typeLearn;
  final String? typeTeacher;

  ScheduleModel({
    required this.courseName,
    required this.buoiHoc,
    required this.createdDate,
    required this.timeStart,
    required this.timeEnd,
    this.phongHocName,
    this.cosoName,
    this.checkinOffId,
    this.linkZoom,
    this.meetingId,
    required this.typeLearn,
    this.typeTeacher,
  });

  factory ScheduleModel.fromJson(Map<String, dynamic> json) {
    return ScheduleModel(
      courseName: json["course_name"] ?? '',
      buoiHoc: json["buoi_hoc"] ?? '',
      createdDate:
          DateFormat("dd-MM-yyyy").parse(json["created_date"] ?? ''),
      timeStart: json["time_start"] ?? '',
      timeEnd: json["time_end"] ?? '',
      phongHocName: json["phonghoc_name"],
      cosoName: json["coso_name"],
      checkinOffId: json["checkin_off_id"],
      linkZoom: json["link_zoom"],
      meetingId: json["meeting_id"],
      typeLearn: json["type_learn"] ?? '',
      typeTeacher: json["type_teacher"],
    );
  }
}


class AppointmentModel implements BaseCalendarEvent {
  @override
  DateTime get date => appointmentDate;

  @override
  String get title => fullName;

  final DateTime appointmentDate;
  final String time;
  final String fullName;
  final String cosoName;
  final String cosoAddress;
  final String phone;
  final String email;
  final String userName;
  final String note;

  AppointmentModel({
    required this.appointmentDate,
    required this.time,
    required this.fullName,
    required this.cosoName,
    required this.cosoAddress,
    required this.phone,
    required this.email,
    required this.userName,
    required this.note,
  });

  factory AppointmentModel.fromJson(Map<String, dynamic> json) {
    return AppointmentModel(
      appointmentDate:
          DateFormat("dd-MM-yyyy").parse(json['appointment_date'] ?? ''),
      time: json['time'] ?? '',
      fullName: json['full_name'] ?? '',
      cosoName: json['coso_name'] ?? '',
      cosoAddress: json['coso_address'] ?? '',
      phone: json['phone'] ?? '',
      email: json['email'] ?? '',
      userName: json['user_name'] ?? '',
      note: json['note'] ?? '',
    );
  }
}


abstract class BaseCalendarEvent {
  DateTime get date;
  String get title;
}
