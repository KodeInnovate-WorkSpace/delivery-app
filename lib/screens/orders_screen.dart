// import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';
// import '../providers/order_provider.dart';
//
// class OrderHistoryScreen extends StatefulWidget {
//   const OrderHistoryScreen({super.key});
//
//   @override
//   State<OrderHistoryScreen> createState() => _OrderHistoryScreenState();
// }
//
// class _OrderHistoryScreenState extends State<OrderHistoryScreen> {
//   @override
//   Widget build(BuildContext context) {
//     final orderProvider = Provider.of<OrderProvider>(context);
//
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('Order History'),
//       ),
//       body: orderProvider.orders.isEmpty
//           ? Center(
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             Image.asset(
//               'assets/images/dog.png',
//               height: 200,
//             ),
//             const SizedBox(height: 20),
//             Text(
//               'Oops, you haven’t placed an order yet',
//               style: TextStyle(
//                 fontSize: 18,
//                 color: Colors.grey[600],
//               ),
//             ),
//           ],
//         ),
//       )
//           : ListView.builder(
//         itemCount: orderProvider.orders.length,
//         itemBuilder: (context, index) {
//           final order = orderProvider.orders[index];
//           bool isNewOrder = index == 0 ||
//               order.orderId != orderProvider.orders[index - 1].orderId;
//
//           return InkWell(
//             onTap: () {
//               Navigator.push(
//                 context,
//                 MaterialPageRoute(
//                   builder: (context) => const OrderTrackingScreen(),
//                 ),
//               );
//             },
//             child: Card(
//               color: const Color(0xffeaf1fc),
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   if (isNewOrder)
//                     Padding(
//                       padding: const EdgeInsets.all(8.0),
//                       child: Text('Order ID: ${order.orderId}'),
//                     ),
//                   ListTile(
//                     leading: CircleAvatar(
//                       backgroundImage: NetworkImage(order.productImage),
//                     ),
//                     title: Text(order.productName),
//                     subtitle: Text(
//                         'Price: ₹${order.price}, Quantity: ${order.quantity}, Total Price: ₹${order.totalPrice}'),
//                     trailing: IconButton(
//                       icon: const Icon(Icons.delete),
//                       onPressed: () async {
//                         setState(() {
//                           orderProvider.deleteOrder(order);
//                         });
//                       },
//                     ),
//                   ),
//                   if (isNewOrder && order.paymentMode == 'Cash')
//                     Padding(
//                       padding:
//                       const EdgeInsets.symmetric(horizontal: 16.0),
//                       child: Flexible(
//                         child: Text('Address: ${order.address}'),
//                       ),
//                     ),
//                   if (isNewOrder && order.paymentMode == 'Bank')
//                     Padding(
//                       padding:
//                       const EdgeInsets.symmetric(horizontal: 16.0),
//                       child: Column(
//                         crossAxisAlignment: CrossAxisAlignment.start,
//                         children: [
//                           Flexible(
//                             child: Text('Address: ${order.address}'),
//                           ),
//                           Text('Transaction ID: ${order.transactionId}'),
//                           //Text('User ID: ${order.userId}'),
//                         ],
//                       ),
//                     ),
//                 ],
//               ),
//             ),
//           );
//         },
//       ),
//     );
//   }
// }
//

// class OrderTrackingScreen extends StatefulWidget {
//   final String orderId;
//
//   const OrderTrackingScreen({required this.orderId, super.key});
//
//   @override
//   _OrderTrackingScreenState createState() => _OrderTrackingScreenState();
// }
//
// class _OrderTrackingScreenState extends State<OrderTrackingScreen> {
//   late Stream<DocumentSnapshot> _orderStream;
//
//   @override
//   void initState() {
//     super.initState();
//     _orderStream = FirebaseFirestore.instance
//         .collection('Extras')
//         .doc(widget.orderId)
//         .snapshots();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('Order Tracking'),
//       ),
//       body: StreamBuilder<DocumentSnapshot>(
//         stream: _orderStream,
//         builder: (context, snapshot) {
//           if (snapshot.connectionState == ConnectionState.waiting) {
//             return const Center(child: CircularProgressIndicator());
//           }
//           if (!snapshot.hasData || !snapshot.data!.exists) {
//             return const Center(child: Text('Order not found'));
//           }
//           final orderData = snapshot.data!.data() as Map<String, dynamic>;
//           final currentStatus = orderData['status'] ?? 0;
//
//           return Stepper(
//             currentStep: currentStatus,
//             steps: [
//               Step(
//                 title: const Text('Order Confirmed'),
//                 content: const Text('Your order has been confirmed.'),
//                 isActive: currentStatus >= 0,
//               ),
//               Step(
//                 title: const Text('Order in Process'),
//                 content: const Text('Your order is being processed.'),
//                 isActive: currentStatus >= 1,
//               ),
//               Step(
//                 title: const Text('Order Pickup'),
//                 content: const Text('Your order is ready for pickup.'),
//                 isActive: currentStatus >= 2,
//               ),
//               Step(
//                 title: const Text('Order Delivered'),
//                 content: const Text('Your order has been delivered.'),
//                 isActive: currentStatus >= 3,
//               ),
//               Step(
//                 title: const Text('Order Received'),
//                 content: const Text('You have received your order.'),
//                 isActive: currentStatus >= 4,
//               ),
//             ],
//           );
//         },
//       ),
//     );
//   }
// }
//
// import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';
// import '../providers/order_provider.dart';
//
// class OrderHistoryScreen extends StatefulWidget {
//   const OrderHistoryScreen({super.key});
//
//   @override
//   State<OrderHistoryScreen> createState() => _OrderHistoryScreenState();
// }
//
// class _OrderHistoryScreenState extends State<OrderHistoryScreen> {
//   @override
//   Widget build(BuildContext context) {
//     final orderProvider = Provider.of<OrderProvider>(context);
//
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('Order History'),
//       ),
//       body: orderProvider.orders.isEmpty
//           ? Center(
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             Image.asset(
//               'assets/images/dog.png',
//               height: 200,
//             ),
//             const SizedBox(height: 20),
//             Text(
//               'Oops, you haven’t placed an order yet',
//               style: TextStyle(
//                 fontSize: 18,
//                 color: Colors.grey[600],
//               ),
//             ),
//           ],
//         ),
//       )
//           : ListView.builder(
//         itemCount: orderProvider.orders.length,
//         itemBuilder: (context, index) {
//           final order = orderProvider.orders[index];
//           bool isNewOrder = index == 0 ||
//               order.orderId != orderProvider.orders[index - 1].orderId;
//
//           return InkWell(
//             onTap: () {
//               Navigator.push(
//                 context,
//                 MaterialPageRoute(
//                   builder: (context) => const OrderTrackingScreen(),
//                 ),
//               );
//             },
//             child: Card(
//               color: const Color(0xffeaf1fc),
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   if (isNewOrder)
//                     Padding(
//                       padding: const EdgeInsets.all(8.0),
//                       child: Text('Order ID: ${order.orderId}'),
//                     ),
//                   ListTile(
//                     leading: CircleAvatar(
//                       backgroundImage: NetworkImage(order.productImage),
//                     ),
//                     title: Text(order.productName),
//                     subtitle: Text(
//                         'Price: ₹${order.price}, Quantity: ${order.quantity}, Total Price: ₹${order.totalPrice}'),
//                     trailing: IconButton(
//                       icon: const Icon(Icons.delete),
//                       onPressed: () async {
//                         setState(() {
//                           orderProvider.deleteOrder(order);
//                         });
//                       },
//                     ),
//                   ),
//                   if (isNewOrder && order.paymentMode == 'Cash')
//                     Padding(
//                       padding:
//                       const EdgeInsets.symmetric(horizontal: 16.0),
//                       child: Flexible(
//                         child: Text('Address: ${order.address}'),
//                       ),
//                     ),
//                   if (isNewOrder && order.paymentMode == 'Bank')
//                     Padding(
//                       padding:
//                       const EdgeInsets.symmetric(horizontal: 16.0),
//                       child: Column(
//                         crossAxisAlignment: CrossAxisAlignment.start,
//                         children: [
//                           Flexible(
//                             child: Text('Address: ${order.address}'),
//                           ),
//                           Text('Transaction ID: ${order.transactionId}'),
//                           //Text('User ID: ${order.userId}'),
//                         ],
//                       ),
//                     ),
//                 ],
//               ),
//             ),
//           );
//         },
//       ),
//     );
//   }
// }
//

// class OrderTrackingScreen extends StatefulWidget {
//   final String orderId;
//
//   const OrderTrackingScreen({required this.orderId, super.key});
//
//   @override
//   _OrderTrackingScreenState createState() => _OrderTrackingScreenState();
// }
//
// class _OrderTrackingScreenState extends State<OrderTrackingScreen> {
//   late Stream<DocumentSnapshot> _orderStream;
//
//   @override
//   void initState() {
//     super.initState();
//     _orderStream = FirebaseFirestore.instance
//         .collection('Extras')
//         .doc(widget.orderId)
//         .snapshots();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('Order Tracking'),
//       ),
//       body: StreamBuilder<DocumentSnapshot>(
//         stream: _orderStream,
//         builder: (context, snapshot) {
//           if (snapshot.connectionState == ConnectionState.waiting) {
//             return const Center(child: CircularProgressIndicator());
//           }
//           if (!snapshot.hasData || !snapshot.data!.exists) {
//             return const Center(child: Text('Order not found'));
//           }
//           final orderData = snapshot.data!.data() as Map<String, dynamic>;
//           final currentStatus = orderData['status'] ?? 0;
//
//           return Stepper(
//             currentStep: currentStatus,
//             steps: [
//               Step(
//                 title: const Text('Order Confirmed'),
//                 content: const Text('Your order has been confirmed.'),
//                 isActive: currentStatus >= 0,
//               ),
//               Step(
//                 title: const Text('Order in Process'),
//                 content: const Text('Your order is being processed.'),
//                 isActive: currentStatus >= 1,
//               ),
//               Step(
//                 title: const Text('Order Pickup'),
//                 content: const Text('Your order is ready for pickup.'),
//                 isActive: currentStatus >= 2,
//               ),
//               Step(
//                 title: const Text('Order Delivered'),
//                 content: const Text('Your order has been delivered.'),
//                 isActive: currentStatus >= 3,
//               ),
//               Step(
//                 title: const Text('Order Received'),
//                 content: const Text('You have received your order.'),
//                 isActive: currentStatus >= 4,
//               ),
//             ],
//           );
//         },
//       ),
//     );
//   }
// }
//
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:speedy_delivery/providers/auth_provider.dart';
import '../providers/order_provider.dart';
import 'order_tracking.dart'; // Ensure this import is correct

class OrderHistoryScreen extends StatefulWidget {
  const OrderHistoryScreen({super.key});

  @override
  State<OrderHistoryScreen> createState() => _OrderHistoryScreenState();
}

class _OrderHistoryScreenState extends State<OrderHistoryScreen> {
  @override
  Widget build(BuildContext context) {
    final orderProvider = Provider.of<OrderProvider>(context);
    final authProvider = Provider.of<MyAuthProvider>(context);

    // Group orders by orderId
    final groupedOrders = <String, List<Order>>{};
    for (var order in orderProvider.orders) {
      if (groupedOrders.containsKey(order.orderId)) {
        groupedOrders[order.orderId]!.add(order);
      } else {
        groupedOrders[order.orderId] = [order];
      }
    }

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
              itemCount: groupedOrders.length,
              itemBuilder: (context, index) {
                final orderId = groupedOrders.keys.elementAt(index);
                final orders = groupedOrders[orderId]!;

                return InkWell(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) =>
                            OrderTrackingScreen(orderId: orderId),
                      ),
                    );
                  },
                  child: Card(
                    color: const Color(0xffeaf1fc),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text('Order ID: $orderId'),
                        ),
                        ...orders.map((order) {
                          return ListTile(
                            leading: CircleAvatar(
                              backgroundImage: NetworkImage(order.productImage),
                            ),
                            title: Text(order.productName),
                            subtitle: Text(
                                'Price: ₹${order.price}, Quantity: ${order.quantity}, Total Price: ₹${order.totalPrice}'),
                            trailing: IconButton(
                              icon: const Icon(Icons.delete),
                              onPressed: () async {
                                setState(() {
                                  orderProvider.deleteOrder(order);
                                });
                              },
                            ),
                          );
                        }),
                        Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 16.0, vertical: 5),
                          child: orders.first.paymentMode == 'Cash'
                              ? Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text('Address: ${orders.first.address}'),
                                    Text("Phonne: ${authProvider.phone}"),
                                    // Text('Transaction ID: ${orders.first.transactionId}'),
                                  ],
                                )
                              : Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text('Address: ${orders.first.address}'),
                                    // Text('Transaction ID: ${orders.first.transactionId}'),
                                  ],
                                ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
    );
  }
}

