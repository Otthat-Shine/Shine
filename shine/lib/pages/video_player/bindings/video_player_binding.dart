// Package imports:
import 'package:get/get.dart';

// Project imports:
import '../controllers/video_player_controller.dart';

class VideoPlayerBinding implements Bindings {
  @override
  void dependencies() {
    Get.put(VideoPlayerController());
  }
}
