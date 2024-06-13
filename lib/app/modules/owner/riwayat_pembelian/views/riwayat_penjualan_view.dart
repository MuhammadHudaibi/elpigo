import 'package:elpigo/app/modules/owner/riwayat_pembelian/views/detail_customer.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:elpigo/app/modules/owner/riwayat_pembelian/controllers/riwayat_penjualan_controller.dart';

class RiwayatPenjualanView extends StatelessWidget {
  final RiwayatPenjualanController controller = Get.put(RiwayatPenjualanController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Riwayat Penjualan', style: GoogleFonts.poppins(color: Colors.white)),
        backgroundColor:   Color.fromARGB(255, 82, 140, 75),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: controller.getUsersStream(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircularProgressIndicator(),
                  SizedBox(height: 20),
                  Text(
                    'Loading data...',
                    style: GoogleFonts.poppins(),
                  ),
                ],
              ),
            );
          }
          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }

          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return Center(child: Text('No users found', style: GoogleFonts.poppins()));
          }

          return ListView.builder(
            itemCount: snapshot.data!.docs.length,
            itemBuilder: (context, index) {
              DocumentSnapshot userDoc = snapshot.data!.docs[index];
              Map<String, dynamic> userData = userDoc.data() as Map<String, dynamic>;

              return Card(
                margin: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                child: ListTile(
                  contentPadding: EdgeInsets.all(16),
                  leading: userData['ownerPhotoUrl'] != null
                      ? CircleAvatar(
                          backgroundImage: NetworkImage(userData['ownerPhotoUrl']),
                          onBackgroundImageError: (_, __) => Icon(Icons.person),
                          child: Container(
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              border: Border.all(
                                color:  Color.fromARGB(255, 82, 140, 75).withOpacity(0.5),
                                width: 2,
                              ),
                            ),
                          ),
                        )
                      : CircleAvatar(
                          child: Icon(Icons.person),
                        ),
                  title: Text(
                    userData['name'] ?? 'No Name',
                    style: GoogleFonts.poppins(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(height: 8),
                      Text(
                        'NIK: ${userData['nik'] ?? 'No NIK'}',
                        style: GoogleFonts.poppins(),
                      ),
                      Text(
                        'Phone: ${userData['phone'] ?? 'No Phone'}',
                        style: GoogleFonts.poppins(),
                      ),
                    ],
                  ),
                  onTap: () {
                    Get.to(() => DetailCustomer(userId: userDoc.id));
                  },
                ),
              );
            },
          );
        },
      ),
    );
  }
}