// class OrderTrackingScreen extends StatefulWidget {
//   const OrderTrackingScreen({super.key});
//
//   @override
//   _OrderTrackingScreenState createState() => _OrderTrackingScreenState();
// }
//
// class _OrderTrackingScreenState extends State<OrderTrackingScreen> {
//   int _currentStatus = 0;
//
//   void _incrementStatus() {
//     setState(() {
//       if (_currentStatus < 4) {
//         _currentStatus++;
//       }
//     });
//   }
//
//   void _decrementStatus() {
//     setState(() {
//       if (_currentStatus > 0) {
//         _currentStatus--;
//       }
//     });
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('Order Tracking Demo'),
//       ),
//       body: Column(
//         children: [
//           Expanded(
//             child: Stepper(
//               currentStep: _currentStatus,
//               steps: [
//                 Step(
//                   title: const Text('Order Confirmed'),
//                   content: const Text('Your order has been confirmed.'),
//                   isActive: _currentStatus >= 0,
//                 ),
//                 Step(
//                   title: const Text('Order in Process'),
//                   content: const Text('Your order is being processed.'),
//                   isActive: _currentStatus >= 1,
//                 ),
//                 Step(
//                   title: const Text('Order Pickup'),
//                   content: const Text('Your order is ready for pickup.'),
//                   isActive: _currentStatus >= 2,
//                 ),
//                 Step(
//                   title: const Text('Order Delivered'),
//                   content: const Text('Your order has been delivered.'),
//                   isActive: _currentStatus >= 3,
//                 ),
//                 Step(
//                   title: const Text('Order Received'),
//                   content: const Text('You have received your order.'),
//                   isActive: _currentStatus >= 4,
//                 ),
//               ],
//             ),
//           ),
//           Row(
//             mainAxisAlignment: MainAxisAlignment.center,
//             children: [
//               ElevatedButton(
//                 onPressed: _decrementStatus,
//                 child: const Text('Previous Step'),
//               ),
//               const SizedBox(width: 20),
//               ElevatedButton(
//                 onPressed: _incrementStatus,
//                 child: const Text('Next Step'),
//               ),
//             ],
//           ),
//           const SizedBox(height: 20),
//         ],
//       ),
//     );
//   }
// }

