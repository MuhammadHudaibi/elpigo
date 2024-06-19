import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class KeranjangCustomerController extends GetxController {
  var cartItems = [].obs;
  var selectedItems = {}.obs;
  var catatan = ''.obs;
  TextEditingController catatanController = TextEditingController();

  @override
  void onInit() {
    super.onInit();
    catatanController.text = catatan.value;
    catatanController.addListener(() {
      catatan.value = catatanController.text;
    });
    listenToCartChanges();
  }

  void listenToCartChanges() {
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      FirebaseFirestore.instance
          .collection('customers')
          .doc(user.uid)
          .collection('pemesanan')
          .snapshots()
          .listen((QuerySnapshot snapshot) {
        cartItems.value = snapshot.docs.map((doc) {
          var data = doc.data() as Map<String, dynamic>;
          data['id'] = doc.id;
          data['quantity'] = data['quantity'] ?? 1;
          data['price'] = data['price'] is String
              ? double.tryParse(data['price']) ?? 0
              : data['price'];
          data['totalPrice'] = data['price'] * data['quantity'];
          return data;
        }).toList();
      });
    }
  }

  Future<void> fetchCartItems() async {
    try {
      User? user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        QuerySnapshot querySnapshot = await FirebaseFirestore.instance
            .collection('customers')
            .doc(user.uid)
            .collection('pemesanan')
            .get();

        cartItems.value = querySnapshot.docs.map((doc) {
          var data = doc.data() as Map<String, dynamic>;
          data['id'] = doc.id;
          data['quantity'] = data['quantity'] ?? 1;
          data['price'] = data['price'] is String
              ? double.tryParse(data['price']) ?? 0
              : data['price'];
          data['totalPrice'] = data['price'] * data['quantity'];
          return data;
        }).toList();
      }
    } catch (e) {
      print('Error fetching cart items: $e');
    }
  }

  void increaseQuantity(Map<String, dynamic> product) {
    String userId = FirebaseAuth.instance.currentUser!.uid;
    double price = product['price'] is String
        ? double.tryParse(product['price']) ?? 0
        : product['price'];
    int stock = product['stok'];

    if (product['quantity'] < stock) {
      FirebaseFirestore.instance
          .collection('customers')
          .doc(userId)
          .collection('pemesanan')
          .doc(product['id'])
          .update({
        'quantity': FieldValue.increment(1),
        'totalPrice': FieldValue.increment(price)
      }).then((_) {
        if (selectedItems.containsKey(product['id'])) {
          selectedItems[product['id']]['quantity'] += 1;
          selectedItems[product['id']]['totalPrice'] += price;
          selectedItems.refresh();
        }
      });
    } else {
      Get.snackbar(
        'Stok tidak cukup',
        'Jumlah produk melebihi stok yang tersedia',
        snackPosition: SnackPosition.TOP,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    }
  }

  void decreaseQuantity(Map<String, dynamic> product) {
    String userId = FirebaseAuth.instance.currentUser!.uid;
    double price = product['price'] is String
        ? double.tryParse(product['price']) ?? 0
        : product['price'];
    FirebaseFirestore.instance
        .collection('customers')
        .doc(userId)
        .collection('pemesanan')
        .doc(product['id'])
        .get()
        .then(
      (DocumentSnapshot doc) {
        int currentQuantity = doc['quantity'] ?? 1;
        if (currentQuantity > 1) {
          doc.reference.update({
            'quantity': currentQuantity - 1,
            'totalPrice': FieldValue.increment(-price)
          }).then((_) {
            if (selectedItems.containsKey(product['id'])) {
              selectedItems[product['id']]['quantity'] -= 1;
              selectedItems[product['id']]['totalPrice'] -= price;
              selectedItems.refresh();
            }
          });
        } else {
          removeFromCart(product);
        }
      },
    );
  }

  void removeFromCart(Map<String, dynamic> product) {
    String userId = FirebaseAuth.instance.currentUser!.uid;
    FirebaseFirestore.instance
        .collection('customers')
        .doc(userId)
        .collection('pemesanan')
        .doc(product['id'])
        .delete()
        .then((_) {
      selectedItems.remove(product['id']);
      selectedItems.refresh();
    });
  }

  void toggleSelection(Map<String, dynamic> product, bool isSelected) {
    if (isSelected) {
      selectedItems[product['id']] = product;
    } else {
      selectedItems.remove(product['id']);
    }
    selectedItems.refresh();
  }

  double get totalSelectedPrice {
    return selectedItems.values
        .fold(0, (sum, item) => sum + item['totalPrice']);
  }

  int get totalSelectedQuantity {
    return selectedItems.values
        .fold(0, (int sum, item) => sum + (item['quantity'] as int));
  }

  void checkout() async {
    String userId = FirebaseAuth.instance.currentUser!.uid;
    var batch = FirebaseFirestore.instance.batch();

    selectedItems.forEach((key, product) {
      var docRef = FirebaseFirestore.instance
          .collection('customers')
          .doc(userId)
          .collection('riwayat_pemesanan')
          .doc();

      batch.set(docRef, {
        'title': product['title'],
        'imageUrl': product['imageUrl'],
        'quantity': product['quantity'],
        'price': product['price'],
        'totalPrice': product['totalPrice'],
        'timestamp': DateTime.now(),
        'catatan': catatan.value,
      });

      FirebaseFirestore.instance
          .collection('customers')
          .doc(userId)
          .collection('pemesanan')
          .doc(product['id'])
          .delete();
    });

    await batch.commit();
    selectedItems.clear();
    Get.offNamed('/riwayat-pemesanan');
  }

  bool get isEmpty => cartItems.isEmpty;
}
