import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:kiddo/l10n/l10n.dart';
import 'package:kiddo/modules/feature_home/hoc_phi/confirm_screen.dart';
import 'package:kiddo/modules/notification/notification.dart';
import 'package:kiddo/student_models/profile_model.dart';
import 'package:kiddo/student_repo/customer_repo.dart';
import 'package:kiddo/utils/constants/color.dart';
import 'package:kiddo/utils/constants/styles.dart';
import 'package:kiddo/utils/widget/app_image.dart';
import 'package:screenshot/screenshot.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:gal/gal.dart';

class ThanhToanScreen extends StatefulWidget {
  const ThanhToanScreen({
    super.key,
    required this.id,
  });
  final String id;
  @override
  State<ThanhToanScreen> createState() => _ThanhToanScreenState();
}

class _ThanhToanScreenState extends State<ThanhToanScreen> {
  ScreenshotController screenshotController = ScreenshotController();

  bool isLoading = true;
  PaymentDetailModel? detailPayment;
  @override
  void initState() {
    super.initState();
    fetchData();
  }

  Future<void> fetchData() async {
    try {
      final response = await CustomerRepo().getDetailPayment(widget.id);
      if (!mounted) return;
      setState(() {
        detailPayment = response;
        isLoading = false;
      });
    } catch (e) {
      // Xử lý lỗi nếu cần
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
        appBar: AppBar(
          backgroundColor: mainOrange,
          elevation: 0,
          centerTitle: true,
          title: Text(
            'Thanh toán học phí',
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
          width: double.infinity,
          height: double.infinity,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(26.r),
              topRight: Radius.circular(26.r),
            ),
          ),
          child: isLoading
              ? Center(
                  child: CircularProgressIndicator(),
                )
              : Column(
                  children: [
                    SizedBox(height: 16.h),
                    Text(
                      'Quét mã để chuyển tiền',
                      style: defaultText16M,
                    ),
                    SizedBox(height: 16.h),
                    Screenshot(
                        controller: screenshotController,
                        child: AppImage(
                          url: detailPayment?.linkQr ?? '',
                          width: 343,
                          height: 454,
                          fit: BoxFit.cover,
                        )),
                    SizedBox(height: 16.h),
                    Row(
                      children: [
                        SizedBox(width: 56.w),
                        GestureDetector(
                          onTap: () {
                            _captureAndSaveWidget();
                          },
                          child: Image.asset(
                            'assets/images/save.png',
                            width: 83.w,
                            height: 24.h,
                          ),
                        ),
                        SizedBox(width: 40.w),
                        GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => ComfirmScreen(
                                  pendingPaymentId:
                                      detailPayment?.pendingPaymentId ?? '',
                                  orderId: detailPayment?.orderId ?? '',
                                ),
                              ),
                            );
                          },
                          child: Container(
                            width: 163.w,
                            height: 40.h,
                            alignment: Alignment.center,
                            decoration: BoxDecoration(
                              color: Color(0xffF6F7FB),
                              borderRadius: BorderRadius.circular(20.r),
                            ),
                            child: Text(
                              L10n.of(context).confirm,
                              style: defaultText14B.copyWith(color: mainBlue),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
        ));
  }

  // Hàm xử lý việc chụp và lưu ảnh widget
  Future<void> _captureAndSaveWidget() async {
    try {
      final bool hasPermission = await Gal.hasAccess(toAlbum: false);
      if (!hasPermission) {
        final bool granted = await Gal.requestAccess(toAlbum: false);
        if (!granted) {
          if (!mounted) return;
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
                content: Text('Quyền truy cập thư viện ảnh bị từ chối.')),
          );

          if (await Permission.photos.isPermanentlyDenied) {
            if (!mounted) return;
            openAppSettings();
          }
          return;
        }
      }

      // 2. Chụp ảnh widget bằng ScreenshotController.capture(...)
      final Uint8List? byteData = await screenshotController.capture(
        delay: const Duration(milliseconds: 10),
        pixelRatio: MediaQuery.of(context).devicePixelRatio,
      );

      if (byteData != null) {
        if (!mounted) return;
        await Gal.putImageBytes(
          byteData,
          name: "Kiddo_QR_${DateTime.now().millisecondsSinceEpoch}",
        );
        if (!mounted) return;
        showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              title: Text(
                L10n.of(context).notification,
              ),
              content: Text("Đã lưu ảnh mã QR vào thư viện ảnh!"),
              actions: [
                ElevatedButton(
                  onPressed: () {
                    if (!mounted) return;
                    Navigator.of(context).pop();
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: mainGreen,
                  ),
                  child: Text("OK",
                      style: defaultText14M.copyWith(color: Colors.white)),
                ),
              ],
            );
          },
        );
      } else {
        showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              title: Text(L10n.of(context).notification),
              content: Text("Không thể chụp ảnh widget."),
              actions: [
                ElevatedButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: mainGreen,
                  ),
                  child: Text("OK",
                      style: defaultText14M.copyWith(color: Colors.white)),
                ),
              ],
            );
          },
        );
      }
    } catch (e) {
      showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            title: Text(
              L10n.of(context).success,
            ),
            content: Text("Lỗi: $e"),
            actions: [
              ElevatedButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: mainGreen,
                ),
                child: Text("OK",
                    style: defaultText14M.copyWith(color: Colors.white)),
              ),
            ],
          );
        },
      );
    }
  }
}
