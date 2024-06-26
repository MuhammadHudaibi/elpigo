import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';

import '../controllers/home_owner_controller.dart';

class AddProductPage extends StatefulWidget {
  const AddProductPage({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _AddProductPageState createState() => _AddProductPageState();
}

class _AddProductPageState extends State<AddProductPage> {
  final HomeOwnerController controller = Get.find();
  final TextEditingController titleController = TextEditingController();
  final TextEditingController priceController = TextEditingController();
  final TextEditingController stockController = TextEditingController();
  XFile? _image;

  Future<void> _pickImage() async {
    try {
      final pickedImage =
          await ImagePicker().pickImage(source: ImageSource.gallery);
      if (pickedImage != null) {
        setState(() {
          _image = pickedImage;
        });
      } else {
        Get.snackbar('Tidak ada gambar yang dipilih', 'Pilih gambar.');
      }
    } catch (e) {
      Get.snackbar('Error', 'Failed to pick image: $e');
    }
  }

  Future<void> _submit() async {
    if (titleController.text.isNotEmpty &&
        priceController.text.isNotEmpty &&
        stockController.text.isNotEmpty &&
        _image != null) {
      try {
        await controller.addProduct(
          titleController.text,
          priceController.text,
          int.parse(stockController.text),
          _image!,
        );
        Get.back();
      } catch (e) {
        Get.snackbar('Error', 'Gagal menambahkan produk: $e');
      }
    } else {
      Get.snackbar('Error', 'Silahkan lengkapi semua kolom dan pilih gambar');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Tambah Produk',
            style: GoogleFonts.poppins(color: Colors.white)),
        backgroundColor: Color.fromARGB(255, 82, 140, 75),
        iconTheme: IconThemeData(color: Colors.white),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextField(
                controller: titleController,
                cursorColor: Color.fromARGB(255, 82, 140, 75),
                decoration: InputDecoration(
                  labelText: 'Nama Produk',
                  labelStyle: GoogleFonts.poppins(
                    color: Color.fromARGB(255, 82, 140, 75),
                  ),
                  border: OutlineInputBorder(),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                      color: Color.fromARGB(255, 82, 140, 75),
                    ),
                  ),
                ),
              ),
              SizedBox(height: 16.0),
              TextField(
                controller: priceController,
                cursorColor: Color.fromARGB(255, 82, 140, 75),
                decoration: InputDecoration(
                  labelText: 'Harga',
                  labelStyle: GoogleFonts.poppins(
                    color: Color.fromARGB(255, 82, 140, 75),
                  ),
                  border: OutlineInputBorder(),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                      color: Color.fromARGB(255, 82, 140, 75),
                    ),
                  ),
                ),
                keyboardType: TextInputType.number,
              ),
              SizedBox(height: 16.0),
              TextField(
                controller: stockController,
                cursorColor: Color.fromARGB(255, 82, 140, 75),
                decoration: InputDecoration(
                  labelText: 'Stok',
                  labelStyle: GoogleFonts.poppins(
                    color: Color.fromARGB(255, 82, 140, 75),
                  ),
                  border: OutlineInputBorder(),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                      color: Color.fromARGB(255, 82, 140, 75),
                    ),
                  ),
                ),
                keyboardType: TextInputType.number,
              ),
              SizedBox(height: 16.0),
              Center(
                child: Container(
                  height: 200,
                  width: 200,
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey.shade400),
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                  child: _image == null
                      ? Center(
                          child: Text(
                            'Belum ada gambar dipilih.',
                            style: GoogleFonts.poppins(
                                color: Color.fromARGB(255, 82, 140, 75)),
                          ),
                        )
                      : ClipRRect(
                          borderRadius: BorderRadius.circular(8.0),
                          child: Image.file(
                            File(_image!.path),
                            fit: BoxFit.cover,
                            width: double.infinity,
                          ),
                        ),
                ),
              ),
              SizedBox(height: 25.0),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ElevatedButton.icon(
                    onPressed: _pickImage,
                    icon: Icon(
                      Icons.image,
                      color: Colors.white,
                    ),
                    label: Text('Pilih Gambar',
                        style: GoogleFonts.poppins(color: Colors.white)),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Color.fromARGB(255, 82, 140, 75),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                      padding: EdgeInsets.symmetric(
                          vertical: 14.0, horizontal: 24.0),
                    ),
                  ),
                  SizedBox(width: 16.0),
                  ElevatedButton.icon(
                    onPressed: _submit,
                    icon: Icon(Icons.add, color: Colors.white),
                    label: Text('Tambah Produk',
                        style: GoogleFonts.poppins(color: Colors.white)),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Color.fromARGB(255, 82, 140, 75),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                      padding: EdgeInsets.symmetric(
                          vertical: 14.0, horizontal: 22.0),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
