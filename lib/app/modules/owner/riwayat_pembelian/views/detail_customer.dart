import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:elpigo/app/modules/owner/riwayat_pembelian/controllers/riwayat_penjualan_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class DetailCustomer extends StatelessWidget {
  final String userId;

  DetailCustomer({required this.userId});

  final RiwayatPenjualanController controller = Get.find();

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2, // Number of tabs
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            'Riwayat Penjualan',
            style: GoogleFonts.poppins(color: Colors.white),
          ),
          backgroundColor: Color.fromARGB(255, 82, 140, 75),
          bottom: TabBar(
            labelColor: Colors.greenAccent,
            indicatorColor: Colors.greenAccent,
            labelStyle: GoogleFonts.poppins(),
            unselectedLabelColor: Colors.white,
            tabs: [
              Tab(text: 'Data Penjualan'),
              Tab(text: 'Data Pelanggan'),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            FirstPage(),
            DetailPelanggan(userId: userId),
          ],
        ),
      ),
    );
  }
}

class FirstPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text('Ini adalah halaman data penjualan'),
    );
  }
}

class DetailPelanggan extends StatelessWidget {
  final String userId;

  DetailPelanggan({required this.userId});

  final RiwayatPenjualanController controller = Get.find();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder<DocumentSnapshot<Map<String, dynamic>>>(
        future: controller.getUserById(userId),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }

          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }

          final data = snapshot.data?.data();
          if (data == null) {
            return Center(child: Text('Pengguna tidak ditemukan', style: GoogleFonts.poppins()));
          }

          final photos = [
            {'url': data['ktpPhotoUrl'], 'caption': 'Foto KTP'},
            {'url': data['kkPhotoUrl'], 'caption': 'Foto KK'},
            {'url': data['ownerPhotoUrl'], 'caption': 'Foto Pemilik'},
            if (data['customerType'] == "UMKM") {'url': data['businessPhotoUrl'], 'caption': 'Foto Tempat Usaha'},
          ];

          final location = data['location'];

          Widget contentMaps;
          if (location == null ||
              location['latitude'] == null ||
              location['longitude'] == null ||
              double.tryParse(location['latitude'].toString()) == null ||
              double.tryParse(location['longitude'].toString()) == null) {
            contentMaps = _buildGoogleMapsFieldError();
          } else {
            contentMaps = _buildGoogleMapsField(context, double.parse(location['latitude'].toString()), double.parse(location['longitude'].toString()));
          }

          return SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  buildUserDetail('Nama', data['name']),
                  buildUserDetail('Email', data['email']),
                  buildUserDetail('Tipe Pelanggan', data['customerType']),
                  buildUserDetail('No HP', data['phone']),
                  buildUserDetail('NIK', data['nik']),
                  buildUserDetail('Alamat', data['address']),
                  SizedBox(height: 20),
                  Text('Foto-foto', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                  SizedBox(height: 10),
                  GridView.builder(
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      crossAxisSpacing: 10,
                      mainAxisSpacing: 10,
                      childAspectRatio: 1.0,
                    ),
                    itemCount: photos.length,
                    itemBuilder: (context, index) {
                      return GestureDetector(
                        onTap: () {
                          controller.showImageDialog(
                            context,
                            photos[index]['url'],
                            photos[index]['caption'] ?? '',
                            userId,
                          );
                        },
                        child: Column(
                          children: [
                            Expanded(
                              child: Container(
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(8.0),
                                ),
                                child: Image.network(
                                  photos[index]['url'] ?? '',
                                  fit: BoxFit.cover,
                                  loadingBuilder: (context, child, loadingProgress) {
                                    if (loadingProgress == null) return child;
                                    return Center(
                                      child: CircularProgressIndicator(
                                        value: loadingProgress.expectedTotalBytes != null
                                            ? loadingProgress.cumulativeBytesLoaded / loadingProgress.expectedTotalBytes!
                                            : null,
                                      ),
                                    );
                                  },
                                  errorBuilder: (context, error, stackTrace) => Icon(
                                    Icons.error_outline,
                                    size: 100,
                                    color: Color.fromARGB(255, 82, 140, 75),
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(height: 5),
                            Text(
                              photos[index]['caption']!,
                              style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                  SizedBox(height: 20),
                  contentMaps,
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget buildUserDetail(String title, String? value, [double fontSize = 16]) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '$title: ',
            style: GoogleFonts.poppins(fontSize: fontSize, fontWeight: FontWeight.bold),
          ),
          Expanded(
            child: Text(
              value ?? 'Tidak ada data',
              style: GoogleFonts.poppins(fontSize: fontSize),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildGoogleMapsField(BuildContext context, double lat, double long) {
    return Container(
      width: double.infinity,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 4.0),
            child: Text(
              'Lokasi',
              style: GoogleFonts.poppins(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
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
                  target: LatLng(lat, long),
                  zoom: 15,
                ),
                markers: {
                  Marker(
                    markerId: MarkerId('current_location'),
                    position: LatLng(lat, long),
                    icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueAzure),
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

  Widget _buildGoogleMapsFieldError() {
    return Container(
      width: double.infinity,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 4.0),
            child: Text(
              'Lokasi',
              style: GoogleFonts.poppins(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
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
              child: Center(
                child: Text("Lokasi tidak ditemukan"),
              ),
            ),
          ),
        ],
      ),
    );
  }
}