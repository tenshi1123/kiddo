import 'package:intl/intl.dart';

class InfoClassModel {
  final String courseName;
  final String courseId;
  final String courseScheduleName;
  final String customerScheduleId;
  final String courseImg;
  final String scheduleId;
  final String typeId;
  final String typeName;
  final String typeType;
  final String zoomOfflineId;
  InfoClassModel({
    required this.courseName,
    required this.courseId,
    required this.courseScheduleName,
    required this.customerScheduleId,
    required this.courseImg,
    required this.scheduleId,
    required this.typeId,
    required this.typeName,
    required this.typeType,
    required this.zoomOfflineId,
  });
  factory InfoClassModel.fromJson(Map<String, dynamic> json) {
    return InfoClassModel(
      courseName: json['course_name'].replaceAll(RegExp(r'&amp;'), '&') ?? '',
      courseId: json['course_id'] ?? '',
      courseScheduleName:
          json['course_schedule_name'].replaceAll(RegExp(r'&amp;'), '&') ??
              '' ??
              '',
      customerScheduleId: json['customer_course_schedule_id'] ?? '',
      courseImg: json['course_img'] ?? '',
      scheduleId: json['course_schedule_id'] ?? '',
      typeId: json['setting_course_type_id'] ?? '',
      typeName: json['setting_course_type_name'] ?? '',
      typeType: json['setting_course_type_type'] ?? '',
      zoomOfflineId: json['customer_zoom_google_offline_id'] ?? '',
    );
  }
}

class ClassDetailModel {
  final DetailClassModel detailClassModel;
  final List<InfoLessonModel> listLesson;
  ClassDetailModel({
    required this.detailClassModel,
    required this.listLesson,
  });
  factory ClassDetailModel.fromJson(Map<String, dynamic> json) {
    return ClassDetailModel(
      detailClassModel: DetailClassModel.fromJson(json['info']),
      listLesson: ((json['class'] as List)
          .map((e) => InfoLessonModel.fromJson(e))
          .toList()),
    );
  }
}

class RefeeModel {
  final String nameCourse;
  final String courseScheduleName;
  final String courseScheduleAlias;
  final String goiPhi;
  final int feeAfterDiscount;
  final int feeOriginal;
  final int soBuoiHoc;
  final String note;
  final String expiryDate;
  final String createdAt;
  RefeeModel({
    required this.nameCourse,
    required this.courseScheduleName,
    required this.courseScheduleAlias,
    required this.goiPhi,
    required this.feeAfterDiscount,
    required this.feeOriginal,
    required this.soBuoiHoc,
    required this.note,
    required this.expiryDate,
    required this.createdAt,
  });
  factory RefeeModel.fromJson(Map<String, dynamic> json) {
    return RefeeModel(
      nameCourse: json['name_course'] ?? '',
      courseScheduleName: json['course_schedule_name'] ?? '',
      courseScheduleAlias: json['course_schedule_alias'] ?? '',
      goiPhi: json['goi_phi'] ?? '',
      feeAfterDiscount: int.tryParse(json['fee_after_discount'] ?? '') ?? 0,
      feeOriginal: int.tryParse(json['fee_oringal'] ?? '') ?? 0,
      soBuoiHoc: int.tryParse(json['so_buoi_hoc'] ?? '') ?? 0,
      note: json['note'] ?? '',
      expiryDate: json['expiry_date'] ?? '',
      createdAt: json['created_at'] ?? '',
    );
  }
}

class InfoLessonModel {
  final String typeLearn;
  final DateTime createdDate;
  final String phonghocName;
  final String cosoName;
  final String name;
  final String topic;
  final String gvStatus;
  final String checkId;
  final String leaveId;
  final String leaveReason;
  final String leaveCreateAt;
  final String meetingId;
  InfoLessonModel({
    required this.typeLearn,
    required this.createdDate,
    required this.phonghocName,
    required this.cosoName,
    required this.name,
    required this.topic,
    required this.gvStatus,
    required this.checkId,
    required this.leaveId,
    required this.leaveReason,
    required this.leaveCreateAt,
    required this.meetingId,
  });
  factory InfoLessonModel.fromJson(Map<String, dynamic> json) {
    return InfoLessonModel(
      typeLearn: json['type_learn'] ?? '',
      createdDate: DateFormat("dd-MM-yyyy").parse(json['created_date'] ?? ''),
      phonghocName: json['phonghoc_name'] ?? '',
      cosoName: json['coso_name'] ?? '',
      name: json['name'] ?? '',
      topic: json['topic'] ?? '',
      gvStatus: json['gv_status'] ?? '',
      checkId: json['checkin_off_id'] ?? '',
      leaveId: json['customer_leave_id'] ?? '',
      leaveReason: json['customer_leave_reason'] ?? '',
      leaveCreateAt: json['customer_leave_created_at'] ?? '',
      meetingId: json['meeting_id'] ?? '',
    );
  }
}

