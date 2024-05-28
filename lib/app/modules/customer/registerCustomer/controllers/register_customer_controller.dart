import 'package:elpigo/app/modules/customer/loginCustomer/views/login_customer_view.dart';
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
  var emailController = TextEditingController();
  var phoneController = TextEditingController();
  var passwordController = TextEditingController();
  var confirmPasswordController = TextEditingController();
  var location = ''.obs;

  var isObscured = true.obs;
  var selectedCustomerType = ''.obs;
  var isLoading = false.obs;

  final List<String> customerTypes = ['UMKM', 'RT'];

  var nameError = ''.obs;
  var addressError = ''.obs;
  var nikError = ''.obs;
  var emailError = ''.obs;
  var phoneError = ''.obs;
  var passwordError = ''.obs;
  var confirmPasswordError = ''.obs;
  var customerTypeError = ''.obs;

  void toggleObscure() {
    isObscured.toggle();
  }

  bool validateInputs() {
    bool isValid = true;

    if (nameController.text.isEmpty) {
      nameError.value = 'Nama harus diisi';
      isValid = false;
    } else {
      nameError.value = '';
    }

    if (addressController.text.isEmpty) {
      addressError.value = 'Alamat harus diisi';
      isValid = false;
    } else {
      addressError.value = '';
    }

    if (nikController.text.isEmpty) {
      nikError.value = 'NIK harus diisi';
      isValid = false;
    } else {
      nikError.value = '';
    }

    if (emailController.text.isEmpty || !GetUtils.isEmail(emailController.text)) {
      emailError.value = 'Email yang valid harus diisi';
      isValid = false;
    } else {
      emailError.value = '';
    }

    if (phoneController.text.isEmpty || !GetUtils.isPhoneNumber(phoneController.text)) {
      phoneError.value = 'Nomor telepon yang valid harus diisi';
      isValid = false;
    } else {
      phoneError.value = '';
    }

    if (passwordController.text.isEmpty || passwordController.text.length < 6) {
      passwordError.value = 'Kata sandi harus minimal 6 karakter';
      isValid = false;
    } else {
      passwordError.value = '';
    }

    if (confirmPasswordController.text != passwordController.text) {
      confirmPasswordError.value = 'Kata sandi tidak cocok';
      isValid = false;
    } else {
      confirmPasswordError.value = '';
    }

    if (selectedCustomerType.value.isEmpty) {
    customerTypeError.value = 'Tipe pelanggan harus dipilih';
    isValid = false;
  } else {
    customerTypeError.value = '';
  }
    return isValid;
  }

  Future<String?> _uploadPhoto(File? photo, String path, String username, String password) async {
    if (photo == null) return null;
    try {
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
    if (!validateInputs()) {
      return;
    }

    try {
      isLoading.value = true;
      UserCredential userCredential = await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: emailController.text,
        password: passwordController.text,
      );

      User? user = userCredential.user;
      if (user != null) {
        String nextPage = selectedCustomerType.value == 'UMKM' ? '/upload-umkm' : '/upload-rt';
        Get.toNamed(nextPage);
      }
    } catch (e) {
      Get.snackbar('Error', 'Failed to register user: $e');
      print(e);
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> uploadData() async {
    try {
      isLoading.value = true;
      String name = nameController.text;
      int currentTimeMillis = DateTime.now().millisecondsSinceEpoch;

      String? ktpPhotoUrl = await _uploadPhoto(
        ktpPhoto.value,
        'photos/$name/ktp/$currentTimeMillis.jpg',
        name,
        passwordController.text,
      );

      String? kkPhotoUrl = await _uploadPhoto(
        kkPhoto.value,
        'photos/$name/kk/$currentTimeMillis.jpg',
        name,
        passwordController.text,
      );

      String? ownerPhotoUrl = await _uploadPhoto(
        ownerPhoto.value,
        'photos/$name/owner/$currentTimeMillis.jpg',
        name,
        passwordController.text,
      );

      String? businessPhotoUrl;
      if (selectedCustomerType.value == 'UMKM') {
        businessPhotoUrl = await _uploadPhoto(
          businessPhoto.value,
          'photos/$name/business/$currentTimeMillis.jpg',
          name,
          passwordController.text,
        );
      }

      await FirebaseFirestore.instance.collection('customers').add({
        'name': nameController.text,
        'address': addressController.text,
        'nik': nikController.text,
        'email': emailController.text,
        'phone': phoneController.text,
        'customerType': selectedCustomerType.value,
        'password': passwordController.text,
        'ktpPhotoUrl': ktpPhotoUrl,
        'kkPhotoUrl': kkPhotoUrl,
        'ownerPhotoUrl': ownerPhotoUrl,
        if (businessPhotoUrl != null) 'businessPhotoUrl': businessPhotoUrl,
        'location': location.value,
      });

      Get.snackbar('Success', 'Data registered successfully');

      Get.off(LoginCustomerView());

    } catch (e) {
      Get.snackbar('Error', 'Failed to register data: $e');
    } finally {
      isLoading.value = false;
    }
  }
}
