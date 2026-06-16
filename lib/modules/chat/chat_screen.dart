import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:intl/intl.dart';
import 'package:kiddo/student_models/chat_models.dart';
import 'package:kiddo/student_repo/chat_repo.dart';
import 'package:kiddo/utils/constants/color.dart';
import 'package:kiddo/utils/constants/styles.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:camera_camera/camera_camera.dart';
import 'package:image_picker/image_picker.dart';

class ChatScreen extends StatefulWidget {
  const ChatScreen({
    super.key,
    required this.model,
    required this.type,
  });
  final UserModel model;
  final String type;
  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  TextEditingController messageController = TextEditingController();
  List<File> photos = <File>[];
  String id = '';

  void openCamera() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => CameraCamera(
          onFile: (file) async {
            //Navigator.pop(context);
            // await ChatRepo().sendImageMessage(widget.model.id, file);
            showDialog(
              context: context,
              builder: (BuildContext context) {
                return CupertinoAlertDialog(
                  title: const Text('Tin nhắn đã được gửi'),
                  actions: <Widget>[
                    CupertinoDialogAction(
                      isDefaultAction: true,
                      child: Text(
                        'ok',
                        style: TextStyle(fontSize: 20, color: mainOrange),
                      ),
                      onPressed: () {
                        Navigator.pop(context);
                        Navigator.pop(context);
                      },
                    )
                  ],
                );
              },
            );
            setState(() {});
          },
        ),
      ),
    );
  }

  Future _pickImageFromGallery() async {
    final returnedImage = await ImagePicker().pickMultiImage();
    if (!mounted) return;
    if (!mounted) return;
    photos = List<File>.from(
      (returnedImage).map(
        (e) => File(e.path),
      ),
    );
    //File(returnedImage!.path);
    if (photos.isNotEmpty) {
      //await ChatRepo().sendImageMessage(widget.model.id, photos.last);
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return CupertinoAlertDialog(
            title: const Text('Tin nhắn đã được gửi'),
            actions: <Widget>[
              CupertinoDialogAction(
                isDefaultAction: true,
                child: Text(
                  'ok',
                  style: TextStyle(fontSize: 20, color: mainOrange),
                ),
                onPressed: () {
                  Navigator.pop(context);
                  Navigator.pop(context);
                },
              )
            ],
          );
        },
      );
    }
    setState(() {});
  }

  Future<void> _getIdUser() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    id = prefs.getString('id_user') ?? '';
    setState(() {
      // Cập nhật trạng thái để hiển thị dữ liệu mới
    });
  }

  bool isLoading = true;
  List<MessageModel> listMessage = [];

  Future<void> fetchData() async {
    try {
      final response = await ChatRepo().getListMessage(
          lectureId: widget.model.userId ?? '', type: widget.type);
      setState(() {
        listMessage = response;
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
  void initState() {
    //listMessage = widget.model.messages;
    _getIdUser();
    fetchData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          title: Row(
            children: [
              CircleAvatar(
                radius: 21.r,
                backgroundImage: NetworkImage(widget.model.avatar ?? ''),
                backgroundColor: Colors.transparent,
              ),
              SizedBox(
                width: 10.w,
              ),
              SizedBox(
                width: 230.w,
                child: Text(
                  widget.model.fullName ?? 'Không xác định',
                  style: defaultText18B.copyWith(
                    color: Colors.white,
                  ),
                ),
              ),
            ],
          ),
          toolbarHeight: 60.h,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back_ios_new, color: Colors.white),
            onPressed: () => Navigator.of(context).pop(),
          ),
          flexibleSpace: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment(0.8, 1),
                colors: [
                  mainOrange.withValues(alpha: 0.8),
                  mainOrange,
                ],
              ),
            ),
          ),
          // actions: [
          //   IconButton(
          //     icon: const Icon(
          //       Icons.phone,
          //       color: Colors.white,
          //     ),
          //     onPressed: () {
          //       _makePhoneCall('19008978');
          //     },
          //   ),
          // ],
        ),
        body: Stack(
          children: [
            SizedBox(
                height: 655.h,
                child: ListView.builder(
                  padding: EdgeInsets.symmetric(horizontal: 16.w),
                  itemCount: listMessage.length,
                  itemBuilder: (context, index) {
                    final current = listMessage[index];
                    final previous = index > 0 ? listMessage[index - 1] : null;

                    bool showTimeLabel = false;
                    String timeLabel = '';

                    if (previous == null) {
                      showTimeLabel = true;
                      timeLabel = DateFormat('dd/MM/yyyy HH:mm')
                          .format(current.createdAt);
                    } else {
                      final difference =
                          current.createdAt.difference(previous.createdAt);
                      if (current.createdAt.day != previous.createdAt.day) {
                        showTimeLabel = true;
                        timeLabel = DateFormat('dd/MM/yyyy HH:mm')
                            .format(current.createdAt);
                      } else if (difference.inHours >= 1) {
                        showTimeLabel = true;
                        timeLabel =
                            DateFormat('HH:mm').format(current.createdAt);
                      }
                    }

                    return Column(
                      children: [
                        // 🕓 Thời gian giữa tin nhắn — fade-in nhẹ
                        if (showTimeLabel)
                          AnimatedOpacity(
                            opacity: 1.0,
                            duration: const Duration(milliseconds: 500),
                            curve: Curves.easeInOut,
                            child: Padding(
                              padding: EdgeInsets.symmetric(vertical: 8.h),
                              child: Text(
                                timeLabel,
                                style: TextStyle(
                                  fontSize: 12.sp,
                                  color: Colors.grey.shade600,
                                  fontStyle: FontStyle.italic,
                                ),
                              ),
                            ),
                          ),
                        // 💬 Tin nhắn
                        Align(
                          alignment:
                              (current.type == "0" || current.type == '1')
                                  ? Alignment.topRight
                                  : Alignment.topLeft,
                          child: Container(
                            margin: EdgeInsets.only(bottom: 6.h),
                            constraints: BoxConstraints(maxWidth: 300.w),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(20.r),
                              color:
                                  (current.type == "0" || current.type == '1')
                                      ? mainOrange
                                      : Colors.grey.shade200,
                            ),
                            padding: EdgeInsets.all(16.r),
                            child: Text(
                              current.content,
                              style: TextStyle(
                                fontSize: 14.sp,
                                color:
                                    (current.type == "0" || current.type == '1')
                                        ? Colors.white
                                        : Colors.black87,
                              ),
                            ),
                          ),
                        ),
                      ],
                    );
                  },
                )),
            Align(
              alignment: Alignment.bottomLeft,
              child: Container(
                padding: const EdgeInsets.only(left: 10, bottom: 10, top: 10),
                margin: EdgeInsets.only(bottom: 16.h),
                //height: 60.h,
                width: double.infinity,
                color: Colors.white,
                child: Row(
                  children: <Widget>[
                    // GestureDetector(
                    //     onTap: () {
                    //       openCamera();
                    //     },
                    //     child:
                    //         SvgPicture.asset('assets/icons/camera_icon.svg')),
                    // const SizedBox(
                    //   width: 15,
                    // ),
                    // GestureDetector(
                    //     onTap: () {
                    //       _pickImageFromGallery();
                    //     },
                    //     child:
                    //         SvgPicture.asset('assets/icons/picture_icon.svg')),
                    SizedBox(
                      width: 20.w,
                    ),
                    Expanded(
                      child: Container(
                        decoration: BoxDecoration(
                          color: state2,
                          borderRadius:
                              const BorderRadius.all(Radius.circular(15)),
                        ),
                        padding: EdgeInsets.symmetric(horizontal: 10.w),
                        child: TextField(
                          controller: messageController,
                          decoration: InputDecoration(
                              hintText: "Nhập tin nhắn...",
                              hintStyle: TextStyle(
                                  color: Colors.black.withValues(alpha: 0.95)),
                              border: InputBorder.none),
                          style: defaultText14M,
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ),
                    SizedBox(
                      width: 16.w,
                    ),
                    GestureDetector(
                        onTap: () async {
                          if (messageController.text.isNotEmpty) {
                            ChatRepo().sendMessage(widget.model.userId ?? '',
                                messageController.text, widget.type);
                            setState(() {
                              listMessage.insert(
                                listMessage.length,
                                MessageModel(
                                  content: messageController.text,
                                  createdAt: DateTime.now(),
                                  id: '',
                                  chatMessageId: '',
                                  customerId: '',
                                  lectureId: '',
                                  type: "0",
                                ),
                              );
                            });
                            messageController.clear();
                            showDialog(
                              context: context,
                              builder: (BuildContext context) {
                                return CupertinoAlertDialog(
                                  title: const Text('Tin nhắn đã được gửi'),
                                  actions: <Widget>[
                                    CupertinoDialogAction(
                                      isDefaultAction: true,
                                      child: Text(
                                        'ok',
                                        style: TextStyle(
                                            fontSize: 20, color: mainOrange),
                                      ),
                                      onPressed: () {
                                        Navigator.of(context,
                                                rootNavigator: true)
                                            .pop(
                                          (_) => false,
                                        );
                                      },
                                    )
                                  ],
                                );
                              },
                            );
                          }
                        },
                        // onTap: () async {
                        //   messageController.clear();
                        //   showDialog(
                        //     context: context,
                        //     builder: (BuildContext context) {
                        //       return CupertinoAlertDialog(
                        //         title: const Text('Tin nhắn đã được gửi'),
                        //         actions: <Widget>[
                        //           CupertinoDialogAction(
                        //             isDefaultAction: true,
                        //             child: Text(
                        //               'ok',
                        //               style: TextStyle(
                        //                   fontSize: 20, color: mainOrange),
                        //             ),
                        //             onPressed: () {
                        //               Navigator.of(context, rootNavigator: true)
                        //                   .pop(
                        //                 (_) => false,
                        //               );
                        //             },
                        //           )
                        //         ],
                        //       );
                        //     },
                        //   );
                        // },
                        child:
                            SvgPicture.asset('assets/icons/plane_outline.svg')),
                    SizedBox(
                      width: 16.w,
                    ),
                  ],
                ),
              ),
            )
          ],
        ));
  }
}
