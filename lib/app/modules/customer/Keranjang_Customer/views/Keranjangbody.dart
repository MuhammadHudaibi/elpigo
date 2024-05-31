import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:elpigo/app/modules/customer/Keranjang_Customer/controllers/keranjang_customer_controller.dart';
import 'package:get/get.dart';

class Keranjangbody extends StatelessWidget {
  @override
  Widget build(BuildContext context){
    return Column(
        children: [
          for(int i=1; i<4; i++)
          Container(
            height: 100,
            margin: EdgeInsets.symmetric(horizontal: 15, vertical: 10),
            padding: EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Row(
              children: [
                Radio(
                  value: "",
                  groupValue: "",
                  activeColor: Colors.green,
                  onChanged: (Index){}
                ),
                Container(
                  height: 80,
                  width: 80,
                  margin: EdgeInsets.only(right: 15),
                  child: Image.asset("assets/3kg.png"),
                ),
                Padding(padding: EdgeInsets.symmetric(vertical: 10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "Nama Produk",
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                        color: Colors.green,
                      ),
                    ),
                    Text(
                    "Rp.20.000  ",
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                      ),
                    ),
                  ],
                ),
              ),
              Spacer(),
              Padding(padding: EdgeInsets.symmetric(vertical: 5),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Icon(
                    Icons.delete,
                    color: Colors.red,
                  ),
                  Row(
                    children: [
                      Container(
                        padding: EdgeInsets.all(4),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(20),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey.withOpacity(0.5),
                              spreadRadius: 1,
                              blurRadius: 10,
                            ),
                          ]
                        ),
                        child: Icon(
                          CupertinoIcons.plus,
                          size: 18,
                        ),
                      ),
                      Container(
                        margin: EdgeInsets.symmetric(horizontal: 10),
                        child: Text(
                          "1",
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Colors.green,
                          ),
                        ),
                      ),
                      Container(
                        padding: EdgeInsets.all(4),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(20),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey.withOpacity(0.5),
                              spreadRadius: 1,
                              blurRadius: 10,
                            ),
                          ]
                        ),
                        child: Icon(
                          CupertinoIcons.minus,
                          size: 18,
                       ),
                     ),
                   ],
                  ),
                ],
               ),
              ),
             ],
            ),
          ),
        ],
    );
  }
}