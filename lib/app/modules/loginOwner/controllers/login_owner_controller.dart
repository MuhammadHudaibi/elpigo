import 'package:get/get.dart';

class LoginOwnerController extends GetxController {
  var isObscured = true.obs;

  void toggleObscure() {
    isObscured.toggle();
  }
}
