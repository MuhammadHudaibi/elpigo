import 'package:elpigo/app/modules/customer/Profile/controllers/profile_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class ProfileView extends StatelessWidget {
  final ProfileController controller = Get.put(ProfileController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.green,
        title: Text('Profile',
            style: GoogleFonts.poppins(
              fontSize: 25,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            )),
        actions: [
          IconButton(
            onPressed: () async {
              await controller.signOut();
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
                        backgroundImage: controller.profileData['ownerPhotoUrl'] != null
                            ? NetworkImage(controller.profileData['ownerPhotoUrl'])
                            : null,
                        child: controller.profileData['ownerPhotoUrl'] == null
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
              buildDocumentPhoto('KK', 'kkPhotoUrl'),
              SizedBox(height: 10),
              buildDocumentPhoto('KTP', 'ktpPhotoUrl'),
              if (controller.profileData['customerType'] == 'UMKM') ...[
                SizedBox(height: 10),
                buildDocumentPhoto('Usaha', 'usahaPhotoUrl'),
              ],
              SizedBox(height: 10),
              buildDocumentPhoto('Pemilik', 'PemilikPhotoUrl', isPemilik: true),
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
      child: Text('$label: ${controller.profileData[key] ?? ''}',
        style: GoogleFonts.poppins(),
      ),
    );
  }

  Widget buildNonEditableText(String label, String key) {
    return Text('$label: ${controller.profileData[key] ?? ''}',
      style: GoogleFonts.poppins(),
    );
  }

  Widget buildDocumentPhoto(String label, String key, {bool isPemilik = false}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('$label:', style: GoogleFonts.poppins()),
        SizedBox(height: 5),
        GestureDetector(
          onTap: isPemilik ? () => controller.updatePemilikPhoto() : null,
          child: Container(
            height: 150,
            width: double.infinity,
            decoration: BoxDecoration(
              border: Border.all(color: Colors.grey),
              borderRadius: BorderRadius.circular(8),
            ),
            child: controller.profileData[key] != null && controller.profileData[key] is String
                ? Image.network(
                    controller.profileData[key],
                    fit: BoxFit.cover,
                  )
                : Center(child: Text('No image available', style: GoogleFonts.poppins())),
          ),
        ),
      ],
    );
  }

  Widget buildLocationMap(String label, Map<String, dynamic> location) {
    // Default location (San Francisco)
    LatLng initialLocation = LatLng(37.7749, -122.4194);
    bool locationFound = false;

    if (location != null && location['latitude'] != null && location['longitude'] != null) {
      double latitude = location['latitude'];
      double longitude = location['longitude'];
      initialLocation = LatLng(latitude, longitude);
      locationFound = true;
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
    TextEditingController textController = TextEditingController(text: currentValue);

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
            child: Text('Cancel', style: GoogleFonts.poppins()),
          ),
          TextButton(
            onPressed: () {
              controller.updateProfileData(key, textController.text);
              Get.back();
            },
            child: Text('Save', style: GoogleFonts.poppins()),
          ),
        ],
      ),
    );
  }
}
