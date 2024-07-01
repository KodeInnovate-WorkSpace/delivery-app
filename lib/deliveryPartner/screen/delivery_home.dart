
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:speedy_delivery/deliveryPartner/model/model.dart';
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
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(
                          Icons.phone,
                          size: 12,
                        ),
                        Text(
                          order.phone,
                          style: const TextStyle(fontFamily: 'Gilroy-Bold'),
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
