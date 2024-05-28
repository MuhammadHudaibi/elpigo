import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/home_customer_controller.dart';

class HomeCustomerView extends StatelessWidget {
  final HomeCustomerController _controller = Get.put(HomeCustomerController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Home'),
      ),
      body: Center(
        child: Obx(
          () {
            if (_controller.isLoading.value) {
              return CircularProgressIndicator();
            } else {
              final userData = _controller.userData;
              return Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Welcome ${userData['name']}!',
                    style: TextStyle(fontSize: 24),
                  ),
                  SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: () {
                      _controller.logout();
                    },
                    child: Text('Logout'),
                  ),
                ],
              );
            }
          },
        ),
      ),
    );
  }
}