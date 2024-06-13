import 'dart:io';
import 'package:elpigo/app/modules/owner/home_owner/controllers/home_owner_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';

class AddProductPage extends StatefulWidget {
  @override
  _AddProductPageState createState() => _AddProductPageState();
}

class _AddProductPageState extends State<AddProductPage> {
  final HomeOwnerController controller = Get.find();
  final TextEditingController titleController = TextEditingController();
  final TextEditingController priceController = TextEditingController();
  final TextEditingController stockController = TextEditingController();
  XFile? _image;

  Future<void> _pickImage() async {
    final pickedImage = await controller.picker.pickImage(source: ImageSource.gallery);
    setState(() {
      _image = pickedImage;
    });
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
        Get.snackbar('Error', 'Failed to add product: $e');
      }
    } else {
      Get.snackbar('Error', 'Please fill all fields and select an image');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Tambah Produk', style: GoogleFonts.poppins()),
        backgroundColor: Color.fromARGB(255, 82, 140, 75),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextField(
                controller: titleController,
                decoration: InputDecoration(
                  labelText: 'Title',
                  labelStyle: GoogleFonts.poppins(),
                  border: OutlineInputBorder(),
                ),
              ),
              SizedBox(height: 16.0),
              TextField(
                controller: priceController,
                decoration: InputDecoration(
                  labelText: 'Price',
                  labelStyle: GoogleFonts.poppins(),
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.number,
              ),
              SizedBox(height: 16.0),
              TextField(
                controller: stockController,
                decoration: InputDecoration(
                  labelText: 'Stock',
                  labelStyle: GoogleFonts.poppins(),
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.number,
              ),
              SizedBox(height: 16.0),
              _image == null
                  ? Text('No image selected.', style: GoogleFonts.poppins())
                  : Image.file(File(_image!.path), height: 150),
              SizedBox(height: 16.0),
              ElevatedButton(
                onPressed: _pickImage,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Color.fromARGB(255, 82, 140, 75),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                  padding: EdgeInsets.symmetric(vertical: 14.0, horizontal: 24.0),
                ),
                child: Text('Pick Image', style: GoogleFonts.poppins(color: Colors.white)),
              ),
              SizedBox(height: 16.0),
              Center(
                child: ElevatedButton(
                  onPressed: _submit,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color.fromARGB(255, 82, 140, 75),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                    padding: EdgeInsets.symmetric(vertical: 14.0, horizontal: 24.0),
                  ),
                  child: Text('Add Product', style: GoogleFonts.poppins(color: Colors.white)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}