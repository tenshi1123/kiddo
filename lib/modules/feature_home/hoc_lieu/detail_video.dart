import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:kiddo/student_models/info_class_model.dart';
import 'package:kiddo/student_models/profile_model.dart';
import 'package:kiddo/student_repo/video_repo.dart';
import 'package:kiddo/utils/constants/color.dart';
import 'package:kiddo/utils/constants/styles.dart';
import 'package:screen_protector/screen_protector.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:webview_flutter_wkwebview/webview_flutter_wkwebview.dart';

class DetailVideo extends StatefulWidget {
  const DetailVideo({
    super.key,
    required this.model,
    required this.bunnyModel,
    required this.name,
  });

  final ProfileModel? model;
  final BunnyModel bunnyModel;
  final String name;
  @override
  State<DetailVideo> createState() => _DetailVideoState();
}

class _DetailVideoState extends State<DetailVideo> with WidgetsBindingObserver {
  bool _isRecording = false;
  final bool _isFullscreen = false;
  StreamSubscription? _recordingSub;

  late final WebViewController _controller;
  Timer? _trackingTimer;
  int _totalSecondsWatched = 0;
  int? _videoId;
  @override
  void initState() {
    super.initState();
    _videoId = widget.bunnyModel.customerTrackWithVideoId;
    WidgetsBinding.instance.addObserver(this);
    _initSecurity();
    _initWebView();
    _startTrackingTime();
  }

  void _startTrackingTime() {
    _trackingTimer = Timer.periodic(const Duration(seconds: 10), (timer) {
      _totalSecondsWatched += 10;
      _sendTimeTrackingApi(_totalSecondsWatched);
    });
  }

  Future<void> _sendTimeTrackingApi(int totalTime) async {
    try {
      VideoRepository().updateTime(
        customerTrackWithVideoId: _videoId ?? 0,
        time: totalTime,
      );
    } catch (e) {
      print('Lỗi khi gửi API tracking: $e');
    }
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
    String watermarkText = widget.model != null
        ? "${widget.model?.fullName} - ${widget.model?.phone}"
        : "Bản quyền thuộc về Kiido";
    final url =
        "https://iframe.mediadelivery.net/embed/${widget.bunnyModel.idBunny}/${widget.bunnyModel.streamingUrl}?autoplay=true&muted=false";

    late final PlatformWebViewControllerCreationParams params;
    if (WebViewPlatform.instance is WebKitWebViewPlatform) {
      params = WebKitWebViewControllerCreationParams(
        allowsInlineMediaPlayback: true, // Khóa inline cho iOS
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
            // CHẶN PHÓNG TO VÀ CHÈN WATERMARK DI CHUYỂN
            await _controller.runJavaScript('''
          // Bước A: Ẩn nút Fullscreen bằng CSS
          var style = document.createElement('style');
          style.innerHTML = `
            video::-webkit-media-controls-fullscreen-button { display: none !important; }
            video::-internal-media-controls-fullscreen-button { display: none !important; }
            .fullscreen-button, .custom-fs-btn { display: none !important; }
          `;
          document.head.appendChild(style);

          // Bước B: Bẻ gãy tính năng Fullscreen của Javascript API
          Element.prototype.requestFullscreen = function() { return Promise.reject(); };
          Element.prototype.webkitRequestFullscreen = function() { return Promise.reject(); };
          Element.prototype.mozRequestFullScreen = function() { return Promise.reject(); };
          Element.prototype.msRequestFullscreen = function() { return Promise.reject(); };
          
          // Bước C: Chèn watermark giới hạn TRONG KHUNG VIDEO
          if (!document.getElementById("flutter-watermark")) {
          var wm = document.createElement("div");
          wm.id = "flutter-watermark";
          wm.innerHTML = "$watermarkText";
          wm.style.position = "absolute"; // Đổi thành absolute
          wm.style.color = "rgba(255, 165, 0, 0.8)";
          wm.style.fontSize = "14px";
          wm.style.fontWeight = "bold";
          wm.style.zIndex = "999999"; 
          wm.style.pointerEvents = "none";
          wm.style.textShadow = "1px 1px 2px rgba(0, 0, 0, 0.8)"; 
          wm.style.transition = "all 0.3s ease"; // Cho phép mượt mà khi đổi góc
          // Tìm thẻ chứa video (Thường BunnyCDN dùng Plyr player)
          var videoElement = document.querySelector('video');
          var videoContainer = videoElement ? videoElement.parentElement : document.body;
          // Đảm bảo container chứa video có position relative để watermark neo theo
          if (getComputedStyle(videoContainer).position === "static") {
          videoContainer.style.position = "relative";
          }
          videoContainer.appendChild(wm);
          var currentIndex = 0;
          function updatePosition() {
          // Khoảng cách an toàn so với mép video
            var padding = "10px"; 
          // Reset lại toàn bộ CSS vị trí
            wm.style.top = "auto";
            wm.style.bottom = "auto";
            wm.style.left = "auto";
            wm.style.right = "auto";
    // Set vị trí theo góc
          if (currentIndex === 0) { wm.style.top = padding; wm.style.left = padding; } // Trên trái
          else if (currentIndex === 1) { wm.style.top = padding; wm.style.right = padding; } // Trên phải
          else if (currentIndex === 2) { wm.style.bottom = "50px"; wm.style.right = padding; } // Dưới phải (né thanh điều khiển)
          else if (currentIndex === 3) { wm.style.bottom = "50px"; wm.style.left = padding; } // Dưới trái (né thanh điều khiển)
          }

          updatePosition();

          setInterval(function() {
            currentIndex = (currentIndex + 1) % 4;
            updatePosition();
          }, 3000); 

          // Lắng nghe sự kiện kết thúc video
          var videoCheckInterval = setInterval(function() {
            var v = document.querySelector('video');
            if (v) {
              clearInterval(videoCheckInterval);
              v.addEventListener('ended', function() {
                if (window.VideoChannel) {
                  window.VideoChannel.postMessage('video_ended');
                }
              });
            }
          }, 1000);
        }
        ''');
          },
        ),
      );
    _controller.loadRequest(Uri.parse(url));
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _recordingSub?.cancel();
    if (Platform.isAndroid) {
      ScreenProtector.preventScreenshotOff();
    }
    _trackingTimer?.cancel();

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
              onPressed: () => Navigator.pop(context),
              icon: const Icon(Icons.arrow_back_ios, color: Colors.white),
            ),
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
