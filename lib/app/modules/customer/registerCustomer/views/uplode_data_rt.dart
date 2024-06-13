import 'dart:io';

import 'package:elpigo/app/modules/customer/maps/controllers/maps_controller.dart';
import 'package:elpigo/app/routes/app_pages.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:image_picker/image_picker.dart';

import '../controllers/register_customer_controller.dart';

class UploadRTDataView extends StatefulWidget {
  const UploadRTDataView({Key? key}) : super(key: key);

  @override
  _UploadRTDataViewState createState() => _UploadRTDataViewState();
}

class _UploadRTDataViewState extends State<UploadRTDataView> {
  final RegisterCustomerController controller = Get.find();
  final MapsController mapsController = Get.find();

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
                  "UNGGAH DATA RT",
                  style: GoogleFonts.poppins(
                    fontSize: 30,
                    fontWeight: FontWeight.bold,
                    color:  Color.fromARGB(255, 82, 140, 75),
                  ),
                ),
              ),
              const SizedBox(height: 15),
              Form(
                child: Container(
                  width: 340,
                  height: 1000,
                  decoration: BoxDecoration(
                    color:  Color.fromARGB(255, 82, 140, 75),
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.only(top: 50),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        _buildUploadField(
                          context,
                          'Unggah Foto KTP',
                          controller.ktpPhoto,
                        ),
                        const SizedBox(height: 20),
                        _buildUploadField(
                          context,
                          'Unggah Foto KK',
                          controller.kkPhoto,
                        ),
                        const SizedBox(height: 20),
                        _buildUploadField(
                          context,
                          'Unggah Foto Anda',
                          controller.ownerPhoto,
                        ),
                        const SizedBox(height: 20),
                        _buildGoogleMapsField(context, mapsController),
                        const SizedBox(height: 40),
                        Obx(() {
                          if (controller.isLoading.value) {
                            return CircularProgressIndicator();
                          } else {
                            return ElevatedButton(
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
                                if (controller.ktpPhoto.value == null ||
                                    controller.kkPhoto.value == null ||
                                    controller.ownerPhoto.value == null) {
                                  Get.snackbar(
                                    'Data belum lengkap!',
                                    'Silahkan lengkapi semua foto yang diperlukan beserta lokasi Anda.',
                                    snackPosition: SnackPosition.TOP,
                                  );
                                } else {
                                  controller.uploadData();
                                }
                              },
                              child: Text(
                                "Unggah",
                                style: GoogleFonts.poppins(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                  color: Color.fromARGB(255, 88, 122, 44),
                                ),
                              ),
                            );
                          }
                        }),
                        SizedBox(height: 20),
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

  Widget _buildGoogleMapsField(BuildContext context, MapsController mapsController) {
    return GestureDetector(
      onTap: () {
        Get.toNamed(Routes.MAPS);
      },
      child: Container(
        width: 300,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Pilih Lokasi',
              style: GoogleFonts.poppins(
                color: Colors.white,
                fontSize: 16,
              ),
            ),
            SizedBox(height: 10),
            ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: Container(
                height: 150,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: Colors.white),
                ),
                child: Obx(() {
                  if (mapsController.location == null) {
                    return Center(
                      child: Icon(
                        Icons.map,
                        color: Colors.white,
                      ),
                    );
                  } else {
                    return GoogleMap(
                      initialCameraPosition: CameraPosition(
                        target: mapsController.location!,
                        zoom: 15,
                      ),
                      markers: {
                        Marker(
                          markerId: MarkerId('current_location'),
                          position: mapsController.location!,
                        ),
                      },
                      zoomGesturesEnabled: false,
                      zoomControlsEnabled: false,
                      onMapCreated: (GoogleMapController controller) {
                        controller.animateCamera(
                          CameraUpdate.newLatLngZoom(
                            mapsController.location!,
                            15,
                          ),
                        );
                      },
                    );
                  }
                }),
              ),
            ),
            Align(
              alignment: Alignment.bottomRight,
              child: Padding(
                padding: const EdgeInsets.only(top: 10),
                child: Text(
                  "Atur Lokasi",
                  style: GoogleFonts.poppins(color: Colors.white),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}