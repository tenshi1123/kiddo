class TeacherHomeModel {
  final List<LichHocModel> lichhoc;
  final List<LichHenModel> lichhen;
  TeacherHomeModel({
    required this.lichhoc,
    required this.lichhen,
  });
  factory TeacherHomeModel.fromJson(Map<String, dynamic> json) {
    return TeacherHomeModel(
      lichhoc: (json['data_lich_hoc'] as List)
          .map((data) => LichHocModel.fromJson(data))
          .toList(),
      lichhen: (json['lich_hen'] as List)
          .map((data) => LichHenModel.fromJson(data))
          .toList(),
    );
  }
}

class LichHocModel {
  final String id;
  final String name;
  final String courseScheduleId;
  final String courseScheduleName;
  final DateTime day;
  final String dayOfWeek;
  final String time;
  final String phongHoc;
  final String coSo;
  final String type;
  final String noidung;
  LichHocModel({
    required this.id,
    required this.name,
    required this.courseScheduleId,
    required this.courseScheduleName,
    required this.day,
    required this.dayOfWeek,
    required this.time,
    required this.phongHoc,
    required this.coSo,
    required this.type,
    required this.noidung,
  });
  factory LichHocModel.fromJson(Map<String, dynamic> json) {
    return LichHocModel(
      id: json['id'] ?? '',
      name: json['name'] ?? '',
      courseScheduleId: json['course_schedule_id'] ?? '',
      courseScheduleName: json['course_schedule_name'] ?? '',
      day: DateTime.parse(json['day'] ?? ''),
      dayOfWeek: json['day_of_week'] ?? '',
      time: json['time'] ?? '',
      phongHoc: json['phong_hoc'] ?? '',
      coSo: json['coso'] ?? '',
      type: json['type'] ?? '',
      noidung: json['noi_dung_buoi_hoc'] ?? '',
    );
  }
}

class LichHenModel {
  final String cosoName;
  final String address;
  final String fullName;
  final String phone;
  final String email;
  final String userName;
  final String teacherName;
  final String id;
  final DateTime appointmentDate;
  LichHenModel({
    required this.cosoName,
    required this.address,
    required this.fullName,
    required this.phone,
    required this.email,
    required this.userName,
    required this.teacherName,
    required this.id,
    required this.appointmentDate,
  });
  factory LichHenModel.fromJson(Map<String, dynamic> json) {
    return LichHenModel(
      cosoName: json['coso_name'] ?? '',
      address: json['address'] ?? '',
      fullName: json['full_name'] ?? '',
      phone: json['phone'] ?? '',
      email: json['email'] ?? '',
      userName: json['user_name'] ?? '',
      teacherName: json['teachers_full_name'] ?? '',
      id: json['id'] ?? '',
      appointmentDate: DateTime.parse(json['appointment_date'] ?? ''),
    );
  }
}

class TeacherProfileModel {
  final String id;
  final String fullName;
  final String phone;
  final String email;
  final String dob;
  final String avatar;

  TeacherProfileModel({
    required this.id,
    required this.fullName,
    required this.phone,
    required this.email,
    required this.dob,
    required this.avatar,
  });
  factory TeacherProfileModel.fromJson(Map<String, dynamic> json) {
    return TeacherProfileModel(
      id: json['id'] ?? '',
      fullName: json['full_name'] ?? '',
      phone: json['phone'] ?? '',
      email: json['email'] ?? '',
      dob: json['dob'] ?? '',
      avatar: json['avatar'] ?? '',
    );
  }
}
