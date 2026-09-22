import 'dart:async';
import 'dart:io';

import 'package:chewie/chewie.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:kiddo/student_models/info_class_model.dart';
import 'package:kiddo/student_models/profile_model.dart';
import 'package:kiddo/student_repo/video_repo.dart';
import 'package:kiddo/utils/constants/color.dart';
import 'package:kiddo/utils/constants/styles.dart';
import 'package:screen_protector/screen_protector.dart';
import 'package:video_player/video_player.dart';

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

  // Video Player
  late VideoPlayerController _videoPlayerController;
  ChewieController? _chewieController;
  bool _isVideoInitialized = false;

  // Watermark
  int _watermarkIndex = 0;
  Timer? _watermarkTimer;

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
      print('Lỗi khi gửi API tracking: $e');
    }
  }

  /// 🔐 Security setup
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

  /// 🌐 Native Video Player setup
  Future<void> _initVideoPlayer() async {
    final videoId = widget.bunnyModel.streamingUrl;
    // Sử dụng Pull Zone gốc và Video ID
    final directM3u8Url =
        "https://vz-549a7ea4-e2a.b-cdn.net/$videoId/playlist.m3u8";

    _videoPlayerController = VideoPlayerController.networkUrl(
      Uri.parse(directM3u8Url),
      httpHeaders: {
        'Referer': 'https://lms.kiddo.edu.vn/',
        'Origin': 'https://lms.kiddo.edu.vn',
      },
    );

    try {
      await _videoPlayerController.initialize();
      
      _chewieController = ChewieController(
        videoPlayerController: _videoPlayerController,
        autoPlay: true,
        looping: false,
        allowFullScreen: false, // Theo logic cũ, không cho phép fullscreen
        allowPlaybackSpeedChanging: false,
        hideControlsTimer: const Duration(seconds: 3),
        errorBuilder: (context, errorMessage) {
          return Center(
            child: Text(
              errorMessage,
              style: const TextStyle(color: Colors.white),
            ),
          );
        },
      );

      _videoPlayerController.addListener(() {
        final position = _videoPlayerController.value.position;
        final duration = _videoPlayerController.value.duration;
        
        if (position >= duration && duration > Duration.zero) {
          if (mounted) {
            Navigator.pop(context, true);
          }
        }
      });

      if (mounted) {
        setState(() {
          _isVideoInitialized = true;
        });
      }

      _startWatermarkAnimation();
    } catch (e) {
      print("Lỗi khi khởi tạo video: $e");
    }
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

  Widget _buildWatermark() {
    String watermarkText = widget.model != null
        ? "${widget.model?.fullName} - ${widget.model?.phone}"
        : "Bản quyền thuộc về Kiddo";

    AlignmentGeometry alignment;
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

    return AnimatedAlign(
      alignment: alignment,
      duration: const Duration(milliseconds: 400),
      curve: Curves.easeInOut,
      child: Padding(
        padding: const EdgeInsets.only(
          top: 20.0,
          left: 20.0,
          right: 20.0,
          bottom: 60.0, // Tránh thanh điều khiển video
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
    );
  }

  @override
  void dispose() {
    SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
    WidgetsBinding.instance.removeObserver(this);
    
    _videoPlayerController.dispose();
    _chewieController?.dispose();
    _watermarkTimer?.cancel();
    
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
          body: _isVideoInitialized && _chewieController != null
              ? Stack(
                  children: [
                    Center(
                      child: Chewie(
                        controller: _chewieController!,
                      ),
                    ),
                    _buildWatermark(),
                  ],
                )
              : const Center(
                  child: CircularProgressIndicator(
                    color: Colors.orange,
                  ),
                ),
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
