import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/cart_provider.dart';
import '../shared/constants.dart';

class BillDetails extends StatefulWidget {
  const BillDetails({super.key});

  @override
  State<BillDetails> createState() => _BillDetailsState();
}

class _BillDetailsState extends State<BillDetails> {
  @override
  Widget build(BuildContext context) {
    final cartProvider = Provider.of<CartProvider>(context);
    return Card(
      elevation: 0,
      color: Colors.white,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Padding(
              padding: EdgeInsets.all(8.0),
              child: Text('Bill details',
                  style: TextStyle(fontSize: 18, fontFamily: 'Gilroy-Black')),
            ),
            // const Divider(),
            // Row 1
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Row(
                  children: [
                    Icon(Icons.receipt_long, size: 14),
                    SizedBox(width: 4),
                    Text('Item total', style: TextStyle(fontSize: 14)),
                  ],
                ),
                Align(
                  alignment: Alignment.centerRight,
                  child: Text(
                    '\u{20B9}${cartProvider.calculateTotalPrice().toStringAsFixed(0)}',
                    style: const TextStyle(fontSize: 14),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            // Row 2
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Row(
                  children: [
                    Icon(Icons.local_shipping, size: 14),
                    SizedBox(width: 4),
                    Text('Delivery Charge', style: TextStyle(fontSize: 14)),
                  ],
                ),
                Align(
                  alignment: Alignment.centerRight,
                  child: Text(
                    '\u{20B9}${deliveryCharge!.toStringAsFixed(0)}',
                    style: const TextStyle(fontSize: 14),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            // Row 3
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Row(
                  children: [
                    Icon(Icons.payment, size: 14),
                    SizedBox(width: 4),
                    Text('Handling Charges', style: TextStyle(fontSize: 14)),
                  ],
                ),
                Align(
                  alignment: Alignment.centerRight,
                  child: Text(
                    '\u{20B9}${handlingCharge!.toStringAsFixed(2)}',
                    style: const TextStyle(fontSize: 14),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            // Discount Row
            if (cartProvider.Discount > 0)
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Row(
                    children: [
                      Icon(Icons.local_offer, size: 14),
                      SizedBox(width: 4),
                      Text('Discount', style: TextStyle(fontSize: 14)),
                    ],
                  ),
                  Align(
                    alignment: Alignment.centerRight,
                    child: Text(
                      '- Rs.${cartProvider.Discount.toStringAsFixed(2)}',
                      style: const TextStyle(fontSize: 14),
                    ),
                  ),
                ],
              ),
            const Divider(),
            // Grand Total Row
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text('To pay',
                    style: TextStyle(fontSize: 16, fontFamily: 'Gilroy-Black')),
                Text(
                  '\u{20B9}${cartProvider.calculateGrandTotal().toStringAsFixed(2)}',
                  style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.black),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
