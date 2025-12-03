import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:kiddo/modules/bottombar/screen/details_offer_screen.dart';
import 'package:kiddo/student_models/review_models.dart';
import 'package:kiddo/student_repo/extension_repo.dart';
import 'package:kiddo/utils/constants/color.dart';
import 'package:kiddo/utils/constants/styles.dart';
import 'package:persistent_bottom_nav_bar_v2/persistent_bottom_nav_bar_v2.dart';

class OfferScreen extends StatefulWidget {
  const OfferScreen({super.key});

  @override
  State<OfferScreen> createState() => _OfferScreenState();
}

class _OfferScreenState extends State<OfferScreen> {
  bool isLoading = true;
  List<DiscountModels> listDiscount = [];
  @override
  void initState() {
    super.initState();
    fetchData();
  }

  Future<void> fetchData() async {
    try {
      final response = await ExtensionRepo().getListDiscount();
      setState(() {
        listDiscount = response;
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
        title: Text("Ưu đãi",
            style: defaultText18B.copyWith(
              color: Colors.white,
            )),
        automaticallyImplyLeading: false,
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
        child: isLoading
            ? Center(child: CircularProgressIndicator())
            : listDiscount.isEmpty
                ? Center(
                    child: Text(
                      'Không có ưu đãi',
                      style: defaultText14M,
                    ),
                  )
                : ListView.builder(
                    itemCount: listDiscount.length,
                    itemBuilder: (BuildContext context, int index) {
                      return GestureDetector(
                        onTap: () {
                          pushWithoutNavBar(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => DetailsOfferScreen(
                                        id: listDiscount[index].id,
                                      )));
                        },
                        child: Container(
                          //height: 84.h,
                          width: 348.w,
                          margin: EdgeInsets.symmetric(
                              horizontal: 16.w, vertical: 8.h),
                          decoration: BoxDecoration(
                            image: DecorationImage(
                              image:
                                  AssetImage('assets/images/empty_offer.png'),
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
                                  Text(listDiscount[index].title,
                                      style: defaultText14B),
                                  Text("HSD: ${listDiscount[index].expiryDate}",
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
                                                text: listDiscount[index].code,
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
                              Center(
                                child: Text(
                                  'Chi tiết',
                                  style: defaultText12B.copyWith(
                                    color: mainBlue,
                                    decoration: TextDecoration.underline,
                                  ),
                                ),
                              ),
                              SizedBox(width: 16.w),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
      ),
    );
  }
}
