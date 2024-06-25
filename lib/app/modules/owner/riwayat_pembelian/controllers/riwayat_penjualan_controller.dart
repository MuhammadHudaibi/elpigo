import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_gallery_saver/image_gallery_saver.dart';
import 'package:photo_view/photo_view.dart';
import 'package:photo_view/photo_view_gallery.dart';
import 'package:http/http.dart' as http;
import 'package:permission_handler/permission_handler.dart';

class RiwayatPenjualanController extends GetxController {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Stream<QuerySnapshot> getUsersStream() {
    return _firestore.collection('customers').snapshots();
  }

  Future<DocumentSnapshot<Map<String, dynamic>>> getUserById(
      String userId) async {
    try {
      DocumentSnapshot<Map<String, dynamic>> userSnapshot =
          await _firestore.collection('customers').doc(userId).get();
      if (userSnapshot.exists) {
        return userSnapshot;
      } else {
        return Future.error("User tidak ditemukan");
      }
    } catch (e) {
      return Future.error(e.toString());
    }
  }

  Stream<QuerySnapshot> getRiwayatPemesananStream(String userId) {
    return _firestore
        .collection('customers')
        .doc(userId)
        .collection('riwayat_pemesanan')
        .orderBy('timestamp', descending: true)
        .snapshots();
  }

  void updateStatus(DocumentSnapshot doc, String newStatus) {
    FirebaseFirestore.instance.runTransaction((transaction) async {
      DocumentSnapshot freshSnap = await transaction.get(doc.reference);
      transaction.update(freshSnap.reference, {'status': newStatus});
    });
  }

  void showImageDialog(BuildContext context, String imageUrl, String caption,
      String userId) async {
    try {
      DocumentSnapshot<Map<String, dynamic>> userSnapshot =
          await getUserById(userId);
      String nama = userSnapshot.data()?['name'] ?? 'Unknown';

      showGeneralDialog(
        // ignore: use_build_context_synchronously
        context: context,
        barrierDismissible: true,
        barrierLabel:
            // ignore: use_build_context_synchronously
            MaterialLocalizations.of(context).modalBarrierDismissLabel,
        barrierColor: Colors.black87.withOpacity(0.5),
        transitionDuration: const Duration(milliseconds: 200),
        pageBuilder: (BuildContext buildContext, Animation animation,
            Animation secondaryAnimation) {
          return Scaffold(
            backgroundColor: Colors.black,
            body: SafeArea(
              child: Stack(
                children: [
                  PhotoViewGallery.builder(
                    itemCount: 1,
                    builder: (context, index) {
                      return PhotoViewGalleryPageOptions(
                        imageProvider: NetworkImage(imageUrl),
                        minScale: PhotoViewComputedScale.contained * 0.8,
                        maxScale: PhotoViewComputedScale.covered * 2,
                      );
                    },
                    scrollPhysics: BouncingScrollPhysics(),
                    backgroundDecoration: BoxDecoration(
                      color: Colors.black,
                    ),
                  ),
                  Positioned(
                    top: 0,
                    left: 0,
                    right: 0,
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.black54,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.5),
                            spreadRadius: 5,
                            blurRadius: 7,
                            offset: Offset(0, 3),
                          ),
                        ],
                      ),
                      padding: EdgeInsets.symmetric(horizontal: 10),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              IconButton(
                                icon:
                                    Icon(Icons.arrow_back, color: Colors.white),
                                onPressed: () {
                                  Navigator.of(context).pop();
                                },
                              ),
                              SizedBox(width: 8),
                              Text(
                                caption,
                                style: GoogleFonts.poppins(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                                overflow: TextOverflow.ellipsis,
                              ),
                            ],
                          ),
                          IconButton(
                            icon: Icon(Icons.save, color: Colors.white),
                            onPressed: () {
                              saveImageToGallery(
                                  context, imageUrl, caption, nama);
                            },
                            padding: EdgeInsets.all(0),
                            constraints: BoxConstraints(),
                            color: Colors.black54,
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      );
    } catch (e) {
      // ignore: use_build_context_synchronously
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $e')),
      );
    }
  }

  Future<void> requestPermissions() async {
    final status = await Permission.storage.request();
    if (status.isGranted) {
      print('Izin penyimpanan diberikan');
    } else {
      print('Izin penyimpanan ditolak');
    }
  }

  void saveImageToGallery(BuildContext context, String imageUrl, String caption,
      String nama) async {
        await requestPermissions();
    try {
      final response = await http.get(Uri.parse(imageUrl));
      final Uint8List bytes = response.bodyBytes;
      final result = await ImageGallerySaver.saveImage(bytes,
          quality: 80, name: "$caption $nama");

      if (result['isSuccess']) {
        // ignore: use_build_context_synchronously
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Gambar berhasil disimpan ke galeri')),
        );
      } else {
        // ignore: use_build_context_synchronously

        final errorMessage = result['errorMessage'] ?? 'Unknown error';
        print('Gagal menyimpan gambar ke galeri: $errorMessage');
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Gagal menyimpan gambar ke galeri')),
        );
      }
    } catch (e) {
      // ignore: use_build_context_synchronously
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $e')),
      );
    }
  }
}
