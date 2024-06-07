import 'package:get/get.dart';

import '../controllers/keranjang_customer_controller.dart';

class KeranjangCustomerBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<KeranjangCustomerController>(
      () => KeranjangCustomerController(),
    );
  }
}
