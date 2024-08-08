import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:speedy_delivery/deliveryPartner/model/model.dart';

class AllOrderProvider with ChangeNotifier {
  late List<AllOrder> _allOrders = [];

  List<AllOrder> get allOrders => _allOrders;
  AllOrderProvider() {
    fetchAllOrders();
  }
  void fetchAllOrders() {
    FirebaseFirestore.instance
        .collection('OrderHistory')
        .orderBy('timestamp', descending: true) // Sort by date, latest first
        .snapshots()
        .listen((snapshot) {
      _allOrders = snapshot.docs.map((doc) {
        final data = doc.data();
        print('Order Data: $data'); // Debugging line to print the fetched data

        final orderDetails = (data['orders'] as List<dynamic>? ?? []).map((order) {
          print('Order Details: $order'); // Debugging line to print each order's details

          return OrderDetail(
            price: order['price'] ?? 0.0,
            productImage: order['productImage'] ?? '',
            productName: order['productName'] ?? '',
            quantity: order['quantity'] ?? 0,
            unit: order['unit'] ?? 'Unknown', // Provide default if 'unit' is missing
          );
        }).toList();

        return AllOrder(
          orderId: data['orderId'] ?? '',
          address: data['address'] ?? '',
          orders: orderDetails,
          overallTotal: data['overallTotal'] ?? 0.0,
          paymentMode: data['paymentMode'] ?? '',
          status: data['status'] ?? 0,
          phone: data['phone'] ?? '',
          time: data['timestamp'] ?? Timestamp.now(),
        );
      }).toList().reversed.toList(); // Reverse the order of the list

      notifyListeners();
    });
  }



}
