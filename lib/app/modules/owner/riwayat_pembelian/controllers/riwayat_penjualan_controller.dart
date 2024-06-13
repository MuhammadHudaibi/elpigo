import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
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
}