class DetailClassModel {
  final String name;
  final String courseId;
  final String settingCourseTypeName;
  final String settingCourseTypeId;
  final String courseImg;
  final int percentLearning;
  DetailClassModel({
    required this.name,
    required this.courseId,
    required this.settingCourseTypeName,
    required this.settingCourseTypeId,
    required this.courseImg,
    required this.percentLearning,
  });
  factory DetailClassModel.fromJson(Map<String, dynamic> json) {
    return DetailClassModel(
      name: json['name'].replaceAll(RegExp(r'&amp;'), '&') ?? '',
      courseId: json['course_id'] ?? '',
      settingCourseTypeName: json['setting_course_type_name'] ?? '',
      settingCourseTypeId: json['setting_course_type_id'] ?? '',
      courseImg: json['course_img'] ?? '',
      percentLearning: json['percent_learning'] ?? '',
    );
  }
}

class TopicalModel {
  final String topicalId;
  final String nameTopical;
  final String courseId;
  final String settingCourseTypeId;
  final String numLLessson;

  TopicalModel({
    required this.topicalId,
    required this.nameTopical,
    required this.courseId,
    required this.settingCourseTypeId,
    required this.numLLessson,
  });
  factory TopicalModel.fromJson(Map<String, dynamic> json) {
    return TopicalModel(
      topicalId: json['topical_id'] ?? '',
      nameTopical: json['name_topical'] ?? '',
      courseId: json['course_id'] ?? '',
      settingCourseTypeId: json['setting_course_type_id'] ?? '',
      numLLessson: json['num_lessson'] ?? '0',
    );
  }
}

class CourseVideoModel {
  final DetailClassModel detailClassModel;
  final List<TopicalModel> listTopical;
  CourseVideoModel({
    required this.detailClassModel,
    required this.listTopical,
  });
  factory CourseVideoModel.fromJson(Map<String, dynamic> json) {
    return CourseVideoModel(
      detailClassModel: DetailClassModel.fromJson(json['info']),
      listTopical: ((json['topical'] as List)
          .map((e) => TopicalModel.fromJson(e))
          .toList()),
    );
  }
}

class LessonVideoModel {
  final String lessonsId;
  final String lessonType;
  final String settingCourseTypeId;
  final String name;
  final String time;
  final String isTrial;
  final String documentFilesActive;
  final String type;
  final String link;
  final List<DocumentModel> document;

  LessonVideoModel({
    required this.lessonsId,
    required this.lessonType,
    required this.settingCourseTypeId,
    required this.name,
    required this.time,
    required this.isTrial,
    required this.documentFilesActive,
    required this.type,
    required this.link,
    required this.document,
  });

  factory LessonVideoModel.fromJson(Map<String, dynamic> json) {
    // 2. Ép kiểu và map danh sách document an toàn
    var documentList = json['document'] as List? ?? [];
    List<DocumentModel> parsedDocuments = documentList
        .map((docJson) =>
            DocumentModel.fromJson(docJson as Map<String, dynamic>))
        .toList();

    return LessonVideoModel(
      lessonsId: json['lessons_id'] ?? '',
      lessonType: json['lesson_type'] ?? '',
      settingCourseTypeId: json['setting_course_type_id'] ?? '',
      name: json['name'] ?? '',
      time: json['time'] ?? '',
      isTrial: json['is_trial'] ?? '',
      documentFilesActive: json['document_files_active'] ?? '',
      type: json['type'] ?? '',
      link: json['link_webview'] ??
          '', // Lưu ý: JSON của bạn không có 'link_webview' ở tầng này, nếu bị null nó sẽ lấy ''
      document: parsedDocuments,
    );
  }
}

class DocumentModel {
  final String id;
  final String type;
  final String link;
  final String name;
  final String linkWebView;

  DocumentModel({
    required this.id,
    required this.type,
    required this.link,
    required this.name,
    required this.linkWebView,
  });

  factory DocumentModel.fromJson(Map<String, dynamic> json) {
    return DocumentModel(
      id: json['id'] ?? '',
      type: json['type'] ?? '',
      link: json['link'] ?? '',
      name: json['name'] ?? '',
      linkWebView: json['link_webview'] ?? '',
    );
  }
}

class BunnyModel {
  final String lessonsId;
  final int idBunny;
  final String streamingUrl;
  final int customerTrackWithVideoId;
  BunnyModel({
    required this.lessonsId,
    required this.idBunny,
    required this.streamingUrl,
    required this.customerTrackWithVideoId,
  });
  factory BunnyModel.fromJson(Map<String, dynamic> json) {
    return BunnyModel(
      lessonsId: json['lessons_id'] ?? '',
      idBunny: int.parse(json['id_bunny'] ?? 0),
      streamingUrl: json['streaming_url'] ?? '',
      customerTrackWithVideoId: json['customer_track_with_video_id'] ?? '',
    );
  }
}
