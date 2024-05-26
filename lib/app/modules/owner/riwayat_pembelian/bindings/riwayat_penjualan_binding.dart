import 'package:get/get.dart';

import '../controllers/riwayat_penjualan_controller.dart';

class RiwayatPenjualanBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<RiwayatPenjualanController>(
      () => RiwayatPenjualanController(),
    );
  }
}
