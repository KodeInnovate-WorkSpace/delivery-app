import 'package:flutter/material.dart';
import 'add_to_cart_button.dart';

class ProductCard extends StatefulWidget {
  final String productName;
  final String imageUrl;
  final String productWeight;
  final String productPrice;

  const ProductCard({
    super.key,
    required this.imageUrl,
    required this.productName,
    required this.productWeight,
    required this.productPrice,
  });

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
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Image.network(
                widget.imageUrl,
                width: 90,
              ),
            ),
            const SizedBox(height: 15),
            Text(
              widget.productName,
              textAlign: TextAlign.left,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(fontFamily: 'Gilroy-SemiBold'),
            ),
            Text(
              widget.productWeight,
              style: const TextStyle(color: Colors.grey),
            ),
            const SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "\u20B9 ${widget.productPrice}",
                  style: const TextStyle(fontFamily: "Gilroy-medium"),
                ),
                const AddToCartButton(),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
