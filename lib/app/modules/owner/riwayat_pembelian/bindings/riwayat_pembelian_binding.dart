import 'package:get/get.dart';

import '../controllers/riwayat_pembelian_controller.dart';

class RiwayatPembelianBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<RiwayatPembelianController>(
      () => RiwayatPembelianController(),
    );
  }
}
