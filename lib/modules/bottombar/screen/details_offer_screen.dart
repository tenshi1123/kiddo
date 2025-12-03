import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:kiddo/student_models/review_models.dart';
import 'package:kiddo/student_repo/extension_repo.dart';
import 'package:kiddo/utils/constants/color.dart';
import 'package:kiddo/utils/constants/styles.dart';

class DetailsOfferScreen extends StatefulWidget {
  const DetailsOfferScreen({super.key, required this.id});
  final String id;
  @override
  State<DetailsOfferScreen> createState() => _DetailsOfferScreenState();
}

class _DetailsOfferScreenState extends State<DetailsOfferScreen> {
  bool isLoading = true;
  late DetailDiscountModels detailDiscount;
  @override
  void initState() {
    super.initState();
    fetchData();
  }

  Future<void> fetchData() async {
    try {
      final response = await ExtensionRepo().getDetailDiscount(widget.id);
      setState(() {
        detailDiscount = response;
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
      backgroundColor: mainOrange, // nền AppBar
      appBar: AppBar(
        backgroundColor: mainOrange,
        elevation: 0,
        centerTitle: true,
        title: Text(
          "Chi tiết ưu đãi",
          style: defaultText18B.copyWith(
            color: Colors.white,
          ),
        ),
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios_new, color: Colors.white, size: 24.w),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        actions: [
          SvgPicture.asset(
            'assets/icons/bell.svg',
            width: 20.w,
            height: 20.h,
            colorFilter: ColorFilter.mode(
              Colors.white,
              BlendMode.srcIn,
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
            topLeft: Radius.circular(24.r),
            topRight: Radius.circular(24.r),
          ),
        ),
        child: SingleChildScrollView(
          padding: EdgeInsets.all(16.w),
          child: isLoading
              ? CircularProgressIndicator()
              : Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      //height: 84.h,
                      width: 348.w,
                      decoration: BoxDecoration(
                        image: DecorationImage(
                          image: AssetImage('assets/images/empty_offer.png'),
                          fit: BoxFit.fitWidth,
                        ),
                      ),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(width: 100.w),
                          Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(detailDiscount.title, style: defaultText14B),
                              Text("HSD: ${detailDiscount.expiryDate}",
                                  style: defaultText12Re),
                              SizedBox(height: 6.h),
                              Container(
                                decoration: BoxDecoration(
                                  color: mainOrange,
                                  borderRadius: BorderRadius.circular(4.r),
                                ),
                                child: Padding(
                                  padding: EdgeInsets.symmetric(
                                      horizontal: 8.w, vertical: 4.h),
                                  child: RichText(
                                    text: TextSpan(
                                      text: 'Mã: ',
                                      style: defaultText12M.copyWith(
                                          color: Colors.white),
                                      children: <TextSpan>[
                                        TextSpan(
                                            text: detailDiscount.code,
                                            style: defaultText12B.copyWith(
                                                color: Colors.white)),
                                      ],
                                    ),
                                  ),
                                ),
                              )
                            ],
                          ),
                          Spacer(),
                          SizedBox(width: 16.w),
                        ],
                      ),
                    ),
                    SizedBox(height: 12.h),
                    // Row(
                    //   children: [
                    //     SvgPicture.asset(
                    //       'assets/icons/clock2.svg',
                    //       width: 16.w,
                    //       height: 16.h,
                    //       colorFilter: ColorFilter.mode(
                    //         colorText.withValues(alpha: 0.64),
                    //         BlendMode.srcIn,
                    //       ),
                    //     ),
                    //     SizedBox(
                    //       width: 8.w,
                    //     ),
                    //     Text(
                    //       "Hiệu lực sau: 6 giờ",
                    //       style: defaultText12M.copyWith(
                    //         color: colorText.withValues(alpha: 0.64),
                    //       ),
                    //     ),
                    //   ],
                    // ),
                    SizedBox(height: 16.h),
                    Text(
                      "Hạn sử dụng mã",
                      style: defaultText14B,
                    ),
                    Text(
                      detailDiscount.expiryDate,
                      style: defaultText12M.copyWith(
                        color: colorText.withValues(alpha: 0.64),
                      ),
                    ),
                    SizedBox(height: 16.h),
                    Text(
                      "Nội dung ưu đãi",
                      style: defaultText14B,
                    ),
                    Html(data: detailDiscount.content),
                    // Text(
                    //   detailDiscount.content,
                    //   style: defaultText12M.copyWith(
                    //     color: colorText.withValues(alpha: 0.64),
                    //   ),
                    // ),
                  ],
                ),
        ),
      ),
    );
  }
}
