import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

class HomeOwnerController extends GetxController {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseStorage _storage = FirebaseStorage.instance;
  final ImagePicker picker = ImagePicker();

  var priceChanges = <String, String>{}.obs;
  var stockChanges = <String, int>{}.obs;
  var titleChanges = <String, String>{}.obs;

  @override
  void onInit() {
    super.onInit();
  }

  Stream<QuerySnapshot> getProductsStream() {
    return _firestore.collection('products').snapshots();
  }

  Future<DocumentSnapshot<Map<String, dynamic>>> getProductById(String productId) async {
    try {
      DocumentSnapshot<Map<String, dynamic>> productSnapshot = await _firestore.collection('products').doc(productId).get();
      if (productSnapshot.exists) {
        return productSnapshot;
      } else {
        return Future.error("Product not found");
      }
    } catch (e) {
      return Future.error(e.toString());
    }
  }

  Future<void> updatePrice(String docId, String newPrice) async {
    await _firestore.collection('products').doc(docId).update({
      'price': newPrice,
    });
  }

  Future<void> updateStock(String docId, int newStock) async {
    await _firestore.collection('products').doc(docId).update({
      'stok': newStock,
    });
  }

  Future<void> updateTitle(String docId, String newTitle) async {
    await _firestore.collection('products').doc(docId).update({
      'title': newTitle,
    });
  }

  Future<void> deleteProduct(String docId, String imageUrl) async {
    try {
      // Delete image from Firebase Storage
      if (imageUrl.isNotEmpty) {
        await _storage.refFromURL(imageUrl).delete();
      }

      // Delete product from Firestore
      await _firestore.collection('products').doc(docId).delete();
    } catch (e) {
      Future.error("Failed to delete product: $e");
    }
  }

  Future<void> saveAllChanges() async {
    final batch = _firestore.batch();
    priceChanges.forEach((docId, newPrice) {
      final docRef = _firestore.collection('products').doc(docId);
      batch.update(docRef, {'price': newPrice});
    });
    stockChanges.forEach((docId, newStock) {
      final docRef = _firestore.collection('products').doc(docId);
      batch.update(docRef, {'stok': newStock});
    });
    titleChanges.forEach((docId, newTitle) {
      final docRef = _firestore.collection('products').doc(docId);
      batch.update(docRef, {'title': newTitle});
    });
    await batch.commit();
  }

  Future<void> addProduct(String title, String price, int stock, XFile image) async {
    try {
      String imageUrl = await _uploadImage(image);

      // Add product to Firestore
      await _firestore.collection('products').add({
        'title': title,
        'price': price,
        'stok': stock,
        'imageUrl': imageUrl,
      });
    } catch (e) {
      Future.error("Failed to add product: $e");
    }
  }

  Future<String> _uploadImage(XFile image) async {
    File file = File(image.path);
    try {
      var snapshot = await _storage.ref().child('produk/${image.name}').putFile(file);
      return await snapshot.ref.getDownloadURL();
    } catch (e) {
      return Future.error("Failed to upload image: $e");
    }
  }

  @override
  void dispose() {
    super.dispose();
  }
}