import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:elpigo/app/routes/app_pages.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:firebase_auth/firebase_auth.dart';

class LoginCustomerController extends GetxController {
  var isObscured = true.obs;
  var isLoading = false.obs;
  TextEditingController emailNikController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  void toggleObscure() {
    isObscured.toggle();
  }

  Stream<User?> get streamAuthStatus =>
      FirebaseAuth.instance.authStateChanges();

  Future<void> login(String identifier, String password) async {
    try {
      isLoading.value = true;
      String? email;

      if (GetUtils.isEmail(identifier)) {
        email = identifier;
      } else {
        var userDoc = await FirebaseFirestore.instance
            .collection('customers')
            .where('nik', isEqualTo: identifier)
            .get();

        if (userDoc.docs.isNotEmpty) {
          email = userDoc.docs.first['email'];
        } else {
          Get.snackbar('Error', 'NIK tidak ditemukan');
          return;
        }
      }

      if (email != null) {
        await FirebaseAuth.instance.signInWithEmailAndPassword(
          email: email,
          password: password,
        );
        Get.snackbar(
          "Berhasil",
          "Anda Berhasil Masuk.",
          backgroundColor: Color.fromARGB(255, 151, 182, 153),
        );
        Get.offAllNamed(Routes.LAYOUT_CUSTOMER);
      }
    } on FirebaseAuthException catch (e) {
      Get.snackbar('Error', e.message ?? 'An error occurred');
    } finally {
      isLoading.value = false;
    }
  }

  @override
  void onClose() {
    emailNikController.dispose();
    passwordController.dispose();
    super.onClose();
  }
}
