import 'package:flutter/material.dart';

 class CartBottomNavBar extends StatelessWidget {
  @override
  Widget build(BuildContext context){
    return BottomAppBar(
      color: Colors.green,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 1,vertical: 1),
        
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Total: 1",
                  style: TextStyle(color: Colors.white,
                  fontSize: 14,
                  fontWeight: FontWeight.bold),
                ),Text(
                  "Rp.20.000 ",
                  style: TextStyle(color: Colors.white,
                  fontSize: 14,
                  fontWeight: FontWeight.bold),
                ),
              ],
            ),
            Container(
              alignment: Alignment.center,
              height: 32,
              width:150,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(5),
              ),
              child: Text(
                "CheckOut",
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
 }