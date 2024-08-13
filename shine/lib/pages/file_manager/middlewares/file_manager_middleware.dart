// Package imports:
import 'package:get/get.dart';

// Project imports:
import 'package:shine/pages/home/controllers/home_controller.dart';
import '../controllers/file_manager_controller.dart';

class FileManagerMiddleware extends GetMiddleware {
  late FileManagerController controller;
  late HomeController homeController;

  @override
  List<Bindings>? onBindingsStart(List<Bindings>? bindings) {
    for (var element in bindings!) {
      element.dependencies();
    }

    controller = Get.find<FileManagerController>();
    homeController = Get.find<HomeController>();
    return super.onBindingsStart(bindings);
  }

  @override
  GetPageBuilder? onPageBuildStart(GetPageBuilder? page) {
      controller.enableConcert = Get.arguments['enableConcert'] ?? false;
      if (controller.enableConcert) {
        controller.concertFile = Get.arguments['concertFile'];
        controller.concertExtDir = Get.arguments['concertExtDir'];
      }

    controller.currentPath = Get.arguments['path'];
    controller.addHistory(controller.currentPath);

    return super.onPageBuildStart(page);
  }

  @override
  void onPageDispose() {
    controller.removeLastHistory();
    if (controller.isHistoryEmpty) return;
    controller.currentPath = controller.lastHistory;

    controller.updateFileSystemList();

    super.onPageDispose();
  }
}
