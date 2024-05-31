import 'package:elpigo/app/modules/customer/Keranjang_Customer/views/CartBottom.dart';
import 'package:elpigo/app/modules/customer/Keranjang_Customer/views/Keranjangbody.dart';
import 'package:elpigo/app/modules/customer/home_customer/views/home_customer_view.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:elpigo/app/modules/customer/Keranjang_Customer/controllers/keranjang_customer_controller.dart';
import 'package:google_fonts/google_fonts.dart';

class KeranjangCustomerView extends GetView<KeranjangCustomerController> {
  KeranjangCustomerView({Key? key}) : super(key: key);

  final KeranjangCustomerController controller = Get.put(KeranjangCustomerController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.green,
        title: Text(
          "Keranjang",
          style: GoogleFonts.poppins(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
          actions: [
          IconButton(
            onPressed: () {
              Get.back();
            },
            icon: Icon(
              CupertinoIcons.home,
              size: 25,
              color: Colors.white,
            ),
          ),
        ],
        automaticallyImplyLeading: false,
      ),  
      body: ListView(
        children: [
          Container(
            height: 750,
            padding: EdgeInsets.only(top: 20),
            decoration: BoxDecoration(
              color: Color.fromARGB(255, 209, 209, 209),
            ),
            child: Column(
              children: [
                Keranjangbody(),
                Padding(padding: EdgeInsets.all(20.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("Catatan",
                    style: GoogleFonts.poppins(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.green,
                     ),
                    ),
                    TextField(
                      decoration: InputDecoration(
                        border: OutlineInputBorder(),
                        hintText: 'Masukkan Catatan Jika Diperlukan',
                      ),
                    ),
                  ],
                ),
               ),
              ],
            ),
          )
        ],
      ),
      bottomNavigationBar: CartBottomNavBar(),
    );
  }
}
