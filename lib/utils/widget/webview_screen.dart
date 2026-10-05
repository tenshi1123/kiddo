import 'package:flutter/material.dart';
import 'package:kiddo/l10n/app_localizations.dart';
import 'package:kiddo/utils/constants/color.dart';
import 'package:kiddo/utils/constants/styles.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:webview_flutter/webview_flutter.dart';
// Import for Android features.
import 'package:webview_flutter_android/webview_flutter_android.dart';
// Import for iOS/macOS features.
import 'package:webview_flutter_wkwebview/webview_flutter_wkwebview.dart';

class WebViewScreen extends StatefulWidget {
  const WebViewScreen(
      {super.key, required this.link, required this.title, required this.type});
  final String link;
  final String title;
  final int type;

  @override
  State<WebViewScreen> createState() => _WebViewScreenState();
}

class _WebViewScreenState extends State<WebViewScreen> {
  late final WebViewController _controller;
  // hàm tải file bằng dio ?
  // Future<void> downloadFile(String url, String fileName) async {
  //   final taskId = await FlutterDownloader.enqueue(
  //     url: url,
  //     savedDir: (await getExternalStorageDirectory())!.path,
  //     showNotification: true,
  //     openFileFromNotification: true,
  //   );

  //   FlutterDownloader.registerCallback((id, status, progress) {
  //     if (taskId == id && status == DownloadTaskStatus.complete) {
  //       print('Download completed!');
  //     }
  //   });
  // }

  String generateFileNameFromUrl(String url) {
    final fileName = getFileNameFromUrl(url);
    return '${DateTime.now().millisecondsSinceEpoch}_$fileName';
  }

  String getFileNameFromUrl(String url) {
    final uri = Uri.parse(url);
    final pathSegments = uri.pathSegments;
    return pathSegments.last;
  }

  @override
  void initState() {
    super.initState();
    final PlatformWebViewControllerCreationParams params;
    if (WebViewPlatform.instance is WebKitWebViewPlatform) {
      params = WebKitWebViewControllerCreationParams(
        allowsInlineMediaPlayback: true,
        // 👇 thay vì để trống, truyền giá trị hợp lệ
        mediaTypesRequiringUserAction: <PlaybackMediaTypes>{
          PlaybackMediaTypes.audio,
          PlaybackMediaTypes.video,
        },
      );
    } else {
      params = const PlatformWebViewControllerCreationParams();
    }

    final controller = WebViewController.fromPlatformCreationParams(params);

    controller
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      // ..setNavigationDelegate(
      //   NavigationDelegate(
      //     onPageFinished: (url) => debugPrint("✅ Finished: $url"),
      //     onWebResourceError: (error) =>
      //         debugPrint("❌ Error: ${error.description}"),
      //   ),
      // )
      ..setNavigationDelegate(
        NavigationDelegate(
          onNavigationRequest: (request) {
            return NavigationDecision.navigate;
          },
          onPageFinished: (url) => debugPrint("✅ Finished: $url"),
          onWebResourceError: (error) =>
              debugPrint("❌ Error: ${error.description}"),
        ),
      )
      ..loadRequest(
        // 👇 kiểm tra link trước khi parse
        Uri.tryParse(widget.link) ?? Uri.parse("https://google.com"),
      );

    if (controller.platform is AndroidWebViewController) {
      AndroidWebViewController.enableDebugging(true);
      (controller.platform as AndroidWebViewController)
          .setMediaPlaybackRequiresUserGesture(false);
    }

    _controller = controller;
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(100),
        child: AppBar(
          backgroundColor: mainOrange,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back_ios_new, color: Colors.white),
            onPressed: () {
              Navigator.of(context).pop(false);
            },
          ),
          centerTitle: true,
          title: Text(
            widget.title,
            style: defaultText18B.copyWith(
              color: Colors.white,
            ),
          ),
          // actions: [
          //   widget.type == 0
          //       ? SizedBox()
          //       : IconButton(
          //           icon: const Icon(Icons.file_download, color: Colors.white),
          //           onPressed: () {
          //             downloadFile(
          //                 widget.link, generateFileNameFromUrl(widget.link));
          //           },
          //         ),
          // ],
          bottom: PreferredSize(
            preferredSize: const Size.fromHeight(4.0),
            child: TextButton(
                style: TextButton.styleFrom(
                  foregroundColor: Theme.of(context).colorScheme.onPrimary,
                ),
                onPressed: () async {
                  if (!await launchUrl(Uri.parse(widget.link))) {
                    throw Exception('Could not launch ');
                  }
                },
                child: Text(AppLocalizations.of(context).openWeb)),
          ),
        ),
      ),
      body: WebViewWidget(controller: _controller),
    );
  }
}
