import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:speedy_delivery/shared/capitalise.dart';
import '../shared/remove_trailing_zero.dart';
import 'add_to_cart_button.dart';

class ProductCard extends StatefulWidget {
  final String productName;
  final String imageUrl;
  final String productWeight;
  final double productPrice;

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
              child: CachedNetworkImage(
                  imageUrl: widget.imageUrl,
                  width: 90,
                  fit: BoxFit.contain,
                  errorWidget: (context, url, error) =>
                      const Icon(Icons.error)),
            ),
            const SizedBox(height: 15),
            Text(
              toSentenceCase(widget.productName),
              textAlign: TextAlign.left,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(fontFamily: 'Gilroy-SemiBold'),
            ),
            Text(
              widget.productWeight.toString(),
              style: const TextStyle(color: Colors.grey),
            ),
            const SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "\u20B9 ${formatPrice(widget.productPrice)}",
                  style: const TextStyle(fontFamily: "Gilroy-medium"),
                ),
                // AddToCartButton(
                //   productName: widget.productName,
                //   productPrice: widget.productPrice,
                //   productImage: widget.imageUrl,
                //   productUnit: widget.productWeight,
                // ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
