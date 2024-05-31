import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';

class HomeOwnerController extends GetxController {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  var priceChanges = <String, String>{}.obs;
  var stockChanges = <String, int>{}.obs;

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
    await batch.commit();
  }

  @override
  void dispose() {
    super.dispose();
  }
}