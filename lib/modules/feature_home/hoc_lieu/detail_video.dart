import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bunny_video_player/flutter_bunny_video_player.dart';
import 'package:flutter_bunny_video_player_ios/flutter_bunny_video_player_ios.dart';
import 'package:kiddo/utils/constants/color.dart';
import 'package:kiddo/utils/constants/styles.dart';

class DetailVideo extends StatefulWidget {
  const DetailVideo(
      {super.key, required this.videoId, required this.libraryId});
  final String videoId;
  final int libraryId;

  @override
  State<DetailVideo> createState() => _DetailVideoState();
}

class _DetailVideoState extends State<DetailVideo> {
  @override
  Widget build(BuildContext context) {
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
        body: (Platform.isAndroid)
            ? BunnyPlayerView(
                accessKey: null,
                videoId: widget.videoId,
                libraryId: widget.libraryId,
                token: null,
                expire: null,
                referer: null,
                //isPortrait: true,
                isScreenShotProtectEnable: true,
              )
            : BunnyIosPlayerView(
                accessKey: null,
                videoId: widget.videoId,
                libraryId: widget.libraryId,
                token: null, // Optional for DRM
                expires: null, // Optional token expiration

                //playIconAsset: 'assets/play_icon.png', // Optional custom play icon
              ));
  }
}
