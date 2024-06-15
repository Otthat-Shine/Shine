// Dart imports:
import 'dart:io';

// Package imports:
import 'package:get/get.dart';
import 'package:video_player/video_player.dart' as vp;
import 'package:video_player_win/video_player_win.dart' as vp_win;

class VideoPlayerController extends GetxController {
  vp.VideoPlayerController? _videoPlayerController;
  String path = '';

  vp.VideoPlayerController get videoPlayerController => _videoPlayerController!;

  @override
  void onInit() async {
    super.onInit();

    if (Get.parameters['path'] == null) {
      throw VideoPlayerException('Path is empty');
    } else {
      path = Get.parameters['path']!;
    }

    if (Platform.isWindows) {
      vp_win.WindowsVideoPlayer.registerWith();
    }

    _videoPlayerController = vp.VideoPlayerController.file(File(path));
    await _videoPlayerController!.initialize();

    if (!videoPlayerController.value.isInitialized ||
        videoPlayerController.value.hasError) {
      throw VideoPlayerException(
          _videoPlayerController!.value.errorDescription ??
              'Initialized failed');
    }
  }

  @override
  void onClose() {
    _videoPlayerController!.dispose();
    super.onClose();
  }
}

class VideoPlayerException implements Exception {
  final String msg;

  VideoPlayerException(this.msg);

  @override
  String toString() {
    return '$VideoPlayerException: $msg';
  }
}
