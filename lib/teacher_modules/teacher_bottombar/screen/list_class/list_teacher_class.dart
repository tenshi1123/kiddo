import 'package:flutter/material.dart';
import 'package:kiddo/l10n/app_localizations.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:kiddo/l10n/l10n.dart';
import 'package:kiddo/modules/bottombar/utils.dart';
import 'package:kiddo/modules/notification/notification.dart';
import 'package:kiddo/teacher_model/teacher_class_model.dart';
import 'package:kiddo/teacher_modules/teacher_bottombar/screen/list_class/detail_teacher_class.dart';
import 'package:kiddo/teacher_repo/teacher_class_repo.dart';
import 'package:kiddo/utils/constants/color.dart';
import 'package:kiddo/utils/constants/styles.dart';
import 'package:kiddo/utils/widget/custom_dialog.dart';

class ListTeacherClassScreen extends StatefulWidget {
  const ListTeacherClassScreen({super.key});

  @override
  State<ListTeacherClassScreen> createState() => _ListTeacherClassScreenState();
}

class _ListTeacherClassScreenState extends State<ListTeacherClassScreen> {
  bool isLoading = true;
  List<TeacherClassModel> offClasses = [];
  List<TeacherClassModel> zoomClasses = [];
  List<PhuDaoClassModel> phuDaoClasses = [];
  List<PhuDaoClassModel> xepBuClasses = [];
  String selectedClassType = 'Lớp học trung tâm';

  @override
  void initState() {
    super.initState();
    fetchData();
  }

