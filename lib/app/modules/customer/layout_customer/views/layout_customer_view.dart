import 'package:elpigo/app/modules/customer/Profile/views/profile_view.dart';
import 'package:elpigo/app/modules/customer/home_customer/views/home_customer_view.dart';
import 'package:elpigo/app/modules/customer/riwayat_pemesanan/views/riwayat_pemesanan_view.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

import '../controllers/layout_customer_controller.dart';

class LayoutCustomerView extends GetView<LayoutCustomerController> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Obx(
        () => IndexedStack(
          index: controller.tabIndex.value,
          children: [
            HomeCustomerView(),
            RiwayatPemesanan(),
            ProfileView(),
          ],
        ),
      ),
      bottomNavigationBar: Obx(
        () => BottomNavigationBar(
          currentIndex: controller.tabIndex.value,
          onTap: (index) {
            controller.changeTabIndex(index);
          },
          backgroundColor: Color.fromARGB(255, 82, 140, 75),
          selectedItemColor: Colors.white,
          unselectedItemColor: Colors.white70,
          selectedFontSize: 14,
          unselectedFontSize: 12,
          selectedLabelStyle: GoogleFonts.poppins(fontWeight: FontWeight.bold),
          unselectedLabelStyle:
              GoogleFonts.poppins(fontWeight: FontWeight.normal),
          type: BottomNavigationBarType.fixed,
          items: [
            BottomNavigationBarItem(
              icon: Icon(Icons.home),
              label: 'Home',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.history),
              label: 'Riwayat Pemesanan',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.person),
              label: 'Profil',
            ),
          ],
        ),
      ),
    );
  }
}
