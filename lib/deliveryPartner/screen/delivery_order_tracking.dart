import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../model/model.dart';

class DeliveryTrackingScreen extends StatefulWidget {
  final String orderId;
  final double orderTotalPrice;
  final List<OrderDetail> order;
  final String paymentMode;
  final String customerAddress;
  final String customerPhone;

  const DeliveryTrackingScreen({
    super.key,
    required this.order,
    required this.orderId,
    required this.orderTotalPrice,
    required this.paymentMode,
    required this.customerAddress,
    required this.customerPhone,
  });

  @override
  State<DeliveryTrackingScreen> createState() => _DeliveryTrackingScreenState();
}

class _DeliveryTrackingScreenState extends State<DeliveryTrackingScreen> {
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
        title: const Text("Order Tracking",
            style: TextStyle(fontSize: 20, color: Colors.black)),
        backgroundColor: Colors.white,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.black),
      ),
      body: StreamBuilder<DocumentSnapshot>(
        stream: _orderStatusStream,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
                child: CircularProgressIndicator(
              color: Colors.black,
            ));
          }

          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }

          if (snapshot.hasData) {
            var orderData = snapshot.data!;
            var status = orderData['status'];

            if (status == 5) {
              return Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(widget.orderId,
                        style: const TextStyle(
                            fontSize: 24, fontWeight: FontWeight.bold)),
                    const SizedBox(height: 20),
                    _buildCustomerDetailsTable(),
                    const SizedBox(height: 20),
                    _buildOrderDetailsTable(),
                    const SizedBox(height: 20),
                    _buildOrderFailedCard(
                        'Order Failed',
                        'Your order has failed due to a transaction issue.',
                        true,
                        Colors.red,
                        Icons.error),
                  ],
                ),
              );
            } else if (status == 6) {
              return Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(widget.orderId,
                        style: const TextStyle(
                            fontSize: 24, fontWeight: FontWeight.bold)),
                    const SizedBox(height: 20),
                    _buildCustomerDetailsTable(),
                    const SizedBox(height: 20),
                    _buildOrderDetailsTable(),
                    const SizedBox(height: 20),
                    _buildOrderStatusCard(
                        'Order Cancelled',
                        'Unfortunately, your order has been cancelled.',
                        true,
                        Colors.red,
                        Icons.cancel),
                  ],
                ),
              );
            } else {
              var statusCards = <Widget>[
                _buildOrderStatusCard('Order Received',
                    'Your order has been received.', status >= 0),
                _buildOrderStatusCard('Order Confirmed',
                    'Your order has been confirmed.', status >= 1),
                _buildOrderStatusCard('Order In Process',
                    'Your order is in process.', status >= 2),
                _buildOrderStatusCard('Order Pickup',
                    'Your order is ready for pickup.', status >= 3),
                _buildOrderStatusCard('Order Delivered',
                    'Your order has been delivered', status >= 4),
              ];

              return Padding(
                padding: const EdgeInsets.all(16.0),
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(widget.orderId,
                          style: const TextStyle(
                              fontSize: 24, fontWeight: FontWeight.bold)),
                      const SizedBox(height: 20),
                      _buildCustomerDetailsTable(),
                      const SizedBox(height: 20),
                      _buildOrderDetailsTable(),
                      const SizedBox(height: 20),
                      Column(children: statusCards),
                    ],
                  ),
                ),
              );
            }
          }

          return const Center(child: Text('No data available'));
        },
      ),
    );
  }

  Widget _buildOrderDetailsTable() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          color: Colors.grey[200],
          padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
          child: const Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text("Items",
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
              Text("Quantity",
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
              Text("Total Price",
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            ],
          ),
        ),
        ListView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: widget.order.length,
          itemBuilder: (context, index) {
            var orderDetail = widget.order[index];
            return Container(
              padding:
                  const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
              decoration: BoxDecoration(
                border: Border(
                  bottom: BorderSide(
                    color: Colors.grey[300]!,
                    width: 1.0,
                  ),
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(orderDetail.productName),
                  Text(orderDetail.quantity.toString()),
                  Text(orderDetail.totalPrice.toString()),
                ],
              ),
            );
          },
        ),
      ],
    );
  }

  Widget _buildCustomerDetailsTable() {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
      decoration: BoxDecoration(
        color: Colors.grey[200],
        borderRadius: BorderRadius.circular(5.0),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text("Customer Details",
              style: TextStyle(fontSize: 20, fontFamily: 'Gilroy-ExtraBold')),
          const SizedBox(height: 8.0),
          Text("Payment Mode: ${widget.paymentMode}",
              style: const TextStyle(
                fontSize: 16,
              )),

          //Amount
          Row(
            children: [
              const Text("Total Amount:",
                  style: TextStyle(
                    fontSize: 16,
                  )),
              Text(widget.orderTotalPrice.toString(),
                  style:
                      const TextStyle(fontSize: 16, fontFamily: 'Gilroy-Bold')),
            ],
          ),
          //Phone
          Row(
            children: [
              const Text("Phone: ",
                  style: TextStyle(
                    fontSize: 16,
                  )),
              const Icon(
                Icons.phone,
                size: 15,
              ),
              Text(widget.customerPhone, style: const TextStyle(fontSize: 16)),
            ],
          ),
          //Address
          // Row(
          //   children: [
          //     const Text("Address: ",
          //         style: TextStyle(
          //           fontSize: 16,
          //         )),
          //
          //     Text(widget.customerAddress,
          //         style:
          //         const TextStyle(fontSize: 16, fontFamily: 'Gilroy-Bold')),
          //   ],
          // ),
          Text("Address: ${widget.customerAddress}",
              style: const TextStyle(
                fontSize: 16,
              )),
        ],
      ),
    );
  }

  Widget _buildOrderStatusCard(String title, String description, bool done,
      [Color color = Colors.green, IconData icon = Icons.check_circle]) {
    return Card(
      color: done ? color : Colors.grey[300],
      child: ListTile(
        leading: Icon(icon, color: done ? Colors.white : Colors.grey),
        title: Text(title,
            style: TextStyle(color: done ? Colors.white : Colors.grey)),
        subtitle: Text(description,
            style: TextStyle(color: done ? Colors.white : Colors.grey)),
      ),
    );
  }

  Widget _buildOrderFailedCard(String title, String description, bool done,
      [Color color = Colors.red, IconData icon = Icons.error]) {
    return Card(
      color: done ? color : Colors.grey[300],
      child: ListTile(
        leading: Icon(icon, color: done ? Colors.white : Colors.grey),
        title: Text(title,
            style: TextStyle(color: done ? Colors.white : Colors.grey)),
        subtitle: Text(description,
            style: TextStyle(color: done ? Colors.white : Colors.grey)),
      ),
    );
  }
}
