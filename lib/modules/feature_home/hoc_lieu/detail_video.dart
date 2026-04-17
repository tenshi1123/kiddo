import 'package:flutter/material.dart';
import 'package:kiddo/utils/constants/color.dart';
import 'package:kiddo/utils/constants/styles.dart';
import 'package:screen_protector/screen_protector.dart';
import 'package:webview_flutter/webview_flutter.dart';

class DetailVideo extends StatefulWidget {
  const DetailVideo(
      {super.key, required this.videoId, required this.libraryId});
  final String videoId;
  final int libraryId;

  @override
  State<DetailVideo> createState() => _DetailVideoState();
}

class _DetailVideoState extends State<DetailVideo> {
  void _preventScreenshotOn() async =>
      await ScreenProtector.preventScreenshotOn();
  @override
  void initState() {
    super.initState();
    // Kích hoạt bảo vệ
    _preventScreenshotOn();
  }

  @override
  Widget build(BuildContext context) {
    final url =
        "https://iframe.mediadelivery.net/embed/${widget.libraryId}/${widget.videoId}";

    return Scaffold(
        appBar: AppBar(
          backgroundColor: mainOrange,
          elevation: 0,
          centerTitle: true,
          title: Text(
            'Video',
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
        ),
        body: WebViewWidget(
          controller: WebViewController()
            ..setJavaScriptMode(JavaScriptMode.unrestricted)
            ..loadRequest(Uri.parse(url)),
        ));
  }
}
