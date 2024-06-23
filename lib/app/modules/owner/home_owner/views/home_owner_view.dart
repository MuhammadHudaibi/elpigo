import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:elpigo/app/modules/owner/home_owner/controllers/home_owner_controller.dart';
import 'package:elpigo/app/modules/owner/home_owner/views/add_product.dart';
import 'package:elpigo/app/modules/owner/loginOwner/controllers/login_owner_controller.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';

class HomeOwnerView extends StatefulWidget {
  const HomeOwnerView({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _HomeViewState createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeOwnerView> {
  final HomeOwnerController controller = Get.put(HomeOwnerController());
  final LoginOwnerController logincontroller = Get.put(LoginOwnerController());

  Future<void> _pickImage(String productId) async {
    final ImagePicker picker = ImagePicker();
    final XFile? image = await picker.pickImage(source: ImageSource.gallery);

    if (image != null) {
      try {
        // Menampilkan dialog konfirmasi sebelum mengunggah gambar baru
        bool confirmChange = await showDialog(
          // ignore: use_build_context_synchronously
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text('Konfirmasi'),
              content: Text('Apakah Anda yakin ingin mengganti foto produk ini?'),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop(false); // Batal
                  },
                  child: Text('Tidak'),
                ),
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop(true); // Konfirmasi
                  },
                  child: Text('Ya'),
                ),
              ],
            );
          },
        );

        if (confirmChange) {
          String fileName = image.name;
          Reference storageRef = FirebaseStorage.instance.ref().child('product_images').child(fileName);
          await storageRef.putFile(File(image.path));
          String downloadUrl = await storageRef.getDownloadURL();
          await controller.updateProductImage(productId, downloadUrl);
        }
      } catch (e) {
        if (kDebugMode) {
          print('Error uploading image: $e');
        }
        // ignore: use_build_context_synchronously
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error uploading image: $e', style: GoogleFonts.poppins())),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 82, 140, 75),
        title: Text(
          'Produk Manajemen',
          style: GoogleFonts.poppins(color: Colors.white),
        ),
        actions: [
          IconButton(
            color: Colors.white,
            onPressed: () {
              Get.defaultDialog(
                title: "Konfirmasi",
                middleText: "Apakah Anda yakin ingin keluar?",
                textConfirm: "Ya",
                textCancel: "Tidak",
                confirmTextColor: Colors.white,
                onConfirm: () {
                  logincontroller.logout();
                  Get.back();
                },
                onCancel: () {},
              );
            },
            icon: const Icon(Icons.logout),
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
                        const CircularProgressIndicator(),
                        const SizedBox(height: 20),
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
                      var imageUrl = product['imageUrl'] ?? '';
                      return Card(
                        margin: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
                        child: Padding(
                          padding: const EdgeInsets.all(12.0),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              GestureDetector(
                                onTap: () => _pickImage(productId),
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(8.0),
                                  child: Image.network(
                                    product['imageUrl'],
                                    width: 100,
                                    height: 100,
                                    fit: BoxFit.cover,
                                    loadingBuilder: (context, child, loadingProgress) {
                                      if (loadingProgress == null) return child;
                                      return SizedBox(
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
                                        color: const Color.fromARGB(255, 82, 140, 75),
                                        child: const Icon(
                                          Icons.error,
                                          color: Colors.red,
                                        ),
                                      );
                                    },
                                  ),
                                ),
                              ),
                              const SizedBox(width: 16.0),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.only(bottom: 4.0),
                                      child: TextFormField(
                                        initialValue: product['title'],
                                        style: GoogleFonts.poppins(
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold,
                                        ),
                                        maxLines: 2,
                                        decoration: const InputDecoration(
                                          border: InputBorder.none,
                                        ),
                                        onChanged: (value) {
                                          controller.updateTitle(productId, value);
                                        },
                                      ),
                                    ),
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
                                            decoration: const InputDecoration(
                                              border: InputBorder.none,
                                            ),
                                            onChanged: (value) {
                                              controller.updatePrice(productId, value);
                                            },
                                            keyboardType: TextInputType.number,
                                          ),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(height: 4.0),
                                    Row(
                                      children: [
                                        Text(
                                          'Stok: ',
                                          style: GoogleFonts.poppins(fontSize: 16),
                                        ),
                                        Expanded(
                                          child: TextFormField(
                                            initialValue: '${product['stok']}',
                                            style: GoogleFonts.poppins(fontSize: 14),
                                            decoration: const InputDecoration(
                                              border: InputBorder.none,
                                            ),
                                            onChanged: (value) {
                                              // Jika value kosong atau tidak valid, set stok menjadi 0
                                              int stok = int.tryParse(value) ?? 0;
                                              controller.updateStock(productId, stok);
                                            },
                                            keyboardType: TextInputType.number,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                              Column(
                                children: [
                                  ElevatedButton(
                                    onPressed: () {
                                      Get.defaultDialog(
                                        title: "Konfirmasi",
                                        middleText: "Apa anda yakin ingin menghapus produk ini?",
                                        textConfirm: "Ya",
                                        textCancel: "Tidak",
                                        confirmTextColor: Colors.white,
                                        onConfirm: () {
                                          controller.deleteProduct(productId, imageUrl);
                                          Get.back();
                                        },
                                        onCancel: () {},
                                      );
                                    },
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: const Color.fromARGB(255, 82, 140, 75),
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(5),
                                      ),
                                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                                    ),
                                    child: const Icon(
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
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                ElevatedButton(
                  onPressed: () {
                    Get.to(() => AddProductPage());
                  },
                  style: ElevatedButton.styleFrom(
                    foregroundColor: const Color.fromARGB(255, 82, 140, 75),
                    backgroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8.0),
                      side: const BorderSide(
                        color: Color.fromARGB(255, 82, 140, 75),
                        width: 0.5,
                      ),
                    ),
                    padding: const EdgeInsets.symmetric(vertical: 14.0, horizontal: 24.0),
                  ),
                  child: Text('Tambah Produk', style: GoogleFonts.poppins()),
                ),
                ElevatedButton(
                  onPressed: () async {
                    try {
                      await controller.saveAllChanges();
                      // ignore: use_build_context_synchronously
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('Perubahan disimpan', style: GoogleFonts.poppins())),
                      );
                    } catch (e) {
                      // ignore: use_build_context_synchronously
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('Error: ${e.toString()}')),
                      );
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    foregroundColor: Colors.white,
                    backgroundColor: const Color.fromARGB(255, 82, 140, 75),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                    padding: const EdgeInsets.symmetric(vertical: 14.0, horizontal: 24.0),
                  ),
                  child: Text('Simpan Perubahan', style: GoogleFonts.poppins()),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
