import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../controllers/riwayat_pemesanan_controller.dart';

class RiwayatPemesananView extends GetView<RiwayatPemesananController> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('RiwayatPemesananView'),
        centerTitle: true,
      ),
      body: Center(
        child: Text(
          'RiwayatPemesananView is working',
          style: TextStyle(fontSize: 20),
        ),
      ),
    );
  }
}
