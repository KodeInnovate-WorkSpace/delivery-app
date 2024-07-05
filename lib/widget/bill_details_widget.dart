import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dotted_line/dotted_line.dart';
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

    return StreamBuilder<DocumentSnapshot>(
      stream: constantDocumentStream,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const CircularProgressIndicator(
            color: Colors.black,
          );
        } else if (snapshot.hasError) {
          return Text('Error: ${snapshot.error}');
        } else if (!snapshot.hasData || !snapshot.data!.exists) {
          return const Text('No data available');
        } else {
          var data = snapshot.data!.data() as Map<String, dynamic>;
          double deliveryCharge = (data['deliveryCharge'] ?? 29).toDouble();
          // double handlingCharge = (data['handlingCharge'] ?? 1.85).toDouble();
          return Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(10), // Adjust the radius as needed
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.1), // Shadow color
                  spreadRadius: 2, // Spread radius
                  blurRadius: 5, // Blur radius
                  offset: const Offset(0, 2), // Shadow offset (x, y)
                ),
              ],
            ),
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Text('Bill details', style: TextStyle(fontSize: 18, fontFamily: 'Gilroy-Black')),
                  ),
                  // Row 1: Item total
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
                  // Row 2: Delivery Charge
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
                          '\u{20B9}${deliveryCharge.toStringAsFixed(0)}',
                          style: const TextStyle(fontSize: 14),
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 8),
                  // Row 3: Handling Charges
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Row(
                        children: [
                          Icon(Icons.payment, size: 14),
                          SizedBox(width: 4),
                          // Text('Handling Charges', style: TextStyle(fontSize: 14)),

                          Text('Handling Charges', style: TextStyle(fontSize: 14)),
                        ],
                      ),
                      Align(
                        alignment: Alignment.centerRight,
                        child: Text(
                          // '\u{20B9}${handlingCharge.toStringAsFixed(2)}',
                          '\u{20B9}${cartProvider.calculateHandlingCharge()}',
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
                            '- \u{20B9}${cartProvider.Discount.toStringAsFixed(2)}',
                            style: const TextStyle(fontSize: 14),
                          ),
                        ),
                      ],
                    ),
                  // const Divider(),
                  const SizedBox(
                    height: 20,
                  ),

                  const DottedLine(
                    dashLength: 3,
                    dashGapLength: 2,
                    lineThickness: 3,
                    dashColor: Color(0xff666666),
                    dashRadius: 20,
                  ),

                  const SizedBox(
                    height: 10,
                  ),
                  // Grand Total Row
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text('To pay', style: TextStyle(fontSize: 16, fontFamily: 'Gilroy-Black')),
                      Text(
                        // '\u{20B9}${cartProvider.calculateGrandTotal().toStringAsFixed(2)}',
                        '\u{20B9}${cartProvider.calculateGrandTotal()}',

                        style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.black),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          );
        }
      },
    );
  }
}
