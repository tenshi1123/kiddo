class StudentHomeModel {
  final CustomerInfoModel customerInfoModel;
  final String totalCourse;
  final String chuyenCan;
  final List<CalendarModel> lichHocSapToi;
  final List<CourseModels> listCourse;
  StudentHomeModel({
    required this.customerInfoModel,
    required this.totalCourse,
    required this.chuyenCan,
    required this.lichHocSapToi,
    required this.listCourse,
  });
  factory StudentHomeModel.fromJson(Map<String, dynamic> json) {
    return StudentHomeModel(
      customerInfoModel: CustomerInfoModel.fromJson(json['customer']),
      totalCourse: json['total_course'] ?? '',
      chuyenCan: json['chuyen_can'] ?? '',
      lichHocSapToi: [
        for (var item in json['lich_hoc_sap_toi']) CalendarModel.fromJson(item)
      ],
      listCourse: [
        for (var item in json['course']) CourseModels.fromJson(item)
      ],
    );
  }
}

class CourseModels {
  final String categoryName;
  final String id;
  final String name;
  final String slug;
  final String img;
  final String soBuoiHoc;
  CourseModels({
    required this.categoryName,
    required this.id,
    required this.name,
    required this.slug,
    required this.img,
    required this.soBuoiHoc,
  });
  factory CourseModels.fromJson(Map<String, dynamic> json) {
    return CourseModels(
      categoryName: json['category_name'] ?? '',
      id: json['id'] ?? '',
      name: json['name'] ?? '',
      slug: json['slug'] ?? '',
      img: json['img'] ?? '',
      soBuoiHoc: json['so_buoi_hoc'] ?? '',
    );
  }
}

class CustomerInfoModel {
  final String id;
  final String code;
  final String fullName;
  final String phone;
  final String email;
  final String gender;
  final String dob;
  final String img;
  final String schoolName;
  final String address;
  final String targetIelts;

  CustomerInfoModel({
    required this.id,
    required this.code,
    required this.fullName,
    required this.phone,
    required this.email,
    required this.gender,
    required this.dob,
    required this.img,
    required this.schoolName,
    required this.address,
    required this.targetIelts,
  });
  factory CustomerInfoModel.fromJson(Map<String, dynamic> json) {
    return CustomerInfoModel(
      id: json['id'] ?? 'Không có dữ liệu',
      code: json['code'] ?? 'Không có dữ liệu',
      fullName: json['full_name'] ?? 'Không có dữ liệu',
      phone: json['phone'] ?? 'Không có dữ liệu',
      email: json['email'] ?? 'Không có dữ liệu',
      gender: json['gender'] ?? 'Không có dữ liệu',
      dob: json['dob'] ?? 'Không có dữ liệu',
      img: json['img'] ?? 'Không có dữ liệu',
      schoolName: json['school_name'] ?? 'Không có dữ liệu',
      address: json['address'] ?? 'Không có dữ liệu',
      targetIelts: json['target_ielts'] ?? 'Không có dữ liệu',
    );
  }
}

class CalendarModel {
  final String id;
  final String courseScheduleAlias;
  final DateTime day;
  final String name;
  final String timeStart;
  final String timeEnd;
  final String cosoAddress;
  final String phongHocName;
  final String? ccsmslId;
  final String? reason;
  final String teacherName;
  final String teacherAvatar;
  final String type;
  final String status;
  CalendarModel({
    required this.id,
    required this.courseScheduleAlias,
    required this.day,
    required this.name,
    required this.timeStart,
    required this.timeEnd,
    required this.cosoAddress,
    required this.phongHocName,
    required this.ccsmslId,
    required this.reason,
    required this.teacherName,
    required this.teacherAvatar,
    required this.type,
    required this.status,
  });
  factory CalendarModel.fromJson(Map<String, dynamic> json) {
    return CalendarModel(
      id: json["id"] ?? '',
      courseScheduleAlias: json["course_schedule_alias"] ?? '',
      day: DateTime.parse(json["day"]),
      name: json["name"] ?? '',
      timeStart: json["time_start"] ?? '',
      timeEnd: json["time_end"] ?? '',
      cosoAddress: json["coso_address"] ?? '',
      phongHocName: json['phonghoc_name'] ?? '',
      ccsmslId: json["ccsmsl_id"],
      reason: json["reason"],
      teacherName: json['teachers_full_name'] ?? '',
      teacherAvatar: json['teachers_avatar'] ?? '',
      type: json['type'] ?? '',
      status: json['status'] ?? '',
    );
  }
}

