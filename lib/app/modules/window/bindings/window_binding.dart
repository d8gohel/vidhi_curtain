import 'package:get/get.dart';

import '../controllers/window_controller.dart';

class WindowBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<WindowController>(
      () => WindowController(),
    );
  }
}