// class OrderTrackingScreen extends StatefulWidget {
//   final Order order;
//
//   const OrderTrackingScreen({required this.order, super.key});
//
//   @override
//   _OrderTrackingScreenState createState() => _OrderTrackingScreenState();
// }
//
// class _OrderTrackingScreenState extends State<OrderTrackingScreen> {
//   late Stream<DocumentSnapshot> _orderStream;
//
//   @override
//   void initState() {
//     super.initState();
//     _orderStream = FirebaseFirestore.instance
//         .collection('Extras')
//         .doc(widget.order.orderId)
//         .snapshots();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('Order Tracking'),
//       ),
//       body: StreamBuilder<DocumentSnapshot>(
//         stream: _orderStream,
//         builder: (context, snapshot) {
//           if (snapshot.connectionState == ConnectionState.waiting) {
//             return Center(child: CircularProgressIndicator());
//           }
//           if (!snapshot.hasData || !snapshot.data!.exists) {
//             return Center(child: Text('Order not found'));
//           }
//           final orderData = snapshot.data!.data() as Map<String, dynamic>;
//           final currentStatus = orderData['status'] ?? 0;
//
//           return Stepper(
//             currentStep: currentStatus,
//             steps: [
//               Step(
//                 title: const Text('Order Confirmed'),
//                 content: const Text('Your order has been confirmed.'),
//                 isActive: currentStatus >= 0,
//               ),
//               Step(
//                 title: const Text('Order in Process'),
//                 content: const Text('Your order is being processed.'),
//                 isActive: currentStatus >= 1,
//               ),
//               Step(
//                 title: const Text('Order Pickup'),
//                 content: const Text('Your order is ready for pickup.'),
//                 isActive: currentStatus >= 2,
//               ),
//               Step(
//                 title: const Text('Order Delivered'),
//                 content: const Text('Your order has been delivered.'),
//                 isActive: currentStatus >= 3,
//               ),
//               Step(
//                 title: const Text('Order Received'),
//                 content: const Text('You have received your order.'),
//                 isActive: currentStatus >= 4,
//               ),
//             ],
//           );
//         },
//       ),
//     );
//   }
// }

