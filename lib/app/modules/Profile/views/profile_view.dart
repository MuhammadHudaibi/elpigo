import 'dart:io';
import 'package:flutter/material.dart';

import 'package:image_picker/image_picker.dart';

class Profileview extends StatefulWidget {
  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<Profileview> {
  File? _imageFile;

  Future<void> _pickImage() async {
    final pickedFile = await ImagePicker().pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _imageFile = File(pickedFile.path);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color.fromARGB(240, 37, 228, 34),
        title: const Text('Profile',
        style: TextStyle(fontSize: 36),),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: GestureDetector(
                onTap: _pickImage,
                child: CircleAvatar(
                  radius: 60.0,
                  backgroundImage: _imageFile != null
                      ? FileImage(_imageFile!)
                      : AssetImage('assets/placeholder.png') as ImageProvider,
                ),
              ),
            ),
            SizedBox(height: 16.0),
            Text(
              'Nama Customer',
              style: TextStyle(
                fontSize: 18.0,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 8.0),
            Text('Tipe Customer'),
            SizedBox(height: 16.0),
            Text(
              'NIK',
              style: TextStyle(
                fontSize: 16.0,
                fontWeight: FontWeight.bold,
              ),
            ),
            TextField(
              decoration: InputDecoration(
                hintText: 'Masukkan NIK',
              ),
            ),
            SizedBox(height: 16.0),
            Text(
              'KTP',
              style: TextStyle(
                fontSize: 16.0,
                fontWeight: FontWeight.bold,
              ),
            ),
            TextField(
              decoration: InputDecoration(
                hintText: 'Nomor KTP',
              ),
            ),
            SizedBox(height: 16.0),
            Text(
              'Address',
              style: TextStyle(
                fontSize: 16.0,
                fontWeight: FontWeight.bold,
              ),
            ),
            TextField(
              decoration: InputDecoration(
                hintText: 'Masukkan Alamat',
              ),
            ),
            SizedBox(height: 16.0),
            Text(
              'Phone Number',
              style: TextStyle(
                fontSize: 16.0,
                fontWeight: FontWeight.bold,
              ),
            ),
            TextField(
              decoration: InputDecoration(
                hintText: 'Masukkan Nomor Hp',
              ),
            ),
          ]
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Implementasikan logika edit profil di sini
        },
        child: Icon(Icons.edit),
      ),
    );
  }
}
