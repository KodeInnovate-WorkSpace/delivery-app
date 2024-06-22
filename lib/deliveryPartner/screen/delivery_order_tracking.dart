// import 'package:flutter/material.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
//
// import '../model/model.dart';
//
// class DeliveryTrackingScreen extends StatefulWidget {
//   final String orderId;
//   final double orderTotalPrice;
//   final List<OrderDetail> order;
//   final String paymentMode;
//   final String customerAddress;
//   final String customerPhone;
//   const DeliveryTrackingScreen({
//     super.key,
//     required this.order,
//     required this.orderId,
//     required this.orderTotalPrice,
//     required this.paymentMode,
//     required this.customerAddress,
//     required this.customerPhone,
//   });
//
//   @override
//   State<DeliveryTrackingScreen> createState() => _DeliveryTrackingScreenState();
// }
//
// class _DeliveryTrackingScreenState extends State<DeliveryTrackingScreen> {
//   late Stream<DocumentSnapshot> _orderStatusStream;
//
//   @override
//   void initState() {
//     super.initState();
//     _orderStatusStream = FirebaseFirestore.instance
//         .collection('OrderHistory')
//         .doc(widget.orderId)
//         .snapshots();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('Order Tracking',
//             style: TextStyle(fontSize: 20, color: Colors.black)),
//         backgroundColor: Colors.white,
//         elevation: 0,
//         iconTheme: const IconThemeData(color: Colors.black),
//       ),
//       body: StreamBuilder<DocumentSnapshot>(
//         stream: _orderStatusStream,
//         builder: (context, snapshot) {
//           if (snapshot.connectionState == ConnectionState.waiting) {
//             return const Center(child: CircularProgressIndicator());
//           }
//
//           if (snapshot.hasError) {
//             return Center(child: Text('Error: ${snapshot.error}'));
//           }
//
//           if (snapshot.hasData) {
//             var orderData = snapshot.data!;
//             var status = orderData['status'];
//
//             if (status == 5) {
//               return Padding(
//                 padding: const EdgeInsets.all(16.0),
//                 child: Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     Text(widget.orderId,
//                         style: const TextStyle(
//                             fontSize: 24, fontWeight: FontWeight.bold)),
//                     const SizedBox(height: 20),
//                     _buildOrderFailedCard(
//                         'Order Failed',
//                         'Your order has failed due to a transaction issue.',
//                         true,
//                         Colors.red,
//                         Icons.error),
//                   ],
//                 ),
//               );
//             } else if (status == 6) {
//               return Padding(
//                 padding: const EdgeInsets.all(16.0),
//                 child: Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     Text(widget.orderId,
//                         style: const TextStyle(
//                             fontSize: 24, fontWeight: FontWeight.bold)),
//                     const SizedBox(height: 20),
//                     _buildOrderStatusCard(
//                         'Order Cancelled',
//                         'Unfortunately, your order has been cancelled.',
//                         true,
//                         Colors.red,
//                         Icons.cancel),
//                   ],
//                 ),
//               );
//             } else {
//               var statusCards = <Widget>[
//                 _buildOrderStatusCard('Order Received',
//                     'Your order has been received.', status >= 0),
//                 _buildOrderStatusCard('Order Confirmed',
//                     'Your order has been confirmed.', status >= 1),
//                 _buildOrderStatusCard('Order In Process',
//                     'Your order is in process.', status >= 2),
//                 _buildOrderStatusCard('Order Pickup',
//                     'Your order is ready for pickup.', status >= 3),
//                 _buildOrderStatusCard('Order Delivered',
//                     'You order has been delivered', status >= 4),
//               ];
//
//               final itemName = widget.order
//                   .map((ord) => "${ord.productName} x ${ord.quantity}")
//                   .join(', ');
//
//               // final itemName = widget.order.map((ord) => ord.productName);
//               // final itemQnt = widget.order.map((ord) => ord.quantity);
//
//               return Padding(
//                 padding: const EdgeInsets.all(16.0),
//                 child: Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     Text(widget.orderId,
//                         style: const TextStyle(
//                             fontSize: 24, fontWeight: FontWeight.bold)),
//
//                     Row(
//                       mainAxisAlignment: MainAxisAlignment.center,
//                       children: [
//                         Column(
//                           children: [
//                             const Text("Items",
//                                 style: TextStyle(
//                                     fontSize: 16, fontWeight: FontWeight.bold)),
//                             Text(itemName,
//                                 style: const TextStyle(
//                                     fontSize: 16, fontWeight: FontWeight.bold)),
//                           ],
//                         ),
//                         const SizedBox(
//                           width: 35,
//                         ),
//                         Column(
//                           children: [
//                             const Text("Total Price",
//                                 style: TextStyle(
//                                     fontSize: 16, fontWeight: FontWeight.bold)),
//                             Text("${widget.orderTotalPrice}",
//                                 style: const TextStyle(
//                                     fontSize: 16, fontWeight: FontWeight.bold)),
//                           ],
//                         ),
//                       ],
//                     ),
//
//                     //Payment Mode | Price
//                     Text(
//                         "Payment Mode: ${widget.paymentMode} | Price: ${widget.orderTotalPrice}",
//                         style: const TextStyle(
//                             fontSize: 16, fontWeight: FontWeight.bold)),
//
//                     //Address
//                     Text("Address: ${widget.customerAddress}",
//                         style: const TextStyle(
//                             fontSize: 16, fontWeight: FontWeight.bold)),
//
//                     //Customer Phone Number
//                     Text("Phone: ${widget.customerPhone}",
//                         style: const TextStyle(
//                             fontSize: 16, fontWeight: FontWeight.bold)),
//
//                     const SizedBox(height: 20),
//                     Column(children: statusCards),
//                   ],
//                 ),
//               );
//             }
//           }
//
//           return const Center(child: Text('No data available'));
//         },
//       ),
//     );
//   }
//
//   Widget _buildOrderStatusCard(String title, String description, bool isActive,
//       [Color color = Colors.green, IconData icon = Icons.check_circle]) {
//     return Container(
//       margin: const EdgeInsets.symmetric(vertical: 8.0),
//       padding: const EdgeInsets.all(16.0),
//       decoration: BoxDecoration(
//         color: isActive ? color.withOpacity(0.1) : Colors.grey.withOpacity(0.1),
//         borderRadius: BorderRadius.circular(12.0),
//       ),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           Row(
//             children: [
//               Icon(isActive ? icon : Icons.radio_button_unchecked,
//                   color: isActive ? color : Colors.grey),
//               const SizedBox(width: 16.0),
//               Text(title,
//                   style: TextStyle(
//                       fontSize: 18.0,
//                       fontWeight: FontWeight.bold,
//                       color: isActive ? color : Colors.black)),
//             ],
//           ),
//           const SizedBox(height: 8.0),
//           Text(description,
//               style: const TextStyle(fontSize: 16.0, color: Colors.black54)),
//         ],
//       ),
//     );
//   }
//
//   Widget _buildOrderFailedCard(String title, String description, bool isActive,
//       [Color color = Colors.red, IconData icon = Icons.error]) {
//     return Container(
//       margin: const EdgeInsets.symmetric(vertical: 8.0),
//       padding: const EdgeInsets.all(16.0),
//       decoration: BoxDecoration(
//         color: isActive ? color.withOpacity(0.1) : Colors.grey.withOpacity(0.1),
//         borderRadius: BorderRadius.circular(12.0),
//       ),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           Row(
//             children: [
//               Icon(isActive ? icon : Icons.radio_button_unchecked,
//                   color: isActive ? color : Colors.grey),
//               const SizedBox(width: 16.0),
//               Text(title,
//                   style: TextStyle(
//                       fontSize: 18.0,
//                       fontWeight: FontWeight.bold,
//                       color: isActive ? color : Colors.black)),
//             ],
//           ),
//           const SizedBox(height: 8.0),
//           Text(description,
//               style: const TextStyle(fontSize: 16.0, color: Colors.black54)),
//         ],
//       ),
//     );
//   }
// }

