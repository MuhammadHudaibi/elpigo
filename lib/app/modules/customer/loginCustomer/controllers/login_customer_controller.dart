import 'package:elpigo/app/routes/app_pages.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:firebase_auth/firebase_auth.dart';

class LoginCustomerController extends GetxController {
  var isObscured = true.obs;
  TextEditingController emailNikController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  void toggleObscure() {
    isObscured.toggle();
  }

  Stream<User?> get streamAuthStatus => FirebaseAuth.instance.authStateChanges();

  Future<void> login(String email, String password) async {
    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      Get.snackbar(
        "Berhasil",
        "Anda Berhasil Masuk.",
        backgroundColor: Colors.green
      );
      Get.offAllNamed(Routes.HOME_CUSTOMER);
    } on FirebaseAuthException catch (e) {
      print(e.code);
      Get.snackbar('Error', e.code);
    }
  }

  Future<void> logout() async {
    try {
      await FirebaseAuth.instance.signOut();
      Get.offAllNamed(Routes.CONFIRM);
    } catch (e) {
      print('Error while logging out: $e');
      Get.snackbar('Error', 'Failed to logout: $e');
    }
  }

  @override
  void onClose() {
    emailNikController.dispose();
    passwordController.dispose();
    super.onClose();
  }
}
