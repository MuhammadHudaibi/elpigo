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

  Stream<User?> get streamAuthStatus =>
  FirebaseAuth.instance.authStateChanges();

  Future<void> login(String email, String pasword) async {
    try {
      // Lakukan proses login dengan Firebase Auth
      await FirebaseAuth.instance.signInWithEmailAndPassword(

        email: email,
        password: pasword,
      );

  
      Get.offAllNamed('/home');
    } catch (e) {

      print('Error while logging in: $e');

      Get.snackbar('Error', 'Failed to login: $e');
    }
  }

  @override
  void onClose() {
    emailNikController.dispose();
    passwordController.dispose();
    super.onClose();
  }
}