//New Code
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
        title: const Text('Order Tracking',
            style: TextStyle(fontSize: 20, color: Colors.black)),
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
                    'You order has been delivered', status >= 4),
              ];

              return Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(widget.orderId,
                        style: const TextStyle(
                            fontSize: 24, fontWeight: FontWeight.bold)),
                    const SizedBox(height: 20),
                    _buildOrderDetailsTable(),
                    _buildCustomerDetailsTable(),
                    const SizedBox(height: 20),
                    // Text(
                    //     "Payment Mode: ${widget.paymentMode} | Price: ${widget.orderTotalPrice}",
                    //     style: const TextStyle(
                    //         fontSize: 16, fontWeight: FontWeight.bold)),
                    // Text("Address: ${widget.customerAddress}",
                    //     style: const TextStyle(
                    //         fontSize: 16, fontWeight: FontWeight.bold)),
                    // Text("Phone: ${widget.customerPhone}",
                    //     style: const TextStyle(
                    //         fontSize: 16, fontWeight: FontWeight.bold)),
                    const SizedBox(height: 20),
                    Column(children: statusCards),
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
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(orderDetail.productName,
                      style: const TextStyle(fontSize: 16)),
                  Text(orderDetail.quantity.toString(),
                      style: const TextStyle(fontSize: 16)),
                  Text(
                      (orderDetail.quantity * orderDetail.price)
                          .toStringAsFixed(2),
                      style: const TextStyle(fontSize: 16)),
                ],
              ),
            );
          },
        ),
        Container(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text("Total Price",
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
              Text("₹${widget.orderTotalPrice.toStringAsFixed(2)}",
                  style: const TextStyle(
                      fontSize: 16, fontWeight: FontWeight.bold)),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildCustomerDetailsTable() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          color: Colors.grey[200],
          padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
          child: const Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text("Payment Mode",
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
              Text("Address",
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
              Text("Phone No.",
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            ],
          ),
        ),
        ListView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemBuilder: (context, index) {
            return Container(
              padding:
                  const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(widget.customerAddress,
                      style: const TextStyle(fontSize: 16)),
                  Text(widget.paymentMode,
                      style: const TextStyle(fontSize: 16)),
                  Text(widget.customerPhone,
                      style: const TextStyle(fontSize: 16)),
                ],
              ),
            );
          },
        ),
      ],
    );
  }

  Widget _buildOrderStatusCard(String title, String description, bool isActive,
      [Color color = Colors.green, IconData icon = Icons.check_circle]) {
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
              Icon(isActive ? icon : Icons.radio_button_unchecked,
                  color: isActive ? color : Colors.grey),
              const SizedBox(width: 16.0),
              Text(title,
                  style: TextStyle(
                      fontSize: 18.0,
                      fontWeight: FontWeight.bold,
                      color: isActive ? color : Colors.black)),
            ],
          ),
          const SizedBox(height: 8.0),
          Text(description,
              style: const TextStyle(fontSize: 16.0, color: Colors.black54)),
        ],
      ),
    );
  }

  Widget _buildOrderFailedCard(String title, String description, bool isActive,
      [Color color = Colors.red, IconData icon = Icons.error]) {
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
              Icon(isActive ? icon : Icons.radio_button_unchecked,
                  color: isActive ? color : Colors.grey),
              const SizedBox(width: 16.0),
              Text(title,
                  style: TextStyle(
                      fontSize: 18.0,
                      fontWeight: FontWeight.bold,
                      color: isActive ? color : Colors.black)),
            ],
          ),
          const SizedBox(height: 8.0),
          Text(description,
              style: const TextStyle(fontSize: 16.0, color: Colors.black54)),
        ],
      ),
    );
  }
}
