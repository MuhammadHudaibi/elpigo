import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/splash_controller.dart';

class SplashView extends GetView<SplashController> {
  const SplashView({super.key});

  @override
  Widget build(BuildContext context) {
    controller.streamAuthStatus.listen((User? user) {
      if (user != null) {
        Get.offNamed('/layout-customer');
      } else {
        Get.offNamed('/login-customer');
      }
    });

    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Image.asset(
              'assets/logo.png',
              height: 190,
              width: 190,
            ),
          ],
        ),
      ),
    );
  }
}
