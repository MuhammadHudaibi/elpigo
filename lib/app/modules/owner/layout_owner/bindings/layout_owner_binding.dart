import 'package:get/get.dart';

import '../controllers/layout_owner_controller.dart';

class LayoutOwnerBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<LayoutOwnerController>(
      () => LayoutOwnerController(),
    );
  }
}
