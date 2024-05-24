import 'package:get/get.dart';

class RegisterCustomerController extends GetxController {
  var isObscured = true.obs;
  var selectedCustomerType = ''.obs;

  // List of customer types
  final List<String> customerTypes = ['UMKM', 'RT'];

  void toggleObscure() {
    isObscured.toggle();
  }

  void register() {
    
  }
}
