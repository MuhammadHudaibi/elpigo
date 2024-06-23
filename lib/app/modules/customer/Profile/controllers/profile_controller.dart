// ignore_for_file: empty_catches

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'dart:io';

class ProfileController extends GetxController {
  var isLoading = true.obs;
  var profileData = <String, dynamic>{}.obs;

  @override
  void onInit() {
    super.onInit();
    fetchProfileData();
  }

  void fetchProfileData() async {
    try {
      isLoading.value = true;
      User? user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        var documentSnapshot = await FirebaseFirestore.instance
            .collection('customers')
            .doc(user.uid)
            .get();
        if (documentSnapshot.exists) {
          profileData.value = documentSnapshot.data()!;
        } else {
        }
      } else {
      }
    // ignore: duplicate_ignore
    // ignore: empty_catches
    } catch (e) {
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> updateProfileData(String key, dynamic value) async {
    try {
      User? user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        await FirebaseFirestore.instance
            .collection('customers')
            .doc(user.uid)
            .update({key: value});
        profileData[key] = value;
      } else {
      }
    } catch (e) {
    }
  }

  Future<void> updateField(String fieldName) async {
    try {
      final pickedFile =
          await ImagePicker().pickImage(source: ImageSource.gallery);
      if (pickedFile != null) {
        File imageFile = File(pickedFile.path);
        User? user = FirebaseAuth.instance.currentUser;
        if (user != null) {
          String filePath = '${fieldName}_images/${user.uid}.jpg';
          TaskSnapshot uploadTask =
              await FirebaseStorage.instance.ref(filePath).putFile(imageFile);

          // Get the download URL
          String imageUrl = await uploadTask.ref.getDownloadURL();

          // Update Firestore with the new image URL
          await FirebaseFirestore.instance
              .collection('customers')
              .doc(user.uid)
              .update({fieldName: imageUrl});
          profileData[fieldName] = imageUrl;
        }
      }
    } catch (e) {
    }
  }

  Future<void> updatePemilikPhoto() async {
    await updateField('PemilikPhotoUrl');
  }

  Future<void> updateProfilePhoto() async {
    await updateField('profilePhotoUrl');
  }

  Future<void> updateKK() async {
    await updateField('kk');
  }

  Future<void> signOut() async {
    isLoading.value = true;
    try {
      await FirebaseAuth.instance.signOut(); // Sign out the user
      profileData.clear();
      Get.offAllNamed('/confirm');
    } catch (e) {
      Get.snackbar('Error', 'Sign-out failed');
    } finally {
      isLoading.value = false;
    }
  }
}
