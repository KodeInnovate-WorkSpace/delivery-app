import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/order_provider.dart';
import 'order_tracking.dart';

class OrderHistoryScreen extends StatefulWidget {
  const OrderHistoryScreen({super.key});

  @override
  State<OrderHistoryScreen> createState() => _OrderHistoryScreenState();
}

class _OrderHistoryScreenState extends State<OrderHistoryScreen> {
  @override
  Widget build(BuildContext context) {
    final orderProvider = Provider.of<OrderProvider>(context);
    // final authProvider = Provider.of<MyAuthProvider>(context);

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

                // Calculate overall total
                final overallTotal =
                    orders.fold(0.0, (sum, order) => sum + order.totalPrice) +
                        30.85;

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
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      border: Border(
                        bottom:
                            BorderSide(width: 1.5, color: Colors.grey.shade300),
                      ),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: Row(
                            children: [
                              Text(
                                'Order ID: $orderId',
                                style: const TextStyle(
                                    fontFamily: 'Gilroy-Bold', fontSize: 15),
                              ),
                              const Spacer(),
                              const Icon(
                                Icons.arrow_forward_ios_rounded,
                                size: 14,
                              ),
                            ],
                          ),
                        ),
                        Column(
                          children: orders.map((order) {
                            return ListTile(
                              leading: CircleAvatar(
                                backgroundImage:
                                    NetworkImage(order.productImage),
                              ),
                              title: Text(order.productName),
                              subtitle: Text(
                                  'Price: ₹${order.price}, Quantity: ${order.quantity}'),
                            );
                          }).toList(),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text('Total: ₹$overallTotal',
                              style: const TextStyle(fontSize: 16)),
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
