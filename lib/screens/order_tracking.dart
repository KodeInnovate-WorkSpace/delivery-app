import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:provider/provider.dart';
import 'package:speedy_delivery/providers/valet_provider.dart';

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
    _orderStatusStream = FirebaseFirestore.instance.collection('OrderHistory').doc(widget.orderId).snapshots();
  }

  @override
  Widget build(BuildContext context) {
    final valetProvider = Provider.of<ValetProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.orderId, style: const TextStyle(fontSize: 20, color: Colors.black)),
        backgroundColor: Colors.white,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.black),
      ),
      body: SingleChildScrollView(
        child: StreamBuilder<DocumentSnapshot>(
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
              var status = orderData['status'];
              var paymentMode = orderData['paymentMode'];

              if (status == 7) {
                status = 5;
              }

              if (status == 5) {
                return Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text('Order Status', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
                      const SizedBox(height: 20),
                      _buildOrderFailedCard('Order Failed', 'Your order has failed due to a transaction issue.', true, Colors.red, Icons.error),
                    ],
                  ),
                );
              } else if (status == 6) {
                return Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text('Order Status', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
                      const SizedBox(height: 20),
                      _buildOrderCancelledCard('Order Cancelled', paymentMode == 'Online' ? 'Currently we can\'t find available stock for ordered products. (You will get a refund up to 3 working days for more details contact us)' : 'Currently we can\'t find available stock for ordered products. Unfortunately, your order has been cancelled.', true, Colors.red, Icons.cancel),
                    ],
                  ),
                );
              } else {
                var statusCards = <Widget>[
                  _buildOrderStatusCard('Order Received', 'Your order has been received.', status >= 0),
                  _buildOrderStatusCard('Order Confirmed', 'Your order has been confirmed.', status >= 1),
                  _buildOrderStatusCard('Order In Process', 'Your order is in process.', status >= 2),
                  _buildOrderStatusCard('Order Pickup', 'Your order is ready for pickup.', status >= 3),
                  _buildOrderStatusCard('Order Delivered', 'Your order has been delivered', status >= 4),
                  // _buildOrderStatusCard('Order Delivered', 'Your order has been delivered', status >= 7),
                ];

                return Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text('Order Status', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
                      const SizedBox(height: 20),
                      valetProvider.buildValetDetailsTable(widget.orderId),
                      Column(children: statusCards),
                    ],
                  ),
                );
              }
            }

            return const Center(child: Text('No data available'));
          },
        ),
      ),
    );
  }

  Widget _buildOrderStatusCard(String title, String description, bool isActive, [Color color = Colors.green, IconData icon = Icons.check_circle]) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8.0),
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: isActive ? color.withOpacity(0.1) : Colors.grey.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12.0),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(isActive ? icon : Icons.radio_button_unchecked, color: isActive ? color : Colors.grey),
              const SizedBox(width: 16.0),
              Text(title, style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold, color: isActive ? color : Colors.black)),
            ],
          ),
          const SizedBox(height: 8.0),
          Text(description, style: const TextStyle(fontSize: 16.0, color: Colors.black54)),
        ],
      ),
    );
  }

  Widget _buildOrderCancelledCard(String title, String description, bool isActive, [Color color = Colors.red, IconData icon = Icons.cancel]) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8.0),
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: isActive ? color.withOpacity(0.1) : Colors.grey.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12.0),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(isActive ? icon : Icons.radio_button_unchecked, color: isActive ? color : Colors.grey),
              const SizedBox(width: 16.0),
              Text(title, style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold, color: isActive ? color : Colors.black)),
            ],
          ),
          const SizedBox(height: 8.0),
          Text(description, style: const TextStyle(fontSize: 16.0, color: Colors.black54)),
        ],
      ),
    );
  }

  Widget _buildOrderFailedCard(String title, String description, bool isActive, [Color color = Colors.red, IconData icon = Icons.error]) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8.0),
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: isActive ? color.withOpacity(0.1) : Colors.grey.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12.0),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(isActive ? icon : Icons.radio_button_unchecked, color: isActive ? color : Colors.grey),
              const SizedBox(width: 16.0),
              Text(title, style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold, color: isActive ? color : Colors.black)),
            ],
          ),
          const SizedBox(height: 8.0),
          Text(description, style: const TextStyle(fontSize: 16.0, color: Colors.black54)),
        ],
      ),
    );
  }
}
