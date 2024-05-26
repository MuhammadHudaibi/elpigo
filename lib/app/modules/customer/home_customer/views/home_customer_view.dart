import 'package:elpigo/app/modules/customer/loginCustomer/controllers/login_customer_controller.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../controllers/home_customer_controller.dart';

class HomeCustomerView extends GetView<HomeCustomerController> {
  @override
  Widget build(BuildContext context) {
    final LoginCustomerController controller = Get.put(LoginCustomerController());
    return Scaffold(
      appBar: AppBar(
        title: Text('HomeCustomerView'),
        centerTitle: true,
      ),
      body: Center(
        child: ElevatedButton(
          onPressed: (){
            controller.logout();
          },
          child: Text(
            'log out'
          )
        )
      ),
    );
  }
}
