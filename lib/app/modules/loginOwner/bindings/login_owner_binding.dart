import 'package:get/get.dart';
import '../controllers/login_owner_controller.dart';

class LoginOwnerBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<LoginOwnerController>(
      () => LoginOwnerController(),
    );
  }
}
