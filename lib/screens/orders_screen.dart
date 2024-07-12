// import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';
// import '../providers/auth_provider.dart';
// import '../providers/order_provider.dart';
// import 'order_tracking.dart';
// import 'package:cached_network_image/cached_network_image.dart';
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
//     final authProvider = Provider.of<MyAuthProvider>(context);
//     final orderProvider = Provider.of<OrderProvider>(context);
//     final phone = authProvider.phone;
//
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('Order History', style: TextStyle(color: Colors.black)),
//         backgroundColor: Colors.white,
//         elevation: 0,
//         iconTheme: const IconThemeData(color: Colors.black),
//       ),
//       body: StreamBuilder<List<Order>>(
//         stream: orderProvider.streamOrdersByPhone(phone),
//         builder: (context, snapshot) {
//           if (snapshot.connectionState == ConnectionState.waiting) {
//             return const Center(child: CircularProgressIndicator());
//           }
//           if (snapshot.hasError) {
//             return Center(child: Text('Error: ${snapshot.error}'));
//           }
//           if (!snapshot.hasData || snapshot.data!.isEmpty) {
//             return Center(
//               child: Column(
//                 mainAxisAlignment: MainAxisAlignment.center,
//                 children: [
//                   Image.asset(
//                     'assets/images/dog.png',
//                     height: 200,
//                   ),
//                   const SizedBox(height: 20),
//                   Text(
//                     'Oops, you haven’t placed an order yet',
//                     style: TextStyle(
//                       fontSize: 18,
//                       color: Colors.grey[600],
//                     ),
//                   ),
//                 ],
//               ),
//             );
//           }
//
//           final orders = snapshot.data!;
//           final groupedOrders = <String, List<Order>>{};
//           for (var order in orders) {
//             if (groupedOrders.containsKey(order.orderId)) {
//               groupedOrders[order.orderId]!.add(order);
//             } else {
//               groupedOrders[order.orderId] = [order];
//             }
//           }
//
//           final reversedKeys = groupedOrders.keys.toList().reversed.toList();
//
//           return ListView.builder(
//             itemCount: groupedOrders.length,
//             itemBuilder: (context, index) {
//               final orderId = reversedKeys[index];
//               final orders = groupedOrders[orderId]!;
//
//               IconData getOrderStatusIcon(int status) {
//                 switch (status) {
//                   case 4:
//                     return Icons.check_circle;
//                   case 5:
//                     return Icons.error;
//                   case 6:
//                     return Icons.cancel;
//                   default:
//                     return Icons.hourglass_empty;
//                 }
//               }
//
//               Color getOrderStatusColor(int status) {
//                 switch (status) {
//                   case 4:
//                     return Colors.green;
//                   case 5:
//                     return Colors.red;
//                   case 6:
//                     return Colors.red;
//                   default:
//                     return Colors.orange;
//                 }
//               }
//
//               String getOrderStatusText(int status) {
//                 switch (status) {
//                   case 4:
//                     return 'Order Completed';
//                   case 5:
//                     return 'Order Failed';
//                   case 6:
//                     return 'Order Cancelled';
//                   default:
//                     return 'Ongoing';
//                 }
//               }
//
//               return InkWell(
//                 onTap: () {
//                   Navigator.push(
//                     context,
//                     MaterialPageRoute(
//                       builder: (context) => OrderTrackingScreen(orderId: orderId),
//                     ),
//                   );
//                 },
//                 child: Container(
//                   margin: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
//                   padding: const EdgeInsets.all(16.0),
//                   decoration: BoxDecoration(
//                     color: Colors.white,
//                     borderRadius: BorderRadius.circular(12.0),
//                     boxShadow: [
//                       BoxShadow(
//                         color: Colors.grey.withOpacity(0.1),
//                         spreadRadius: 5,
//                         blurRadius: 7,
//                         offset: const Offset(0, 3),
//                       ),
//                     ],
//                   ),
//                   child: Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       Text(
//                         'Order ID: $orderId',
//                         style: const TextStyle(fontFamily: 'Gilroy-Bold', fontSize: 15),
//                       ),
//                       const Divider(),
//                       Column(
//                         children: orders.map((order) {
//                           return ListTile(
//                             leading: CircleAvatar(
//                               backgroundImage: CachedNetworkImageProvider(order.productImage),
//                             ),
//                             title: Text(order.productName),
//                             subtitle: Text('Price: ₹${order.price.toStringAsFixed(0)}, Quantity: ${order.quantity}'),
//                           );
//                         }).toList(),
//                       ),
//                       const Divider(),
//                       Row(
//                         mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                         children: [
//                           Text(
//                             'To Pay: ₹${orders.first.overallTotal}',
//                             style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
//                           ),
//                           Row(
//                             children: [
//                               Text(
//                                 getOrderStatusText(orders.first.status),
//                                 style: TextStyle(
//                                   color: getOrderStatusColor(orders.first.status),
//                                   fontWeight: FontWeight.bold,
//                                 ),
//                               ),
//                               const SizedBox(width: 4.0),
//                               Icon(
//                                 getOrderStatusIcon(orders.first.status),
//                                 color: getOrderStatusColor(orders.first.status),
//                               ),
//                             ],
//                           ),
//                         ],
//                       ),
//                     ],
//                   ),
//                 ),
//               );
//             },
//           );
//         },
//       ),
//     );
//   }
// }
