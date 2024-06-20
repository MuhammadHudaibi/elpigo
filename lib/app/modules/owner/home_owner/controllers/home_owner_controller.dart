import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

class HomeOwnerController extends GetxController {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseStorage _storage = FirebaseStorage.instance;

  var priceChanges = <String, String>{}.obs;
  var stockChanges = <String, int>{}.obs;
  var titleChanges = <String, String>{}.obs;
  var products = <DocumentSnapshot>[].obs;

  get picker => null;

  @override
  void onInit() {
    super.onInit();
    getProductsStream().listen((snapshot) {
      products.value = snapshot.docs;
    });
  }

  Stream<QuerySnapshot> getProductsStream() {
    return _firestore.collection('products').snapshots();
  }

  void updatePrice(String docId, String newPrice) {
    priceChanges[docId] = newPrice;
  }

  void updateStock(String docId, int newStock) {
    stockChanges[docId] = newStock;
  }

  void updateTitle(String docId, String newTitle) {
    titleChanges[docId] = newTitle;
  }

  Future<void> deleteProduct(String docId, String imageUrl) async {
    try {
      if (imageUrl.isNotEmpty) {
        await _storage.refFromURL(imageUrl).delete();
      }
      await _firestore.collection('products').doc(docId).delete();
    } catch (e) {
      throw Exception("Gagal menghapus product: $e");
    }
  }

  Future<void> saveAllChanges() async {
    final batch = _firestore.batch();
    
    // Update Firestore with changes from local maps
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

    try {
      await batch.commit();
      // Clear local changes after successful commit
      priceChanges.clear();
      stockChanges.clear();
      titleChanges.clear();
    } catch (e) {
      throw Exception("Gagal menyimpan pembaharuan: $e");
    }
  }

  Future<void> addProduct(String title, String price, int stock, XFile image) async {
    try {
      String imageUrl = await _uploadImage(image);
      await FirebaseFirestore.instance.collection('products').doc(title).set({
        'title': title,
        'price': price,
        'stok': stock,
        'imageUrl': imageUrl,
      });
    } catch (e) {
      throw Exception("Gagal menambahkan product: $e");
    }
  }

  Future<String> _uploadImage(XFile image) async {
    File file = File(image.path);
    try {
      var snapshot = await _storage.ref().child('produk/${image.name}').putFile(file);
      return await snapshot.ref.getDownloadURL();
    } catch (e) {
      throw Exception("Gagal mengunggah foto: $e");
    }
  }

  Future<void> updateProductImage(String productId, String imageUrl) async {
    try {
      await _firestore.collection('products').doc(productId).update({'imageUrl': imageUrl});
    } catch (e) {
      throw Exception("Gagal memperbaharui: $e");
    }
  }
}
