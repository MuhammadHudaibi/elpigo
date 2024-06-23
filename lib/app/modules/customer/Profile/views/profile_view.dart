import 'package:elpigo/app/modules/customer/Profile/controllers/profile_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import '../../loginCustomer/controllers/login_customer_controller.dart';

class ProfileView extends StatelessWidget {
  final ProfileController controller = Get.put(ProfileController());
  final LoginCustomerController logincontroller =
      Get.put(LoginCustomerController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color.fromARGB(255, 82, 140, 75),
        title: Text('Profile',
            style: GoogleFonts.poppins(
              fontSize: 25,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            )),
        actions: [
          IconButton(
            onPressed: () {
              showLogoutConfirmationDialog(context);
            },
            icon: Icon(
              Icons.logout,
              size: 25,
              color: Colors.white,
            ),
          ),
        ],
      ),
      body: Obx(() {
        if (controller.isLoading.value) {
          return Center(child: CircularProgressIndicator());
        }
        return SingleChildScrollView(
          padding: EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Stack(
                  children: [
                    Container(
                      width: 120,
                      height: 120,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: Colors.grey.withOpacity(0.5),
                          width: 2,
                        ),
                      ),
                      child: CircleAvatar(
                        radius: 60,
                        backgroundImage:
                            controller.profileData['profilePhotoUrl'] != null
                                ? NetworkImage(
                                    controller.profileData['profilePhotoUrl'])
                                : null,
                        child: controller.profileData['profilePhotoUrl'] == null
                            ? Icon(
                                Icons.person,
                                size: 60,
                                color: Colors.grey,
                              )
                            : null,
                      ),
                    ),
                    Positioned(
                      bottom: 0,
                      right: 0,
                      child: GestureDetector(
                        onTap: () {
                          controller.updateProfilePhoto();
                        },
                        child: CircleAvatar(
                          backgroundColor: Colors.green,
                          radius: 20,
                          child: Icon(
                            Icons.camera_alt,
                            color: Colors.white,
                            size: 20,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 30),
              buildEditableText('Nama', 'name'),
              SizedBox(height: 10),
              buildEditableText('NIK', 'nik'),
              SizedBox(height: 10),
              buildEditableText('Email', 'email'),
              SizedBox(height: 10),
              buildEditableText('No HP', 'phone'),
              SizedBox(height: 10),
              buildEditableText('Alamat', 'address'),
              SizedBox(height: 15),
              buildNonEditableText('Type Customer', 'customerType'),
              SizedBox(height: 20),
              Text('Foto:', style: GoogleFonts.poppins()),
              SizedBox(height: 10),
              buildDocumentPhoto('KK', 'kkPhotoUrl', key: 'kkPhotoUrl'),
              SizedBox(height: 10),
              buildDocumentPhoto('KTP', 'ktpPhotoUrl', key: 'ktpPhotoUrl'),
              if (controller.profileData['customerType'] == 'UMKM') ...[
                SizedBox(height: 10),
                buildDocumentPhoto('Usaha', 'usahaPhotoUrl',
                    key: 'usahaPhotoUrl'),
              ],
              SizedBox(height: 10),
              buildDocumentPhoto('Pemilik', 'PemilikPhotoUrl',
                  key: 'PemilikPhotoUrl', isPemilik: true),
              SizedBox(height: 10),
              buildLocationMap('Lokasi', controller.profileData['location']),
            ],
          ),
        );
      }),
    );
  }

  Widget buildEditableText(String label, String key) {
    return GestureDetector(
      onTap: () => showEditDialog(key, controller.profileData[key] ?? ''),
      child: Text(
        '$label: ${controller.profileData[key] ?? ''}',
        style: GoogleFonts.poppins(),
      ),
    );
  }

  Widget buildNonEditableText(String label, String key) {
    return Text(
      '$label: ${controller.profileData[key] ?? ''}',
      style: GoogleFonts.poppins(),
    );
  }

  Widget buildDocumentPhoto(String label, String imageUrlKey,
      {bool isPemilik = false, required String key}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('$label:', style: GoogleFonts.poppins()),
        SizedBox(height: 5),
        GestureDetector(
          onTap: isPemilik
              ? () => controller.updatePemilikPhoto()
              : () => controller.updateField(key),
          child: Container(
            height: 150,
            width: double.infinity,
            decoration: BoxDecoration(
              border: Border.all(color: Colors.grey),
              borderRadius: BorderRadius.circular(8),
            ),
            child: controller.profileData[imageUrlKey] != null &&
                    controller.profileData[imageUrlKey] is String
                ? Image.network(
                    controller.profileData[imageUrlKey],
                    fit: BoxFit.cover,
                  )
                : Center(
                    child: Text('Gambar tidak tersedia',
                        style: GoogleFonts.poppins())),
          ),
        ),
      ],
    );
  }

  Widget buildLocationMap(String label, Map<String, dynamic>? location) {
    LatLng initialLocation;
    bool locationFound = false;

    if (location?['latitude'] != null && location?['longitude'] != null) {
      double latitude = location?['latitude'];
      double longitude = location?['longitude'];
      initialLocation = LatLng(latitude, longitude);
      locationFound = true;
    } else {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('$label:', style: GoogleFonts.poppins()),
          Container(
            height: 150,
            width: double.infinity,
            decoration: BoxDecoration(
              border: Border.all(color: Colors.grey),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Center(
                child: Text('Lokasi Tidak ditemukan',
                    style: GoogleFonts.poppins())),
          ),
        ],
      );
    }

    return Container(
      width: double.infinity,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 4.0),
            child: Text('$label:', style: GoogleFonts.poppins()),
          ),
          SizedBox(height: 10),
          ClipRRect(
            borderRadius: BorderRadius.circular(20),
            child: Container(
              height: 150,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: Color.fromARGB(255, 82, 140, 75).withOpacity(0.5),
                    spreadRadius: 2,
                    blurRadius: 7,
                    offset: Offset(0, 3),
                  ),
                ],
              ),
              child: GoogleMap(
                initialCameraPosition: CameraPosition(
                  target: initialLocation,
                  zoom: 15,
                ),
                markers: {
                  Marker(
                    markerId: MarkerId('current_location'),
                    position: initialLocation,
                  ),
                },
                zoomControlsEnabled: false,
              ),
            ),
          ),
        ],
      ),
    );
  }

  void showEditDialog(String key, String currentValue) {
    TextEditingController textController =
        TextEditingController(text: currentValue);

    Get.dialog(
      AlertDialog(
        title: Text('Edit $key', style: GoogleFonts.poppins()),
        content: TextField(
          controller: textController,
          decoration: InputDecoration(
            border: OutlineInputBorder(),
            labelText: key,
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: Text('Batalkan', style: GoogleFonts.poppins()),
          ),
          TextButton(
            onPressed: () {
              controller.updateProfileData(key, textController.text);
              Get.back();
            },
            child: Text('Simpan', style: GoogleFonts.poppins()),
          ),
        ],
      ),
    );
  }

  void showLogoutConfirmationDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Konfirmasi'),
          content: Text('Apakah Anda yakin ingin keluar?'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(false);
              },
              child: Text(
                'Tidak',
                style: TextStyle(color: Color.fromARGB(255, 82, 140, 75)),
              ),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(true);
                logincontroller.logout();
              },
              child: Text(
                'Ya',
                style: TextStyle(color: Color.fromARGB(255, 82, 140, 75)),
              ),
            ),
          ],
        );
      },
    );
  }
}
