import 'package:flutter/material.dart';
import '../shared/constants.dart';

class CheckoutTop extends StatelessWidget {
  const CheckoutTop({super.key});

  @override
  Widget build(BuildContext context) {
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
        padding: const EdgeInsets.all(18.0),
        child: Row(
          children: [
            const Icon(Icons.timer),
            const SizedBox(width: 12),
            //Head
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Delivery within $deliveryTime minutes',
                    style: const TextStyle(fontSize: 18, color: Color(0xff1c1c1c), fontFamily: 'Gilroy-ExtraBold'),
                  ),
                  const Text(
                    'Shipment of 1 item',
                    style: TextStyle(fontSize: 12, color: Color(0xff666666)),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
