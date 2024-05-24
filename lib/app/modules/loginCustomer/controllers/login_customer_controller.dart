import 'package:get/get.dart';

class LoginCustomerController extends GetxController {
  var isObscured = true.obs;

  void toggleObscure() {
    isObscured.toggle();
  }
}
