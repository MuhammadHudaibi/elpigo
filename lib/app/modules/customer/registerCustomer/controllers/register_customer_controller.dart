import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'dart:io';
import 'package:firebase_auth/firebase_auth.dart';

class RegisterCustomerController extends GetxController {
  var ktpPhoto = Rx<File?>(null);
  var kkPhoto = Rx<File?>(null);
  var businessPhoto = Rx<File?>(null);
  var ownerPhoto = Rx<File?>(null);
  var addressController = TextEditingController();
  var nameController = TextEditingController();
  var nikController = TextEditingController();
  var phoneController = TextEditingController();
  var passwordController = TextEditingController();
  var confirmPasswordController = TextEditingController();
  var location = ''.obs;

  var isObscured = true.obs;
  var selectedCustomerType = ''.obs;

  final List<String> customerTypes = ['UMKM', 'RT'];

  void toggleObscure() {
    isObscured.toggle();
  }

  Future<String?> _uploadPhoto(File? photo, String path) async {
    if (photo == null) return null;
    try {
      final ref = FirebaseStorage.instance.ref().child(path);
      await ref.putFile(photo);
      return await ref.getDownloadURL();
    } catch (e) {
      Get.snackbar('Error', 'Failed to upload photo: $e');
      return null;
    }
  }

  void register() async {
  try {
    // Lakukan otentikasi pengguna dengan email dan password
    UserCredential userCredential = await FirebaseAuth.instance.createUserWithEmailAndPassword(
      email: nikController.text,
      password: passwordController.text,
    );

    // Menggunakan userCredential
    User? user = userCredential.user;
    if (user != null) {
      // Lakukan tindakan tambahan, misalnya menyimpan informasi tambahan tentang pengguna ke Firestore
    }

    // Setelah pengguna berhasil diautentikasi, lanjutkan dengan menentukan halaman upload data yang sesuai
    String nextPage = selectedCustomerType.value == 'UMKM' ? '/upload-umkm' : '/upload-rt';
    await uploadData(nextPage);

  } catch (e) {
    Get.snackbar('Error', 'Failed to register user: $e');
  }
}


  Future<void> uploadData(String nextPage) async {
    try {
      String? ktpPhotoUrl = await _uploadPhoto(ktpPhoto.value, 'photos/ktp/${DateTime.now().millisecondsSinceEpoch}.jpg');
      String? kkPhotoUrl = await _uploadPhoto(kkPhoto.value, 'photos/kk/${DateTime.now().millisecondsSinceEpoch}.jpg');
      String? ownerPhotoUrl = await _uploadPhoto(ownerPhoto.value, 'photos/owner/${DateTime.now().millisecondsSinceEpoch}.jpg');
      String? businessPhotoUrl = selectedCustomerType.value == 'UMKM'
          ? await _uploadPhoto(businessPhoto.value, 'photos/business/${DateTime.now().millisecondsSinceEpoch}.jpg')
          : null;

      // Simpan data di Firebase
      await FirebaseFirestore.instance.collection('customers').add({
        'name': nameController.text,
        'address': addressController.text,
        'nik': nikController.text,
        'phone': phoneController.text,
        'customerType': selectedCustomerType.value,
        'password': passwordController.text,
        'ktpPhotoUrl': ktpPhotoUrl,
        'kkPhotoUrl': kkPhotoUrl,
        'ownerPhotoUrl': ownerPhotoUrl,
        'businessPhotoUrl': businessPhotoUrl,
        'location': location.value,
      });

      Get.snackbar('Success', 'Data registered successfully');

      // Alihkan ke halaman berikutnya jika diberikan
      if (nextPage.isNotEmpty) {
        Get.toNamed(nextPage);
      }
    } catch (e) {
      Get.snackbar('Error', 'Failed to register data: $e');
    }
  }
}
