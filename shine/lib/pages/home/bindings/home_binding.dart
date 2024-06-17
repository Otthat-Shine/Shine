// Package imports:
import 'package:get/get.dart';

// Project imports:
import '../controllers/home_controller.dart';

class HomeBinding implements Bindings {
  @override
  void dependencies() {
    Get.put(HomeController());
  }
}
