import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:elpigo/app/routes/app_pages.dart';

class ForgotPasswordController extends GetxController {
  TextEditingController emailController = TextEditingController();
  FirebaseAuth auth = FirebaseAuth.instance;

  void resetPassword(String email) async {
    if (email != "" && GetUtils.isEmail(email)) {
      try {
        await auth.sendPasswordResetEmail(email: email);
        Get.snackbar('Success', 'Password reset link sent to your email');
        Get.offAllNamed(Routes.LOGIN_CUSTOMER);
      } catch (e) {
        Get.snackbar('Error', 'Failed to send reset link: $e');
      }
    } else {
      Get.snackbar('Error', 'Please enter a valid email');
    }
  }
}