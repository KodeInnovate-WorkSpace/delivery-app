import 'package:flutter/material.dart';

import 'add_to_cart_button.dart';

class ProductCard extends StatefulWidget {
  const ProductCard({super.key});

  @override
  State<ProductCard> createState() => _ProductCardState();
}

class _ProductCardState extends State<ProductCard> {

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(6.0), // Set the border radius here
      ),
      color: Colors.white,
      elevation: 1.6,
      child: const Padding(
        padding: EdgeInsets.all(8.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [

            Center(
            //     child: Image.network(
            //   width: 90,
            //   "https://firebasestorage.googleapis.com/v0/b/speedy-app-e17a5.appspot.com/o/images%2Fblack_pepper_masala.png?alt=media&token=38266974-fadb-4613-b724-83ef4b66e1b0",
            // )
            child: Text("Image"),
            ),

            SizedBox(
              height: 15,
            ),
            Text(
              "MDH Black Pepper Powder",
              textAlign: TextAlign.left,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(fontFamily: 'Gilroy-SemiBold'),
            ), // Replace with your actual data field
            Text(
              "100g",
              style: TextStyle(color: Colors.grey),
            ),
            SizedBox(
              height: 10,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "\u20B9 78",
                  style: TextStyle(
                    fontFamily: "Gilroy-medium",
                  ),
                ),

                AddToCartButton(),

              ],
            ),
          ],
        ),
      ),
    );
  }
}
