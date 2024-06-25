import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:speedy_delivery/deliveryPartner/model/model.dart';
import 'package:speedy_delivery/shared/show_msg.dart';
import 'package:url_launcher/url_launcher.dart';
import '../provider/delivery_order_provider.dart';
import 'delivery_order_tracking.dart';

class DeliveryHomeScreen extends StatefulWidget {
  const DeliveryHomeScreen({super.key});

  @override
  State<DeliveryHomeScreen> createState() => _DeliveryHomeScreenState();
}

class _DeliveryHomeScreenState extends State<DeliveryHomeScreen> {
  @override
  Widget build(BuildContext context) {
    final orderProvider = Provider.of<AllOrderProvider>(context);

    // Fetch orders when the screen loads
    orderProvider.fetchAllOrders();

    return Scaffold(
      body: DefaultTabController(
        length: 2,
        child: Scaffold(
          appBar: AppBar(
            bottom: const TabBar(
              indicatorColor: Colors.black,
              labelColor: Colors.black,
              unselectedLabelColor: Colors.grey,
              labelStyle:
                  TextStyle(fontSize: 17, fontFamily: 'Gilroy-SemiBold'),
              tabs: [
                Tab(text: "Pending Orders"),
                Tab(text: "Completed Orders"),
              ],
            ),
            title: const Text(
              'Orders',
              style: TextStyle(fontSize: 20),
            ),
          ),
          body: Consumer<AllOrderProvider>(
            builder: (context, allOrderProvider, child) {
              if (allOrderProvider.allOrders.isEmpty) {
                return const Center(
                    child: CircularProgressIndicator(
                  color: Colors.black,
                ));
              }
              return TabBarView(
                children: [
                  pendingOrders(context, orderProvider),
                  completedOrders(context, orderProvider),
                ],
              );
            },
          ),
        ),
      ),
    );
  }

