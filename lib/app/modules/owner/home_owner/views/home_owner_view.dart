import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:elpigo/app/modules/owner/home_owner/controllers/home_owner_controller.dart';
import 'package:elpigo/app/modules/owner/loginOwner/controllers/login_owner_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

class HomeOwnerView extends StatefulWidget {
  @override
  _HomeViewState createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeOwnerView> {
  final HomeOwnerController controller = Get.put(HomeOwnerController());
  final LoginOwnerController logincontroller = Get.put(LoginOwnerController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blueGrey,
        title: Text(
          'Produk Manajemen',
          style: GoogleFonts.poppins(color: Colors.white),
        ),
        actions: [
          IconButton(
            color: Colors.white,
            onPressed: () {
              logincontroller.logout();
            },
            icon: Icon(Icons.logout),
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream: controller.getProductsStream(),
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
                  return ListView.builder(
                    itemCount: products.length,
                    itemBuilder: (context, index) {
                      var product = products[index].data() as Map<String, dynamic>;
                      var productId = products[index].id;
                      return Container(
                        padding: EdgeInsets.all(8.0),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            ClipRRect(
                              borderRadius: BorderRadius.circular(8.0),
                              child: Image.network(
                                product['imageUrl'],
                                width: 100,
                                height: 100,
                                fit: BoxFit.cover,
                              ),
                            ),
                            SizedBox(width: 16.0),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  TextFormField(
                                    initialValue: product['title'],
                                    style: GoogleFonts.poppins(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                    ),
                                    decoration: InputDecoration(
                                      border: InputBorder.none,
                                    ),
                                    onChanged: (value) {
                                      controller.titleChanges[productId] = value;
                                    },
                                  ),
                                  SizedBox(height: 4.0),
                                  Row(
                                    children: [
                                      Text(
                                        'Harga: Rp.',
                                        style: GoogleFonts.poppins(fontSize: 16),
                                      ),
                                      Expanded(
                                        child: TextFormField(
                                          initialValue: '${product['price']}',
                                          style: GoogleFonts.poppins(fontSize: 14),
                                          decoration: InputDecoration(
                                            border: InputBorder.none,
                                          ),
                                          onChanged: (value) {
                                            controller.priceChanges[productId] = value;
                                          },
                                          keyboardType: TextInputType.number,
                                        ),
                                      ),
                                    ],
                                  ),
                                  SizedBox(height: 4.0),
                                  Row(
                                    children: [
                                      Text(
                                        'Stok: ${product['stok']}',
                                        style: GoogleFonts.poppins(fontSize: 16),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                            Column(
                              children: [
                                Column(
                                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                  children: [
                                    ElevatedButton(
                                      onPressed: () {
                                        int currentStock = product['stok'];
                                        controller.updateStock(productId, currentStock + 1);
                                      },
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: Colors.green,
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(5),
                                        ),
                                        padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                                      ),
                                      child: Icon(
                                        Icons.add,
                                        color: Colors.white,
                                      ),
                                    ),
                                    SizedBox(width: 16),
                                    ElevatedButton(
                                      onPressed: () {
                                        int currentStock = product['stok'];
                                        if (currentStock > 0) {
                                          controller.updateStock(productId, currentStock - 1);
                                        }
                                      },
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: Colors.red,
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(5),
                                        ),
                                        padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                                      ),
                                      child: Icon(
                                        Icons.remove,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ],
                        ),
                      );
                    },
                  );
                }
              },
            ),
          ),
          ElevatedButton(
            onPressed: () async {
              try {
                await controller.saveAllChanges();
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Perubahan disimpan', style: GoogleFonts.poppins())),
                );
              } catch (e) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Error: ${e.toString()}')),
                );
              }
            },
            style: ElevatedButton.styleFrom(
              foregroundColor: Colors.white,
              backgroundColor: Colors.blueGrey,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8.0),
              ),
              padding: EdgeInsets.symmetric(vertical: 14.0, horizontal: 24.0),
            ),
            child: Text('Simpan Perubahan', style: GoogleFonts.poppins()),
          ),
          SizedBox(height: 20)
        ],
      ),
    );
  }
}
