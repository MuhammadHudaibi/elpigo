import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';

class SplashController extends GetxController {
  Stream<User?> get streamAuthStatus =>
      FirebaseAuth.instance.authStateChanges();
}
