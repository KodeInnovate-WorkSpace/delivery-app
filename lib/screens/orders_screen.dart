import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:cloud_firestore/cloud_firestore.dart'; // Import Firestore
import '../providers/order_provider.dart';

class OrderHistoryScreen extends StatefulWidget {
  const OrderHistoryScreen({super.key});

  @override
  State<OrderHistoryScreen> createState() => _OrderHistoryScreenState();
}

class _OrderHistoryScreenState extends State<OrderHistoryScreen> {
  // Flag to track whether order data has been stored in Firestore
  bool _isOrderDataStored = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!_isOrderDataStored) {
      // Accessing the provider inside didChangeDependencies
      final orderProvider = Provider.of<OrderProvider>(context);
      if (orderProvider.orders.isNotEmpty) {
        final order = orderProvider.orders[0]; // Assuming orders is not empty
        // Save order to Firestore
        FirebaseFirestore.instance.collection('OrderHistory').add({
          'orderId': order.orderId,
          'productName': order.productName,
          'productImage': order.productImage,
          'price': order.price,
          'quantity': order.quantity,
          'address': order.address,
          'paymentMode': order.paymentMode,
          'transactionId': order.transactionId,
          'userId': order.userId,
        });
        // Set flag to true to indicate order data has been stored
        setState(() {
          _isOrderDataStored = true;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final orderProvider = Provider.of<OrderProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Order History'),
      ),
      body: orderProvider.orders.isEmpty
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.asset(
                    'assets/images/dog.png',
                    height: 200,
                  ),
                  const SizedBox(height: 20),
                  Text(
                    'Oops, you haven’t placed an order yet',
                    style: TextStyle(
                      fontSize: 18,
                      color: Colors.grey[600],
                    ),
                  ),
                ],
              ),
            )
          : ListView.builder(
              itemCount: orderProvider.orders.length,
              itemBuilder: (context, index) {
                final order = orderProvider.orders[index];
                bool isNewOrder = index == 0 ||
                    order.orderId != orderProvider.orders[index - 1].orderId;

                return Card(
                  color: const Color(0xffeaf1fc),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      if (isNewOrder)
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text('Order ID: ${order.orderId}'),
                        ),
                      ListTile(
                        leading: CircleAvatar(
                          backgroundImage: NetworkImage(order.productImage),
                        ),
                        title: Text(order.productName),
                        subtitle: Text(
                            'Price: ₹${order.price}, Quantity: ${order.quantity}'),
                        trailing: IconButton(
                          icon: const Icon(Icons.delete),
                          onPressed: () {
                            orderProvider.deleteOrder(order);
                          },
                        ),
                      ),
                      if (isNewOrder && order.paymentMode == 'Cash')
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16.0),
                          child: Text('Address: ${order.address}'),
                        ),
                      if (isNewOrder && order.paymentMode == 'Bank')
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('Address: ${order.address}'),
                              Text('Transaction ID: ${order.transactionId}'),
                              Text('User ID: ${order.userId}'),
                            ],
                          ),
                        ),
                    ],
                  ),
                );
              },
            ),
    );
  }
}
