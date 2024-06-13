import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

class ProfileController extends GetxController {
  var isLoading = true.obs;
  var profileData = {}.obs;

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
        var documentSnapshot = await FirebaseFirestore.instance.collection('customers').doc(user.uid).get();
        if (documentSnapshot.exists) {
          profileData.value = documentSnapshot.data()!;
        } else {
          print("User document not found");
        }
      } else {
        print("No user is signed in");
      }
    } catch (e) {
      print("Error fetching profile data: $e");
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> updateProfileData(String key, dynamic value) async {
    try {
      User? user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        await FirebaseFirestore.instance.collection('customers').doc(user.uid).update({key: value});
        profileData[key] = value;
      } else {
        print("No user is signed in");
      }
    } catch (e) {
      print("Error updating profile data: $e");
    }
  }

  Future<void> updateProfilePhoto() async {
    try {
      final pickedFile = await ImagePicker().pickImage(source: ImageSource.gallery);
      if (pickedFile != null) {
        File imageFile = File(pickedFile.path);
        User? user = FirebaseAuth.instance.currentUser;
        if (user != null) {
          // Upload image to your preferred storage solution and get the URL
          // Example: final imageUrl = await uploadImage(imageFile);

          final imageUrl = 'URL_of_uploaded_image'; // Replace with actual upload function

          await FirebaseFirestore.instance.collection('customers').doc(user.uid).update({'ownerPhotoUrl': imageUrl});
          profileData['ownerPhotoUrl'] = imageUrl;
        }
      }
    } catch (e) {
      print("Error updating profile photo: $e");
    }
  }
}
