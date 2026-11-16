import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:kiddo/student_models/info_class_model.dart';
import 'package:kiddo/student_models/profile_model.dart';
import 'package:kiddo/student_repo/video_repo.dart';
import 'package:kiddo/utils/constants/color.dart';
import 'package:kiddo/utils/constants/styles.dart';
import 'package:media_kit/media_kit.dart';
import 'package:media_kit_video/media_kit_video.dart';
import 'package:screen_protector/screen_protector.dart';

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
  bool _isLandscape = false;
  StreamSubscription? _recordingSub;

  Timer? _trackingTimer;
  int _totalSecondsWatched = 0;
  int? _videoId;

  // MediaKit Video Player
  late final Player _player;
  late final VideoController _videoController;
  StreamSubscription? _completedSub;
  StreamSubscription? _errorSub;

  bool _isVideoInitialized = false;
  bool _hasError = false;
  String _errorMessage = "";

  @override
  void initState() {
    super.initState();
    _videoId = widget.bunnyModel.customerTrackWithVideoId;
    WidgetsBinding.instance.addObserver(this);
    _initSecurity();
    _initVideoPlayer();
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
      debugPrint('Lỗi khi gửi API tracking: $e');
    }
  }

  /// 🔐 Security setup
  Future<void> _initSecurity() async {
    // Bật chặn chụp và quay màn hình cho CẢ Android và iOS
    await ScreenProtector.preventScreenshotOn();

    if (Platform.isIOS) {
      await ScreenProtector.protectDataLeakageWithBlur();

      bool isRecording = await ScreenProtector.isRecording();
      if (mounted) setState(() => _isRecording = isRecording);

      _recordingSub =
          Stream.periodic(const Duration(seconds: 1)).listen((_) async {
        bool recording = await ScreenProtector.isRecording();
        if (recording != _isRecording && mounted) {
          setState(() => _isRecording = recording);
        }
      });
    }
  }

  /// 🌐 Native MediaKit Video Player setup
  Future<void> _initVideoPlayer() async {
    final videoId = widget.bunnyModel.streamingUrl;
    // Sử dụng Pull Zone gốc và Video ID
    final directM3u8Url =
        "https://vz-549a7ea4-e2a.b-cdn.net/$videoId/playlist.m3u8";

    _player = Player();
    _videoController = VideoController(_player);

    try {
      // Lắng nghe lỗi phát video
      _errorSub = _player.stream.error.listen((error) {
        debugPrint("MediaKit error: $error");
        if (mounted) {
          setState(() {
            _hasError = true;
            _errorMessage = "Lỗi phát video:\n$error";
          });
        }
      });

      // Lắng nghe khi video kết thúc để tự động pop
      _completedSub = _player.stream.completed.listen((completed) {
        if (completed && mounted) {
          Navigator.pop(context, true);
        }
      });

      // Mở luồng HLS với header Referer và Origin cho BunnyCDN
      await _player.open(
        Media(
          directM3u8Url,
          httpHeaders: {
            'Referer': 'https://lms.kiddo.edu.vn/',
            'Origin': 'https://lms.kiddo.edu.vn',
          },
        ),
        play: true,
      );

      if (mounted) {
        setState(() {
          _isVideoInitialized = true;
          _hasError = false;
        });
      }
    } catch (e) {
      debugPrint("Lỗi khi khởi tạo video: $e");
      if (mounted) {
        setState(() {
          _hasError = true;
          _errorMessage = "Lỗi mạng/Bảo mật:\n$e";
        });
      }
    }
  }

  @override
  void dispose() {
    SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
    WidgetsBinding.instance.removeObserver(this);

    _completedSub?.cancel();
    _errorSub?.cancel();
    _player.dispose();

    _recordingSub?.cancel();
    ScreenProtector.preventScreenshotOff();
    _trackingTimer?.cancel();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Scaffold(
          backgroundColor: Colors.black, // Nền đen cho video player
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
          body: _hasError
              ? Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Center(
                    child: Text(
                      _errorMessage,
                      textAlign: TextAlign.center,
                      style: const TextStyle(color: Colors.red, fontSize: 14),
                    ),
                  ),
                )
              : (_isVideoInitialized
                  ? Center(
                      child: AspectRatio(
                        aspectRatio: 16 / 9,
                        child: Stack(
                          fit: StackFit.expand,
                          children: [
                            MaterialVideoControlsTheme(
                              normal: const MaterialVideoControlsThemeData(
                                automaticallyImplySkipNextButton: false,
                                automaticallyImplySkipPreviousButton: false,
                                displaySeekBar: true,
                                speedUpOnLongPress: false,
                              ),
                              fullscreen: const MaterialVideoControlsThemeData(
                                automaticallyImplySkipNextButton: false,
                                automaticallyImplySkipPreviousButton: false,
                                displaySeekBar: true,
                                speedUpOnLongPress: false,
                              ),
                              child: Video(
                                controller: _videoController,
                                controls: MaterialVideoControls,
                              ),
                            ),
                            Positioned.fill(
                              child: IgnorePointer(
                                child: VideoWatermarkOverlay(
                                  model: widget.model,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    )
                  : const Center(
                      child: CircularProgressIndicator(
                        color: Colors.orange,
                      ),
                    )),
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

class VideoWatermarkOverlay extends StatefulWidget {
  const VideoWatermarkOverlay({
    super.key,
    this.model,
  });

  final ProfileModel? model;

  @override
  State<VideoWatermarkOverlay> createState() => _VideoWatermarkOverlayState();
}

class _VideoWatermarkOverlayState extends State<VideoWatermarkOverlay> {
  int _watermarkIndex = 0;
  Timer? _watermarkTimer;

  @override
  void initState() {
    super.initState();
    _startWatermarkAnimation();
  }

  void _startWatermarkAnimation() {
    _watermarkTimer = Timer.periodic(const Duration(seconds: 3), (timer) {
      if (mounted) {
        setState(() {
          _watermarkIndex = (_watermarkIndex + 1) % 4;
        });
      }
    });
  }

  @override
  void dispose() {
    _watermarkTimer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final watermarkText = widget.model != null
        ? "${widget.model?.fullName} - ${widget.model?.phone}"
        : "Bản quyền thuộc về Kiddo";

    Alignment alignment;
    switch (_watermarkIndex) {
      case 0:
        alignment = Alignment.topLeft;
        break;
      case 1:
        alignment = Alignment.topRight;
        break;
      case 2:
        alignment = Alignment.bottomRight;
        break;
      case 3:
      default:
        alignment = Alignment.bottomLeft;
        break;
    }

    return SafeArea(
      child: AnimatedAlign(
        alignment: alignment,
        duration: const Duration(milliseconds: 400),
        curve: Curves.easeInOut,
        child: Padding(
          padding: const EdgeInsets.only(
            top: 14.0,
            left: 14.0,
            right: 14.0,
            bottom: 45.0, // Tránh thanh điều khiển video
          ),
          child: IgnorePointer(
            child: Text(
              watermarkText,
              style: TextStyle(
                color: Colors.orange.withValues(alpha: 0.8),
                fontSize: 14,
                fontWeight: FontWeight.bold,
                shadows: [
                  Shadow(
                    color: Colors.black.withValues(alpha: 0.8),
                    blurRadius: 3,
                    offset: const Offset(1, 1),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}