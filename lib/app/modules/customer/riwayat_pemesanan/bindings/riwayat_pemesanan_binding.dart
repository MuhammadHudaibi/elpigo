import 'package:get/get.dart';
import '../controllers/riwayat_pemesanan_controller.dart';

class RiwayatPemesananBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<RiwayatPemesananController>(
      () => RiwayatPemesananController(),
    );
  }
}
