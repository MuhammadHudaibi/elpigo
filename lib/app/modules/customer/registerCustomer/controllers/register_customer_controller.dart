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
      
      UserCredential userCredential = await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: nikController.text,
        password: passwordController.text,
      );

      
      User? user = userCredential.user;
      if (user != null) {
       
      }

      
      String nextPage = selectedCustomerType.value == 'UMKM' ? '/upload-umkm' : '/upload-rt';
      await uploadData(nextPage);

    } catch (e) {
      Get.snackbar('Error', 'Failed to register user: $e');
    }
  }

  Future<void> uploadData(String nextPage) async {
    try {
      
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

      // Mengunggah foto pemilik
      String? ownerPhotoUrl = await _uploadPhoto(
        ownerPhoto.value, 
        'photos/$name/owner/$currentTimeMillis.jpg',
        name, 
        passwordController.text, 
      );

      
      String? businessPhotoUrl = selectedCustomerType.value == 'UMKM'
          ? await _uploadPhoto(
              businessPhoto.value, 
              'photos/$name/business/$currentTimeMillis.jpg',
              name, 
              passwordController.text, 
            )
          : null;


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

      
      if (nextPage.isNotEmpty) {
        Get.toNamed(nextPage);
      }
    } catch (e) {
     
      Get.snackbar('Error', 'Failed to register data: $e');
    }
  }

  Future<void> uploadToFirebaseStorage() async {
    
  }
}
