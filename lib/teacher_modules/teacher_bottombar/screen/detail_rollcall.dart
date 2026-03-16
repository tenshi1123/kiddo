import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:kiddo/l10n/l10n.dart';
import 'package:kiddo/modules/feature_home/hoc_phi/confirm_screen.dart';
import 'package:kiddo/modules/notification/notification.dart';
import 'package:kiddo/teacher_model/roll_call_model.dart';
import 'package:kiddo/teacher_model/teacher_class_model.dart';
import 'package:kiddo/teacher_repo/teacher_class_repo.dart';
import 'package:kiddo/utils/constants/color.dart';
import 'package:kiddo/utils/constants/styles.dart';
import 'package:kiddo/utils/widget/custom_dialog.dart';

class DetailRollCallScreen extends StatefulWidget {
  const DetailRollCallScreen({
    super.key,
    required this.typeTeacher,
    required this.courseScheduleId,
  });
  final String typeTeacher;
  final String courseScheduleId;
  @override
  State<DetailRollCallScreen> createState() => _DetailRollCallScreenState();
}

class _DetailRollCallScreenState extends State<DetailRollCallScreen> {
  int selectedTab = 0;
  bool isLoading = true;
  bool isExpanded = false;
  late List<BuoiHocModel> listBuoiHoc;
  BuoiHocModel? selectedLesson;
  late List<DiemDanhModel> listDiemDanh = [];
  List<ValueAttitudeModel> listAttitude = [];
  List<ValueAttitudeModel> listSituation = [];
  final List<String> statusList = [
    "Vắng mặt",
    "Xin nghỉ",
    "Đi muộn",
    "Đúng giờ",
  ];
  Color _statusColor(String status) {
    switch (status) {
      case 'Đúng giờ':
        return mainGreen;
      case 'Xin nghỉ':
        return mainBlue;
      case 'Vắng mặt':
        return mainRed;
      case 'Đi muộn':
        return mainYellow;
      default:
        return Color(0xffEFEFEF);
    }
  }

  bool _isDefault(String status) => status == 'Trạng thái';
  @override
  initState() {
    super.initState();
    fetchData();
  }

