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

  Future<String?> _uploadPhoto(File? photo, String path, String username, String password) async {
    if (photo == null) return null;
    try {
      // Konfigurasi Firebase Storage dengan username dan password
      final ref = FirebaseStorage.instance
          .ref()
          .child(path)
          .putFile(photo, SettableMetadata(
              customMetadata: <String, String>{'username': username, 'password': password}));
      await ref;
      return await ref.snapshot.ref.getDownloadURL();
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
      // Mendapatkan NIK dari nikController
      String name = nameController.text;

      // Menyimpan waktu saat ini dalam variabel untuk digunakan sebagai nama file
      int currentTimeMillis = DateTime.now().millisecondsSinceEpoch;

      // Mengunggah foto KTP
      String? ktpPhotoUrl = await _uploadPhoto(
        ktpPhoto.value, 
        'photos/$name/ktp/$currentTimeMillis.jpg',
        name, // Menggunakan NIK sebagai username
        passwordController.text, // Menggunakan password dari controller
      );

      // Mengunggah foto KK
      String? kkPhotoUrl = await _uploadPhoto(
        kkPhoto.value, 
        'photos/$name/kk/$currentTimeMillis.jpg',
        name, // Menggunakan NIK sebagai username
        passwordController.text, // Menggunakan password dari controller
      );

      // Mengunggah foto pemilik
      String? ownerPhotoUrl = await _uploadPhoto(
        ownerPhoto.value, 
        'photos/$name/owner/$currentTimeMillis.jpg',
        name, // Menggunakan NIK sebagai username
        passwordController.text, // Menggunakan password dari controller
      );

      // Mengunggah foto bisnis (jika jenis pelanggan adalah UMKM)
      String? businessPhotoUrl = selectedCustomerType.value == 'UMKM'
          ? await _uploadPhoto(
              businessPhoto.value, 
              'photos/$name/business/$currentTimeMillis.jpg',
              name, // Menggunakan NIK sebagai username
              passwordController.text, // Menggunakan password dari controller
            )
          : null;

      // Menyimpan data pelanggan ke Firestore
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

      // Menampilkan snackbar untuk konfirmasi
      Get.snackbar('Success', 'Data registered successfully');

      // Mengalihkan ke halaman berikutnya jika diberikan
      if (nextPage.isNotEmpty) {
        Get.toNamed(nextPage);
      }
    } catch (e) {
      // Menampilkan snackbar jika terjadi kesalahan
      Get.snackbar('Error', 'Failed to register data: $e');
    }
  }

  Future<void> uploadToFirebaseStorage() async {
    // Implementasi logika untuk mengunggah ke Firebase Storage di sini
    // Anda dapat memanggil metode _uploadPhoto atau menggunakan metode upload file Firebase Storage lainnya
    // Misalnya:
    // await _uploadPhoto(ktpPhoto.value, 'photos/ktp/${DateTime.now().millisecondsSinceEpoch}.jpg');
  }
}
