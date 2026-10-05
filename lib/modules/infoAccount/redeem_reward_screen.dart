import 'package:flutter/material.dart';
import 'package:kiddo/l10n/app_localizations.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:kiddo/student_models/gift_models.dart';
import 'package:kiddo/utils/constants/color.dart';
import 'package:kiddo/utils/constants/styles.dart';
import 'package:kiddo/utils/widget/app_image.dart';

class RedeemRewardScreen extends StatefulWidget {
  const RedeemRewardScreen({super.key, required this.giftModel});
  final GiftModel giftModel;
  @override
  State<RedeemRewardScreen> createState() => _RedeemRewardScreenState();
}

class _RedeemRewardScreenState extends State<RedeemRewardScreen> {
  late GiftModel _giftModel; // Giả sử bạn load từ API
  final Set<String> selectedIds = {};
  String get selectedNames {
    return widget.giftModel.value
        .where((item) => selectedIds.contains(item.id))
        .map((item) => item.name)
        .join(', ');
  }

  @override
  void initState() {
    super.initState();
    _giftModel = widget.giftModel;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text(
          'Đổi điểm thưởng',
          style: defaultText18B,
        ),
        centerTitle: true,
        toolbarHeight: 60.h,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios_new, color: mainBlue),
          onPressed: () => Navigator.of(context).pop(),
        ),
        backgroundColor: Colors.white,
      ),
      body: Stack(
        children: [
          Column(
            children: [
              SizedBox(
                width: 390.w,
                height: 84.h,
                child: Stack(
                  children: [
                    Positioned(
                      right: 20.w,
                      child: Image.asset(
                        'assets/images/redeem.png',
                        height: 84.h,
                        width: 350.w,
                        fit: BoxFit.fill,
                      ),
                    ),
                    Positioned(
                      top: 20.h,
                      right: 40.w,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Text(
                            'Điểm thưởng của tôi',
                            style: defaultText14Re,
                          ),
                          Text(
                            '${_giftModel.totalCustomerScore} điểm',
                            style: defaultText20B.copyWith(
                              color: Colors.white,
                            ),
                          )
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: 10.h,
              ),
              SizedBox(
                width: 390.w,
                height: 600.h,
                child: GridView.count(
                  crossAxisCount: 2,
                  //childAspectRatio: (1 / .35),
                  //shrinkWrap: true,
                  scrollDirection: Axis.vertical,
                  children: List.generate(
                    _giftModel.value.length,
                    (i) {
                      final item = _giftModel.value[i];
                      final isSelected = selectedIds.contains(item.id);
                      return PresentItem(
                        model: _giftModel.value[i],
                        isSelected: isSelected,
                        onChanged: (bool? value) {
                          setState(() {
                            if (value == true) {
                              selectedIds.add(item.id);
                            } else {
                              selectedIds.remove(item.id);
                            }
                          });
                        },
                      );
                    },
                  ),
                ),
              ),
            ],
          ),
          Align(
            alignment: Alignment.bottomLeft,
            child: Container(
              padding: EdgeInsets.only(left: 10, bottom: 20.h, top: 20.h),
              height: 94.h,
              width: double.infinity,
              decoration: BoxDecoration(
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                    color: mainBlue.withOpacity(0.1),
                    spreadRadius: 1,
                    blurRadius: 5,
                    offset: const Offset(0, -1), // changes position of shadow
                  ),
                ],
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: <Widget>[
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      RichText(
                        text: TextSpan(
                          text: 'Đã chọn ',
                          style: defaultText16Re,
                          children: <TextSpan>[
                            TextSpan(
                              text: selectedIds.length.toString(),
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16.sp,
                                  color: mainOrange),
                            ),
                            const TextSpan(text: ' phần thưởng!'),
                          ],
                        ),
                      ),
                      Text(
                        'Tiêu hao: ${_giftModel.value.where((item) => selectedIds.contains(item.id)).map((item) => int.tryParse(item.score) ?? 0).fold(0, (prev, score) => prev + score)} điểm',
                        style: defaultText14Re.copyWith(
                          color: mainBlue.withOpacity(0.5),
                        ),
                      )
                    ],
                  ),
                  const SizedBox(
                    width: 15,
                  ),
                  GestureDetector(
                    onTap: () {
                      showDialog<String>(
                        context: context,
                        builder: (BuildContext context) => AlertDialog(
                          backgroundColor: Colors.white,
                          title: RichText(
                            text: TextSpan(
                              text: 'Bạn xác nhận đổi ',
                              style: defaultText14M,
                              children: [
                                TextSpan(
                                  text:
                                      ' ${_giftModel.value.where((item) => selectedIds.contains(item.id)).map((item) => int.tryParse(item.score) ?? 0).fold(0, (prev, score) => prev + score)} điểm thưởng',
                                  style: defaultText14B.copyWith(
                                    color: mainOrange,
                                  ),
                                ),
                                const TextSpan(text: ' lấy phần quà'),
                                TextSpan(
                                  text: selectedNames.isNotEmpty
                                      ? ' $selectedNames'
                                      : '',
                                  style: defaultText14B.copyWith(
                                    color: mainOrange,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          actions: <Widget>[
                            GestureDetector(
                              onTap: () {
                                Navigator.pop(context, 'Cancel');
                              },
                              child: Container(
                                height: 37.h,
                                width: 111.w,
                                decoration: BoxDecoration(
                                  color: state2,
                                  borderRadius: BorderRadius.all(
                                    Radius.circular(4.r),
                                  ),
                                ),
                                child: Center(
                                    child: Text('Hủy', style: defaultText14M)),
                              ),
                            ),
                            SizedBox(
                              width: 10.w,
                            ),
                            GestureDetector(
                              onTap: () async {
                                // Hiển thị thông báo
                                showDialog(
                                  context: context,
                                  builder: (context) {
                                    return AlertDialog(
                                      title: Text(AppLocalizations.of(context).notification),
                                      content: Text(AppLocalizations.of(context).redeemSuccess),
                                      actions: [
                                        TextButton(
                                          onPressed: () {
                                            Navigator.of(context).pop();
                                          },
                                          child: Text('OK'),
                                        ),
                                      ],
                                    );
                                  },
                                );
                              },
                              child: Container(
                                height: 37.h,
                                width: 111.w,
                                decoration: BoxDecoration(
                                  gradient: mainGradient2,
                                  borderRadius: BorderRadius.all(
                                    Radius.circular(4.r),
                                  ),
                                ),
                                child: Center(
                                    child: Text('Xác nhận',
                                        style: defaultText14B.copyWith(
                                          color: Colors.white,
                                        ))),
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                    child: Container(
                      width: 131.w,
                      height: 43.h,
                      decoration: BoxDecoration(
                        gradient: mainGradient2,
                        borderRadius: BorderRadius.all(
                          Radius.circular(36.r),
                        ),
                      ),
                      child: Center(
                        child: Text(
                          'Xác nhận đổi',
                          style: defaultText14B.copyWith(
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}

class PresentItem extends StatelessWidget {
  const PresentItem({
    super.key,
    required this.model,
    required this.isSelected,
    required this.onChanged,
  });

  final GiftItem model;
  final bool isSelected;
  final ValueChanged<bool?> onChanged;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 162.w,
      height: 162.h,
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Checkbox(
                value: isSelected,
                onChanged: onChanged,
              ),
              Text(
                'còn (${int.parse(model.totalWarehouseGiftQuantity) - int.parse(model.chuaDuyet) - int.parse(model.daDuyet)})',
                style: defaultText12Re,
              ),
            ],
          ),
          AppImage(
            url: 'https://lms.kiddoenglish.edu.vn/images/${model.img}',
            height: 88.h,
            fit: BoxFit.fitHeight,
          ),
          SizedBox(height: 10.h),
          Text(
            model.name,
            style: defaultText12Re,
          ),
          Text(
            '${model.score} điểm',
            style: defaultText16B.copyWith(color: mainRed),
          ),
        ],
      ),
    );
  }
}
