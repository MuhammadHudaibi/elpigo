import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

class ProfileController extends GetxController {
  var profileData = {}.obs;
  var isLoading = false.obs;

  // Method untuk memperbarui data profil
  void updateProfileData(String key, String value) {
    profileData[key] = value;
  }

  // Method untuk mengganti foto profil
  Future<void> updateProfilePhoto() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      updateProfileData('ownerPhotoUrl', pickedFile.path);
    }
  }

  // Method untuk mengganti foto dokumen
  Future<void> updateDocumentPhoto(String key) async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      updateProfileData(key, pickedFile.path);
    }
  }
}
