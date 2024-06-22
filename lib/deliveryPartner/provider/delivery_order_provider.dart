import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:speedy_delivery/deliveryPartner/model/model.dart';

class AllOrderProvider with ChangeNotifier {
  final List<AllOrder> _allOrders = [];

  List<AllOrder> get allOrders => _allOrders;

  Future<void> fetchAllOrders() async {
    final firestore = FirebaseFirestore.instance.collection('OrderHistory');
    final snapshot = await firestore.get();

    // Clear existing data before fetching new orders
    _allOrders.clear();

    for (var doc in snapshot.docs) {
      final data = doc.data();
      // Check if required data exists before creating an AllOrder object
      if (data.containsKey('orderId') &&
          data.containsKey('address') &&
          data.containsKey('orders') &&
          data.containsKey('overallTotal') &&
          data.containsKey('paymentMode') &&
          data.containsKey('status')) {
        final orderDetails = (data['orders'] as List<dynamic>).map((order) {
          return OrderDetail(
            price: order['price'],
            productImage: order['productImage'],
            productName: order['productName'],
            quantity: order['quantity'],
            totalPrice: order['totalPrice'],
          );
        }).toList();

        final newOrder = AllOrder(
          orderId: data['orderId'],
          address: data['address'],
          orders: orderDetails,
          overallTotal: data['overallTotal'],
          paymentMode: data['paymentMode'],
          status: data['status'],
          phone: data['phone'],
        );
        _allOrders.add(newOrder);

        // log("All orders: ${_allOrders.map((o)=>{
        //   "orderId:" ,o.orderId
        //
        // })}");

      } else {
        // Handle cases where data is missing or has an unexpected format
        log("Error: Order data is missing or invalid for document ${doc.id}");
      }
    }

    // Notify listeners about the change in data
    notifyListeners();
  }
}
