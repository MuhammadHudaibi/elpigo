import 'package:get/get.dart';
import 'package:firebase_auth/firebase_auth.dart';

class LoginCustomerController extends GetxController {
  var isObscured = true.obs;
  var nik = ''.obs;
  var password = ''.obs;

  void toggleObscure() {
    isObscured.toggle();
  }

  Future<void> login() async {
    try {
      // Lakukan proses login dengan Firebase Auth
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: '${nik.value}@example.com',
        password: password.value,
      );

      // Jika berhasil login, lakukan sesuatu seperti navigasi ke halaman berikutnya
      // Misalnya, Anda dapat menggunakan Get untuk melakukan navigasi ke halaman lain:
      // Get.offNamed('/home');
    } catch (e) {
      // Tangani kesalahan saat login
      print('Error while logging in: $e');
      // Tampilkan pesan kesalahan menggunakan Get.snackbar
      Get.snackbar('Error', 'Failed to login: $e');
    }
  }
}
