// ignore_for_file: override_on_non_overriding_member, file_names, prefer_const_constructors, avoid_unnecessary_containers, sized_box_for_whitespace, prefer_const_literals_to_create_immutables, use_full_hex_values_for_flutter_colors, deprecated_member_use, argument_type_not_assignable_to_error_handler, avoid_print, empty_catches, unused_catch_clause, no_duplicate_case_values

import 'dart:io';

import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

class VideoPlayerView extends StatefulWidget {
  VideoPlayerView(this.videoPath, {Key? key}) : super(key: key);
  String videoPath;
  @override
  _VideoPlayerView createState() => _VideoPlayerView(videoPath);
}

class _VideoPlayerView extends State<VideoPlayerView> {
  late VideoPlayerController _controller;

  _VideoPlayerView(this.videoPath);
  String videoPath;
  @override
  void initState() {
    super.initState();
    _controller = VideoPlayerController.file(File(videoPath));

    _controller.setVolume(0);
    _controller.setLooping(true);
    _controller.initialize().then((_) => setState(() {}));
    _controller.play();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: AspectRatio(
        aspectRatio: _controller.value.aspectRatio,
        child: Stack(
          alignment: Alignment.center,
          children: <Widget>[
            VideoPlayer(_controller),
            //VideoProgressIndicator(_controller, allowScrubbing: true),
          ],
        ),
      ),
    );
  }
}
