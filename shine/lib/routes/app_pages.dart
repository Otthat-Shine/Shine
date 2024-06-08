// Package imports:
import 'package:get/get.dart';

// Project imports:
import 'package:shine/pages/pages.dart';
import 'package:shine/pages/video_player/bindings/video_player_binding.dart';
import 'package:shine/pages/video_player/views/video_player.dart';

part 'app_routes.dart';

class AppPages {
  static const initial = AppRoutes.home;

  static List<GetPage> get routes {
    return [
      GetPage(
        name: AppRoutes.home,
        page: () => const Home(),
        binding: HomeBinding(),
      ),
      GetPage(
        name: AppRoutes.fileManager,
        page: () => const FileManager(),
        binding: FileManagerBinding(),
        preventDuplicates: false,
        middlewares: [FileManagerMiddleware()],
      ),
      GetPage(
        name: AppRoutes.videoPlayer,
        page: () => const VideoPlayer(),
        bindings: [VideoPlayerBinding()],
      )
    ];
  }
}
