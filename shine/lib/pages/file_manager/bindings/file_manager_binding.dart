// Package imports:
import 'package:get/get.dart';

// Project imports:
import '../controllers/file_manager_controller.dart';

class FileManagerBinding implements Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => FileManagerController());
  }
}
