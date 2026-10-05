import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_en.dart';
import 'app_localizations_vi.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
      : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations)!;
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
    delegate,
    GlobalMaterialLocalizations.delegate,
    GlobalCupertinoLocalizations.delegate,
    GlobalWidgetsLocalizations.delegate,
  ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('en'),
    Locale('vi')
  ];

  /// No description provided for @courseMaterials.
  ///
  /// In vi, this message translates to:
  /// **'Học liệu khoá học'**
  String get courseMaterials;

  /// No description provided for @wellcome.
  ///
  /// In vi, this message translates to:
  /// **'Chào mừng quay trở lại !'**
  String get wellcome;

  /// No description provided for @login.
  ///
  /// In vi, this message translates to:
  /// **'Đăng nhập'**
  String get login;

  /// No description provided for @logout.
  ///
  /// In vi, this message translates to:
  /// **'Đăng xuất'**
  String get logout;

  /// No description provided for @all.
  ///
  /// In vi, this message translates to:
  /// **'Tất cả'**
  String get all;

  /// No description provided for @studying.
  ///
  /// In vi, this message translates to:
  /// **'Đang học'**
  String get studying;

  /// No description provided for @complete.
  ///
  /// In vi, this message translates to:
  /// **'Hoàn thành'**
  String get complete;

  /// No description provided for @lesson.
  ///
  /// In vi, this message translates to:
  /// **'buổi'**
  String get lesson;

  /// No description provided for @requestingLeave.
  ///
  /// In vi, this message translates to:
  /// **'Xin nghỉ: '**
  String get requestingLeave;

  /// No description provided for @teacher.
  ///
  /// In vi, this message translates to:
  /// **'Giáo viên: '**
  String get teacher;

  /// No description provided for @classroom.
  ///
  /// In vi, this message translates to:
  /// **'Phòng học: '**
  String get classroom;

  /// No description provided for @branch.
  ///
  /// In vi, this message translates to:
  /// **'Chi nhánh: '**
  String get branch;

  /// No description provided for @currentPassword.
  ///
  /// In vi, this message translates to:
  /// **'Nhập mật khẩu hiện tại'**
  String get currentPassword;

  /// No description provided for @newPassword.
  ///
  /// In vi, this message translates to:
  /// **'Nhập mật khẩu mới'**
  String get newPassword;

  /// No description provided for @rePassword.
  ///
  /// In vi, this message translates to:
  /// **'Nhập lại mật khẩu'**
  String get rePassword;

  /// No description provided for @schedule.
  ///
  /// In vi, this message translates to:
  /// **'Lịch học'**
  String get schedule;

  /// No description provided for @assignments.
  ///
  /// In vi, this message translates to:
  /// **'Bài tập'**
  String get assignments;

  /// No description provided for @report.
  ///
  /// In vi, this message translates to:
  /// **'Báo cáo'**
  String get report;

  /// No description provided for @academicReport.
  ///
  /// In vi, this message translates to:
  /// **'Báo cáo học tập'**
  String get academicReport;

  /// No description provided for @enterAnswer.
  ///
  /// In vi, this message translates to:
  /// **'Nhập câu trả lời...'**
  String get enterAnswer;

  /// No description provided for @answer.
  ///
  /// In vi, this message translates to:
  /// **'Trả lời'**
  String get answer;

  /// No description provided for @rightAnswer.
  ///
  /// In vi, this message translates to:
  /// **'Đáp án đúng'**
  String get rightAnswer;

  /// No description provided for @selected.
  ///
  /// In vi, this message translates to:
  /// **'Đã chọn'**
  String get selected;

  /// No description provided for @gift.
  ///
  /// In vi, this message translates to:
  /// **'phần thưởng!'**
  String get gift;

  /// No description provided for @confirmExchange.
  ///
  /// In vi, this message translates to:
  /// **'Bạn xác nhận đổi'**
  String get confirmExchange;

  /// No description provided for @takeGift.
  ///
  /// In vi, this message translates to:
  /// **'Lấy phần quà'**
  String get takeGift;

  /// No description provided for @lessonDetails.
  ///
  /// In vi, this message translates to:
  /// **'Chi tiết buổi học'**
  String get lessonDetails;

  /// No description provided for @practicalEnglishwith.
  ///
  /// In vi, this message translates to:
  /// **'Tiếng anh thực chiến cùng '**
  String get practicalEnglishwith;

  /// No description provided for @buildingTheFoundation.
  ///
  /// In vi, this message translates to:
  /// **'Xây dựng nền tảng '**
  String get buildingTheFoundation;

  /// No description provided for @language.
  ///
  /// In vi, this message translates to:
  /// **'Ngôn ngữ'**
  String get language;

  /// No description provided for @steady.
  ///
  /// In vi, this message translates to:
  /// **' vững vàng'**
  String get steady;

  /// No description provided for @teachingStaff.
  ///
  /// In vi, this message translates to:
  /// **'Đội ngũ giáo viên '**
  String get teachingStaff;

  /// No description provided for @experienced.
  ///
  /// In vi, this message translates to:
  /// **'giàu kinh nghiệm'**
  String get experienced;

  /// No description provided for @enterReasonForLeave.
  ///
  /// In vi, this message translates to:
  /// **'Nhập lý do nghỉ'**
  String get enterReasonForLeave;

  /// No description provided for @openWeb.
  ///
  /// In vi, this message translates to:
  /// **'Mở trên web'**
  String get openWeb;

  /// No description provided for @cancel.
  ///
  /// In vi, this message translates to:
  /// **'Hủy'**
  String get cancel;

  /// No description provided for @confirm.
  ///
  /// In vi, this message translates to:
  /// **'Xác nhận'**
  String get confirm;

  /// No description provided for @profileInfo.
  ///
  /// In vi, this message translates to:
  /// **'Thông tin cá nhân'**
  String get profileInfo;

  /// No description provided for @profile.
  ///
  /// In vi, this message translates to:
  /// **'Cá nhân'**
  String get profile;

  /// No description provided for @accountInfo.
  ///
  /// In vi, this message translates to:
  /// **'Thông tin tài khoản'**
  String get accountInfo;

  /// No description provided for @messageSended.
  ///
  /// In vi, this message translates to:
  /// **'Tin nhắn đã được gửi'**
  String get messageSended;

  /// No description provided for @classCode.
  ///
  /// In vi, this message translates to:
  /// **'Mã lớp'**
  String get classCode;

  /// No description provided for @openingDate.
  ///
  /// In vi, this message translates to:
  /// **'Khai giảng'**
  String get openingDate;

  /// No description provided for @campus.
  ///
  /// In vi, this message translates to:
  /// **'Cơ sở'**
  String get campus;

  /// No description provided for @totalNumber.
  ///
  /// In vi, this message translates to:
  /// **'Tổng số chỗ'**
  String get totalNumber;

  /// No description provided for @registered.
  ///
  /// In vi, this message translates to:
  /// **'Đã đăng ký'**
  String get registered;

  /// No description provided for @attendanceDetails.
  ///
  /// In vi, this message translates to:
  /// **'Chi tiết điểm danh'**
  String get attendanceDetails;

  /// No description provided for @remainingTime.
  ///
  /// In vi, this message translates to:
  /// **'Thời gian còn lại'**
  String get remainingTime;

  /// No description provided for @submit.
  ///
  /// In vi, this message translates to:
  /// **'nộp bài'**
  String get submit;

  /// No description provided for @confirmSubmit.
  ///
  /// In vi, this message translates to:
  /// **'Bạn có chắc chắn muốn nộp bài'**
  String get confirmSubmit;

  /// No description provided for @agree.
  ///
  /// In vi, this message translates to:
  /// **'Đồng ý'**
  String get agree;

  /// No description provided for @notification.
  ///
  /// In vi, this message translates to:
  /// **'Thông báo'**
  String get notification;

  /// No description provided for @watchVideo.
  ///
  /// In vi, this message translates to:
  /// **'Xem video'**
  String get watchVideo;

  /// No description provided for @pleaseTryAgain.
  ///
  /// In vi, this message translates to:
  /// **'Vui lòng thử lại'**
  String get pleaseTryAgain;

  /// No description provided for @choseLanguage.
  ///
  /// In vi, this message translates to:
  /// **'Chọn ngôn ngữ'**
  String get choseLanguage;

  /// No description provided for @itisrecommended.
  ///
  /// In vi, this message translates to:
  /// **'Giải pháp đa nền tảng được tin dùng bởi +20,000 người dùng cuối'**
  String get itisrecommended;

  /// No description provided for @thaksforfunevent.
  ///
  /// In vi, this message translates to:
  /// **'Đáp ứng nhu cầu học tập đa dạng thông qua các \nchương trình học chuẩn quốc tế'**
  String get thaksforfunevent;

  /// No description provided for @withtimelynotification.
  ///
  /// In vi, this message translates to:
  /// **'Giáo trình được xây dựng và phát triển độc quyền\n bởi đội ngũ giáo viên kinh nghiệm dày dặn,\n năng động, nhiệt huyết.'**
  String get withtimelynotification;

  /// No description provided for @loginAsStudent.
  ///
  /// In vi, this message translates to:
  /// **'Đăng nhập với vai trò Học Sinh'**
  String get loginAsStudent;

  /// No description provided for @loginAsTeacher.
  ///
  /// In vi, this message translates to:
  /// **'Đăng nhập với vai trò Giáo viên'**
  String get loginAsTeacher;

  /// No description provided for @feeAndPay.
  ///
  /// In vi, this message translates to:
  /// **'Học phí và thanh toán'**
  String get feeAndPay;

  /// No description provided for @changePassword.
  ///
  /// In vi, this message translates to:
  /// **'Thay đổi mật khẩu'**
  String get changePassword;

  /// No description provided for @registerExam.
  ///
  /// In vi, this message translates to:
  /// **'Đăng kí thi thử tháng'**
  String get registerExam;

  /// No description provided for @course.
  ///
  /// In vi, this message translates to:
  /// **'Khóa học'**
  String get course;

  /// Chỉ là từ lớp thôi
  ///
  /// In vi, this message translates to:
  /// **'Lớp'**
  String get lophoc;

  /// No description provided for @saveChange.
  ///
  /// In vi, this message translates to:
  /// **'Lưu thay đổi'**
  String get saveChange;

  /// No description provided for @back.
  ///
  /// In vi, this message translates to:
  /// **'Quay lại'**
  String get back;

  /// No description provided for @dealine.
  ///
  /// In vi, this message translates to:
  /// **'Hạn nộp : '**
  String get dealine;

  /// No description provided for @see.
  ///
  /// In vi, this message translates to:
  /// **'xem'**
  String get see;

  /// No description provided for @yourCourse.
  ///
  /// In vi, this message translates to:
  /// **'Khóa học của bạn'**
  String get yourCourse;

  /// No description provided for @detail.
  ///
  /// In vi, this message translates to:
  /// **'Chi tiết'**
  String get detail;

  /// No description provided for @purchasedCourse.
  ///
  /// In vi, this message translates to:
  /// **'Khóa học đã mua'**
  String get purchasedCourse;

  /// No description provided for @attendance.
  ///
  /// In vi, this message translates to:
  /// **'Chuyên cần'**
  String get attendance;

  /// No description provided for @goals.
  ///
  /// In vi, this message translates to:
  /// **'Mục tiêu'**
  String get goals;

  /// No description provided for @noNearSchedule.
  ///
  /// In vi, this message translates to:
  /// **'Hôm nay bạn không có lịch học nào'**
  String get noNearSchedule;

  /// No description provided for @nearSchedule.
  ///
  /// In vi, this message translates to:
  /// **'Lịch học gần nhất'**
  String get nearSchedule;

  /// No description provided for @suggestCourse.
  ///
  /// In vi, this message translates to:
  /// **'Khóa học đề xuất cho bạn'**
  String get suggestCourse;

  /// No description provided for @diemdanh.
  ///
  /// In vi, this message translates to:
  /// **'Điểm danh'**
  String get diemdanh;

  /// No description provided for @roadmap.
  ///
  /// In vi, this message translates to:
  /// **'Lộ trình'**
  String get roadmap;

  /// No description provided for @address.
  ///
  /// In vi, this message translates to:
  /// **'Địa chỉ'**
  String get address;

  /// No description provided for @news.
  ///
  /// In vi, this message translates to:
  /// **'Tin tức Kiddo ENGLISH'**
  String get news;

  /// No description provided for @news1.
  ///
  /// In vi, this message translates to:
  /// **'Tin tức'**
  String get news1;

  /// No description provided for @timetable.
  ///
  /// In vi, this message translates to:
  /// **'Thời khóa biểu'**
  String get timetable;

  /// No description provided for @yourSchedule.
  ///
  /// In vi, this message translates to:
  /// **'Lịch học của bạn'**
  String get yourSchedule;

  /// No description provided for @noSchedule.
  ///
  /// In vi, this message translates to:
  /// **'Không có lịch học'**
  String get noSchedule;

  /// No description provided for @month.
  ///
  /// In vi, this message translates to:
  /// **'Tháng'**
  String get month;

  /// No description provided for @teachingSchedule.
  ///
  /// In vi, this message translates to:
  /// **'Lịch dạy'**
  String get teachingSchedule;

  /// No description provided for @yourTeachingSchedule.
  ///
  /// In vi, this message translates to:
  /// **'Lịch dạy của bạn'**
  String get yourTeachingSchedule;

  /// No description provided for @noTeachingSchedule.
  ///
  /// In vi, this message translates to:
  /// **'Không có lịch dạy'**
  String get noTeachingSchedule;

  /// No description provided for @studentCode.
  ///
  /// In vi, this message translates to:
  /// **'Mã học viên'**
  String get studentCode;

  /// No description provided for @fullName.
  ///
  /// In vi, this message translates to:
  /// **'Họ và tên'**
  String get fullName;

  /// No description provided for @dob.
  ///
  /// In vi, this message translates to:
  /// **'Ngày sinh'**
  String get dob;

  /// No description provided for @phone.
  ///
  /// In vi, this message translates to:
  /// **'Số điện thoại'**
  String get phone;

  /// No description provided for @rewardPoints.
  ///
  /// In vi, this message translates to:
  /// **'Điểm thưởng'**
  String get rewardPoints;

  /// No description provided for @point.
  ///
  /// In vi, this message translates to:
  /// **'điểm'**
  String get point;

  /// No description provided for @accountManagement.
  ///
  /// In vi, this message translates to:
  /// **'Quản lý tài khoản'**
  String get accountManagement;

  /// No description provided for @password.
  ///
  /// In vi, this message translates to:
  /// **'Mật khẩu'**
  String get password;

  /// No description provided for @hotline.
  ///
  /// In vi, this message translates to:
  /// **'Hotline hỗ trợ'**
  String get hotline;

  /// No description provided for @confirmLogout.
  ///
  /// In vi, this message translates to:
  /// **'Bạn có chắc muốn đăng xuất'**
  String get confirmLogout;

  /// No description provided for @changePass.
  ///
  /// In vi, this message translates to:
  /// **'Đổi mật khẩu'**
  String get changePass;

  /// No description provided for @sent.
  ///
  /// In vi, this message translates to:
  /// **'Đã gửi'**
  String get sent;

  /// No description provided for @mesage.
  ///
  /// In vi, this message translates to:
  /// **'Tin nhắn'**
  String get mesage;

  /// No description provided for @listStudent.
  ///
  /// In vi, this message translates to:
  /// **'Danh sách học viên'**
  String get listStudent;

  /// No description provided for @listTeacher.
  ///
  /// In vi, this message translates to:
  /// **'Danh sách giáo viên'**
  String get listTeacher;

  /// No description provided for @student.
  ///
  /// In vi, this message translates to:
  /// **'Học sinh'**
  String get student;

  /// No description provided for @doubleCheck.
  ///
  /// In vi, this message translates to:
  /// **'Vui lòng kiểm tra lại email và mật khẩu của bạn'**
  String get doubleCheck;

  /// No description provided for @forgotPassword.
  ///
  /// In vi, this message translates to:
  /// **'Quên mật khẩu'**
  String get forgotPassword;

  /// No description provided for @detailTest.
  ///
  /// In vi, this message translates to:
  /// **'Chi tiết bài thi'**
  String get detailTest;

  /// No description provided for @detailFeedback.
  ///
  /// In vi, this message translates to:
  /// **'Chi tiết đánh giá'**
  String get detailFeedback;

  /// No description provided for @detailExam.
  ///
  /// In vi, this message translates to:
  /// **'Chi tiết bài tập'**
  String get detailExam;

  /// No description provided for @detailNoti.
  ///
  /// In vi, this message translates to:
  /// **'Chi tiết thông báo'**
  String get detailNoti;

  /// No description provided for @detailClass.
  ///
  /// In vi, this message translates to:
  /// **'Chi tiết lớp học'**
  String get detailClass;

  /// No description provided for @detailLesson.
  ///
  /// In vi, this message translates to:
  /// **'Chi tiết buổi học'**
  String get detailLesson;

  /// No description provided for @seeDetail.
  ///
  /// In vi, this message translates to:
  /// **'Xem chi tiết'**
  String get seeDetail;

  /// No description provided for @learningPath.
  ///
  /// In vi, this message translates to:
  /// **'Lộ trình học'**
  String get learningPath;

  /// No description provided for @lastestTeachingSchedule.
  ///
  /// In vi, this message translates to:
  /// **'Lịch dạy gần nhất'**
  String get lastestTeachingSchedule;

  /// No description provided for @otp.
  ///
  /// In vi, this message translates to:
  /// **'Mã OTP được gửi qua số điện thoại đã đăng kí'**
  String get otp;

  /// No description provided for @notHaveSchedule.
  ///
  /// In vi, this message translates to:
  /// **'Chưa có lịch học'**
  String get notHaveSchedule;

  /// No description provided for @start.
  ///
  /// In vi, this message translates to:
  /// **'Bắt đầu'**
  String get start;

  /// No description provided for @end.
  ///
  /// In vi, this message translates to:
  /// **'Kết thúc'**
  String get end;

  /// No description provided for @join.
  ///
  /// In vi, this message translates to:
  /// **'Tham gia'**
  String get join;

  /// No description provided for @absent.
  ///
  /// In vi, this message translates to:
  /// **'Vắng'**
  String get absent;

  /// No description provided for @appointmentInformation.
  ///
  /// In vi, this message translates to:
  /// **'Thông tin lịch hẹn'**
  String get appointmentInformation;

  /// No description provided for @loginUsingapp.
  ///
  /// In vi, this message translates to:
  /// **'Đăng nhập để tiếp tục sử dụng ứng dụng'**
  String get loginUsingapp;

  /// No description provided for @loginTitle.
  ///
  /// In vi, this message translates to:
  /// **'Thông tin đăng nhập được cung cấp bởi trung tâm'**
  String get loginTitle;

  /// No description provided for @hello.
  ///
  /// In vi, this message translates to:
  /// **'Xin chào !'**
  String get hello;

  /// No description provided for @loginTitle2.
  ///
  /// In vi, this message translates to:
  /// **'Chào mừng đã trở lại, hãy đăng nhập'**
  String get loginTitle2;

  /// No description provided for @studentApointmentSchedule.
  ///
  /// In vi, this message translates to:
  /// **'Lịch hẹn học viên'**
  String get studentApointmentSchedule;

  /// No description provided for @listStudentApoint.
  ///
  /// In vi, this message translates to:
  /// **'Danh sách lịch hẹn học viên'**
  String get listStudentApoint;

  /// No description provided for @home.
  ///
  /// In vi, this message translates to:
  /// **'Trang chủ'**
  String get home;

  /// No description provided for @lopHoc2.
  ///
  /// In vi, this message translates to:
  /// **'Lớp học'**
  String get lopHoc2;

  /// No description provided for @classInCharge.
  ///
  /// In vi, this message translates to:
  /// **'Lớp học đang phụ trách'**
  String get classInCharge;

  /// No description provided for @centralClassroom.
  ///
  /// In vi, this message translates to:
  /// **'Lớp học trung tâm'**
  String get centralClassroom;

  /// No description provided for @zoomClassroom.
  ///
  /// In vi, this message translates to:
  /// **'Lớp học zoom'**
  String get zoomClassroom;

  /// No description provided for @exam.
  ///
  /// In vi, this message translates to:
  /// **'Đề thi'**
  String get exam;

  /// No description provided for @missWithPermission.
  ///
  /// In vi, this message translates to:
  /// **'Xin nghỉ'**
  String get missWithPermission;

  /// No description provided for @reasonMiss.
  ///
  /// In vi, this message translates to:
  /// **'Lý do xin nghỉ'**
  String get reasonMiss;

  /// No description provided for @late.
  ///
  /// In vi, this message translates to:
  /// **'Đi muộn'**
  String get late;

  /// No description provided for @onTime.
  ///
  /// In vi, this message translates to:
  /// **'Đúng giờ'**
  String get onTime;

  /// No description provided for @examSchedule.
  ///
  /// In vi, this message translates to:
  /// **'Lịch thi'**
  String get examSchedule;

  /// No description provided for @feedBack.
  ///
  /// In vi, this message translates to:
  /// **'Phản hồi'**
  String get feedBack;

  /// No description provided for @notYetStudied.
  ///
  /// In vi, this message translates to:
  /// **'Chưa học'**
  String get notYetStudied;

  /// No description provided for @learned.
  ///
  /// In vi, this message translates to:
  /// **'Đã học'**
  String get learned;

  /// No description provided for @listLesson.
  ///
  /// In vi, this message translates to:
  /// **'Danh sách buổi học'**
  String get listLesson;

  /// No description provided for @nameClass.
  ///
  /// In vi, this message translates to:
  /// **'Tên lớp : '**
  String get nameClass;

  /// No description provided for @learningFormat.
  ///
  /// In vi, this message translates to:
  /// **'Hình thức : '**
  String get learningFormat;

  /// No description provided for @chooseLanguage.
  ///
  /// In vi, this message translates to:
  /// **'Chọn ngôn ngữ'**
  String get chooseLanguage;

  /// No description provided for @chooseCampus.
  ///
  /// In vi, this message translates to:
  /// **'Chọn cơ sở'**
  String get chooseCampus;

  /// No description provided for @registerToJoin.
  ///
  /// In vi, this message translates to:
  /// **'Đăng ký tham gia'**
  String get registerToJoin;

  /// No description provided for @myExamSchedule.
  ///
  /// In vi, this message translates to:
  /// **'Lịch thi của tôi'**
  String get myExamSchedule;

  /// No description provided for @onTimeExam.
  ///
  /// In vi, this message translates to:
  /// **'Đúng hạn'**
  String get onTimeExam;

  /// No description provided for @overdue.
  ///
  /// In vi, this message translates to:
  /// **'Quá hạn'**
  String get overdue;

  /// No description provided for @notStarted.
  ///
  /// In vi, this message translates to:
  /// **'Chưa làm'**
  String get notStarted;

  /// No description provided for @statistics.
  ///
  /// In vi, this message translates to:
  /// **'Thống kê'**
  String get statistics;

  /// No description provided for @upcomingDeadline.
  ///
  /// In vi, this message translates to:
  /// **'Sắp đến hạn'**
  String get upcomingDeadline;

  /// No description provided for @noUpcomingAssignments.
  ///
  /// In vi, this message translates to:
  /// **'Không có bài tập sắp đến hạn'**
  String get noUpcomingAssignments;

  /// No description provided for @overview.
  ///
  /// In vi, this message translates to:
  /// **'Tổng quan'**
  String get overview;

  /// No description provided for @assignmentScore.
  ///
  /// In vi, this message translates to:
  /// **'Điểm bài tập'**
  String get assignmentScore;

  /// No description provided for @mockTestReport.
  ///
  /// In vi, this message translates to:
  /// **'Báo cáo thi thử'**
  String get mockTestReport;

  /// No description provided for @noExamSchedule.
  ///
  /// In vi, this message translates to:
  /// **'Chưa có lịch thi nào'**
  String get noExamSchedule;

  /// No description provided for @teacherFeedback.
  ///
  /// In vi, this message translates to:
  /// **'Đánh giá từ giáo viên'**
  String get teacherFeedback;

  /// No description provided for @overviewFeedback.
  ///
  /// In vi, this message translates to:
  /// **'Đánh giá tổng quan'**
  String get overviewFeedback;

  /// No description provided for @gradeAssignment.
  ///
  /// In vi, this message translates to:
  /// **'Chấm điểm bài tập'**
  String get gradeAssignment;

  /// No description provided for @content.
  ///
  /// In vi, this message translates to:
  /// **'Nội dung'**
  String get content;

  /// No description provided for @shift.
  ///
  /// In vi, this message translates to:
  /// **'Ca học'**
  String get shift;

  /// No description provided for @lecturer.
  ///
  /// In vi, this message translates to:
  /// **'Giảng viên'**
  String get lecturer;

  /// No description provided for @videoLabel.
  ///
  /// In vi, this message translates to:
  /// **'Video'**
  String get videoLabel;

  /// No description provided for @materials.
  ///
  /// In vi, this message translates to:
  /// **'Tài liệu'**
  String get materials;

  /// No description provided for @classroomLabel.
  ///
  /// In vi, this message translates to:
  /// **'Phòng học'**
  String get classroomLabel;

  /// No description provided for @comment.
  ///
  /// In vi, this message translates to:
  /// **'Nhận xét'**
  String get comment;

  /// No description provided for @tutoringClass.
  ///
  /// In vi, this message translates to:
  /// **'Lớp học phụ đạo'**
  String get tutoringClass;

  /// No description provided for @makeupClass.
  ///
  /// In vi, this message translates to:
  /// **'Lớp xếp bù'**
  String get makeupClass;

  /// No description provided for @noConversation.
  ///
  /// In vi, this message translates to:
  /// **'Không có cuộc trò chuyện nào'**
  String get noConversation;

  /// No description provided for @switchAccount.
  ///
  /// In vi, this message translates to:
  /// **'Chuyển tài khoản'**
  String get switchAccount;

  /// No description provided for @comfirmSwitchAcc.
  ///
  /// In vi, this message translates to:
  /// **'Bạn chắc chắn muốn chuyển sang tài khoản '**
  String get comfirmSwitchAcc;

  /// No description provided for @detailCourse.
  ///
  /// In vi, this message translates to:
  /// **'Chi tiết khóa học'**
  String get detailCourse;

  /// No description provided for @listCourse.
  ///
  /// In vi, this message translates to:
  /// **'Danh sách khoá học'**
  String get listCourse;

  /// No description provided for @avatar.
  ///
  /// In vi, this message translates to:
  /// **'Ảnh đại diện'**
  String get avatar;

  /// No description provided for @success.
  ///
  /// In vi, this message translates to:
  /// **'Thành công'**
  String get success;

  /// No description provided for @close.
  ///
  /// In vi, this message translates to:
  /// **'Đóng'**
  String get close;

  /// No description provided for @notHaveTeachingSchedule.
  ///
  /// In vi, this message translates to:
  /// **'Chưa có lịch dạy sắp tới'**
  String get notHaveTeachingSchedule;

  /// No description provided for @account.
  ///
  /// In vi, this message translates to:
  /// **'Tài khoản'**
  String get account;

  /// No description provided for @offers.
  ///
  /// In vi, this message translates to:
  /// **'Ưu đãi'**
  String get offers;

  /// No description provided for @info.
  ///
  /// In vi, this message translates to:
  /// **'Thông tin'**
  String get info;

  /// No description provided for @contact.
  ///
  /// In vi, this message translates to:
  /// **'Liên lạc'**
  String get contact;

  /// No description provided for @menuAttendance.
  ///
  /// In vi, this message translates to:
  /// **'Điểm danh'**
  String get menuAttendance;

  /// No description provided for @menuAssignments.
  ///
  /// In vi, this message translates to:
  /// **'Bài tập'**
  String get menuAssignments;

  /// No description provided for @menuEvaluate.
  ///
  /// In vi, this message translates to:
  /// **'Đánh giá'**
  String get menuEvaluate;

  /// No description provided for @menuTuition.
  ///
  /// In vi, this message translates to:
  /// **'Học phí'**
  String get menuTuition;

  /// No description provided for @menuMaterials.
  ///
  /// In vi, this message translates to:
  /// **'Học liệu'**
  String get menuMaterials;

  /// No description provided for @menuPolicy.
  ///
  /// In vi, this message translates to:
  /// **'Chính sách'**
  String get menuPolicy;

  /// No description provided for @chooseFile.
  ///
  /// In vi, this message translates to:
  /// **'Chọn file'**
  String get chooseFile;

  /// No description provided for @choosePhotoFromLibrary.
  ///
  /// In vi, this message translates to:
  /// **'Chọn ảnh từ thư viện'**
  String get choosePhotoFromLibrary;

  /// No description provided for @takePhoto.
  ///
  /// In vi, this message translates to:
  /// **'Chụp ảnh'**
  String get takePhoto;

  /// No description provided for @error.
  ///
  /// In vi, this message translates to:
  /// **'Lỗi'**
  String get error;

  /// No description provided for @noNotification.
  ///
  /// In vi, this message translates to:
  /// **'Không có thông báo'**
  String get noNotification;

  /// No description provided for @cannotLoadData.
  ///
  /// In vi, this message translates to:
  /// **'Không thể tải dữ liệu'**
  String get cannotLoadData;

  /// No description provided for @redeemSuccess.
  ///
  /// In vi, this message translates to:
  /// **'Đổi quà thành công'**
  String get redeemSuccess;

  /// No description provided for @photoLibraryAccessDenied.
  ///
  /// In vi, this message translates to:
  /// **'Quyền truy cập thư viện ảnh bị từ chối.'**
  String get photoLibraryAccessDenied;

  /// No description provided for @savedQrToGallery.
  ///
  /// In vi, this message translates to:
  /// **'Đã lưu ảnh mã QR vào thư viện ảnh!'**
  String get savedQrToGallery;

  /// No description provided for @cannotCaptureWidget.
  ///
  /// In vi, this message translates to:
  /// **'Không thể chụp ảnh widget.'**
  String get cannotCaptureWidget;

  /// No description provided for @noDataOrLoadFailed.
  ///
  /// In vi, this message translates to:
  /// **'Không có dữ liệu hoặc tải thất bại'**
  String get noDataOrLoadFailed;

  /// No description provided for @enterClass.
  ///
  /// In vi, this message translates to:
  /// **'Vào lớp'**
  String get enterClass;

  /// No description provided for @upcomingSchedule.
  ///
  /// In vi, this message translates to:
  /// **'Lịch học sắp tới'**
  String get upcomingSchedule;

  /// No description provided for @seeSchedule.
  ///
  /// In vi, this message translates to:
  /// **'Xem lịch học'**
  String get seeSchedule;

  /// No description provided for @noUpcomingSchedule.
  ///
  /// In vi, this message translates to:
  /// **'Chưa có lịch học sắp tới'**
  String get noUpcomingSchedule;

  /// No description provided for @inviteFriends.
  ///
  /// In vi, this message translates to:
  /// **'Mời bạn bè, nhận quà liền tay'**
  String get inviteFriends;

  /// No description provided for @centerNews.
  ///
  /// In vi, this message translates to:
  /// **'Bảng tin trung tâm'**
  String get centerNews;

  /// No description provided for @checkInternet.
  ///
  /// In vi, this message translates to:
  /// **'Vui lòng kiểm tra lại kết nối internet'**
  String get checkInternet;

  /// No description provided for @monday.
  ///
  /// In vi, this message translates to:
  /// **'Thứ 2'**
  String get monday;

  /// No description provided for @tuesday.
  ///
  /// In vi, this message translates to:
  /// **'Thứ 3'**
  String get tuesday;

  /// No description provided for @wednesday.
  ///
  /// In vi, this message translates to:
  /// **'Thứ 4'**
  String get wednesday;

  /// No description provided for @thursday.
  ///
  /// In vi, this message translates to:
  /// **'Thứ 5'**
  String get thursday;

  /// No description provided for @friday.
  ///
  /// In vi, this message translates to:
  /// **'Thứ 6'**
  String get friday;

  /// No description provided for @saturday.
  ///
  /// In vi, this message translates to:
  /// **'Thứ 7'**
  String get saturday;

  /// No description provided for @sunday.
  ///
  /// In vi, this message translates to:
  /// **'Chủ nhật'**
  String get sunday;

  /// No description provided for @ok.
  ///
  /// In vi, this message translates to:
  /// **'OK'**
  String get ok;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['en', 'vi'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en':
      return AppLocalizationsEn();
    case 'vi':
      return AppLocalizationsVi();
  }

  throw FlutterError(
      'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
      'an issue with the localizations generation tool. Please file an issue '
      'on GitHub with a reproducible sample app and the gen-l10n configuration '
      'that was used.');
}
