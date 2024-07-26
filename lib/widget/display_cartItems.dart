import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/cart_provider.dart';
import 'checkout_add_to_cart_button.dart';

class DisplayCartItems extends StatefulWidget {
  const DisplayCartItems({super.key});

  @override
  State<DisplayCartItems> createState() => _DisplayCartItemsState();
}

class _DisplayCartItemsState extends State<DisplayCartItems> {
  void _showImageDialog(BuildContext context, String imageUrl) {
    final mediaQuery = MediaQuery.of(context);
    showDialog(
      context: context,
      builder: (context) {
        return Dialog(
          backgroundColor: Colors.transparent,
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(15),
              color: Colors.white,
            ),
            padding: const EdgeInsets.all(8),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                CachedNetworkImage(
                  imageUrl: imageUrl,
                  width: mediaQuery.size.width * 0.8,
                  height: mediaQuery.size.height * 0.6,
                  fit: BoxFit.contain,
                ),
                const SizedBox(height: 10),
                ElevatedButton(
                  onPressed: () => Navigator.of(context).pop(),
                  child: const Text('Close'),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<CartProvider>(
      builder: (context, cartProvider, _) {
        return Column(
          children: cartProvider.cart.map((item) {
            return Card(
              color: Colors.white,
              shadowColor: Colors.grey.withOpacity(0.1),
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  children: [
                    GestureDetector(
                      onTap: () => _showImageDialog(context, item.itemImage),
                      child: CachedNetworkImage(
                        imageUrl: item.itemImage,
                        width: 50,
                        height: 50,
                      ),
                    ),
                    const SizedBox(width: 15),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            item.itemName,
                            style: const TextStyle(fontSize: 16),
                          ),
                          Text(
                            item.itemUnit.toString(),
                            style: const TextStyle(color: Colors.grey),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            'Total: ₹${item.itemPrice * item.qnt}',
                            style: const TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 2),
                    Column(
                      children: [
                        CheckoutAddToCartButton(
                          productName: item.itemName,
                          productPrice: item.itemPrice,
                          productImage: item.itemImage,
                          productUnit: item.itemUnit,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            );
          }).toList(),
        );
      },
    );
  }
}
