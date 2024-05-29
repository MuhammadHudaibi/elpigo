import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter/cupertino.dart';
import 'package:google_fonts/google_fonts.dart';
import '../controllers/home_customer_controller.dart';

class HomeCustomerView extends GetView<HomeCustomerController> {
  final HomeCustomerController _controller = Get.put(HomeCustomerController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.green,
        title: Text(
          "Home",
          style: GoogleFonts.poppins(
            fontSize: 25,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        actions: [
          IconButton(
            onPressed: () {},
            icon: Icon(
              CupertinoIcons.cart,
              size: 25,
              color: Colors.white,
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Obx(
          () {
            if (_controller.isLoading.value) {
              return CircularProgressIndicator();
            } else {
              final userData = _controller.userData;
              return Center(
                child: Padding(
                  padding: EdgeInsets.all(25),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "Selamat Datang ${userData['name']}!",
                        style: GoogleFonts.poppins(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.grey,
                        ),
                      ),
                      SizedBox(height: 8),
                      Text(
                        "Selamat Berbelanja",
                        style: GoogleFonts.poppins(
                          fontSize: 18,
                          fontWeight: FontWeight.normal,
                          color: Colors.grey,
                        ),
                      ),
                      SizedBox(height: 50),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Column(
                            children: [
                              Image.asset(
                                'assets/3kg.png',
                                width: 140,
                                height: 140,
                              ),
                              SizedBox(height: 10),
                              Text(
                                "Tabung Gas 3 Kg",
                                style: GoogleFonts.poppins(
                                  fontSize: 14,
                                  fontWeight: FontWeight.normal,
                                  color: Colors.grey,
                                ),
                              ),
                              SizedBox(height: 6),
                              Text(
                                "Rp.30.000",
                                style: GoogleFonts.poppins(
                                  fontSize: 12,
                                  fontWeight: FontWeight.normal,
                                  color: Colors.grey,
                                ),
                              ),
                              SizedBox(height: 6),
                              Text(
                                "Stok : 1",
                                style: GoogleFonts.poppins(
                                  fontSize: 12,
                                  fontWeight: FontWeight.normal,
                                  color: Colors.grey,
                                ),
                              ),
                              SizedBox(height: 6),
                              ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.green,
                                    minimumSize: Size(30, 30)),
                                onPressed: () {},
                                child: Icon(
                                  CupertinoIcons.add,
                                  size: 30,
                                  color: Colors.white,
                                ),
                              ),
                            ],
                          ),
                          SizedBox(width: 30),
                          Column(
                            children: [
                              Image.asset(
                                'assets/12.png',
                                width: 140,
                                height: 140,
                              ),
                              SizedBox(height: 10),
                              Text(
                                "Tabung Gas 12 Kg",
                                style: GoogleFonts.poppins(
                                  fontSize: 14,
                                  fontWeight: FontWeight.normal,
                                  color: Colors.grey,
                                ),
                              ),
                              SizedBox(height: 6),
                              Text(
                                "Rp.125.000",
                                style: GoogleFonts.poppins(
                                  fontSize: 12,
                                  fontWeight: FontWeight.normal,
                                  color: Colors.grey,
                                ),
                              ),
                              SizedBox(height: 6),
                              Text(
                                "Stok : 100",
                                style: GoogleFonts.poppins(
                                  fontSize: 12,
                                  fontWeight: FontWeight.normal,
                                  color: Colors.grey,
                                ),
                              ),
                              SizedBox(height: 6),
                              ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.green,
                                    minimumSize: Size(30, 30)),
                                onPressed: () {},
                                child: Icon(
                                  CupertinoIcons.add,
                                  size: 30,
                                  color: Colors.white,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                      SizedBox(height: 30),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Column(
                            children: [
                              Image.asset(
                                'assets/bright_gas.png',
                                width: 160,
                                height: 160,
                              ),
                              SizedBox(height: 10),
                              Text(
                                "Tabung Gas Bright",
                                style: GoogleFonts.poppins(
                                  fontSize: 14,
                                  fontWeight: FontWeight.normal,
                                  color: Colors.grey,
                                ),
                              ),
                              SizedBox(height: 6),
                              Text(
                                "Rp.100.000",
                                style: GoogleFonts.poppins(
                                  fontSize: 12,
                                  fontWeight: FontWeight.normal,
                                  color: Colors.grey,
                                ),
                              ),
                              SizedBox(height: 6),
                              Text(
                                "Stok : 100",
                                style: GoogleFonts.poppins(
                                  fontSize: 12,
                                  fontWeight: FontWeight.normal,
                                  color: Colors.grey,
                                ),
                              ),
                              SizedBox(height: 6),
                              ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.green,
                                    minimumSize: Size(30, 30)),
                                onPressed: () {},
                                child: Icon(
                                  CupertinoIcons.add,
                                  size: 30,
                                  color: Colors.white,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              );
            }
          },
        ),
      ),
    );
  }
}
