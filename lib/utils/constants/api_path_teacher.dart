class ApiPathTeacher {
  static const String baseUrl = 'https://lms.kiddo.hvg.edu.vn/';
  static const String teachersUrl = '${baseUrl}api/teacher';
  //api về đăng nhập, các thông tin của học sinh
  static const String refreshToken = '$teachersUrl/refresh-token';
  static const String login = '${baseUrl}api/login/teacher';

  //api điểm danh
  static const String listStudent = '$teachersUrl/class/buoi_hoc/hoc_vien';
  static const String updateTT = '$teachersUrl/class/buoi_hoc/update_status';

  static const String attitude = '$teachersUrl/class/buoi_hoc/thai_do';
  static const String updateAttitude =
      '$teachersUrl/class/buoi_hoc/thai_do_update_status';

  static const String situation = '$teachersUrl/class/buoi_hoc/tinh_hinh';
  static const String updateSituation =
      '$teachersUrl/class/buoi_hoc/tinh_hinh_update_status';
  static const String updatePhuDao = '$teachersUrl/class/phu_dao/update_status';
  static const String updateXepBu = '$teachersUrl/class/xep_bu/update_status';
  // danh sách lớp
  static const String listClass = '$teachersUrl/class';
  static const String lessonByClass = '$teachersUrl/class/buoi_hoc';

  //api nhận xét
  static const String feedbackmidterm = '$teachersUrl/class/nhan_xet/giua_ky';
  static const String feedbackendterm = '$teachersUrl/class/nhan_xet/cuoi_ky';

  static const String baoCao = '$teachersUrl/class/bao_cao';
  static const String baoCaoChiTiet = '$teachersUrl/class/bao_cao/gio_day';

  //lịch học
  static const String teachingSchedule = '$teachersUrl/schedule';
  //lịch hẹn
  static const String appointment = '$teachersUrl/appointment';

  static const String category = '$baseUrl/api/category';
  static const String detailBaiViet = '$baseUrl/api/category/detail';

  static const String info = '$teachersUrl/info';

  //api danh sách lớp học theo loại
  static const String listOffClass = '$teachersUrl/class/off';
  static const String listZoomClass = '$teachersUrl/class/zoom';
  static const String listPhuDaoClass = '$teachersUrl/class/phu_dao';
  static const String listXepBuClass = '$teachersUrl/class/xep_bu';

  static const String listEventCheckinOff =
      '$teachersUrl/class/event_checkin_off';
  static const String listBaoCao =
      '$teachersUrl/class/event_checkin_off/report';

  static const String detailsClass = '$teachersUrl/lop-hoc/detail';
  static const String feedBack = '$teachersUrl/class/feedback';
  static const String gopY = '$teachersUrl/class/gop_y';
  //api chi tiet bai tap, de thi
  static const String detailsExam =
      '$teachersUrl/lop-hoc/detail/buoi_hoc/detail_bai_tap_de_thi';
  //Thông tin và đổi thông tin học viên
  static const String profile = '$teachersUrl/profile';
  //api thông báo
  static const String notification = '$teachersUrl/notification';
  //lich-day
  static const String lichDay = '$teachersUrl/lich-day';
}
