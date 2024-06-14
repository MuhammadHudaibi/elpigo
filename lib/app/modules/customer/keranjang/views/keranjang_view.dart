import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import '../controllers/keranjang_customer_controller.dart';

class KeranjangCustomerView extends GetView<KeranjangCustomerController> {
  final KeranjangCustomerController cartController =
      Get.find<KeranjangCustomerController>();

  final TextEditingController catatanController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color.fromARGB(255, 82, 140, 75),
        title: Text(
          "Keranjang",
          style: GoogleFonts.poppins(
            fontSize: 25,
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
      body: Obx(
        () {
          if (cartController.cartItems.isEmpty) {
            return Center(
              child: Text(
                'Belum ada produk yang ditambahkan',
                style: GoogleFonts.poppins(
                  fontSize: 14,
                  fontWeight: FontWeight.normal,
                  color: Colors.black,
                ),
              ),
            );
          } else {
            return Stack(
              children: [
                ListView.builder(
                  itemCount: cartController.cartItems.length,
                  itemBuilder: (context, index) {
                    var product = cartController.cartItems[index];
                    return Container(
                      margin:
                          EdgeInsets.symmetric(horizontal: 15, vertical: 10),
                      padding: EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.grey),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Row(
                        children: [
                          Obx(() {
                            bool isSelected = cartController.selectedItems
                                .containsKey(product['id']);
                            return Checkbox(
                              value: isSelected,
                              onChanged: (bool? value) {
                                cartController.toggleSelection(
                                    product, value ?? false);
                              },
                              activeColor: isSelected
                                  ? Color.fromARGB(255, 82, 140, 75)
                                  : Colors.white,
                              checkColor: Colors.white,
                            );
                          }),
                          Image.network(
                            product['imageUrl'],
                            width: 54,
                            height: 90,
                            fit: BoxFit.fitHeight,
                          ),
                          SizedBox(width: 10),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                product['title'],
                                style: GoogleFonts.poppins(
                                  fontSize: 15,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black,
                                ),
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                              ),
                              SizedBox(height: 24),
                              Text(
                                "Rp.${product['totalPrice'] is int ? product['totalPrice'] : product['totalPrice'].toStringAsFixed(0)}",
                                style: GoogleFonts.poppins(
                                  fontSize: 14,
                                  fontWeight: FontWeight.normal,
                                  color: Colors.black,
                                ),
                              ),
                            ],
                          ),
                          Spacer(),
                          Padding(
                            padding: EdgeInsets.symmetric(vertical: 5),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                IconButton(
                                  onPressed: () {
                                    cartController.removeFromCart(product);
                                  },
                                  icon: Icon(
                                    Icons.delete,
                                    color: Colors.red,
                                    size: 28,
                                  ),
                                ),
                                Row(
                                  children: [
                                    IconButton(
                                      onPressed: () {
                                        cartController
                                            .decreaseQuantity(product);
                                      },
                                      icon: Icon(
                                        CupertinoIcons.minus_circled,
                                        color: Colors.red,
                                      ),
                                    ),
                                    Text(
                                      '${product['quantity'] ?? 1}',
                                      style: GoogleFonts.poppins(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.black,
                                      ),
                                    ),
                                    IconButton(
                                      onPressed: () {
                                        cartController
                                            .increaseQuantity(product);
                                      },
                                      icon: Icon(
                                        CupertinoIcons.add_circled,
                                        color: Color.fromARGB(255, 82, 140, 75),
                                      ),
                                    ),
                                  ],
                                )
                              ],
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                ),
                Obx(
                  () {
                    if (cartController.selectedItems.isNotEmpty) {
                      return Positioned(
                        bottom: 0,
                        left: 0,
                        right: 0,
                        child: Container(
                          color: Color.fromARGB(255, 82, 140, 75),
                          padding: EdgeInsets.all(16),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    'Total Harga',
                                    style: GoogleFonts.poppins(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white,
                                    ),
                                  ),
                                  Text(
                                    'Rp.${cartController.totalSelectedPrice.toStringAsFixed(0)}',
                                    style: GoogleFonts.poppins(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white,
                                    ),
                                  ),
                                ],
                              ),
                              Padding(
                                padding: EdgeInsets.only(top: 5),
                                child: Center(
                                  child: ElevatedButton(
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: Colors.white,
                                      minimumSize: Size(30, 35),
                                    ),
                                    onPressed: () {},
                                    child: Text(
                                      "Checkout",
                                      style: GoogleFonts.poppins(
                                        fontWeight: FontWeight.w500,
                                        color: Color.fromARGB(255, 82, 140, 75),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    } else {
                      return SizedBox.shrink();
                    }
                  },
                ),
              ],
            );
          }
        },
      ),
    );
  }
}
