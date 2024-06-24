import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
// ignore: depend_on_referenced_packages
import 'package:intl/intl.dart';

import 'package:elpigo/app/modules/owner/riwayat_pembelian/controllers/riwayat_penjualan_controller.dart';

class DetailCustomer extends StatelessWidget {
  final String userId;

  // ignore: use_key_in_widget_constructors
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
            tabs: const [
              Tab(text: 'Data Penjualan'),
              Tab(text: 'Data Pelanggan'),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            RiwayatPenjualan(userId: userId),
            DetailPelanggan(userId: userId),
          ],
        ),
      ),
    );
  }
}

class RiwayatPenjualan extends StatelessWidget {
  final RiwayatPenjualanController _controller =
      Get.put(RiwayatPenjualanController());
  final String userId;

  // ignore: use_key_in_widget_constructors
  RiwayatPenjualan({required this.userId});

  String formatDateTime(Timestamp timestamp) {
    return DateFormat('dd MMM yyyy, HH:mm').format(timestamp.toDate());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder<QuerySnapshot>(
        stream: _controller.getRiwayatPemesananStream(userId),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }
          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return Center(child: Text('No data available'));
          }

          var riwayatPemesanan = snapshot.data!.docs;

          return ListView.builder(
            itemCount: riwayatPemesanan.length,
            itemBuilder: (context, index) {
              var product =
                  riwayatPemesanan[index].data() as Map<String, dynamic>;
              DateTime dateTime = (product['timestamp'] as Timestamp).toDate();
              String formattedDate = formatDateTime(product['timestamp']);

              String status = product['status'] ?? 'Diproses';
              Color statusColor;

              switch (status) {
                case 'Selesai':
                  statusColor = Colors.green;
                  break;
                case 'Dibatalkan':
                  statusColor = Colors.red;
                  break;
                default:
                  statusColor = Colors.orange;
              }

              return Container(
                margin: EdgeInsets.symmetric(horizontal: 15, vertical: 10),
                padding: EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.white,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.5),
                      spreadRadius: 2,
                      blurRadius: 5,
                      offset: Offset(0, 3),
                    ),
                  ],
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Container(
                          padding:
                              EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                          decoration: BoxDecoration(
                            color: Colors.blueAccent,
                            borderRadius: BorderRadius.circular(5),
                          ),
                          child: Text(
                            formattedDate,
                            style: GoogleFonts.poppins(
                              fontSize: 12,
                              fontWeight: FontWeight.w400,
                              color: Colors.white,
                            ),
                          ),
                        ),
                        DropdownButton<String>(
                          value: status,
                          items: <String>['Diproses', 'Selesai', 'Dibatalkan']
                              .map((String value) {
                            Color color;
                            switch (value) {
                              case 'Selesai':
                                color = Colors.green;
                                break;
                              case 'Dibatalkan':
                                color = Colors.red;
                                break;
                              default:
                                color = Colors.orange;
                            }
                            return DropdownMenuItem<String>(
                              value: value,
                              child: Text(
                                value,
                                style: GoogleFonts.poppins(color: color),
                              ),
                            );
                          }).toList(),
                          onChanged: (newValue) {
                            if (newValue != null) {
                              showDialog(
                                context: context,
                                builder: (BuildContext context) {
                                  return AlertDialog(
                                    title: Text('Konfirmasi'),
                                    content: Text(
                                        'Apakah anda ingin memperbarui status menjadi $newValue?'),
                                    actions: [
                                      TextButton(
                                        onPressed: () {
                                          Navigator.of(context).pop(false);
                                        },
                                        child: Text('Tidak',
                                            style: TextStyle(
                                                color: Color.fromARGB(
                                                    255, 82, 140, 75))),
                                      ),
                                      TextButton(
                                        onPressed: () {
                                          Navigator.of(context).pop(true);
                                          _controller.updateStatus(
                                              snapshot.data!.docs[index],
                                              newValue);
                                          Get.back();
                                        },
                                        child: Text('Ya',
                                            style: TextStyle(
                                                color: Color.fromARGB(
                                                    255, 82, 140, 75))),
                                      ),
                                    ],
                                  );
                                },
                              );
                            }
                          },
                        ),
                      ],
                    ),
                    SizedBox(height: 10),
                    Row(
                      children: [
                        product['imageUrl'] != null
                            ? Image.network(
                                product['imageUrl'],
                                width: 60,
                                height: 80,
                                fit: BoxFit.cover,
                              )
                            : Icon(Icons.image, size: 60),
                        SizedBox(width: 15),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                product['title'] ?? 'No Title',
                                style: GoogleFonts.poppins(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black,
                                ),
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                              ),
                              SizedBox(height: 8),
                              Text(
                                "Rp.${product['totalPrice'] is int ? product['totalPrice'] : product['totalPrice'].toStringAsFixed(0)}",
                                style: GoogleFonts.poppins(
                                  fontSize: 14,
                                  fontWeight: FontWeight.normal,
                                  color: Colors.black,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 10),
                    Text(
                      "Jumlah Produk : ${product['quantity']}",
                      style: GoogleFonts.poppins(
                        fontSize: 14,
                        fontWeight: FontWeight.normal,
                        color: Colors.black,
                      ),
                    ),
                    SizedBox(height: 10),
                    Text(
                      "Catatan : ${product['catatan'] ?? 'Tidak ada catatan'}",
                      style: GoogleFonts.poppins(
                        fontSize: 14,
                        fontWeight: FontWeight.normal,
                        color: Colors.black,
                      ),
                    ),
                  ],
                ),
              );
            },
          );
        },
      ),
    );
  }
}

