import 'package:intl/intl.dart';
import 'package:kiddo/student_models/review_models.dart';

class MyCourseModel {
  final String id;
  final String cosoName;
  final String teacherName;
  final String ccsStatus;
  final String name;
  final String img;
  final String alias;
  final String totalDathemvaoCuocHop;
  final int totalBuoiHoc;
  final int totalAttended;
  final String statusName;
  MyCourseModel({
    required this.id,
    required this.cosoName,
    required this.teacherName,
    required this.ccsStatus,
    required this.name,
    required this.img,
    required this.alias,
    required this.totalDathemvaoCuocHop,
    required this.totalBuoiHoc,
    required this.totalAttended,
    required this.statusName,
  });
  factory MyCourseModel.fromJson(Map<String, dynamic> json) {
    return MyCourseModel(
      id: json['id'],
      cosoName: json['coso_name'],
      teacherName: json['teachers_full_name'],
      ccsStatus: json['ccs_status'],
      name: json['name'],
      img: json['img'],
      alias: json['alias'],
      totalDathemvaoCuocHop: json['total_da_them_vao_cuoc_hop'],
      totalBuoiHoc: int.tryParse(json['total_buoi_hoc']) ?? 0,
      totalAttended: int.tryParse(json['total_attended']) ?? 0,
      statusName: json['status_name'],
    );
  }
}

class DetailMyCourse {
  final String id;
  final String alias;
  final String name;
  final String img;
  final String settingCourseTypeId;
  final String courseScheduleId;
  final List<DetailCourse> saptoi;
  final List<DetailCourse> daqua;
  DetailMyCourse({
    required this.id,
    required this.alias,
    required this.name,
    required this.img,
    required this.settingCourseTypeId,
    required this.courseScheduleId,
    required this.saptoi,
    required this.daqua,
  });
  factory DetailMyCourse.fromJson(Map<String, dynamic> json) {
    return DetailMyCourse(
      id: json["value"]["id"] ?? '',
      alias: json["value"]["alias"] ?? '',
      name: json["value"]["name"] ?? '',
      img: json["value"]["img"] ?? '',
      settingCourseTypeId: json["value"]["setting_course_type_id"] ?? '',
      courseScheduleId: json["value"]["course_schedule_id"] ?? '',
      saptoi: ((json['sap_toi'] as List)
          .map((e) => DetailCourse.fromJson(e))
          .toList()),
      daqua: ((json['da_qua'] as List)
          .map((e) => DetailCourse.fromJson(e))
          .toList()),
    );
  }
}

class DetailCourse {
  final String id;
  final String name;
  final String teachingContent;
  final DateTime day;
  final String time;
  final String teacherName;
  final String phongHoc;
  final String cosoName;
  final String cosoAddress;
  final String? ccsmslId;
  final String? reason;
  DetailCourse({
    required this.id,
    required this.name,
    required this.teachingContent,
    required this.day,
    required this.time,
    required this.teacherName,
    required this.phongHoc,
    required this.cosoName,
    required this.cosoAddress,
    required this.ccsmslId,
    required this.reason,
  });
  factory DetailCourse.fromJson(Map<String, dynamic> json) {
    return DetailCourse(
      id: json["id"] ?? '',
      name: json["name"] ?? '',
      teachingContent: json["teaching_content"] ?? '',
      day: DateFormat("yyyy-MM-dd").parse(json["day"] ?? ''),
      time: json["time"] ?? '',
      teacherName: json["teachers_full_name"] ?? '',
      phongHoc: json["phong_hoc"] ?? '',
      cosoName: json["coso_name"] ?? '',
      cosoAddress: json["coso_address"] ?? '',
      ccsmslId: json["ccsmsl_id"],
      reason: json["reason"],
    );
  }
}

class DetailBaoCaoModel {
  final int chuyenCan;
  final int baiTap;
  final String teacherId;
  final String fullName;
  final String content;
  final List<ReviewDetailModels> monthlyReview;
  DetailBaoCaoModel({
    required this.chuyenCan,
    required this.baiTap,
    required this.teacherId,
    required this.fullName,
    required this.content,
    required this.monthlyReview,
  });
  factory DetailBaoCaoModel.fromJson(Map<String, dynamic> json) {
    return DetailBaoCaoModel(
      chuyenCan: json['cc'] ?? '',
      baiTap: json['bt'] ?? '',
      teacherId: json['chat']['teachers_id'],
      fullName: json['chat']['full_name'],
      content: json['chat']['content'],
      monthlyReview: (json['value'] as List)
          .map((e) => ReviewDetailModels.fromJson(e))
          .toList(),
    );
  }
}

