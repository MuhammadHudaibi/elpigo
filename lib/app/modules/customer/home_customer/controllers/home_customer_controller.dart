import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:elpigo/app/routes/app_pages.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import '../../keranjang/controllers/keranjang_customer_controller.dart';

class Product {
  final String id;
  final String title;
  final String imageUrl;
  final int price;
  final int stock;

  Product({
    required this.id,
    required this.title,
    required this.imageUrl,
    required this.price,
    required this.stock,
  });
}

class HomeCustomerController extends GetxController {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  var isLoading = true.obs;
  var userData = {}.obs;

  final KeranjangCustomerController cartController =
      Get.put(KeranjangCustomerController());

  @override
  void onInit() {
    super.onInit();
    fetchUserData();
  }

  Stream<QuerySnapshot> getRecipesStream() {
    return _firestore.collection('products').snapshots();
  }

  Future<DocumentSnapshot<Map<String, dynamic>>> getRecipeById(
      String productId) async {
    try {
      DocumentSnapshot<Map<String, dynamic>> productSnapshot =
          await _firestore.collection('products').doc(productId).get();
      if (productSnapshot.exists) {
        return productSnapshot;
      } else {
        return Future.error("Product not found");
      }
    } catch (e) {
      return Future.error(e.toString());
    }
  }

  Future<void> fetchUserData() async {
    try {
      User? user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        DocumentSnapshot userDoc = await FirebaseFirestore.instance
            .collection('customers')
            .doc(user.uid)
            .get();

        if (userDoc.exists) {
          userData.value = userDoc.data() as Map<String, dynamic>;
        } else {
          Get.snackbar('Error', 'User data not found');
        }
      } else {
        Get.snackbar('Error', 'No user is currently signed in');
      }
    } catch (e) {
      Get.snackbar('Error', 'Failed to fetch user data: $e');
    } finally {
      isLoading.value = false;
    }
  }

  void addProductToCart(Map<String, dynamic> product) async {
    String userId = FirebaseAuth.instance.currentUser!.uid;
    CollectionReference cart = FirebaseFirestore.instance
        .collection('customers')
        .doc(userId)
        .collection('pemesanan');

    QuerySnapshot existingProductSnapshot =
        await cart.where('id', isEqualTo: product['id']).limit(1).get();

    if (existingProductSnapshot.docs.isNotEmpty) {
      DocumentSnapshot existingProduct = existingProductSnapshot.docs.first;

      if (existingProduct['title'] == product['title']) {
        // Jika ya, tambahkan jumlahnya
        cart.doc(existingProduct.id).update({
          'quantity': FieldValue.increment(1),
        });
      } else {
        cart.add({
          ...product,
          'quantity': 1,
        });
      }
    } else {
      cart.add({
        ...product,
        'quantity': 1,
      });
    }
  }

  Future<void> logout() async {
    try {
      await FirebaseAuth.instance.signOut();
      Get.offAllNamed(Routes.CONFIRM);
    } catch (e) {
      Get.snackbar('Error', 'Failed to logout: $e');
    }
  }
}
