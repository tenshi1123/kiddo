class ApiPath {
  //baseurl

  static String hocvienUrl = '';

  //api về đăng nhập, các thông tin của học sinh
  static String refreshToken = '$hocvienUrl/refresh_token/';
  static String login = '$hocvienUrl/login';

  //chat admin
  static String listAdminStudent = '$hocvienUrl/chat/user/customer';
  static String listAdminTeacher = '$hocvienUrl/chat/user/teacher';

  //Thông tin và đổi thông tin học viên
  static String profile = '$hocvienUrl/user/info';
  static String changePassword = '$hocvienUrl/profile/change_password';
  static String changeAvatar = '$hocvienUrl/change_avatar';
  static String userInfo = '$hocvienUrl/user/info';
  static String changeInfo = '$hocvienUrl/user/info/update';
  static String updateAvatar = '$hocvienUrl/user/update/avatar';

  //đăng nhập nhiều tài khoản
  static String multiCustomer = '$hocvienUrl/parents/children';

  //danh sách giáo viên
  static String lecture = '$hocvienUrl/chat/lecture';
  static String listMessage = '$hocvienUrl/chat/customer_user/message/list';
  static String sendMessage = '$hocvienUrl/chat/customer_user/message/send';
  static String listMessage2 = '$hocvienUrl/chat/lecturer_user/message/list';
  static String sendMessage2 = '$hocvienUrl/chat/lecturer_user/message/send';
  //Ưu đãi
  static String discount = '$hocvienUrl/discount';
  static String detailDiscount = '$hocvienUrl/discount/detail';
  //Lấy danh sách danh mục
  static String category = '$hocvienUrl/category';
  static String library = '$hocvienUrl/category/detail';
  // lịch học
  static String listSchedule = '$hocvienUrl/schedule';
  //class
  static String apiClass = '$hocvienUrl/class';
  static String detailClass = '$hocvienUrl/class/detail';
  //Danh sách tin tức
  static String post = '$hocvienUrl/post';
  static String postDetail = '$hocvienUrl/post/detail';

  //Danh sách khóa học video
  static String listLessonVideo = '$hocvienUrl/lesson';
  //Danh sách Topical
  static String listTopical = '$hocvienUrl/lesson/topical';
  //Danh sách bài giảng
  static String listLecture = '$hocvienUrl/lesson/topical/video';
  //Chi tiết 1 video
  static String detailLesson = '$hocvienUrl/lesson/topical/video/detail';
  static String updateTime = '$hocvienUrl/lesson/topical/video/update_time';
  //Diem danh
  static String diemDanh = '$hocvienUrl/checkin';
  static String detailDiemdanh = '$hocvienUrl/detail_diem_danh';
  static String notification = '$hocvienUrl/notification';
  static String chat = '$hocvienUrl/chat';
  static String teacherChat = 'api/teachers/chat';
  static String chatTeacherCustomer = '$hocvienUrl/chat_teachers_customer';
  static String chatTeacher = '$hocvienUrl/chat_messages';
  static String sendImageMessage = '$hocvienUrl/send_chat_img';
  static String listTeachers = '$hocvienUrl/list_teachers';
  //Lịch thi
  static String offlineExamSchedule = '$hocvienUrl/offline_exam_schedule';
  static String changeCoso = '$offlineExamSchedule/change_coso';
  static String changeDay = '$offlineExamSchedule/change_day';
  static String dangKyThi = '$offlineExamSchedule/dang_ky';

  //Bài tập + báo báo cáo học tập + feedback
  static String baiTap = '$hocvienUrl/homework';
  static String detailBaiTap = '$hocvienUrl/mycourse/detail_exercise';
  static String reportExercise = '$hocvienUrl/bao_cao_hoc_tap';
  static String listFeedback = '$hocvienUrl/feedback';
  static String detailsFeedback = '$hocvienUrl/detail_danh_gia';
  static String policy = '$hocvienUrl/policy';
  //Khóa học của tôi khoa hoc
  static String myCourse = '$hocvienUrl/mycourse';
  static String detailMyCourse = '$myCourse/detail';
  static String detailBaoCao = '$myCourse/detail/bao_cao';
  static String myCoursedetailBaiTap = '$myCourse/detail/bai_tap';
  //Chi tiet khoa hoc
  static String coureDetail = '$hocvienUrl/course/detail';
  //Xin nghi
  static String xinNghi = '$hocvienUrl/student/leave';
  //Buổi học
  static String detailBuoihoc = '$apiClass/detail/buoi_hoc';
  static String uploadBtvn = '$apiClass/detail/buoi_hoc/upload';
  static String submitExeTL = '$myCourse/submit_exercise_tu_luan';
  static String submitTracNghiem = '$myCourse/nop_bai_trac_nghiem';
  static String viewTracNghiem = '$myCourse/view_trac_nghiem';
  static String viewTestDone = '$myCourse/xem_lai_bai_trac_nghiem';
  //quà tặng
  static String gift = '$hocvienUrl/gift';
  static String giftChange = '$hocvienUrl/gift/change';
  //payment
  static String payment = '$hocvienUrl/paymented';
  static String payment2 = '$hocvienUrl/payment';
  static String detailPayment = '$hocvienUrl/payment/detail';
  static String uploadTransaction =
      '$hocvienUrl/payment/upload_transaction_transfer';
  //mời bạn
  static String inviteFriend = '$hocvienUrl/invite-friend';
  //push onesignal
  static String pushOnesignal = '$hocvienUrl/onesignal';
  //api do oneSignal cung cấp
  // static  String oneSignal =
  //     'https://api.onesignal.com/notifications?app_id=1f643336-9d73-4c65-ac00-38d499b8c462';
}
