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
        backgroundColor:  Color.fromARGB(255, 82, 140, 75),
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
                  return Center(
                    child: Text(
                      'Error: ${snapshot.error}',
                      style: GoogleFonts.poppins(color: Colors.red),
                    ),
                  );
                } else {
                  List<DocumentSnapshot> products = snapshot.data!.docs;
                  return ListView.builder(
                    itemCount: products.length,
                    itemBuilder: (context, index) {
                      var product = products[index].data() as Map<String, dynamic>;
                      var productId = products[index].id;
                      return Card(
                        margin: EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
                        child: Padding(
                          padding: EdgeInsets.all(12.0),
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
                                  loadingBuilder: (context, child, loadingProgress) {
                                    if (loadingProgress == null) return child;
                                    return Container(
                                      width: 100,
                                      height: 100,
                                      child: Center(
                                        child: CircularProgressIndicator(
                                          value: loadingProgress.expectedTotalBytes != null
                                              ? loadingProgress.cumulativeBytesLoaded /
                                                  (loadingProgress.expectedTotalBytes ?? 1)
                                              : null,
                                        ),
                                      ),
                                    );
                                  },
                                  errorBuilder: (context, error, stackTrace) {
                                    return Container(
                                      width: 100,
                                      height: 100,
                                      color:  Color.fromARGB(255, 82, 140, 75),
                                      child: Icon(
                                        Icons.error,
                                        color: Colors.red,
                                      ),
                                    );
                                  },
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
                                    Text(
                                      'Stok: ${product['stok']}',
                                      style: GoogleFonts.poppins(fontSize: 16),
                                    ),
                                  ],
                                ),
                              ),
                              Column(
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
                                  SizedBox(height: 8.0),
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
                                  SizedBox(height: 8.0),
                                  ElevatedButton(
                                    onPressed: () {
                                      Get.defaultDialog(
                                        title: "Konfirmasi",
                                        middleText: "Apa anda yakin ingin menghapus produk ini?",
                                        textConfirm: "Ya",
                                        textCancel: "Tidak",
                                        confirmTextColor: Colors.white,
                                        onConfirm: () {
                                          controller.deleteProduct(productId);
                                          Get.back();
                                        },
                                        onCancel: () {},
                                      );
                                    },
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor:  Color.fromARGB(255, 82, 140, 75),
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(5),
                                      ),
                                      padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                                    ),
                                    child: Icon(
                                      Icons.delete,
                                      color: Colors.white,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  );
                }
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: ElevatedButton(
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
                backgroundColor:   Color.fromARGB(255, 82, 140, 75),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8.0),
                ),
                padding: EdgeInsets.symmetric(vertical: 14.0, horizontal: 24.0),
              ),
              child: Text('Simpan Perubahan', style: GoogleFonts.poppins()),
            ),
          ),
        ],
      ),
    );
  }
}
