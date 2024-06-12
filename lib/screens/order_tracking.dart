import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class OrderTrackingScreen extends StatefulWidget {
  final String orderId;

  const OrderTrackingScreen({required this.orderId, super.key});

  @override
  _OrderTrackingScreenState createState() => _OrderTrackingScreenState();
}

class _OrderTrackingScreenState extends State<OrderTrackingScreen> {
  int _currentStatus = 1; // Adjusted initial value to 1
  late Stream<DocumentSnapshot> _orderStatusStream;

  @override
  void initState() {
    super.initState();
    _orderStatusStream = FirebaseFirestore.instance
        .collection('Extras')
        .doc(widget.orderId)
        .snapshots();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Order Tracking'),
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
            _currentStatus =
                orderData['status']; // Assuming 'status' field is an int

            // Ensure _currentStatus is within the valid range
            _currentStatus = _currentStatus.clamp(1, 5);

            return Column(
              children: [
                Expanded(
                  child: Stepper(
                    currentStep: _currentStatus - 1, // Adjust for 0-based index
                    steps: [
                      Step(
                        title: const Text('Order Confirmed'),
                        content: const Text('Your order has been confirmed.'),
                        isActive: _currentStatus >= 1,
                      ),
                      Step(
                        title: const Text('Order in Process'),
                        content: const Text('Your order is being processed.'),
                        isActive: _currentStatus >= 2,
                      ),
                      Step(
                        title: const Text('Order Pickup'),
                        content: const Text('Your order is ready for pickup.'),
                        isActive: _currentStatus >= 3,
                      ),
                      Step(
                        title: const Text('Order Delivered'),
                        content: const Text('Your order has been delivered.'),
                        isActive: _currentStatus >= 4,
                      ),
                      Step(
                        title: const Text('Order Received'),
                        content: const Text('You have received your order.'),
                        isActive: _currentStatus >= 5,
                      ),
                    ],
                  ),
                ),
              ],
            );
          }

          return const Center(child: Text('No data available'));
        },
      ),
    );
  }
}