  // Widget pendingOrders(BuildContext context, AllOrderProvider orderProvider) {
  //   bool isOrderAccepted = false;
  //
  //   return StreamBuilder(
  //     stream: FirebaseFirestore.instance.collection('OrderHistory').snapshots(),
  //     builder: (context, snapshot) {
  //       if (!snapshot.hasData) {
  //         return const Center(child: CircularProgressIndicator());
  //       }
  //
  //       final orders = snapshot.data?.docs
  //           .map((doc) {
  //             final data = doc.data();
  //             final orderDetails =
  //                 (data['orders'] as List<dynamic>).map((order) {
  //               return OrderDetail(
  //                 price: order['price'],
  //                 productImage: order['productImage'],
  //                 productName: order['productName'],
  //                 quantity: order['quantity'],
  //                 totalPrice: order['totalPrice'],
  //               );
  //             }).toList();
  //
  //             return AllOrder(
  //               orderId: data['orderId'],
  //               address: data['address'],
  //               orders: orderDetails,
  //               overallTotal: data['overallTotal'],
  //               paymentMode: data['paymentMode'],
  //               status: data['status'],
  //               phone: data['phone'],
  //             );
  //           })
  //           .where((order) => order.status != 4)
  //           .toList();
  //
  //       return ListView.builder(
  //         itemCount: orders?.length,
  //         itemBuilder: (context, index) {
  //           final order = orders?[index];
  //           return Container(
  //             decoration: BoxDecoration(
  //               color: Colors.white,
  //               border: Border(
  //                 bottom: BorderSide(width: 1.5, color: Colors.grey.shade300),
  //               ),
  //             ),
  //             child: GestureDetector(
  //               onTap: () {
  //                 Navigator.push(
  //                   context,
  //                   MaterialPageRoute(
  //                     builder: (context) => DeliveryTrackingScreen(
  //                       orderId: order.orderId,
  //                       orderTotalPrice: order.overallTotal,
  //                       order: order.orders,
  //                       paymentMode: order.paymentMode,
  //                       customerAddress: order.address,
  //                       customerPhone: order.phone,
  //                     ),
  //                   ),
  //                 );
  //               },
  //               child: ListTile(
  //                 title: Text(order!.orderId),
  //                 trailing: GestureDetector(
  //                   onTap: () async {
  //                     Uri dialNumber = Uri(scheme: 'tel', path: order.phone);
  //                     await launchUrl(dialNumber);
  //                   },
  //
  //                   //dark green = 014737
  //                   //light green = 569f48
  //                   //light green 2 = 62d78d
  //                   child: !isOrderAccepted
  //                       ? ElevatedButton(
  //                           onPressed: () {
  //                             isOrderAccepted = !isOrderAccepted;
  //                             setState(() {});
  //                             log("Accepted: $isOrderAccepted");
  //
  //                             showMessage("Delivery Accepted!");
  //                           },
  //                           style: ElevatedButton.styleFrom(
  //                             backgroundColor:
  //                                 // const Color(0xFF569f48),
  //                                 Colors.lightGreenAccent, // Background color
  //                             elevation: 0, // Remove elevation
  //                             // shape: RoundedRectangleBorder(
  //                             //   borderRadius: BorderRadius.circular(12), // Custom border radius
  //                             // ),
  //                             minimumSize: const Size(40, 40),
  //                           ),
  //                           child: const Text(
  //                             "Accept",
  //                             style: TextStyle(
  //                               fontSize: 12,
  //                               color: const Color(0xFF569f48),
  //                               fontFamily: 'Gilroy-ExtraBold',
  //                             ),
  //                           ),
  //                         )
  //                       : Column(
  //                           mainAxisAlignment: MainAxisAlignment.center,
  //                           children: [
  //                             const Icon(
  //                               Icons.phone,
  //                               size: 12,
  //                             ),
  //                             Text(
  //                               order.phone,
  //                               style:
  //                                   const TextStyle(fontFamily: 'Gilroy-Bold'),
  //                             ),
  //                           ],
  //                         ),
  //                 ),
  //               ),
  //             ),
  //           );
  //         },
  //       );
  //     },
  //   );
  // }
  Widget pendingOrders(BuildContext context, AllOrderProvider orderProvider) {
    return StreamBuilder(
      stream: FirebaseFirestore.instance.collection('OrderHistory').snapshots(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return const Center(child: CircularProgressIndicator());
        }

        final orders = snapshot.data?.docs
            .map((doc) {
              final data = doc.data();
              final orderDetails =
                  (data['orders'] as List<dynamic>).map((order) {
                return OrderDetail(
                  price: order['price'],
                  productImage: order['productImage'],
                  productName: order['productName'],
                  quantity: order['quantity'],
                  totalPrice: order['totalPrice'],
                );
              }).toList();

              return AllOrder(
                orderId: data['orderId'],
                address: data['address'],
                orders: orderDetails,
                overallTotal: data['overallTotal'],
                paymentMode: data['paymentMode'],
                status: data['status'],
                phone: data['phone'],
                isOrderAccepted: data['isOrderAccepted'], // Add this field
                valetPhoneNo: data['valetPhoneNo'], // Add this field
              );
            })
            .where((order) => order.status != 4)
            .toList();

        return ListView.builder(
          itemCount: orders?.length,
          itemBuilder: (context, index) {
            final order = orders?[index];
            return Container(
              decoration: BoxDecoration(
                color: Colors.white,
                border: Border(
                  bottom: BorderSide(width: 1.5, color: Colors.grey.shade300),
                ),
              ),
              child: GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => DeliveryTrackingScreen(
                        orderId: order.orderId,
                        orderTotalPrice: order.overallTotal,
                        order: order.orders,
                        paymentMode: order.paymentMode,
                        customerAddress: order.address,
                        customerPhone: order.phone,
                      ),
                    ),
                  );
                },
                child: ListTile(
                  title: Text(order!.orderId),
                  trailing: GestureDetector(
                    onTap: () async {
                      Uri dialNumber = Uri(scheme: 'tel', path: order.phone);
                      await launchUrl(dialNumber);
                    },
                    child: !order.isOrderAccepted
                        ? ElevatedButton(
                            onPressed: () async {
                              // Update Firestore when the order is accepted
                              await FirebaseFirestore.instance
                                  .collection('OrderHistory')
                                  .doc(order.orderId)
                                  .update({
                                'isOrderAccepted': true,
                                'valetPhoneNo':
                                    'delivery_guy_phone_number', // Set the delivery guy's phone number
                              });

                              setState(() {});
                              log("Order Accepted!");

                              showMessage("Delivery Accepted!");
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor:
                                  Colors.lightGreenAccent, // Background color
                              elevation: 0, // Remove elevation
                              minimumSize: const Size(40, 40),
                            ),
                            child: const Text(
                              "Accept",
                              style: TextStyle(
                                fontSize: 12,
                                color: Color(0xFF569f48),
                                fontFamily: 'Gilroy-ExtraBold',
                              ),
                            ),
                          )
                        : Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Icon(
                                Icons.phone,
                                size: 12,
                              ),
                              Text(
                                order.phone,
                                style:
                                    const TextStyle(fontFamily: 'Gilroy-Bold'),
                              ),
                            ],
                          ),
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }

  Widget completedOrders(BuildContext context, AllOrderProvider orderProvider) {
    final orders = orderProvider.allOrders
        .where((order) => order.status == 4)
        .toList(); // Filter for completed orders
    return ListView.builder(
      itemCount: orders.length,
      itemBuilder: (context, index) {
        final order = orders[index];
        return ListTile(
          title: Text(order.orderId),
          trailing: const Text(
            'Done',
            style: TextStyle(fontSize: 12, fontFamily: 'Gilroy-ExtraBold'),
          ),
        );
      },
    );
  }
}
