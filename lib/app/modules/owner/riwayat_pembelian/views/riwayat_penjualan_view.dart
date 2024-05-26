import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../controllers/riwayat_penjualan_controller.dart';

class RiwayatPenjualanView extends GetView<RiwayatPenjualanController> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('RiwayatPenjualanView'),
        centerTitle: true,
      ),
      body: Center(
        child: Text(
          'RiwayatPenjualanView is working',
          style: TextStyle(fontSize: 20),
        ),
      ),
    );
  }
}
