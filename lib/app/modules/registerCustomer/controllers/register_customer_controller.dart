import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'dart:io';

class RegisterCustomerController extends GetxController {
  var ktpPhoto = Rx<File?>(null);
  var kkPhoto = Rx<File?>(null);
  var businessPhoto = Rx<File?>(null);
  var ownerPhoto = Rx<File?>(null);
  var addressController = TextEditingController();

  var isObscured = true.obs;
  var selectedCustomerType = ''.obs;

 
  final List<String> customerTypes = ['UMKM', 'RT'];

  void toggleObscure() {
    isObscured.toggle();
  }

  void register() {
    if (selectedCustomerType.value == 'UMKM') {
      Get.toNamed('/upload-umkm');
    } else if (selectedCustomerType.value == 'RT') {
      Get.toNamed('/upload-rt');
    } else {
      
      Get.snackbar('Error', 'Please select a customer type');
    }
  }

  void uploadData() {
    
  }
}
