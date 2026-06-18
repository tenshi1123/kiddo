import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:kiddo/student_models/profile_model.dart';
import 'package:kiddo/utils/constants/color.dart';
import 'package:kiddo/utils/constants/styles.dart';
import 'package:screen_protector/screen_protector.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:webview_flutter_wkwebview/webview_flutter_wkwebview.dart';
import 'package:webview_flutter_android/webview_flutter_android.dart';

class DetailWebViewVideo extends StatefulWidget {
  const DetailWebViewVideo({
    super.key,
    required this.url,
    required this.name,
    this.model,
  });

  final String url;
  final String name;
  final ProfileModel? model;

  @override
  State<DetailWebViewVideo> createState() => _DetailWebViewVideoState();
}

class _DetailWebViewVideoState extends State<DetailWebViewVideo>
    with WidgetsBindingObserver {
  bool _isRecording = false;
  final bool _isFullscreen = false;
  bool _isLandscape = false;
  StreamSubscription? _recordingSub;

  late final WebViewController _controller;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _initSecurity();
    _initWebView();
  }

  Future<void> _initSecurity() async {
    // Bật chặn chụp và quay màn hình cho CẢ Android và iOS
    await ScreenProtector.preventScreenshotOn();

    if (Platform.isIOS) {
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

  void _initWebView() {
    late final PlatformWebViewControllerCreationParams params;
    if (WebViewPlatform.instance is WebKitWebViewPlatform) {
      params = WebKitWebViewControllerCreationParams(
        allowsInlineMediaPlayback: true,
        mediaTypesRequiringUserAction: const <PlaybackMediaTypes>{}, // Bật tự động phát cho iOS
      );
    } else {
      params = const PlatformWebViewControllerCreationParams();
    }
    _controller = WebViewController.fromPlatformCreationParams(params)
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..addJavaScriptChannel(
        'VideoChannel',
        onMessageReceived: (JavaScriptMessage message) {
          if (message.message == 'video_ended') {
            if (mounted) {
              Navigator.pop(context, true);
            }
          }
        },
      )
      ..setNavigationDelegate(
        NavigationDelegate(
          onPageFinished: (String url) async {
            // Inject JS to detect when the <video> tag finishes playing
            // This relies on the webpage containing a standard <video> element.
            await _controller.runJavaScript('''
              document.addEventListener('ended', function(e) {
                if (e.target && e.target.tagName && e.target.tagName.toLowerCase() === 'video') {
                  try {
                    if (typeof VideoChannel !== 'undefined') {
                      VideoChannel.postMessage('video_ended');
                    } else if (window.VideoChannel) {
                      window.VideoChannel.postMessage('video_ended');
                    }
                  } catch(err) {
                    console.error(err);
                  }
                }
              }, true);

              // Cố gắng ép video tự động phát
              setTimeout(function() {
                var videos = document.querySelectorAll('video');
                videos.forEach(function(v) {
                  v.play().catch(function(e) { console.error("Autoplay prevented:", e); });
                });
              }, 1000);
            ''');
          },
        ),
      );

    if (_controller.platform is AndroidWebViewController) {
      (_controller.platform as AndroidWebViewController)
          .setMediaPlaybackRequiresUserGesture(false); // Bật tự động phát cho Android
    }

    _controller.loadRequest(Uri.parse(widget.url));
  }

  @override
  void dispose() {
    SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
    WidgetsBinding.instance.removeObserver(this);
    _recordingSub?.cancel();
    ScreenProtector.preventScreenshotOff();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Scaffold(
          appBar: AppBar(
            backgroundColor: mainOrange,
            elevation: 0,
            centerTitle: true,
            title: Text(
              widget.name,
              style: defaultText16B.copyWith(color: Colors.white),
            ),
            leading: IconButton(
              onPressed: () {
                SystemChrome.setPreferredOrientations(
                    [DeviceOrientation.portraitUp]);
                Navigator.pop(context);
              },
              icon: const Icon(Icons.arrow_back_ios, color: Colors.white),
            ),
            actions: [
              IconButton(
                onPressed: () {
                  setState(() {
                    _isLandscape = !_isLandscape;
                  });
                  if (_isLandscape) {
                    SystemChrome.setPreferredOrientations([
                      DeviceOrientation.landscapeLeft,
                      DeviceOrientation.landscapeRight,
                    ]);
                  } else {
                    SystemChrome.setPreferredOrientations([
                      DeviceOrientation.portraitUp,
                    ]);
                  }
                },
                icon: Icon(
                  _isLandscape
                      ? Icons.screen_lock_portrait
                      : Icons.screen_rotation,
                  color: Colors.white,
                ),
              ),
            ],
          ),
          body: WebViewWidget(controller: _controller),
        ),
        if (_isRecording) _buildBlockOverlay("Screen recording is not allowed"),
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
