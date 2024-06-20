import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../keranjang/controllers/keranjang_customer_controller.dart';

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

  void addProductToCart(Map<String, dynamic> product, BuildContext context) async {
    String userId = FirebaseAuth.instance.currentUser!.uid;
    int stok = product['stok'] ?? 0;
    int quantityInCart = 0;

    try {
      QuerySnapshot cartSnapshot = await FirebaseFirestore.instance
          .collection('customers')
          .doc(userId)
          .collection('pemesanan')
          .where('title', isEqualTo: product['title'])
          .get();

      if (cartSnapshot.docs.isNotEmpty) {
        quantityInCart = cartSnapshot.docs.first['quantity'];
      }

      if (quantityInCart + 1 <= stok) {
        if (cartSnapshot.docs.isNotEmpty) {
          DocumentReference productDocRef = cartSnapshot.docs.first.reference;
          productDocRef.update({
            'quantity': FieldValue.increment(1),
            'totalPrice': FieldValue.increment(product['price'] is String
                ? double.tryParse(product['price']) ?? 0
                : product['price'])
          });
        } else {
          // Add new item to cart
          FirebaseFirestore.instance
              .collection('customers')
              .doc(userId)
              .collection('pemesanan')
              .doc(product['title'])
              .set
              ({
            ...product,
            'quantity': 1,
            'totalPrice': product['price'] is String
                ? double.tryParse(product['price']) ?? 0
                : product['price']
          });
        }
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            backgroundColor: Color.fromARGB(255, 151, 182, 153),
            content: Text(
              'Produk berhasil ditambahkan!',
              style: GoogleFonts.poppins(
                fontWeight: FontWeight.w400,
                color: Colors.black,
              ),
            ),
          ),
        );
      } else if (stok == 0) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            backgroundColor: Colors.red,
            content: Text(
              'Stok produk habis!',
              style: GoogleFonts.poppins(
                fontWeight: FontWeight.w400,
                color: Colors.white,
              ),
            ),
          ),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            backgroundColor: Colors.red,
            content: Text(
              'Stok produk tidak cukup!',
              style: GoogleFonts.poppins(
                fontWeight: FontWeight.w400,
                color: Colors.white,
              ),
            ),
          ),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          backgroundColor: Colors.red,
          content: Text(
            'Failed to add product to cart: $e',
            style: GoogleFonts.poppins(
              fontWeight: FontWeight.w400,
              color: Colors.white,
            ),
          ),
        ),
      );
    }
  }
}
