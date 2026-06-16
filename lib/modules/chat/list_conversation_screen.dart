import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:kiddo/l10n/l10n.dart';
import 'package:kiddo/student_models/chat_models.dart';
import 'package:kiddo/student_repo/chat_repo.dart';
import 'package:kiddo/utils/constants/color.dart';
import 'package:kiddo/utils/constants/styles.dart';
import 'package:kiddo/utils/widget/custom_widget.dart';

class ListConversationScreen extends StatefulWidget {
  const ListConversationScreen({
    super.key,
    required this.title,
    required this.type,
  });
  final String title;
  final String type;
  @override
  State<ListConversationScreen> createState() => _ListConversationScreenState();
}

class _ListConversationScreenState extends State<ListConversationScreen> {
  bool isLoading = true;
  //late List<ConverastionModel> listConversation;
  late List<UserModel> listAdmin;

  @override
  void initState() {
    super.initState();
    fetchData();
  }

  @override
  void dispose() {
    super.dispose();
  }

  Future<void> fetchData() async {
    try {
      final response = await ChatRepo().getlistAdmin(widget.type);
      setState(() {
        listAdmin = response;
        isLoading = false;
      });
    } catch (e) {
      // Xử lý lỗi nếu cần
      debugPrint('Lỗi khi gọi API: $e');
      setState(() {
        listAdmin = [];
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
          widget.title,
          style: defaultText18B.copyWith(
            color: Colors.white,
          ),
        ),
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
            ? Center(
                child: CircularProgressIndicator(),
              )
            : listAdmin.isEmpty
                ? Center(
                    child: Text(
                      L10n.of(context).noConversation,
                      style: defaultText14M,
                    ),
                  )
                : ListView.builder(
                    padding: EdgeInsets.only(
                      left: 20.w,
                      right: 20.w,
                      bottom: 80.w,
                      top: 10.h, // Added top padding replacing SizedBox
                    ),
                    physics: const ClampingScrollPhysics(),
                    itemCount: listAdmin.length,
                    itemBuilder: (BuildContext context, int index) {
                      return Padding(
                        padding: EdgeInsets.only(bottom: 10.h),
                        child: ConversationItem(
                          model: listAdmin[index],
                          type: widget.type,
                        ),
                      );
                    },
                  ),
      ),
    );
  }
}
