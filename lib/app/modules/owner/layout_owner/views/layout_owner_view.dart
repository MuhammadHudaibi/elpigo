import 'package:elpigo/app/modules/owner/home_owner/views/home_owner_view.dart';
import 'package:elpigo/app/modules/owner/riwayat_pembelian/views/riwayat_penjualan_view.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

import '../controllers/layout_owner_controller.dart';

// ignore: use_key_in_widget_constructors
class LayoutOwnerView extends StatelessWidget {
  final LayoutOwnerController controller = Get.put(LayoutOwnerController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Obx(
        () => IndexedStack(
          index: controller.tabIndex.value,
          children: [
            HomeOwnerView(),
            RiwayatPenjualanView(),
          ],
        ),
      ),
      bottomNavigationBar: Obx(
        () => BottomNavigationBar(
          currentIndex: controller.tabIndex.value,
          onTap: (index) {
            controller.changeTabIndex(index);
          },
          backgroundColor:  Color.fromARGB(255, 82, 140, 75),
          selectedItemColor: Colors.white,
          unselectedItemColor: Colors.white70,
          selectedFontSize: 14,
          unselectedFontSize: 12,
          selectedLabelStyle: GoogleFonts.poppins(fontWeight: FontWeight.bold),
          unselectedLabelStyle: GoogleFonts.poppins(fontWeight: FontWeight.normal),
          type: BottomNavigationBarType.fixed,
          items: const [
            BottomNavigationBarItem(
              icon: Icon(Icons.home),
              label: 'Home',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.history),
              label: 'Riwayat penjualan',
            ),
          ],
        ),
      ),
    );
  }
}
