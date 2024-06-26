import 'package:elpigo/app/modules/owner/layout_owner/views/layout_owner_view.dart';
import 'package:elpigo/app/routes/app_pages.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class LoginOwnerController extends GetxController {
  var isObscured = true.obs;

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  get userId => null;

  Future<void> signIn(String idPangkalan, String password) async {
    try {
      DocumentSnapshot userSnapshot =
          await _firestore.collection('owner').doc(idPangkalan).get();

      if (userSnapshot.exists) {
        Map<String, dynamic> userData =
            userSnapshot.data() as Map<String, dynamic>;

        if (userData['password'] == password) {
          Get.offAll(LayoutOwnerView());
          Get.snackbar(
            "Berhasil",
            "Anda Berhasil Masuk.",
            backgroundColor: Color.fromARGB(255, 151, 182, 153),
          );
        } else {
          Get.snackbar(
            "Error",
            "Password yang Anda masukkan salah.",
            backgroundColor: Color.fromARGB(255, 151, 182, 153),
            snackPosition: SnackPosition.TOP,
          );
        }
      } else {
        Get.snackbar(
          "Error",
          "ID Pangkalan tidak ditemukan.",
          backgroundColor: Color.fromARGB(255, 151, 182, 153),
          snackPosition: SnackPosition.TOP,
        );
      }
    } catch (error) {
      Get.snackbar(
        "Error",
        error.toString(),
        snackPosition: SnackPosition.TOP,
      );
    }
  }

  void logout() {
    Get.offAllNamed(Routes.CONFIRM);
  }

  void toggleObscure() {
    isObscured.toggle();
  }
}
