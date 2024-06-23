import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter/cupertino.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../keranjang/views/keranjang_view.dart';
import '../controllers/home_customer_controller.dart';

class HomeCustomerView extends GetView<HomeCustomerController> {
  HomeCustomerView({super.key});

  @override
  final HomeCustomerController controller = Get.put(HomeCustomerController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color.fromARGB(255, 82, 140, 75),
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
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => KeranjangCustomerView(),
                ),
              );
            },
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
            if (controller.isLoading.value) {
              return Center(
                child: CircularProgressIndicator(),
              );
            } else {
              final userData = controller.userData;
              return Center(
                child: Padding(
                  padding: EdgeInsets.all(25),
                  child: StreamBuilder<QuerySnapshot>(
                    stream: controller.getRecipesStream(),
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
                      } else if (snapshot.hasError) {
                        return Text('Error: ${snapshot.error}');
                      } else {
                        List<DocumentSnapshot> products = snapshot.data!.docs;
                        return Column(
                          children: [
                            Center(
                              child: Text(
                                "Selamat Datang \n${userData['name']}!",
                                style: GoogleFonts.poppins(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black,
                                ),
                                textAlign: TextAlign.center,
                              ),
                            ),
                            SizedBox(height: 8),
                            Text(
                              "Selamat Berbelanja",
                              style: GoogleFonts.poppins(
                                fontSize: 18,
                                fontWeight: FontWeight.normal,
                                color: Colors.black,
                              ),
                            ),
                            SizedBox(height: 30),
                            GridView.builder(
                              shrinkWrap: true,
                              physics: NeverScrollableScrollPhysics(),
                              gridDelegate:
                                  SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: 2,
                                crossAxisSpacing: 10,
                                mainAxisSpacing: 10,
                                childAspectRatio: 0.65,
                              ),
                              itemCount: products.length,
                              itemBuilder: (context, index) {
                                var product = products[index].data()
                                    as Map<String, dynamic>;
                                var productId = products[index].id;
                                return Card(
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Image.network(
                                        product['imageUrl'],
                                        width: double.infinity,
                                        height: 110,
                                        fit: BoxFit.fitHeight,
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              product['title'],
                                              style: GoogleFonts.poppins(
                                                fontSize: 13,
                                                fontWeight: FontWeight.bold,
                                                color: Colors.black,
                                              ),
                                              maxLines: 2,
                                              overflow: TextOverflow.ellipsis,
                                            ),
                                            Text(
                                              "Rp.${product['price']}",
                                              style: GoogleFonts.poppins(
                                                fontSize: 13,
                                                fontWeight: FontWeight.normal,
                                                color: Colors.black,
                                              ),
                                            ),
                                            Text(
                                              "Stok : ${product['stok'] ?? 0}",
                                              style: GoogleFonts.poppins(
                                                fontSize: 12,
                                                fontWeight: FontWeight.normal,
                                                color: Colors.black,
                                              ),
                                            ),
                                            SizedBox(height: 10),
                                            Center(
                                              child: ElevatedButton(
                                                style: ElevatedButton.styleFrom(
                                                  backgroundColor:
                                                      Color.fromARGB(
                                                          255, 82, 140, 75),
                                                  minimumSize: Size(25, 35),
                                                ),
                                                onPressed: () {
                                                  controller.addProductToCart(
                                                      product, context);
                                                },
                                                child: Icon(
                                                  CupertinoIcons.add,
                                                  size: 25,
                                                  color: Colors.white,
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                );
                              },
                            ),
                          ],
                        );
                      }
                    },
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
