import 'package:get/get.dart';
import '../controllers/login_customer_controller.dart';

class LoginCustomerBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<LoginCustomerController>(
      () => LoginCustomerController(),
    );
  }
}
