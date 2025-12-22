class ApiPathTeacher {
  static String baseUrl = '';
  static String teachersUrl = '${baseUrl}api/teacher';
  //api về đăng nhập, các thông tin của học sinh
  static String refreshToken = '$teachersUrl/refresh-token';
  static String login = '${baseUrl}api/login/teacher';

  //api điểm danh
  static String listStudent = '$teachersUrl/class/buoi_hoc/hoc_vien';
  static String updateTT = '$teachersUrl/class/buoi_hoc/update_status';

  static String attitude = '$teachersUrl/class/buoi_hoc/thai_do';
  static String updateAttitude =
      '$teachersUrl/class/buoi_hoc/thai_do_update_status';

  static String situation = '$teachersUrl/class/buoi_hoc/tinh_hinh';
  static String updateSituation =
      '$teachersUrl/class/buoi_hoc/tinh_hinh_update_status';
  static String updatePhuDao = '$teachersUrl/class/phu_dao/update_status';
  static String updateXepBu = '$teachersUrl/class/xep_bu/update_status';
  // danh sách lớp
  static String listClass = '$teachersUrl/class';
  static String lessonByClass = '$teachersUrl/class/buoi_hoc';

  //api nhận xét
  static String feedbackmidterm = '$teachersUrl/class/nhan_xet/giua_ky';
  static String feedbackendterm = '$teachersUrl/class/nhan_xet/cuoi_ky';

  static String baoCao = '$teachersUrl/class/bao_cao';
  static String baoCaoChiTiet = '$teachersUrl/class/bao_cao/gio_day';

  //lịch học
  static String teachingSchedule = '$teachersUrl/schedule';
  //lịch hẹn
  static String appointment = '$teachersUrl/appointment';

  static String category = '$baseUrl/api/category';
  static String detailBaiViet = '$baseUrl/api/category/detail';

  static String info = '$teachersUrl/info';

  //api danh sách lớp học theo loại
  static String listOffClass = '$teachersUrl/class/off';
  static String listZoomClass = '$teachersUrl/class/zoom';
  static String listPhuDaoClass = '$teachersUrl/class/phu_dao';
  static String listXepBuClass = '$teachersUrl/class/xep_bu';

  static String listEventCheckinOff = '$teachersUrl/class/event_checkin_off';
  static String listBaoCao = '$teachersUrl/class/event_checkin_off/report';

  // thao tác với tài liệu
  static String listTaiLieu = '$teachersUrl/class/event_checkin_off/document';
  static String uploadTaiLieu =
      '$teachersUrl/class/event_checkin_off/document_add';
  static String deleteTaiLieu =
      '$teachersUrl/class/event_checkin_off/document_edit';
  static String editTaiLieu =
      '$teachersUrl/class/event_checkin_off/document_delete';

  static String detailsClass = '$teachersUrl/lop-hoc/detail';
  static String feedBack = '$teachersUrl/class/feedback';
  static String gopY = '$teachersUrl/class/gop_y';
  //api chi tiet bai tap, de thi
  static String detailsExam =
      '$teachersUrl/lop-hoc/detail/buoi_hoc/detail_bai_tap_de_thi';
  //Thông tin và đổi thông tin học viên
  static String profile = '$teachersUrl/profile';
  //api thông báo
  static String notification = '$teachersUrl/notification';
  //lich-day
  static String lichDay = '$teachersUrl/lich-day';
  //danh sách tài liệu
  static String listDocument = '$teachersUrl/class/event_checkin_off/document';
}
