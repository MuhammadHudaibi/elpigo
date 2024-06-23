import 'package:get/get.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
// ignore: depend_on_referenced_packages
import 'package:intl/intl.dart';

class RiwayatPemesananController extends GetxController {
  var riwayatItems = [].obs;

  @override
  void onInit() {
    super.onInit();
    fetchRiwayatItems();
  }

  void fetchRiwayatItems() {
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      FirebaseFirestore.instance
          .collection('customers')
          .doc(user.uid)
          .collection('riwayat_pemesanan')
          .orderBy('timestamp', descending: true)
          .snapshots()
          .listen((QuerySnapshot snapshot) {
        riwayatItems.value = snapshot.docs.map((doc) {
          var data = doc.data() as Map<String, dynamic>;
          data['id'] = doc.id;
          data['timestamp'] = (doc['timestamp'] as Timestamp).toDate();
          return data;
        }).toList();
      });
    }
  }

  String formatDateTime(DateTime date) {
    return DateFormat('dd/MM/yyyy HH:mm').format(date);
  }
}
