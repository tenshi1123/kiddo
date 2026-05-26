import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:kiddo/utils/constants/color.dart';
import 'package:kiddo/utils/constants/styles.dart';
import 'package:screen_protector/screen_protector.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:webview_flutter_wkwebview/webview_flutter_wkwebview.dart';

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
  final bool _isFullscreen = false;
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

    late final PlatformWebViewControllerCreationParams params;
    if (WebViewPlatform.instance is WebKitWebViewPlatform) {
      params = WebKitWebViewControllerCreationParams(
        allowsInlineMediaPlayback: true, // Khóa inline cho iOS
      );
    } else {
      params = const PlatformWebViewControllerCreationParams();
    }

// Khởi tạo controller với params vừa cấu hình
    _controller = WebViewController.fromPlatformCreationParams(params)
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
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
          
          // Bước C: Chèn watermark màu cam, di chuyển 4 góc mỗi 30s
          if (!document.getElementById("flutter-watermark")) {
            var wm = document.createElement("div");
            wm.id = "flutter-watermark";
            // Nội dung theo yêu cầu của bạn
            wm.innerHTML = "Nguyễn Huỳnh Hải Yến - 0972018810"; 
            
            // CSS cơ bản cho watermark
            wm.style.position = "fixed";
            wm.style.color = "rgba(255, 165, 0, 0.8)"; // Màu cam, mờ 80%
            wm.style.fontSize = "14px";
            wm.style.fontWeight = "bold";
            wm.style.zIndex = "999999"; 
            wm.style.pointerEvents = "none"; // Không cản trở click video
            // Thêm viền đen nhẹ để chữ cam không bị chìm nếu video có phông nền sáng
            wm.style.textShadow = "1px 1px 2px rgba(0, 0, 0, 0.8)"; 
            wm.style.transition = "opacity 0.3s"; // Hiệu ứng mờ nhẹ khi đổi góc

            // Danh sách tọa độ 4 góc
            var corners = [
              { top: '10px', left: '10px', bottom: 'auto', right: 'auto' },   // Góc trên trái
              { top: '10px', right: '10px', bottom: 'auto', left: 'auto' },   // Góc trên phải
              { bottom: '10px', right: '10px', top: 'auto', left: 'auto' }, // Góc dưới phải
              { bottom: '10px', left: '10px', top: 'auto', right: 'auto' }  // Góc dưới trái
            ];

            var currentIndex = 0;

            // Hàm áp dụng tọa độ
            function updatePosition() {
              var pos = corners[currentIndex];
              wm.style.top = pos.top;
              wm.style.left = pos.left;
              wm.style.bottom = pos.bottom;
              wm.style.right = pos.right;
            }

            // Gắn vị trí ban đầu (Góc trên trái)
            updatePosition();
            document.body.appendChild(wm);

            // Chạy vòng lặp đổi vị trí mỗi 30 giây (30000ms)
            setInterval(function() {
              currentIndex = (currentIndex + 1) % 4; // Quay vòng 0, 1, 2, 3
              updatePosition();
            }, 3000); 
          }
        ''');
          },
        ),
      );

// Load trang web video của bạn
    _controller.loadRequest(Uri.parse(url));
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
          // Stack(
          //   children: [
          //     // 1. WebView chiếm toàn bộ không gian
          //     Positioned.fill(
          //       child: WebViewWidget(controller: _controller),
          //     ),

          //     Positioned.fill(
          //       child: Center(
          //         child: IgnorePointer(
          //           child: Opacity(
          //             opacity: 0.4,
          //             child: Column(
          //               mainAxisSize: MainAxisSize.min,
          //               children: [
          //                 const SizedBox(height: 8),
          //                 Text(
          //                   "Bản quyền thuộc về Kiido của bạn",
          //                   style: TextStyle(
          //                     color: Colors.white.withOpacity(0.8),
          //                     fontSize: 14,
          //                     fontWeight: FontWeight.w500,
          //                     shadows: const [
          //                       Shadow(
          //                         blurRadius: 4.0,
          //                         color: Colors.black,
          //                         offset: Offset(1, 1),
          //                       ),
          //                     ],
          //                   ),
          //                 ),
          //               ],
          //             ),
          //           ),
          //         ),
          //       ),
          //     ),
          //   ],
          // ),
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