class MycourseBaiTapModel {
  final String scheduleId;
  final List<BaiTapValueModel> value;
  MycourseBaiTapModel({
    required this.scheduleId,
    required this.value,
  });
  factory MycourseBaiTapModel.fromJson(Map<String, dynamic> json) {
    return MycourseBaiTapModel(
      scheduleId: json['customer_course_schedule_id'].toString(),
      value: (json['value'] as List)
          .map((e) => BaiTapValueModel.fromJson(e))
          .toList(),
    );
  }
}

class BaiTapValueModel {
  final String id;
  final String name;
  final DateTime timeDeadline;
  final String type;
  final String typeName;
  final int status;
  final String note;
  BaiTapValueModel({
    required this.id,
    required this.name,
    required this.timeDeadline,
    required this.type,
    required this.typeName,
    required this.status,
    required this.note,
  });
  factory BaiTapValueModel.fromJson(Map<String, dynamic> json) {
    return BaiTapValueModel(
      id: json['id'] ?? '',
      name: json['name'] ?? '',
      timeDeadline:
          DateFormat("yyyy-MM-dd hh:mm:ss").parse(json['time_deadline'] ?? ''),
      type: json['type'] ?? '',
      typeName: json['type_name'] ?? '',
      status: int.tryParse(json['status'].toString()) ?? 0,
      note: json['note'] ?? '',
    );
  }
}

class InfoBuoiHoc {
  final String typeLearn;
  final String createdDate;
  final String phongHocName;
  final String cosoName;
  final String name;
  final String lessonTopic;
  final String meetingId;
  final String content;
  final String linkLearn;
  final String gvStatus;
  final String checkinOffId;

  InfoBuoiHoc({
    required this.typeLearn,
    required this.createdDate,
    required this.phongHocName,
    required this.cosoName,
    required this.name,
    required this.lessonTopic,
    required this.meetingId,
    required this.content,
    required this.linkLearn,
    required this.gvStatus,
    required this.checkinOffId,
  });
  factory InfoBuoiHoc.fromJson(Map<String, dynamic> json) {
    return InfoBuoiHoc(
      typeLearn: json['type_learn'] ?? '',
      createdDate: json['created_date'] ?? '',
      phongHocName: json['phonghoc_name'] ?? '',
      cosoName: json['coso_name'] ?? '',
      name: json['name'] ?? '',
      lessonTopic: json['lesson_topic'] ?? '',
      meetingId: json['meeting_id'] ?? '',
      content: json['content'] ?? 'Chưa có dữ liệu',
      linkLearn: json['link_learn'] ?? '',
      gvStatus: json['gv_status'] ?? '',
      checkinOffId: json['checkin_off_id'] ?? '',
    );
  }
}

class InfoClass {
  final String name;
  final String courseId;
  final String settingCourseTypeName;
  final String settingCourseTypeId;
  final String courseImg;
  final int percentLearning;
  InfoClass({
    required this.name,
    required this.courseId,
    required this.settingCourseTypeName,
    required this.settingCourseTypeId,
    required this.courseImg,
    required this.percentLearning,
  });
  factory InfoClass.fromJson(Map<String, dynamic> json) {
    return InfoClass(
      name: json['name'] ?? '',
      courseId: json['course_id'] ?? '',
      settingCourseTypeName: json['setting_course_type_name'] ?? '',
      settingCourseTypeId: json['setting_course_type_id'] ?? '',
      courseImg: json['course_img'] ?? '',
      percentLearning: json['percent_learning'] ?? 0,
    );
  }
}

class DetailClass {
  final InfoClass info;
  final int cntDaDienRa;
  final int cntChuaDienRa;
  final List<InfoBuoiHoc> daXayRa;
  final List<InfoBuoiHoc> chuaXayRa;
  DetailClass({
    required this.info,
    required this.cntDaDienRa,
    required this.cntChuaDienRa,
    required this.daXayRa,
    required this.chuaXayRa,
  });
  factory DetailClass.fromJson(Map<String, dynamic> json) {
    return DetailClass(
        info: InfoClass.fromJson(json['info'] ?? ''),
        cntDaDienRa: json['cnt_da_xay_ra'] ?? '',
        cntChuaDienRa: json['cnt_chua_xay_ra'] ?? '',
        daXayRa: ((json['da_xay_ra'] as List)
            .map((e) => InfoBuoiHoc.fromJson(e))
            .toList()),
        chuaXayRa: ((json['chua_xay_ra'] as List)
            .map((e) => InfoBuoiHoc.fromJson(e))
            .toList()));
  }
}
