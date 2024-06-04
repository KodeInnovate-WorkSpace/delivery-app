import 'package:flutter/material.dart';
import 'package:speedy_delivery/widget/add_to_cart_button.dart';

import 'addbutton.dart';

const productDetails =
    '''Amul Taaza Toned Milk (Polypack) is pasteurized with a great nutritional value. It can be consumed directly or can be used for preparing tea, coffee, sweets, khoya, curd, buttermilk, ghee etc.''';

class ProductCard extends StatelessWidget {
  const ProductCard({super.key});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        // openProductDescription(context, index);
      },
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10.0),
          border: Border.all(
            color: Colors.grey.shade300,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.2),
              spreadRadius: 1,
              blurRadius: 1,
            )
          ],
        ),
        child: Column(
          // crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Center(
              child: SizedBox(
                width: MediaQuery.of(context).size.width / 4,
                height: MediaQuery.of(context).size.height / 8,
                child: Image.network(
                  "https://firebasestorage.googleapis.com/v0/b/speedy-57c76.appspot.com/o/images%2Fbutter.png?alt=media&token=d07f2d3e-f4a8-4342-888f-d6d033e22c40",
                  // fit: BoxFit.contain,
                ),
              ),
            ),
            const SizedBox(
              height: 30,
            ),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Amul Milk",
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 15,
                    ),
                  ),
                  Text(
                    "300gms",
                    maxLines: 1,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 15,
                    ),
                  ),
                  SizedBox(
                    height: 50,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "₹ 100",
                          maxLines: 1,
                          style: TextStyle(
                            fontSize: 14,
                          ),
                        ),
                        // buildAddToCartButton()

                        AddToCartButton(
                            productName: "AMuk",
                            productPrice: 123,
                            productImage: "image",
                            productUnit: "1pcs")
                      ],
                    ),
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
