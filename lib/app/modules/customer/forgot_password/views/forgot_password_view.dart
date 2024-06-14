import 'package:elpigo/app/modules/customer/forgot_password/controllers/forgot_password_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ForgotPasswordView extends StatelessWidget {
  final ForgotPasswordController controller = Get.put(ForgotPasswordController());
  final Color greenColor = Color.fromARGB(255, 82, 140, 75); 

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Icon(Icons.lock, size: 100, color: greenColor),
              SizedBox(height: 20),
              Text(
                'Lupa password',
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
                child: Text('Reset Password'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: greenColor, 
                  foregroundColor: Colors.white, 
                ),
              ),
              SizedBox(height: 10), 
              ElevatedButton(
                onPressed: () {
                  Get.back();
                },
                child: Text('Back to sign in'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: greenColor, 
                  foregroundColor: Colors.white, 
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
