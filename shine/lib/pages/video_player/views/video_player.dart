// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:get/get.dart';
import 'package:video_player/video_player.dart' as vp;
import 'package:video_player_control_panel/video_player_control_panel.dart';

// Project imports:
import '../controllers/video_player_controller.dart';

class VideoPlayer extends GetView<VideoPlayerController> {
  const VideoPlayer({super.key});

  vp.VideoPlayerController get videoPlayerController =>
      controller.videoPlayerController;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(controller.path),
      ),
      body: JkVideoControlPanel(
        videoPlayerController,
        showClosedCaptionButton: true,
        showFullscreenButton: true,
        showVolumeButton: true,
      ),
    );
  }
}