  Future<void> fetchData() async {
    try {
      offClasses = await TeacherClassRepo().getTeacherClassByType(type: 'off');
      zoomClasses =
          await TeacherClassRepo().getTeacherClassByType(type: 'zoom');
      phuDaoClasses = await TeacherClassRepo().getPhuDaoClass(type: 'phu_dao');
      xepBuClasses = await TeacherClassRepo().getPhuDaoClass(type: 'xep_bu');
      setState(() {
        isLoading = false;
      });
    } catch (e) {
      debugPrint('Lỗi khi gọi API: $e');
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: mainOrange,
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(70.h),
        child: Container(
          color: mainOrange,
          child: Padding(
            padding: EdgeInsets.only(top: 40.h, left: 16.w, right: 16.w),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    SizedBox(
                      width: 20.w,
                    ),
                    Text(
                      'Lớp học',
                      style: defaultText16B.copyWith(color: Colors.white),
                    ),
                    GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => NotificationScreen(),
                          ),
                        );
                      },
                      child: SvgPicture.asset(
                        'assets/icons/bell.svg',
                        width: 20.w,
                        height: 20.h,
                        colorFilter: ColorFilter.mode(
                          Colors.white,
                          BlendMode.srcIn,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
              ],
            ),
          ),
        ),
      ),
      body: Column(
        children: [
          Container(
            color: mainOrange,
            padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    _buildClassTypeButton(
                      L10n.of(context).centralClassroom,
                    ),
                    _buildClassTypeButton(
                      L10n.of(context).zoomClassroom,
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    _buildClassTypeButton(L10n.of(context).tutoringClass),
                    _buildClassTypeButton(L10n.of(context).makeupClass),
                  ],
                ),
              ],
            ),
          ),
          selectedClassType == 'Lớp phụ đạo'
              ? Expanded(
                  child: Container(
                    padding: EdgeInsets.all(16.w),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(16.r),
                      color: Colors.white,
                    ),
                    child: Column(
                      children: [
                        Expanded(
                          child: ListView.builder(
                            shrinkWrap: true,
                            //physics: const NeverScrollableScrollPhysics(),
                            itemCount: phuDaoClasses.length,
                            itemBuilder: (context, index) {
                              return AttendanceDetailCard(
                                model: phuDaoClasses[index],
                                stt: '${index + 1}',
                                type: 'phudao',
                              );
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                )
              : selectedClassType == 'Lớp xếp bù'
                  ? Expanded(
                      child: Container(
                        padding: EdgeInsets.all(16.w),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(16.r),
                          color: Colors.white,
                        ),
                        child: ListView.builder(
                          shrinkWrap: true,
                          //physics: const NeverScrollableScrollPhysics(),
                          itemCount: xepBuClasses.length,
                          itemBuilder: (context, index) {
                            return AttendanceDetailCard(
                              model: xepBuClasses[index],
                              stt: '${index + 1}',
                              type: 'xepbu',
                            );
                          },
                        ),
                      ),
                    )
                  : selectedClassType == 'Lớp học trung tâm'
                      ? Expanded(
                          child: Container(
                            padding: EdgeInsets.all(16.w),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(16.r),
                              color: Colors.white,
                            ),
                            child: isLoading
                                ? const Center(
                                    child: CircularProgressIndicator())
                                : ListView.builder(
                                    shrinkWrap: true,
                                    //physics: const NeverScrollableScrollPhysics(),
                                    itemCount: offClasses.length,
                                    itemBuilder: (context, index) {
                                      return _buildClassCard(offClasses[index]);
                                    },
                                  ),
                          ),
                        )
                      : Expanded(
                          child: Container(
                            padding: EdgeInsets.all(16.w),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(16.r),
                              color: Colors.white,
                            ),
                            child: ListView.builder(
                              shrinkWrap: true,
                              //physics: const NeverScrollableScrollPhysics(),
                              itemCount: zoomClasses.length,
                              itemBuilder: (context, index) {
                                return _buildClassCard(zoomClasses[index]);
                              },
                            ),
                          ),
                        ),
        ],
      ),
    );
  }

  Widget _buildClassTypeButton(String title) {
    final bool isSelected = selectedClassType == title;
    return GestureDetector(
      onTap: () {
        setState(() {
          selectedClassType = title;
        });
      },
      child: Container(
        height: 40.h,
        width: 164.w,
        decoration: BoxDecoration(
          color: isSelected
              ? Colors.white
              : Color(0xffE6E5F2).withValues(alpha: 0.54),
          borderRadius: BorderRadius.circular(12.r),
          border: Border.all(
            color: isSelected
                ? Colors.white
                : Color(0xffE6E5F2).withValues(alpha: 0.54),
            width: 1,
          ),
        ),
        child: Center(
          child: Text(
            title,
            style: isSelected
                ? defaultText14B.copyWith(color: mainGreen)
                : defaultText14M.copyWith(color: Colors.white),
          ),
        ),
      ),
    );
  }

  Widget _buildClassCard(TeacherClassModel data) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 15.0),
      child: GestureDetector(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => DetailTeacherClass(
                model: data,
              ),
            ),
          );
        },
        child: Container(
          margin: EdgeInsets.only(bottom: 12.h),
          padding: EdgeInsets.all(12.w),
          decoration: BoxDecoration(
            color: Colors.grey.shade100,
            borderRadius: BorderRadius.circular(12.r),
            border: Border.all(color: Colors.blue.shade100),
          ),
          child: Row(
            children: [
              Image.asset(
                'assets/images/computer.png',
                width: 40.w,
                height: 40.h,
              ),
              SizedBox(width: 12.w),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(data.name, style: defaultText16B),
                  SizedBox(height: 4.h),
                  Text(
                    data.typeTeacher,
                    style: defaultText14M.copyWith(
                      color: Colors.grey.shade600,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class AttendanceDetailCard extends StatefulWidget {
  const AttendanceDetailCard(
      {super.key, required this.model, required this.stt, required this.type});
  final PhuDaoClassModel model;
  final String stt;
  final String type;
  @override
  State<AttendanceDetailCard> createState() => _AttendanceDetailCardState();
}

class _AttendanceDetailCardState extends State<AttendanceDetailCard> {
  // Trạng thái cho 5 ô kiểm tra (checkboxes)
  Map<String, bool> attendanceStatus = {
    'Chưa tham dự': false,
    'Vắng mặt': false,
    'Xin nghỉ': false,
    'Đi muộn': false,
    'Đúng giờ': false,
  };
  final ValueNotifier<bool> isChange = ValueNotifier<bool>(false);
  @override
  void initState() {
    attendanceStatus = {
      'Chưa tham dự': widget.model.status == '0' ? true : false,
      'Vắng mặt': widget.model.status == '1' ? true : false,
      'Xin nghỉ': widget.model.status == '2' ? true : false,
      'Đi muộn': widget.model.status == '3' ? true : false,
      'Đúng giờ': widget.model.status == '4' ? true : false,
    };
    super.initState();
  }

  // Hàm xử lý khi trạng thái checkbox thay đổi
  void _onStatusChanged(String key, bool? newValue) {
    bool newVal = newValue ?? false;
    // Kiểm tra xem giá trị hiện tại đã khác với giá trị mới chưa

    String toStatusCode(String name) {
      const status = [
        'Chưa tham dự',
        'Vắng mặt',
        'Xin nghỉ',
        'Đi muộn',
        'Đúng giờ',
      ];
      final index = status.indexOf(name);
      if (index == -1) return "-1"; // hoặc "Không xác định"
      return index.toString();
    }

    if (attendanceStatus[key] != newVal) {
      setState(() {
        // Chỉ reset nếu có thay đổi
        attendanceStatus.forEach((status, _) {
          attendanceStatus[status] = false;
        });
        attendanceStatus[key] = newVal;

        // Chỉ set true khi có thay đổi
        isChange.value = true;
        widget.model.status = toStatusCode(key);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsetsGeometry.symmetric(vertical: 4.h),
      child: Card(
        elevation: 4,
        color: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16.r),
          side: BorderSide(color: state1),
        ),
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              // === PHẦN 1: THÔNG TIN HỌC VIÊN ===
              _buildStudentInfoRow("STT", widget.stt, isHeader: true),
              _buildStudentInfoRow(
                "Họ tên:",
                widget.model.customerName,
              ),
              _buildStudentInfoRow("SĐT:", widget.model.phone),
              _buildStudentInfoRow("Email:", widget.model.email),
              const SizedBox(height: 15),
              const Divider(height: 1, color: Colors.grey),
              const SizedBox(height: 15),
              const SizedBox(height: 10),
              Text(
                widget.model.name,
                style: defaultText16B,
              ),
              SizedBox(
                height: 10.h,
              ),
              Row(
                children: [
                  SvgPicture.asset('assets/icons/clock.svg'),
                  SizedBox(width: 8.w),
                  Text(
                    formatDisplay(
                      widget.model.dayPhuDao,
                      widget.model.timeStart,
                      widget.model.timeEnd,
                    ),
                    style: defaultText14M,
                  )
                ],
              ),
              SizedBox(
                height: 4.h,
              ),
              Row(
                children: [
                  SvgPicture.asset('assets/icons/class.svg'),
                  SizedBox(width: 8.w),
                  Text(
                    widget.model.phongHoc,
                    style: defaultText14M,
                  )
                ],
              ),
              SizedBox(
                height: 4.h,
              ),
              Row(
                children: [
                  SvgPicture.asset('assets/icons/place.svg'),
                  SizedBox(width: 8.w),
                  SizedBox(
                    width: 280.w,
                    child: Text(
                      widget.model.address,
                      style: defaultText14M,
                    ),
                  )
                ],
              ),

              const SizedBox(height: 20),
              const Divider(height: 1, color: Colors.grey),
              _buildAttendanceCheckboxes(),
            ],
          ),
        ),
      ),
    );
  }

  // Widget trợ giúp cho Thông tin học viên (Phần 1)
  Widget _buildStudentInfoRow(String label, String value,
      {bool isHeader = false}) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 4.h),
      child: Row(
        //mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          SizedBox(
            width: 80.w,
            child: Text(
              label,
              style: isHeader ? defaultText16B : defaultText14M,
            ),
          ),
          SizedBox(
            width: 200.w,
            child: Text(
              value,
              style: isHeader ? defaultText16B : defaultText14SB,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAttendanceCheckboxes() {
    final List<String> statusKeys = attendanceStatus.keys.toList();
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            _buildCheckboxItem(statusKeys[0]), // Chưa tham dự
            _buildCheckboxItem(statusKeys[1]), // Vắng mặt
          ],
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            _buildCheckboxItem(statusKeys[2]), // Xin nghỉ
            _buildCheckboxItem(statusKeys[3]), // Đi muộn
          ],
        ),
        Row(
          children: [
            _buildCheckboxItem(statusKeys[4]), // Đúng giờ
            // Thêm Spacer để căn chỉnh cột cuối cùng nếu cần
            const Spacer(flex: 1),
          ],
        ),
        ValueListenableBuilder<bool>(
          builder: (BuildContext context, bool value, Widget? child) {
            return child!;
          },
          valueListenable: isChange,
          child: isChange.value
              ? Padding(
                  padding: EdgeInsets.all(10.0),
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: mainOrange,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    onPressed: () async {
                      bool? result = await showConfirmDialog(
                        context: context,
                        content:
                            "Bạn chắc chắn muốn cập nhật trạng thái điểm danh",
                      );
                      if (result == true) {
                        try {
                          await TeacherClassRepo().changePhuDao(
                              id: widget.model.id,
                              status: widget.model.status,
                              type: widget.type);
                          // ✔ Gọi xong toàn bộ, hiện dialog thành công
                          if (context.mounted) {
                            showDialog(
                              context: context,
                              builder: (_) => AlertDialog(
                                title: Text(L10n.of(context).success),
                                content: const Text(
                                    "Đã cập nhật điểm danh cho tất cả học sinh."),
                                actions: [
                                  TextButton(
                                    onPressed: () => Navigator.pop(context),
                                    child: const Text("OK"),
                                  )
                                ],
                              ),
                            );
                          }
                        } catch (e) {
                          // ❌ Nếu có lỗi, show dialog lỗi
                          if (context.mounted) {
                            showDialog(
                              context: context,
                              builder: (_) => AlertDialog(
                                title: Text(AppLocalizations.of(context).error),
                                content: Text("${AppLocalizations.of(context).error}: $e"),
                                actions: [
                                  TextButton(
                                    onPressed: () => Navigator.pop(context),
                                    child: Text(L10n.of(context).close),
                                  )
                                ],
                              ),
                            );
                          }
                        }
                      } else {
                        print("User chọn: Không");
                      }
                      //showSuccessDialog(context);
                    },
                    child: Text('Cập nhật',
                        style: defaultText18B.copyWith(color: Colors.white)),
                  ),
                )
              : SizedBox(),
        ),
      ],
    );
  }

  Widget _buildCheckboxItem(String label) {
    return Expanded(
      flex: 1,
      child: InkWell(
        onTap: () {
          final current = attendanceStatus[label] ?? false;
          _onStatusChanged(label, !current);
        },
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Checkbox(
              value: attendanceStatus[label] ?? false,
              onChanged: (newValue) => _onStatusChanged(label, newValue),
              activeColor: const Color(
                  0xFF34C759), // Màu xanh lá cây cho trạng thái được chọn
            ),
            Text(label, style: const TextStyle(fontSize: 16)),
          ],
        ),
      ),
    );
  }
}
