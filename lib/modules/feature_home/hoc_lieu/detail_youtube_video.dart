import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:kiddo/student_models/profile_model.dart';
import 'package:kiddo/utils/constants/color.dart';
import 'package:kiddo/utils/constants/styles.dart';
import 'package:screen_protector/screen_protector.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

class DetailYoutubeVideo extends StatefulWidget {
  const DetailYoutubeVideo({
    super.key,
    required this.url,
    required this.name,
    this.model,
  });

  final String url;
  final String name;
  final ProfileModel? model;

  @override
  State<DetailYoutubeVideo> createState() => _DetailYoutubeVideoState();
}

class _DetailYoutubeVideoState extends State<DetailYoutubeVideo>
    with WidgetsBindingObserver {
  bool _isRecording = false;
  final bool _isFullscreen = false;
  bool _isLandscape = false;
  StreamSubscription? _recordingSub;

  late YoutubePlayerController _controller;
  bool _isPlayerReady = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _initSecurity();
    
    final videoId = YoutubePlayer.convertUrlToId(widget.url) ?? '';
    
    _controller = YoutubePlayerController(
      initialVideoId: videoId,
      flags: const YoutubePlayerFlags(
        mute: false,
        autoPlay: true,
        disableDragSeek: false,
        loop: false,
        isLive: false,
        forceHD: false,
        enableCaption: true,
      ),
    )..addListener(_youtubeListener);
  }

  void _youtubeListener() {
    if (_isPlayerReady && mounted && !_controller.value.isFullScreen) {
      if (_controller.value.playerState == PlayerState.ended) {
        // Có thể navigate ở đây nhưng ta đã dùng thuộc tính onEnded của YoutubePlayer
      }
    }
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

  @override
  void dispose() {
    SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
    WidgetsBinding.instance.removeObserver(this);
    _recordingSub?.cancel();
    ScreenProtector.preventScreenshotOff();
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        YoutubePlayerBuilder(
          player: YoutubePlayer(
            controller: _controller,
            showVideoProgressIndicator: true,
            progressIndicatorColor: mainOrange,
            onReady: () {
              _isPlayerReady = true;
            },
            onEnded: (data) {
              if (mounted) {
                Navigator.pop(context, true);
              }
            },
          ),
          builder: (context, player) {
            return Scaffold(
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
              body: Center(child: player),
            );
          },
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