  Future<void> fetchData() async {
    try {
      final response = await TeacherClassRepo().getlistBuoiHoc(
          courseScheduleId: widget.courseScheduleId,
          typeTeacher: widget.typeTeacher);
      setState(() {
        listBuoiHoc = response;
        isLoading = false;
      });
    } catch (e) {
      debugPrint('Lỗi khi gọi API: $e');
      setState(() {
        isLoading = false;
      });
    }
    selectedLesson = listBuoiHoc.first;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: mainOrange,
      appBar: AppBar(
        backgroundColor: mainOrange,
        elevation: 0,
        centerTitle: true,
        title: Text(
          'Lớp Orca 56',
          style: defaultText16B.copyWith(color: Colors.white),
        ),
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: const Icon(
            Icons.arrow_back_ios,
            color: Colors.white,
          ),
        ),
        actions: [
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
          SizedBox(width: 16.w),
        ],
      ),
      body: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(26.r),
            topRight: Radius.circular(26.r),
          ),
        ),
        child: Column(
          children: [
            // Tabs
            CustomTabs(
              onChanged: (index) {
                setState(() {
                  selectedTab = index;
                });
              },
            ),
            isLoading
                ? CircularProgressIndicator()
                : Container(
                    padding: EdgeInsets.symmetric(horizontal: 16.w),
                    height: 48.h,
                    decoration: BoxDecoration(
                      color: const Color(0xffF6F6F6),
                      borderRadius: BorderRadius.circular(12.r),
                    ),
                    child: DropdownButtonHideUnderline(
                      child: DropdownButton<BuoiHocModel?>(
                        value: selectedLesson,
                        isExpanded: true,
                        dropdownColor: Colors.white,
                        icon: AnimatedRotation(
                          duration: const Duration(milliseconds: 200),
                          turns: isExpanded ? 0.5 : 0,
                          child: const Icon(Icons.unfold_more,
                              color: Colors.black),
                        ),
                        style: defaultText12M,
                        onChanged: (value) async {
                          setState(() {
                            selectedLesson = value!;
                            isExpanded = false;
                          });
                          final dataDD =
                              await TeacherClassRepo().getListDiemDanhHs(
                            typeTeacher: widget.typeTeacher,
                            buoiHocId: selectedLesson!.buoiHocId,
                            courseScheduleId: widget.courseScheduleId,
                          );
                          final dataTD = await TeacherClassRepo().getListThaiDo(
                            typeTeacher: widget.typeTeacher,
                            buoiHocId: selectedLesson!.buoiHocId,
                            courseScheduleId: widget.courseScheduleId,
                            type: 1,
                          );
                          final dataTH = await TeacherClassRepo().getListThaiDo(
                            typeTeacher: widget.typeTeacher,
                            buoiHocId: selectedLesson!.buoiHocId,
                            courseScheduleId: widget.courseScheduleId,
                            type: 2,
                          );
                          setState(() {
                            listDiemDanh = dataDD;
                            listAttitude = dataTD;
                            listSituation = dataTH;
                          });
                        },
                        onTap: () {
                          setState(() => isExpanded = !isExpanded);
                        },
                        items: listBuoiHoc.map((lesson) {
                          return DropdownMenuItem<BuoiHocModel>(
                            value: lesson,
                            child: Text(
                              '${lesson.name} - ${lesson.createdDate}',
                              style: defaultText12M,
                              overflow: TextOverflow.ellipsis,
                            ),
                          );
                        }).toList(),
                      ),
                    ),
                  ),
            Expanded(
              child: listDiemDanh.isEmpty
                  ? Center(
                      child: Text(
                        'Vui lòng chọn buổi học',
                        style: defaultText16M,
                      ),
                    )
                  : selectedTab == 0
                      ? Column(
                          children: [
                            // Danh sách học viên
                            Expanded(
                              child: ListView.builder(
                                padding: EdgeInsets.symmetric(horizontal: 16.w),
                                itemCount: listDiemDanh.length,
                                itemBuilder: (context, index) {
                                  final student = listDiemDanh[index];
                                  final color = _statusColor(student.status);
                                  final isDefault = _isDefault(student.status);

                                  return Container(
                                    margin: EdgeInsets.only(bottom: 12.w),
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.circular(16.r),
                                      boxShadow: [
                                        BoxShadow(
                                          color: Colors.black.withOpacity(0.05),
                                          blurRadius: 5,
                                          offset: const Offset(0, 3),
                                        ),
                                      ],
                                    ),
                                    child: Padding(
                                      padding: EdgeInsets.all(12.dg),
                                      child: Row(
                                        children: [
                                          Container(
                                              width: 40.w,
                                              height: 40.h,
                                              padding: EdgeInsets.all(8.dm),
                                              decoration: BoxDecoration(
                                                color: mainPurple,
                                                shape: BoxShape.circle,
                                              ),
                                              child: Image.asset(
                                                  'assets/images/study.png')),
                                          SizedBox(width: 12.w),
                                          Expanded(
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Text(
                                                  student.fullName,
                                                  style: defaultText14SB,
                                                ),
                                                Text(
                                                  student.createdAt,
                                                  style: defaultText12M,
                                                ),
                                              ],
                                            ),
                                          ),
                                          Container(
                                            padding: EdgeInsets.symmetric(
                                                horizontal: 8.w),
                                            height: 28.h,
                                            decoration: BoxDecoration(
                                              color: color,
                                              borderRadius:
                                                  BorderRadius.circular(8.r),
                                            ),
                                            child: SizedBox(
                                              height: 28.h,
                                              width: 98.w,
                                              child:
                                                  DropdownButtonHideUnderline(
                                                child: DropdownButton<String>(
                                                  value: student.status,
                                                  icon: Icon(
                                                    Icons.arrow_drop_down,
                                                    color: isDefault
                                                        ? Colors.black
                                                        : Colors.white,
                                                  ),
                                                  isExpanded: true,
                                                  dropdownColor: Colors.white,
                                                  style:
                                                      defaultText12M.copyWith(
                                                          color: Colors.black),
                                                  onChanged: (value) {
                                                    setState(() {
                                                      student.status = value!;
                                                    });
                                                  },
                                                  items: [
                                                    DropdownMenuItem(
                                                      value: 'Trạng thái',
                                                      child: Text(
                                                        'Trạng thái',
                                                        style: defaultText12M
                                                            .copyWith(
                                                                color: Colors
                                                                    .black),
                                                      ),
                                                    ),
                                                    ...statusList.map((s) {
                                                      return DropdownMenuItem(
                                                        value: s,
                                                        child: Text(
                                                          s,
                                                          style: defaultText12M
                                                              .copyWith(
                                                                  color: Colors
                                                                      .black),
                                                        ),
                                                      );
                                                    }),
                                                  ],
                                                  selectedItemBuilder:
                                                      (BuildContext context) {
                                                    final allItems = [
                                                      'Trạng thái',
                                                      ...statusList
                                                    ];
                                                    return allItems.map((s) {
                                                      return Align(
                                                        alignment:
                                                            Alignment.center,
                                                        child: Text(
                                                          s,
                                                          style: defaultText12M
                                                              .copyWith(
                                                            color: isDefault
                                                                ? Colors.black
                                                                : Colors.white,
                                                          ),
                                                        ),
                                                      );
                                                    }).toList();
                                                  },
                                                ),
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  );
                                },
                              ),
                            ),
                            // Nút cập nhật
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 16, vertical: 12),
                              child: SizedBox(
                                width: double.infinity,
                                height: 50.h,
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
                                      for (final student in listDiemDanh) {
                                        try {
                                          await TeacherClassRepo()
                                              .changeDiemdanh(
                                            typeTeacher: student.typeTeacher,
                                            checkinOffId: student.checkinOffId,
                                            status: student.status,
                                          );
                                          // ✔ Gọi xong toàn bộ, hiện dialog thành công
                                          if (context.mounted) {
                                            showDialog(
                                              context: context,
                                              builder: (_) => AlertDialog(
                                                title: Text(
                                                    L10n.of(context).success),
                                                content: const Text(
                                                    "Đã cập nhật điểm danh cho tất cả học sinh."),
                                                actions: [
                                                  TextButton(
                                                    onPressed: () =>
                                                        Navigator.pop(context),
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
                                                title: const Text("Lỗi"),
                                                content:
                                                    Text("Có lỗi xảy ra: $e"),
                                                actions: [
                                                  TextButton(
                                                    onPressed: () =>
                                                        Navigator.pop(context),
                                                    child: Text(
                                                        L10n.of(context).close),
                                                  )
                                                ],
                                              ),
                                            );
                                          }
                                        }
                                      }
                                    } else {
                                      print("User chọn: Không");
                                    }
                                    //showSuccessDialog(context);
                                  },
                                  child: Text('Cập nhật',
                                      style: defaultText18B.copyWith(
                                          color: Colors.white)),
                                ),
                              ),
                            ),
                          ],
                        )
                      : selectedTab == 1
                          ? Column(
                              children: [
                                Expanded(
                                  child: ListView.builder(
                                    itemCount: listAttitude.length,
                                    itemBuilder: (context, index) {
                                      return StudentCard(
                                        model: listAttitude[index],
                                        key: ValueKey(
                                            "attitude_${listAttitude[index].customerId}"),
                                      );
                                    },
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 16, vertical: 12),
                                  child: SizedBox(
                                    width: double.infinity,
                                    height: 50.h,
                                    child: ElevatedButton(
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor:
                                            const Color(0xFFF36A22),
                                        shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(12),
                                        ),
                                      ),
                                      onPressed: () async {
                                        bool? result = await showConfirmDialog(
                                          context: context,
                                          content:
                                              "Bạn chắc chắn muốn cập nhật trạng thái điểm danh",
                                        );
                                        if (result == true) {
                                          for (final student in listAttitude) {
                                            try {
                                              await TeacherClassRepo()
                                                  .changeThaiDo(
                                                typeTeacher: widget.typeTeacher,
                                                buoiHocId: student.buoiHocId,
                                                customerId: student.customerId,
                                                violationErrorId:
                                                    student.violationErrorId ??
                                                        '',
                                                content: student.content,
                                                type: 1,
                                              );
                                              // ✔ Gọi xong toàn bộ, hiện dialog thành công
                                              if (context.mounted) {
                                                showDialog(
                                                  context: context,
                                                  builder: (_) => AlertDialog(
                                                    title: const Text(
                                                        "Thành công"),
                                                    content: const Text(
                                                        "Đã cập nhật điểm danh cho tất cả học sinh."),
                                                    actions: [
                                                      TextButton(
                                                        onPressed: () =>
                                                            Navigator.pop(
                                                                context),
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
                                                    title: const Text("Lỗi"),
                                                    content: Text(
                                                        "Có lỗi xảy ra: $e"),
                                                    actions: [
                                                      TextButton(
                                                        onPressed: () =>
                                                            Navigator.pop(
                                                                context),
                                                        child: Text(
                                                            L10n.of(context)
                                                                .close),
                                                      )
                                                    ],
                                                  ),
                                                );
                                              }
                                            }
                                          }
                                        } else {
                                          print("User chọn: Không");
                                        }
                                      },
                                      child: Text(
                                        'Cập nhật',
                                        style: defaultText18B.copyWith(
                                            color: Colors.white),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            )
                          : Column(
                              children: [
                                Expanded(
                                  child: ListView.builder(
                                    itemCount: listSituation.length,
                                    itemBuilder: (context, index) {
                                      return StudentCard(
                                        model: listSituation[index],
                                        key: ValueKey(
                                            "situation_${listSituation[index].customerId}"),
                                      );
                                    },
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 16, vertical: 12),
                                  child: SizedBox(
                                    width: double.infinity,
                                    height: 50.h,
                                    child: ElevatedButton(
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor:
                                            const Color(0xFFF36A22),
                                        shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(12),
                                        ),
                                      ),
                                      onPressed: () async {
                                        bool? result = await showConfirmDialog(
                                          context: context,
                                          content:
                                              "Bạn chắc chắn muốn cập nhật trạng thái điểm danh",
                                        );
                                        if (result == true) {
                                          for (final student in listSituation) {
                                            try {
                                              await TeacherClassRepo()
                                                  .changeThaiDo(
                                                typeTeacher: widget.typeTeacher,
                                                buoiHocId: student.buoiHocId,
                                                customerId: student.customerId,
                                                violationErrorId:
                                                    student.violationErrorId ??
                                                        '',
                                                content: student.content,
                                                type: 2,
                                              );
                                              // ✔ Gọi xong toàn bộ, hiện dialog thành công
                                              if (context.mounted) {
                                                showDialog(
                                                  context: context,
                                                  builder: (_) => AlertDialog(
                                                    title: const Text(
                                                        "Thành công"),
                                                    content: const Text(
                                                        "Đã cập nhật điểm danh cho tất cả học sinh."),
                                                    actions: [
                                                      TextButton(
                                                        onPressed: () =>
                                                            Navigator.pop(
                                                                context),
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
                                                    title: const Text("Lỗi"),
                                                    content: Text(
                                                        "Có lỗi xảy ra: $e"),
                                                    actions: [
                                                      TextButton(
                                                        onPressed: () =>
                                                            Navigator.pop(
                                                                context),
                                                        child: Text(
                                                            L10n.of(context)
                                                                .close),
                                                      )
                                                    ],
                                                  ),
                                                );
                                              }
                                            }
                                          }
                                        } else {
                                          print("User chọn: Không");
                                        }
                                      },
                                      child: Text(
                                        'Cập nhật',
                                        style: defaultText18B.copyWith(
                                          color: Colors.white,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
            ),

            // Dropdown buổi học

            const SizedBox(height: 10),
          ],
        ),
      ),
    );
  }
}

class CustomTabs extends StatefulWidget {
  const CustomTabs({super.key, this.onChanged});
  final ValueChanged<int>? onChanged;
  @override
  State<CustomTabs> createState() => _CustomTabsState();
}

class _CustomTabsState extends State<CustomTabs> {
  int selectedIndex = 0;
  final List<String> tabs = ['Điểm danh', 'Thái độ', 'Tình hình'];

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.grey.shade200,
          borderRadius: BorderRadius.circular(50.r),
        ),
        child: Row(
          children: List.generate(
            tabs.length,
            (index) => Expanded(
              child: GestureDetector(
                onTap: () {
                  setState(() {
                    selectedIndex = index;
                  });
                  widget.onChanged?.call(index);
                },
                child: Container(
                  height: 44.h,
                  padding:
                      const EdgeInsets.symmetric(vertical: 10, horizontal: 8),
                  decoration: BoxDecoration(
                    color: selectedIndex == index
                        ? mainOrange
                        : Colors.grey.shade200,
                    borderRadius: BorderRadius.circular(50),
                  ),
                  alignment: Alignment.center,
                  child: Text(
                    tabs[index],
                    style: defaultText12M.copyWith(
                      color: selectedIndex == index
                          ? Colors.white
                          : Colors.grey.shade600,
                      fontWeight: selectedIndex == index
                          ? FontWeight.w700
                          : FontWeight.w500,
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class StudentCard extends StatefulWidget {
  const StudentCard({super.key, required this.model});
  final ValueAttitudeModel model;
  @override
  State<StudentCard> createState() => _StudentCardState();
}

class _StudentCardState extends State<StudentCard> {
  String? selectedStatus;
  @override
  void initState() {
    super.initState();
    selectedStatus = widget.model.violationErrorId?.toString();
  }

  @override
  Widget build(BuildContext context) {
    final ids = widget.model.listError!.map((e) => e.id.toString()).toList();

    // Nếu selectedStatus không nằm trong list → bỏ để tránh crash
    if (selectedStatus != null && !ids.contains(selectedStatus)) {
      selectedStatus = null;
    }
    return Container(
      width: double.infinity,
      margin: EdgeInsets.symmetric(vertical: 8.h, horizontal: 16.w),
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 8,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          /// Avatar + Tên + Thời gian
          Row(
            children: [
              Container(
                width: 48.w,
                height: 48.h,
                padding: EdgeInsets.all(8.dm),
                decoration: BoxDecoration(
                  color: mainPurple,
                  shape: BoxShape.circle,
                ),
                child: Image.asset('assets/images/study.png'),
              ),
              SizedBox(width: 12.w),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.model.fullName,
                    style: TextStyle(
                      fontSize: 14.sp,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                  ),
                  SizedBox(height: 4.h),
                ],
              ),
            ],
          ),
          SizedBox(height: 12.h),

          /// Dropdown trạng thái
          Container(
            width: double.infinity,
            height: 40.h,
            padding: EdgeInsets.symmetric(horizontal: 16.w),
            decoration: BoxDecoration(
              color: mainOrange,
              borderRadius: BorderRadius.circular(10.r),
            ),
            child: DropdownButtonHideUnderline(
                child: DropdownButton<String>(
              value: selectedStatus,
              onChanged: (value) {
                setState(() {
                  selectedStatus = value;
                  widget.model.violationErrorId = value;
                });
              },
              dropdownColor: Colors.white,
              icon: const Icon(Icons.arrow_drop_down, color: Colors.white),
              items: widget.model.listError!.map((ViolationError item) {
                return DropdownMenuItem<String>(
                  value: item.id.toString(),
                  child: Text(
                    item.name,
                    style: defaultText12M.copyWith(color: Colors.black),
                  ),
                );
              }).toList(),
              selectedItemBuilder: (context) {
                return widget.model.listError!.map((e) {
                  return Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      e.name,
                      style: defaultText12M.copyWith(color: Colors.white),
                    ),
                  );
                }).toList();
              },
            )),
          ),
          SizedBox(height: 12.h),

          Container(
            width: double.infinity,
            padding: EdgeInsets.all(12.w),
            decoration: BoxDecoration(
              color: const Color(0xffF6F6F6),
              borderRadius: BorderRadius.circular(12.r),
            ),
            child: TextField(
              controller: TextEditingController(text: widget.model.content)
                ..selection = TextSelection.fromPosition(
                  TextPosition(offset: widget.model.content.length),
                ),
              maxLines: null,
              style: TextStyle(
                fontSize: 13.sp,
                color: Colors.black87,
              ),
              decoration: const InputDecoration(
                border: InputBorder.none,
                isDense: true,
                contentPadding: EdgeInsets.zero,
              ),
              onChanged: (value) {
                setState(() {
                  widget.model.content = value; // 🔥 cập nhật vào model gốc
                });
              },
            ),
          )
        ],
      ),
    );
  }
}
