import 'dart:async';
import 'dart:io';

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

class VideoSecurityWrapper extends StatefulWidget {
  final Widget child;

  const VideoSecurityWrapper({
    super.key,
    required this.child,
  });

  @override
  State<VideoSecurityWrapper> createState() => _VideoSecurityWrapperState();
}

class _VideoSecurityWrapperState extends State<VideoSecurityWrapper>
    with WidgetsBindingObserver {
  bool _isRecording = false;
  StreamSubscription? _recordingSub;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _initSecurity();
  }

  Future<void> _initSecurity() async {
    if (Platform.isAndroid) {
      /// ✅ Android: chặn screenshot + record
      await ScreenProtector.preventScreenshotOn();
    } else if (Platform.isIOS) {
      /// ✅ iOS: chỉ có thể detect + xử lý UI

      /// Blur khi app vào background (app switcher)
      await ScreenProtector.protectDataLeakageWithBlur();

      /// Check trạng thái recording ban đầu
      bool isRecording = await ScreenProtector.isRecording();
      setState(() {
        _isRecording = isRecording;
      });

      /// Poll recording state (vì iOS không realtime 100%)
      _recordingSub =
          Stream.periodic(const Duration(seconds: 1)).listen((_) async {
        bool recording = await ScreenProtector.isRecording();
        if (recording != _isRecording) {
          setState(() {
            _isRecording = recording;
          });
        }
      });
    }
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _recordingSub?.cancel();

    /// Reset (optional)
    if (Platform.isAndroid) {
      ScreenProtector.preventScreenshotOff();
    }

    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    /// Có thể xử lý thêm nếu cần
    if (state == AppLifecycleState.paused) {
      // app vào background
    }
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        widget.child,

        /// 🔥 Overlay khi detect recording (iOS)
        if (_isRecording)
          Container(
            color: Colors.black,
            alignment: Alignment.center,
            child: const Text(
              "Screen recording is not allowed",
              style: TextStyle(color: Colors.white, fontSize: 16),
            ),
          ),
      ],
    );
  }
}
