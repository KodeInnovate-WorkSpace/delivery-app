import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import '../providers/order_provider.dart';

class OrderDetailsScreen extends StatefulWidget {
  final String orderId;

  const OrderDetailsScreen({super.key, required this.orderId});

  @override
  State<OrderDetailsScreen> createState() => _OrderDetailsScreenState();
}

class _OrderDetailsScreenState extends State<OrderDetailsScreen> {
  @override
  void initState() {
    super.initState();
    // Refresh the orders every time this screen is initialized
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<OrderProvider>(context, listen: false).fetchOrders();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Order Details'),
      ),
      body: Consumer<OrderProvider>(
        builder: (context, orderProvider, child) {
          final order = orderProvider.orders.firstWhere((order) => order.orderId == widget.orderId);

          return SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Order ID: ${order.orderId}', style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 10),
                  Text('Overall Total: ${order.overallTotal}'),
                  const SizedBox(height: 10),
                  Text('Payment Mode: ${order.paymentMode}'),
                  const SizedBox(height: 10),
                  Text('Address: ${order.address}'),
                  const SizedBox(height: 10),
                  Text('Phone: ${order.phone}'),
                  const SizedBox(height: 10),
                  Text('Timestamp: ${_formatTimestamp(order.timestamp)}'),
                  const SizedBox(height: 10),
                  Text('Valet Name: ${order.valetName}'),
                  const SizedBox(height: 10),
                  Text('Valet Phone: ${order.valetPhone}'),
                  const SizedBox(height: 20),
                  const Text('Products:', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 10),
                  ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: orderProvider.orders.where((o) => o.orderId == widget.orderId).length,
                    itemBuilder: (context, index) {
                      final product = orderProvider.orders.where((o) => o.orderId == widget.orderId).elementAt(index);
                      return FutureBuilder<String?>(
                        future: orderProvider.fetchCategoryName(product.productName),
                        builder: (context, snapshot) {
                          final categoryName = snapshot.data ?? 'Unknown';
                          return Padding(
                            padding: const EdgeInsets.symmetric(vertical: 8.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text('Product Name: ${product.productName}', style: const TextStyle(fontSize: 16)),
                                const SizedBox(height: 5),
                                Text('Category Name: $categoryName'),
                                const SizedBox(height: 5),
                                Text('Quantity: ${product.quantity}'),
                                const SizedBox(height: 5),
                                Text('Unit: ${product.unit}'),
                                const SizedBox(height: 5),
                                Text('Price: ${product.price}'),
                                const Divider(),
                              ],
                            ),
                          );
                        },
                      );
                    },
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  String _formatTimestamp(DateTime timestamp) {
    return DateFormat('dd MMM yyyy, hh:mm a').format(timestamp.toLocal());
  }
}
