import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:kiddo/utils/constants/color.dart';
import 'package:kiddo/utils/constants/styles.dart';
import 'package:screen_protector/screen_protector.dart';
import 'package:webview_flutter/webview_flutter.dart';

class DetailVideo extends StatefulWidget {
  const DetailVideo({
    super.key,
    required this.videoId,
    required this.libraryId,
  });

  final String videoId;
  final int libraryId;

  @override
  State<DetailVideo> createState() => _DetailVideoState();
}

class _DetailVideoState extends State<DetailVideo> with WidgetsBindingObserver {
  bool _isRecording = false;
  bool _isFullscreen = false;
  StreamSubscription? _recordingSub;

  late final WebViewController _controller;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _initSecurity();
    _initWebView();
  }

  /// 🔐 Security setup
  Future<void> _initSecurity() async {
    if (Platform.isAndroid) {
      await ScreenProtector.preventScreenshotOn();
    } else if (Platform.isIOS) {
      await ScreenProtector.protectDataLeakageWithBlur();

      bool isRecording = await ScreenProtector.isRecording();
      setState(() => _isRecording = isRecording);

      _recordingSub =
          Stream.periodic(const Duration(seconds: 1)).listen((_) async {
        bool recording = await ScreenProtector.isRecording();
        if (recording != _isRecording) {
          setState(() => _isRecording = recording);
        }
      });
    }
  }

  /// 🌐 WebView setup + detect fullscreen
  void _initWebView() {
    final url =
        "https://iframe.mediadelivery.net/embed/${widget.libraryId}/${widget.videoId}";

    _controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)

      /// 📡 Channel nhận event từ JS
      ..addJavaScriptChannel(
        'FullscreenChannel',
        onMessageReceived: (message) {
          if (message.message == 'enter_fullscreen') {
            setState(() => _isFullscreen = true);
          } else if (message.message == 'exit_fullscreen') {
            setState(() => _isFullscreen = false);
          }
        },
      )
      ..setNavigationDelegate(
        NavigationDelegate(
          onPageFinished: (url) async {
            /// 🎯 Inject JS detect fullscreen
            await _controller.runJavaScript('''
              document.addEventListener("fullscreenchange", function() {
                if (document.fullscreenElement) {
                  FullscreenChannel.postMessage("enter_fullscreen");
                } else {
                  FullscreenChannel.postMessage("exit_fullscreen");
                }
              });
            ''');
          },
        ),
      )
      ..loadRequest(Uri.parse(url));
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _recordingSub?.cancel();

    if (Platform.isAndroid) {
      ScreenProtector.preventScreenshotOff();
    }

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        /// 👉 Wrap toàn màn hình ở đây
        Scaffold(
          appBar: AppBar(
            backgroundColor: mainOrange,
            elevation: 0,
            centerTitle: true,
            title: Text(
              'Video',
              style: defaultText16B.copyWith(color: Colors.white),
            ),
            leading: IconButton(
              onPressed: () => Navigator.pop(context),
              icon: const Icon(Icons.arrow_back_ios, color: Colors.white),
            ),
          ),
          body: WebViewWidget(controller: _controller),
        ),

        /// 🔥 Overlay khi quay màn hình (iOS)
        if (_isRecording) _buildBlockOverlay("Screen recording is not allowed"),

        /// 🔥 Overlay khi fullscreen (fix case bạn gặp)
        if (_isFullscreen && Platform.isIOS)
          _buildBlockOverlay("Fullscreen is restricted"),
      ],
    );
  }

  Widget _buildBlockOverlay(String text) {
    return Container(
      color: Colors.black,
      alignment: Alignment.center,
      child: Text(
        text,
        style: const TextStyle(color: Colors.white, fontSize: 16),
      ),
    );
  }
}
