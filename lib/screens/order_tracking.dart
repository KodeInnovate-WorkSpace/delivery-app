import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class OrderTrackingScreen extends StatefulWidget {
  final String orderId;

  const OrderTrackingScreen({required this.orderId, super.key});

  @override
  State<OrderTrackingScreen> createState() => _OrderTrackingScreenState();
}

class _OrderTrackingScreenState extends State<OrderTrackingScreen> {
  late Stream<DocumentSnapshot> _orderStatusStream;

  @override
  void initState() {
    super.initState();
    _orderStatusStream = FirebaseFirestore.instance
        .collection('OrderHistory')
        .doc(widget.orderId)
        .snapshots();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Order Tracking',
          style: TextStyle(color: Colors.black),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.black),
      ),
      body: StreamBuilder<DocumentSnapshot>(
        stream: _orderStatusStream,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }

          if (snapshot.hasData) {
            var orderData = snapshot.data!;
            var status =
                orderData['status']; // Assuming 'status' field is an int

            // Build a list of order status cards
            var statusCards = <Widget>[
              _buildOrderStatusCard('Order Confirmed',
                  'Your order has been confirmed.', status >= 1),
              _buildOrderStatusCard('Order in Process',
                  'Your order is being processed.', status >= 2),
              _buildOrderStatusCard('Order Pickup',
                  'Your order is ready for pickup.', status >= 3),
              _buildOrderStatusCard('Order Delivered',
                  'Your order has been delivered.', status >= 4),
              _buildOrderStatusCard('Order Received',
                  'You have received your order.', status >= 5),
            ];

            if(status == 6){
              return const Text("Order Failed");
            }else{

              return Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Order Status',
                      style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                    ),
                    Text(
                      widget.orderId,
                      style: const TextStyle(
                          fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 20),
                    Column(
                      children: statusCards,
                    ),
                  ],
                ),
              );
            }

          }

          return const Center(child: Text('No data available'));
        },
      ),
    );
  }

  Widget _buildOrderStatusCard(
      String title, String description, bool isActive) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8.0),
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: isActive
            ? Colors.green.withOpacity(0.1)
            : Colors.grey.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12.0),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                isActive ? Icons.check_circle : Icons.radio_button_unchecked,
                color: isActive ? Colors.green : Colors.grey,
              ),
              const SizedBox(width: 16.0),
              Text(
                title,
                style: const TextStyle(
                    fontSize: 18.0, fontWeight: FontWeight.bold),
              ),
            ],
          ),
          const SizedBox(height: 8.0),
          Text(
            description,
            style: const TextStyle(fontSize: 16.0, color: Colors.black54),
          ),
        ],
      ),
    );
  }
}