class DetailRcmCourse {
  final RecommentCourseModel recommentCourse;
  final List<LichKhaiGiangModel> listLichKhaiGiang;
  DetailRcmCourse({
    required this.recommentCourse,
    required this.listLichKhaiGiang,
  });
  factory DetailRcmCourse.fromJson(Map<String, dynamic> json) {
    return DetailRcmCourse(
        recommentCourse: RecommentCourseModel.fromJson(json["value"]),
        listLichKhaiGiang: (json["lich_khai_giang"] as List)
            .map((e) => LichKhaiGiangModel.fromJson(e))
            .toList());
  }
}

class RecommentCourseModel {
  final String categoryName;
  final String soBuoiHoc;
  final String id;
  final String name;
  final String img;
  final String price;
  final String priceOld;
  final String descriptioin;
  final String benefits;
  final String content;
  final String urlYoutube;
  final int daDangKy;
  RecommentCourseModel({
    required this.categoryName,
    required this.soBuoiHoc,
    required this.id,
    required this.name,
    required this.img,
    required this.price,
    required this.priceOld,
    required this.descriptioin,
    required this.benefits,
    required this.content,
    required this.urlYoutube,
    required this.daDangKy,
  });
  factory RecommentCourseModel.fromJson(Map<String, dynamic> json) {
    return RecommentCourseModel(
      categoryName: json['category_name'] ?? '',
      soBuoiHoc: json['so_buoi_hoc'] ?? '',
      id: json['id'] ?? '',
      name: json['name'] ?? '',
      img: json['img'] ?? '',
      price: json['price'] ?? '',
      priceOld: json['price_old'] ?? '',
      descriptioin: json['description'] ?? '',
      benefits: json['benefits'] ?? '',
      content: json['content'] ?? '',
      urlYoutube: json['url_youtube'] ?? "",
      daDangKy: json['da_dang_ky'] ?? 0,
    );
  }
}

class LichKhaiGiangModel {
  final String name;
  final String alias;
  final String dateStart;
  final String cosoName;
  final String cosoAddress;
  final String note;
  final String totalSlot;
  final String totalDk;
  LichKhaiGiangModel({
    required this.name,
    required this.alias,
    required this.dateStart,
    required this.cosoName,
    required this.cosoAddress,
    required this.note,
    required this.totalSlot,
    required this.totalDk,
  });
  factory LichKhaiGiangModel.fromJson(Map<String, dynamic> json) {
    return LichKhaiGiangModel(
      name: json["name"] ?? '',
      alias: json["alias"] ?? '',
      dateStart: json["date_start"] ?? '',
      cosoName: json["coso_name"] ?? '',
      cosoAddress: json["coso_address"] ?? '',
      note: json["note"] ?? '',
      totalSlot: json["total_slot"] ?? '',
      totalDk: json["total_dk"] ?? '',
    );
  }
}

class ChildrenModel {
  final String img;
  final String nameChild;
  final String token;
  final String refreshToken;

  ChildrenModel({
    required this.img,
    required this.nameChild,
    required this.token,
    required this.refreshToken,
  });
  factory ChildrenModel.fromJson(Map<String, dynamic> json) {
    return ChildrenModel(
      img: json["img"] ?? '',
      nameChild: json["name_child"] ?? '',
      token: json["token"] ?? '',
      refreshToken: json["refresh_token"] ?? '',
    );
  }
}