class DetailPelanggan extends StatelessWidget {
  final String userId;

  // ignore: use_key_in_widget_constructors
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
            return Center(
                child: Text('Pengguna tidak ditemukan',
                    style: GoogleFonts.poppins()));
          }

          final photos = [
            {'url': data['ktpPhotoUrl'], 'caption': 'Foto KTP'},
            {'url': data['kkPhotoUrl'], 'caption': 'Foto KK'},
            {'url': data['PemilikPhotoUrl'], 'caption': 'Foto Pemilik'},
            if (data['customerType'] == "UMKM")
              {'url': data['usahaPhotoUrl'], 'caption': 'Foto Tempat Usaha'},
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
            contentMaps = _buildGoogleMapsField(
                context,
                double.parse(location['latitude'].toString()),
                double.parse(location['longitude'].toString()));
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
                  Text('Foto-foto',
                      style:
                          TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                  SizedBox(height: 10),
                  Wrap(
                    spacing: 8.0, // gap between adjacent chips
                    runSpacing: 4.0, // gap between lines
                    children: photos.map((photo) {
                      if (photo['url'] != null) {
                        return Column(children: [
                          Text(photo['caption']),
                          Image.network(
                            photo['url'],
                            width: 100,
                            height: 100,
                          )
                        ]);
                      }
                      return Container();
                    }).toList(),
                  ),
                  SizedBox(height: 20),
                  Text('Lokasi',
                      style:
                          TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                  SizedBox(height: 10),
                  contentMaps,
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget buildUserDetail(String title, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: GoogleFonts.poppins(fontSize: 16, fontWeight: FontWeight.bold),
        ),
        SizedBox(height: 8),
        Text(
          value,
          style: GoogleFonts.poppins(fontSize: 14),
        ),
        SizedBox(height: 10),
      ],
    );
  }

  Widget _buildGoogleMapsField(BuildContext context, double lat, double lng) {
    return SizedBox(
      height: 300,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(10),
        child: Image.network(
          'https://maps.googleapis.com/maps/api/staticmap?center=$lat,$lng&zoom=13&size=600x300&maptype=roadmap&markers=color:red%7Clabel:C%7C$lat,$lng',
          fit: BoxFit.cover,
        ),
      ),
    );
  }

  Widget _buildGoogleMapsFieldError() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Icon(Icons.error_outline, size: 60, color: Colors.red),
          SizedBox(height: 16),
          Text('Lokasi tidak tersedia',
              style: GoogleFonts.poppins(fontSize: 20, color: Colors.red)),
          SizedBox(height: 8),
          Text('Harap periksa informasi lokasi pelanggan',
              style: GoogleFonts.poppins(fontSize: 16, color: Colors.red)),
        ],
      ),
    );
  }
}
