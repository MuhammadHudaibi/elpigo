import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter/cupertino.dart';
import 'package:elpigo/app/modules/customer/riwayat_pemesanan/controllers/riwayat_pemesanan_controller.dart';

class RiwayatPemesanan extends StatelessWidget {
  final RiwayatPemesananController transactionController = Get.put(RiwayatPemesananController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.green,
        title: Text(
          "Riwayat Pemesanan",
          style: GoogleFonts.poppins(
            fontSize: 25,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        actions: [
          IconButton(
            onPressed: () {
              Get.toNamed('/keranjang-customer');
            },
            icon: Icon(
              CupertinoIcons.cart,
              size: 25,
              color: Colors.white,
            ),
          ),
        ],
      ),
      body: Obx(() {
        if (transactionController.transactions.isEmpty) {
          return const Center(child: Text("Belum ada transaksi"));
        }

        return ListView.builder(
          itemCount: transactionController.transactions.length,
          itemBuilder: (context, index) {
            final transaction = transactionController.transactions[index];
            return Card(
              margin: const EdgeInsets.all(8.0),
              child: const Padding(
                padding: EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "nama barang",
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    Text(
                          "status",
                          style: TextStyle(fontSize: 14, color: Colors.grey),
                        ),
                      
                    SizedBox(height: 8),
                    Text("Tanggal Pembelian:"),
                    Text("Status: "),
                    Text("Jumlah:"),
                    Text("Harga: Rp"),
                    Text("Catatan:"),
                    ],
                    ),
      
                ),
            );
          },
        );
      }),
    );
  }
}
