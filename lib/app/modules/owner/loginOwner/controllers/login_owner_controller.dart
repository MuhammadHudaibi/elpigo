import 'package:elpigo/app/modules/owner/layout_owner/views/layout_owner_view.dart';
import 'package:elpigo/app/routes/app_pages.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class LoginOwnerController extends GetxController {
  var isObscured = true.obs;

  FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> signIn(String idPangkalan, String password) async {
    try {
      DocumentSnapshot userSnapshot = await _firestore
          .collection('owner')
          .doc(idPangkalan)
          .get();

      if (userSnapshot.exists) {
        Map<String, dynamic> userData = userSnapshot.data() as Map<String, dynamic>;

        if (userData['password'] == password) {
          Contoh: Get.offAll(LayoutOwnerView());
          Get.snackbar(
          "Berhasil",
          "Anda Berhasil Masuk.",
          backgroundColor: Colors.green
        );
        } else {
          Get.snackbar(
            "Error",
            "Password yang Anda masukkan salah.",
            snackPosition: SnackPosition.BOTTOM,
          );
        }
      } else {
        Get.snackbar(
          "Error",
          "ID Pangkalan tidak ditemukan.",
          snackPosition: SnackPosition.BOTTOM,
        );
      }
    } catch (error) {
      Get.snackbar(
        "Error",
        error.toString(),
        snackPosition: SnackPosition.BOTTOM,
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