// class OrderTrackingScreen extends StatefulWidget {
//   const OrderTrackingScreen({super.key});
//
//   @override
//   _OrderTrackingScreenState createState() => _OrderTrackingScreenState();
// }
//
// class _OrderTrackingScreenState extends State<OrderTrackingScreen> {
//   int _currentStatus = 0;
//
//   void _incrementStatus() {
//     setState(() {
//       if (_currentStatus < 4) {
//         _currentStatus++;
//       }
//     });
//   }
//
//   void _decrementStatus() {
//     setState(() {
//       if (_currentStatus > 0) {
//         _currentStatus--;
//       }
//     });
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('Order Tracking Demo'),
//       ),
//       body: Column(
//         children: [
//           Expanded(
//             child: Stepper(
//               currentStep: _currentStatus,
//               steps: [
//                 Step(
//                   title: const Text('Order Confirmed'),
//                   content: const Text('Your order has been confirmed.'),
//                   isActive: _currentStatus >= 0,
//                 ),
//                 Step(
//                   title: const Text('Order in Process'),
//                   content: const Text('Your order is being processed.'),
//                   isActive: _currentStatus >= 1,
//                 ),
//                 Step(
//                   title: const Text('Order Pickup'),
//                   content: const Text('Your order is ready for pickup.'),
//                   isActive: _currentStatus >= 2,
//                 ),
//                 Step(
//                   title: const Text('Order Delivered'),
//                   content: const Text('Your order has been delivered.'),
//                   isActive: _currentStatus >= 3,
//                 ),
//                 Step(
//                   title: const Text('Order Received'),
//                   content: const Text('You have received your order.'),
//                   isActive: _currentStatus >= 4,
//                 ),
//               ],
//             ),
//           ),
//           Row(
//             mainAxisAlignment: MainAxisAlignment.center,
//             children: [
//               ElevatedButton(
//                 onPressed: _decrementStatus,
//                 child: const Text('Previous Step'),
//               ),
//               const SizedBox(width: 20),
//               ElevatedButton(
//                 onPressed: _incrementStatus,
//                 child: const Text('Next Step'),
//               ),
//             ],
//           ),
//           const SizedBox(height: 20),
//         ],
//       ),
//     );
//   }
// }

