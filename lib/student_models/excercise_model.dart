import 'dart:convert';

class QuestionGroupModel {
  final String id;
  final String examDetailQuestionId;
  final String title;
  final String content;
  final String videoAttachment;
  final String audioAttachment;
  final String questions;
  final String type;
  final String answer;
  final Map<String, SubQuestionModel> value;

  QuestionGroupModel({
    required this.id,
    required this.examDetailQuestionId,
    required this.title,
    required this.content,
    required this.videoAttachment,
    required this.audioAttachment,
    required this.questions,
    required this.type,
    required this.answer,
    required this.value,
  });

  factory QuestionGroupModel.fromJson(Map<String, dynamic> json) {
    return QuestionGroupModel(
      id: json['id'] ?? '',
      examDetailQuestionId: json['exam_detail_question_id'] ?? '',
      title: json['title'] ?? '',
      content: json['content'] ?? '',
      videoAttachment: json['video_attachment'] ?? '',
      audioAttachment: json['audio_attachment'] ?? '',
      questions: json['questions'] ?? '',
      type: json['type'] ?? '',
      answer: json['answer'] ?? '',
      value: (json['value'] as Map<String, dynamic>).map(
        (key, val) => MapEntry(key, SubQuestionModel.fromJson(val)),
      ),
    );
  }
}

class SubQuestionModel {
  final String id;
  final String examDetailQuestionId;
  final String title;
  final String content;
  final String mark;
  final String? videoAttachment;
  final String? audioAttachment;
  final List<QuestionChoice> choices;
  final String type;
  final String answer;

  SubQuestionModel({
    required this.id,
    required this.examDetailQuestionId,
    required this.title,
    required this.content,
    required this.mark,
    required this.videoAttachment,
    required this.audioAttachment,
    required this.choices,
    required this.type,
    required this.answer,
  });

  factory SubQuestionModel.fromJson(Map<String, dynamic> json) {
    final questionsRaw = json['questions'];
    List<QuestionChoice> parsedChoices = [];

    try {
      parsedChoices = (jsonDecode(questionsRaw) as List)
          .map((e) => QuestionChoice.fromJson(e))
          .toList();
    } catch (e) {
      // Nếu parse lỗi, để trống
      parsedChoices = [];
    }

    return SubQuestionModel(
      id: json['id'] ?? '',
      examDetailQuestionId: json['exam_detail_question_id'] ?? '',
      title: json['title'] ?? '',
      content: json['content'] ?? '',
      mark: json['mark'] ?? '0',
      videoAttachment: json['video_attachment'],
      audioAttachment: json['audio_attachment'],
      choices: parsedChoices,
      type: json['type'] ?? '',
      answer: json['answer'] ?? '',
    );
  }
}

class QuestionChoice {
  final String text;
  final int key;

  QuestionChoice({
    required this.text,
    required this.key,
  });

  factory QuestionChoice.fromJson(Map<String, dynamic> json) {
    return QuestionChoice(
      text: json['text'] ?? '',
      key: json['key'] ?? 0,
    );
  }
}

class HomeWorkModel {
  final String urlFileLesson;
  final String name;
  final String classLessonDocumentId;
  final String timeDeadline;
  final String daySubmit;
  final String note;
  final String nameTeacher;
  final String finalMark;
  final List<String> urlFileCustomer;
  final String isSubmitHomework;
  final String typeLearn;
  final String eventCheckinOffId;
  final String? nameBuoiHoc;
  HomeWorkModel({
    required this.urlFileLesson,
    required this.name,
    required this.classLessonDocumentId,
    required this.timeDeadline,
    required this.daySubmit,
    required this.note,
    required this.nameTeacher,
    required this.finalMark,
    required this.urlFileCustomer,
    required this.isSubmitHomework,
    required this.typeLearn,
    required this.eventCheckinOffId,
    this.nameBuoiHoc,
  });
  factory HomeWorkModel.fromJson(Map<String, dynamic> json) {
    return HomeWorkModel(
        urlFileLesson:
            json['url_file_lesson'] ?? json['course_schedule_img'] ?? '',
        name: json['name'] ?? json['name_homework'] ?? '',
        classLessonDocumentId: json['class_lesson_document_id'] ?? '',
        timeDeadline: json['time_deadline'] ?? 'Không có thời hạn',
        daySubmit: json['day_submit_homework'] ?? '',
        note: json['note'] ?? json['note_lecturers'] ?? 'Không có nhận xét',
        nameTeacher: json['name_teacher'] ?? '',
        finalMark: (json['final_mark'] ?? '0').toString(),
        urlFileCustomer: (json['url_file_customer'] ?? '').split('|||||'),
        isSubmitHomework: json['is_submit_homework'] ?? '',
        typeLearn: json['type_learn'] ?? '',
        eventCheckinOffId: json['event_checkin_off_id'] ?? '',
        nameBuoiHoc: json['name_buoi_hoc'] ?? '');
  }
}

class DocumentModel {
  final String courseScheduleImg;
  final String name;
  DocumentModel({
    required this.courseScheduleImg,
    required this.name,
  });
  factory DocumentModel.fromJson(Map<String, dynamic> json) {
    return DocumentModel(
      courseScheduleImg: json['course_schedule_img'] ?? '',
      name: json['name'] ?? '',
    );
  }
}

class FeedbackModel {
  final String content;
  final String nameBh;
  FeedbackModel({
    required this.content,
    required this.nameBh,
  });
  factory FeedbackModel.fromJson(Map<String, dynamic> json) {
    return FeedbackModel(
      content: json['content'] ?? '',
      nameBh: json['name_buoi_hoc'] ?? '',
    );
  }
}

class InfoLessonModel {
  final String namePhonghoc;
  final String cosoName;
  final String nameLesson;
  final String topic;
  final String lessonContent;
  InfoLessonModel({
    required this.namePhonghoc,
    required this.cosoName,
    required this.nameLesson,
    required this.topic,
    required this.lessonContent,
  });
  factory InfoLessonModel.fromJson(Map<String, dynamic> json) {
    return InfoLessonModel(
      namePhonghoc: json['name_phonghoc'] ?? '',
      cosoName: json['coso_name'] ?? '',
      nameLesson: json['name_lesson'] ?? '',
      topic: json['topic'] ?? '',
      lessonContent: json['lesson_content'] ?? 'Chưa có nội dung buổi học',
    );
  }
}

class DetailBuoiHocModel {
  final InfoLessonModel infoLesson;
  final List<HomeWorkModel> listHomeWork;
  final List<DocumentModel> listDocument;
  final List<FeedbackModel> listFeedBack;
  DetailBuoiHocModel({
    required this.infoLesson,
    required this.listHomeWork,
    required this.listDocument,
    required this.listFeedBack,
  });
  factory DetailBuoiHocModel.fromJson(Map<String, dynamic> json) {
    return DetailBuoiHocModel(
      infoLesson: InfoLessonModel.fromJson(json['info_lesson']),
      listHomeWork: (json['homework'] as List)
          .map((e) => HomeWorkModel.fromJson(e))
          .toList(),
      listDocument: (json['document'] as List)
          .map((e) => DocumentModel.fromJson(e))
          .toList(),
      listFeedBack: (json['feedback'] as List)
          .map((e) => FeedbackModel.fromJson(e))
          .toList(),
    );
  }
}
