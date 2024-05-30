import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:speedy_delivery/providers/cart_provider.dart';

class CheckoutScreen extends StatelessWidget {
  const CheckoutScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final cartProvider = Provider.of<CartProvider>(context);

    return Scaffold(
      resizeToAvoidBottomInset:
          true, // Enable auto-resizing when keyboard appears
      appBar: AppBar(
        title: const Text('Checkout'),
      ),
      body: Container(
        color: Colors.grey[100], // Set the background color to grey
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Delivery information
                const Card(
                  elevation: 0,
                  color: Colors.white, // Set the card color to white
                  child: Padding(
                    padding: EdgeInsets.all(18.0),
                    child: Row(
                      children: [
                        Icon(Icons.timer),
                        SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Delivery in 7 minutes',
                                style: TextStyle(
                                    fontSize: 18,
                                    fontFamily: 'Gilroy-ExtraBold'),
                              ),
                              Text(
                                'Shipment of 1 item',
                                style:
                                    TextStyle(fontSize: 12, color: Colors.grey),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                // title end
                const SizedBox(height: 10),
                // Display cart items

                if (cartProvider.cart.isEmpty)
                  Center(
                    child: Column(children: [
                      Image.asset("assets/images/empty.png"),
                      const Text(
                        "No item in cart",
                        style: TextStyle(fontSize: 20),
                      ),
                    ]),
                  ),

                if (cartProvider.cart.isNotEmpty)
                  ...cartProvider.cart.map((item) {
                    return Card(
                      elevation: 0,
                      color: Colors.white,
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Row(
                          children: [
                            Image.network(
                              item.itemImage,
                              width: 50,
                              height: 50,
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
                                Container(
                                  // height: 35,
                                  // width: 75,
                                  decoration: BoxDecoration(
                                    color: Colors.green,
                                    borderRadius: BorderRadius.circular(5),
                                  ),
                                  child: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      IconButton(
                                        icon: const Icon(Icons.remove,
                                            size: 15, color: Colors.white),
                                        onPressed: () {
                                          cartProvider.removeItem(item);
                                        },
                                      ),
                                      Text(
                                        '${item.qnt}',
                                        style: const TextStyle(
                                          color: Colors.white,
                                          fontFamily: 'Gilroy-SemiBold',
                                        ),
                                      ),
                                      IconButton(
                                        icon: const Icon(Icons.add,
                                            size: 15, color: Colors.white),
                                        onPressed: () {
                                          cartProvider.addItem(item);
                                        },
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    );
                  }),
                // spacing
                const SizedBox(height: 10),
                // Bill details
                const SizedBox(height: 10),
                Card(
                  color: Colors.white, // Set the card color to white
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text('Bill details',
                            style: TextStyle(
                                fontSize: 18, fontFamily: 'Gilroy-Black')),
                        // Row 1
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Row(
                              children: [
                                Icon(
                                  Icons.receipt_long,
                                  size: 14,
                                ),
                                SizedBox(width: 4),
                                Text('Item total',
                                    style: TextStyle(fontSize: 14)),
                              ],
                            ),
                            Align(
                              alignment: Alignment.centerRight,
                              child: Text(
                                '\u20B9 ${cartProvider.calculateTotalPrice()}',
                                style: const TextStyle(fontSize: 14),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 4),
                        // Row 2
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Row(
                              children: [
                                Icon(
                                  Icons.sports_motorsports,
                                  size: 14,
                                ),
                                SizedBox(width: 4),
                                Text('Delivery Charge',
                                    style: TextStyle(fontSize: 14)),
                              ],
                            ),
                            Align(
                              alignment: Alignment.centerRight,
                              child: Text(
                                  '\u20B9 ${cartProvider.deliveryCharge}',
                                  style: const TextStyle(fontSize: 14)),
                            ),
                          ],
                        ),
                        const SizedBox(height: 4),
                        // Row 3
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Row(
                              children: [
                                Icon(
                                  Icons.shopping_bag,
                                  size: 14,
                                ),
                                SizedBox(width: 4),
                                Text('Handling Charge',
                                    style: TextStyle(fontSize: 14)),
                              ],
                            ),
                            Align(
                              alignment: Alignment.centerRight,
                              child: Text(
                                  '\u20B9 ${cartProvider.handlingCharge}',
                                  style: const TextStyle(fontSize: 14)),
                            ),
                          ],
                        ),
                        const SizedBox(height: 4),
                        // Row 4
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text('Grand total',
                                style: TextStyle(
                                    fontSize: 16, fontFamily: 'Gilroy-Medium')),
                            Text('\u20B9 ${cartProvider.calculateGrandTotal()}',
                                style: const TextStyle(
                                    fontSize: 16, fontFamily: 'Gilroy-Medium')),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