// class OrderTrackingScreen extends StatefulWidget {
//   final Order order;
//
//   const OrderTrackingScreen({required this.order, super.key});
//
//   @override
//   _OrderTrackingScreenState createState() => _OrderTrackingScreenState();
// }
//
// class _OrderTrackingScreenState extends State<OrderTrackingScreen> {
//   late Stream<DocumentSnapshot> _orderStream;
//
//   @override
//   void initState() {
//     super.initState();
//     _orderStream = FirebaseFirestore.instance
//         .collection('Extras')
//         .doc(widget.order.orderId)
//         .snapshots();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('Order Tracking'),
//       ),
//       body: StreamBuilder<DocumentSnapshot>(
//         stream: _orderStream,
//         builder: (context, snapshot) {
//           if (snapshot.connectionState == ConnectionState.waiting) {
//             return Center(child: CircularProgressIndicator());
//           }
//           if (!snapshot.hasData || !snapshot.data!.exists) {
//             return Center(child: Text('Order not found'));
//           }
//           final orderData = snapshot.data!.data() as Map<String, dynamic>;
//           final currentStatus = orderData['status'] ?? 0;
//
//           return Stepper(
//             currentStep: currentStatus,
//             steps: [
//               Step(
//                 title: const Text('Order Confirmed'),
//                 content: const Text('Your order has been confirmed.'),
//                 isActive: currentStatus >= 0,
//               ),
//               Step(
//                 title: const Text('Order in Process'),
//                 content: const Text('Your order is being processed.'),
//                 isActive: currentStatus >= 1,
//               ),
//               Step(
//                 title: const Text('Order Pickup'),
//                 content: const Text('Your order is ready for pickup.'),
//                 isActive: currentStatus >= 2,
//               ),
//               Step(
//                 title: const Text('Order Delivered'),
//                 content: const Text('Your order has been delivered.'),
//                 isActive: currentStatus >= 3,
//               ),
//               Step(
//                 title: const Text('Order Received'),
//                 content: const Text('You have received your order.'),
//                 isActive: currentStatus >= 4,
//               ),
//             ],
//           );
//         },
//       ),
//     );
//   }
// }
