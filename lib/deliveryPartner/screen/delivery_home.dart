import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:speedy_delivery/deliveryPartner/model/model.dart';
import 'package:speedy_delivery/providers/auth_provider.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../screens/sign_in_screen.dart';
import '../provider/delivery_order_provider.dart';
import 'delivery_order_tracking.dart';

class DeliveryHomeScreen extends StatefulWidget {
  const DeliveryHomeScreen({super.key});

  @override
  State<DeliveryHomeScreen> createState() => _DeliveryHomeScreenState();
}

class _DeliveryHomeScreenState extends State<DeliveryHomeScreen> {
  @override
  void initState() {
    super.initState();
    final orderProvider = Provider.of<AllOrderProvider>(context, listen: false);
    orderProvider.fetchAllOrders();
  }

  Future<void> _refreshOrders() async {
    final orderProvider = Provider.of<AllOrderProvider>(context, listen: false);
     orderProvider.fetchAllOrders();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: DefaultTabController(
        length: 2,
        child: Scaffold(
          appBar: AppBar(
            actions: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 5.0),
                child: IconButton(
                  onPressed: () async {
                    showDialog(
                      context: context,
                      builder: (context) => AlertDialog(
                        backgroundColor: Colors.white,
                        title: const Text(
                          "Logout",
                          style: TextStyle(fontFamily: 'Gilroy-ExtraBold'),
                        ),
                        content: const Text("Are you sure you want to logout?"),
                        actions: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              TextButton(
                                onPressed: () => Navigator.of(context).pop(),
                                child: const Text(
                                  "No",
                                  style: TextStyle(color: Color(0xffEF4B4B)),
                                ),
                              ),
                              TextButton(
                                onPressed: () async {
                                  await FirebaseAuth.instance.signOut();
                                  SharedPreferences prefs = await SharedPreferences.getInstance();
                                  await prefs.remove('isLoggedIn');
                                  Navigator.pushAndRemoveUntil(
                                    context,
                                    MaterialPageRoute(builder: (context) => const SigninScreen()),
                                        (route) => false,
                                  );
                                },
                                child: const Text(
                                  "Yes",
                                  style: TextStyle(color: Colors.black),
                                ),
                              ),
                            ],
                          )
                        ],
                      ),
                    );
                  },
                  icon: const Icon(
                    Icons.logout,
                    color: Color(0xffEF4B4B),
                    size: 20,
                  ),
                ),
              ),
            ],
            bottom: const TabBar(
              indicatorColor: Colors.black,
              labelColor: Colors.black,
              unselectedLabelColor: Colors.grey,
              labelStyle: TextStyle(fontSize: 17, fontFamily: 'Gilroy-SemiBold'),
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
                  ),
                );
              }
              return TabBarView(
                children: [
                  pendingOrders(context),
                  completedOrders(context),
                ],
              );
            },
          ),
        ),
      ),
    );
  }

  Widget pendingOrders(BuildContext context) {
    final authProvider = Provider.of<MyAuthProvider>(context);
    return RefreshIndicator(
      onRefresh: _refreshOrders,
      child: StreamBuilder(
        stream: FirebaseFirestore.instance.collection('OrderHistory')
            .where('valetPhone', isEqualTo: authProvider.phone).snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator(color: Colors.black));
          }

          final orders = snapshot.data?.docs
              .map((doc) {
            final data = doc.data();
            final orderDetails = (data['orders'] as List<dynamic>).map((order) {
              return OrderDetail(
                price: order['price'],
                productImage: order['productImage'],
                productName: order['productName'],
                quantity: order['quantity'],
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
              time: data['timestamp'],
            );
          })
              .where((order) => order.status != 4)
              .toList()
              .reversed
              .toList();

          return ListView.builder(
            itemCount: orders?.length,
            itemBuilder: (context, index) {
              final order = orders?[index];
              return Container(
                key: ValueKey(order?.orderId),
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
                          orderId: order?.orderId ?? '',
                          orderTotalPrice: order?.overallTotal ?? 0,
                          order: order?.orders ?? [],
                          paymentMode: order?.paymentMode ?? '',
                          customerAddress: order?.address ?? '',
                          customerPhone: order?.phone ?? '',
                          orderTime: order!.time,
                        ),
                      ),
                    );
                  },
                  child: ListTile(
                    title: Text(order?.orderId ?? ''),
                    subtitle: Text('Order Date: ${formatTimestamp(DateTime.parse(order?.time ?? ''))}',),
                    trailing: GestureDetector(
                      onTap: () async {
                        if (order?.phone != null) {
                          Uri dialNumber = Uri(scheme: 'tel', path: order?.phone);
                          await launchUrl(dialNumber);
                        }
                      },
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(
                            Icons.phone,
                            size: 12,
                          ),
                          Text(
                            order?.phone ?? '',
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
      ),
    );
  }

  Widget completedOrders(BuildContext context) {
    return RefreshIndicator(
      onRefresh: _refreshOrders,
      child: StreamBuilder(
        stream: FirebaseFirestore.instance.collection('OrderHistory').snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator(color: Colors.black));
          }

          final orders = snapshot.data?.docs
              .map((doc) {
            final data = doc.data();
            final orderDetails = (data['orders'] as List<dynamic>).map((order) {
              return OrderDetail(
                price: order['price'],
                productImage: order['productImage'],
                productName: order['productName'],
                quantity: order['quantity'],
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
              time: data['timestamp'],
            );
          })
              .where((order) => order.status == 4)
              .toList()
              .reversed
              .toList();

          return ListView.builder(
            itemCount: orders?.length,
            itemBuilder: (context, index) {
              final order = orders?[index];
              return Container(
                key: ValueKey(order?.orderId),
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
                          orderId: order?.orderId ?? '',
                          orderTotalPrice: order?.overallTotal ?? 0,
                          order: order?.orders ?? [],
                          paymentMode: order?.paymentMode ?? '',
                          customerAddress: order?.address ?? '',
                          customerPhone: order?.phone ?? '',
                          orderTime: order?.time ?? '',
                        ),
                      ),
                    );
                  },
                  child: ListTile(
                    title: Text(order?.orderId ?? ''),
                    subtitle: Text('Order Date: ${formatTimestamp(DateTime.parse(order?.time ?? ''))}',),
                    trailing: GestureDetector(
                      onTap: () async {
                        if (order?.phone != null) {
                          Uri dialNumber = Uri(scheme: 'tel', path: order?.phone);
                          await launchUrl(dialNumber);
                        }
                      },
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(
                            Icons.phone,
                            size: 12,
                          ),
                          Text(
                            order?.phone ?? '',
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
      ),
    );
  }

  String formatTimestamp(DateTime timestamp) {
    return DateFormat('dd MMM yyyy, hh:mm a').format(timestamp);
  }
}
