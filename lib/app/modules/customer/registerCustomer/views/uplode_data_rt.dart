import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import '../controllers/register_customer_controller.dart';

class UploadRTDataView extends GetView<RegisterCustomerController> {
  const UploadRTDataView({Key? key}) : super(key: key);

  Future<void> _pickImage(ImageSource source, Rx<File?> imageFile) async {
    final pickedFile = await ImagePicker().pickImage(source: source);
    if (pickedFile != null) {
      imageFile.value = File(pickedFile.path);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Center(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 50, right: 310),
                child: IconButton(
                  icon: Icon(Icons.arrow_back),
                  iconSize: 30,
                  onPressed: () {
                    Get.back();
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 2, left: 20, right: 20),
                child: Text(
                  "UPLOAD RT DATA",
                  style: GoogleFonts.poppins(
                    fontSize: 30,
                    fontWeight: FontWeight.bold,
                    color: Color.fromARGB(255, 88, 122, 44),
                  ),
                ),
              ),
              const SizedBox(height: 15),
              Form(
                child: Container(
                  width: 340,
                  height: 970,
                  decoration: BoxDecoration(
                    color: Color.fromARGB(255, 88, 122, 44),
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.only(top: 50),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        _buildUploadField(
                          context,
                          'Upload KTP Photo',
                          controller.ktpPhoto,
                        ),
                        const SizedBox(height: 20),
                        _buildUploadField(
                          context,
                          'Upload KK Photo',
                          controller.kkPhoto,
                        ),
                        const SizedBox(height: 20),
                        _buildUploadField(
                          context,
                          'Upload Your Photo',
                          controller.ownerPhoto,
                        ),
                        const SizedBox(height: 20),
                        _buildGoogleMapsField(context),
                        const SizedBox(height: 40),
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.white,
                            minimumSize: const Size(180, 50),
                            padding: const EdgeInsets.symmetric(
                              vertical: 10,
                              horizontal: 16,
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8.0),
                            ),
                          ),
                          onPressed: () {
                            controller.uploadData('/login-customer');
                          },
                          child: Text(
                            "Upload",
                            style: GoogleFonts.poppins(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: Color.fromARGB(255, 88, 122, 44),
                            ),
                          ),
                        ),
                        const SizedBox(height: 20), 
                      ],
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 20), 
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildUploadField(BuildContext context, String label, Rx<File?> imageFile) {
    return Container(
      width: 300,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: GoogleFonts.poppins(
              color: Colors.white,
              fontSize: 16,
            ),
          ),
          const SizedBox(height: 10),
          Obx(
            () => Stack(
              children: [
                GestureDetector(
                  onTap: () {
                    _pickImage(ImageSource.camera, imageFile);
                  },
                  child: Container(
                    height: 150,
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.white),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: imageFile.value == null
                        ? Center(
                            child: Icon(Icons.camera_alt, color: Colors.white),
                          )
                        : Image.file(
                            imageFile.value!,
                            fit: BoxFit.cover,
                          ),
                  ),
                ),
                if (imageFile.value != null)
                  Positioned(
                    top: 5,
                    right: 5,
                    child: GestureDetector(
                      onTap: () {
                        imageFile.value = null;
                      },
                      child: Icon(
                        Icons.close,
                        color: Colors.red,
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildGoogleMapsField(BuildContext context) {
    return Container(
      width: 300,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Choose Location',
            style: GoogleFonts.poppins(
              color: Colors.white,
              fontSize: 16,
            ),
          ),
          const SizedBox(height: 10),
          Container(
            height: 150,
            decoration: BoxDecoration(
              border: Border.all(color: Colors.white),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Center(
              child: IconButton(
                icon: Icon(Icons.map, color: Colors.white),
                onPressed: () async {
                  // This is where you would integrate a map picker
                  // For now, we just simulate picking a location
                  // You would set the location value here
                  controller.location.value = 'Example Location';
                  Get.snackbar('Location picked', 'Location has been set');
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}
