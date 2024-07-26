// Package imports:
import 'package:get/get.dart';
import 'package:path/path.dart';

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
    try {
      controller.enableConcert = Get.arguments['enableConcert'];
      controller.concertFile = Get.arguments['concertFile'];
      controller.concertExtDir = Get.arguments['concertExtDir'];
    } finally {}

    controller.previousPath = controller.currentPath;
    controller.currentPath = Get.arguments['path'];

    controller.refresh();
    return super.onPageBuildStart(page);
  }

  @override
  void onPageDispose() {
    controller.currentPath = controller.previousPath;
    controller.previousPath = dirname(controller.previousPath ?? '');
    controller.refresh();
    super.onPageDispose();
  }
}
