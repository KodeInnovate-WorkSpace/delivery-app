import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../providers/cart_provider.dart';
import 'checkout_add_to_cart_button.dart';

class DisplayCartItems extends StatefulWidget {
  const DisplayCartItems({super.key});

  @override
  State<DisplayCartItems> createState() => _DisplayCartItemsState();
}

class _DisplayCartItemsState extends State<DisplayCartItems> {
  Map<String, bool> _isVegMap = {};

  @override
  void initState() {
    super.initState();
    _fetchProductData();
  }

  Future<void> _fetchProductData() async {
    final firestore = FirebaseFirestore.instance;
    final productsSnapshot = await firestore.collection('products').get();

    final isVegMap = <String, bool>{};
    for (var doc in productsSnapshot.docs) {
      final data = doc.data();
      final isVeg = data['isVeg'] ?? false; // Default to false if not present
      final name = data['name']; // Assuming you have a 'name' field for products
      isVegMap[name] = isVeg;
    }

    setState(() {
      _isVegMap = isVegMap;
    });
  }

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
            final isVeg = _isVegMap[item.itemName] ?? false;

            return Stack(
              children: [
                Card(
                  color: Colors.white,
                  shadowColor: Colors.grey.withOpacity(0.1),
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      children: [
                        if (item.itemImage.isNotEmpty) ...[
                          GestureDetector(
                            onTap: () => _showImageDialog(context, item.itemImage),
                            child: CachedNetworkImage(
                              imageUrl: item.itemImage,
                              width: 50,
                              height: 50,
                            ),
                          ),
                          const SizedBox(width: 15),
                        ],
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
                            const SizedBox(height: 16), // Adjust this value to move the button further down
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
                ),
                if (isVeg)
                  Positioned(
                    top: 8,
                    right: 8,
                    child: Container(
                      width: 24,
                      height: 24,
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.green, width: 2),
                        color: Colors.white,
                      ),
                      child: Center(
                        child: Container(
                          width: 16,
                          height: 16,
                          decoration: const BoxDecoration(
                            shape: BoxShape.circle,
                            color: Colors.green,
                          ),
                          child: const Icon(Icons.circle, color: Colors.green, size: 12),
                        ),
                      ),
                    ),
                  ),
              ],
            );
          }).toList(),
        );
      },
    );
  }
}
