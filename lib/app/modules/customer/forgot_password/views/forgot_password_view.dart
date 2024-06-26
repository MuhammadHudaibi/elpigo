import 'package:elpigo/app/modules/customer/forgot_password/controllers/forgot_password_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ForgotPasswordView extends StatelessWidget {
  final ForgotPasswordController controller =
      Get.put(ForgotPasswordController());
  final Color greenColor = Color.fromARGB(255, 82, 140, 75);

  ForgotPasswordView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Icon(Icons.lock, size: 100, color: greenColor),
              SizedBox(height: 20),
              Text(
                'Lupa Kata Sandi',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 10),
              Text(
                'Masukkan email yang terhubung dengan akunmu!\nKami akan mengirim link untuk pembaharuan.',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 16),
              ),
              SizedBox(height: 20),
              TextField(
                controller: controller.emailController,
                decoration: InputDecoration(
                  labelText: 'Email',
                  labelStyle:
                      TextStyle(color: Color.fromARGB(255, 82, 140, 75)),
                  border: OutlineInputBorder(
                    borderSide: BorderSide(color: greenColor),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: greenColor),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: greenColor),
                  ),
                ),
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  controller.resetPassword(controller.emailController.text);
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: greenColor,
                  foregroundColor: Colors.white,
                ),
                child: Text('Reset kata sandi'),
              ),
              SizedBox(height: 10),
              ElevatedButton(
                onPressed: () {
                  Get.back();
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: greenColor,
                  foregroundColor: Colors.white,
                ),
                child: Text('Kembali ke login'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
