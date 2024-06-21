import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:speedy_delivery/screens/order_tracking.dart';

import '../provider/delivery_order_provider.dart';

class DeliveryHomeScreen extends StatelessWidget {
  const DeliveryHomeScreen({super.key});

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
                Tab(text: "Pending"),
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
    final orders = orderProvider.allOrders
        .where((order) => order.status != 4)
        .toList(); // Filter for pending orders
    return ListView.builder(
      itemCount: orders.length,
      itemBuilder: (context, index) {
        final order = orders[index];
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
                      builder: (context) =>
                          OrderTrackingScreen(orderId: order.orderId)));
            },
            child: ListTile(
              title: Text(order.orderId),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: order.orders.map((orderDetail) {
                  return Text(
                      '${orderDetail.productName} - ${orderDetail.quantity} x Rs.${orderDetail.price}');
                }).toList(),
              ),
              trailing: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Total: Rs.${order.overallTotal}',
                    style: const TextStyle(fontSize: 13),
                  ),
                  Text(
                    'Status: ${order.status}',
                    style: const TextStyle(fontSize: 13),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget completedOrders(BuildContext context, AllOrderProvider orderProvider) {
    final orders = orderProvider.allOrders
        .where((order) => order.status != 0)
        .toList(); // Filter for completed orders
    return ListView.builder(
      itemCount: orders.length,
      itemBuilder: (context, index) {
        final order = orders[index];
        return ListTile(
          title: Text(order.orderId),
          subtitle: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: order.orders.map((orderDetail) {
              return Text(
                  '${orderDetail.productName} - ${orderDetail.quantity} x Rs.${orderDetail.price}');
            }).toList(),
          ),
          trailing: Text(
            'Total: Rs.${order.overallTotal}',
          ),
        );
      },
    );
  }
}
