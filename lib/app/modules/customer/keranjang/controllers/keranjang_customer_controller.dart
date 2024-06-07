import 'package:get/get.dart';

class KeranjangCustomerController extends GetxController {
  var cartItems = [].obs;

  void addToCart(Map<String, dynamic> product) {
    cartItems.add(product);
  }

  void removeFromCart(Map<String, dynamic> product) {
    cartItems.remove(product);
  }

  bool get isEmpty => cartItems.isEmpty;
}
