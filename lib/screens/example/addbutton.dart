import 'package:flutter/material.dart';
import 'package:speedy_delivery/shared/show_msg.dart';

Widget buildAddToCartButton() {
  return InkWell(
    splashColor: Colors.green,
    onTap: () {
      showMessage("Product added to cart");
    },
    child: Container(
      padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 5),
      decoration: BoxDecoration(
        color: Colors.green,
        borderRadius: BorderRadius.circular(10.0),
        // border: Border.all(
        //   width: 1,
        //   // border color
        //   color: Colors.green,
        // )
      ),
      child: const Text(
        "Add",
        style: TextStyle(
          fontSize: 15,
          color: Colors.white,
        ),
      ),
    ),
  );
}
