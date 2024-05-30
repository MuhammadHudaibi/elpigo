import 'package:get/get.dart';

import '../controllers/layout_customer_controller.dart';

class LayoutCustomerBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<LayoutCustomerController>(
      () => LayoutCustomerController(),
    );
  }
}
