import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';
import 'package:url_launcher/url_launcher.dart';

class RiwayatPenjualanController extends GetxController {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Stream<QuerySnapshot> getUsersStream() {
    return _firestore.collection('customers').snapshots();
  }

  Future<DocumentSnapshot<Map<String, dynamic>>> getUserById(String userId) async {
    try {
      DocumentSnapshot<Map<String, dynamic>> userSnapshot = await _firestore.collection('customers').doc(userId).get();
      if (userSnapshot.exists) {
        return userSnapshot;
      } else {
        return Future.error("User not found");
      }
    } catch (e) {
      return Future.error(e.toString());
    }
  }

  // Future<void> downloadImage(String url, String fileName) async {
  //   final response = await http.get(Uri.parse(url));
  //   final bytes = response.bodyBytes;

  //   final directory = await getApplicationDocumentsDirectory();
  //   final filePath = '${directory.path}/$fileName';

  //   File file = File(filePath);
  //   await file.writeAsBytes(bytes);

  //   ScaffoldMessenger.of(context).showSnackBar(
  //     SnackBar(content: Text('Downloaded to $filePath')),
  //   );
  // }
}