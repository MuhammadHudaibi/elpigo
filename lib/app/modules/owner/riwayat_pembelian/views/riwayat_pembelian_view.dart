import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../controllers/riwayat_pembelian_controller.dart';

class RiwayatPembelianView extends GetView<RiwayatPembelianController> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('RiwayatPembelianView'),
        centerTitle: true,
      ),
      body: Center(
        child: Text(
          'RiwayatPembelianView is working',
          style: TextStyle(fontSize: 20),
        ),
      ),
    );
  }
}
