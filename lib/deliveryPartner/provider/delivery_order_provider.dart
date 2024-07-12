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
    FirebaseFirestore.instance.collection('OrderHistory').snapshots().listen((snapshot) {
      _allOrders = snapshot.docs
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
          .toList()
          .reversed
          .toList(); // Reverse the order of the list

      notifyListeners();
    });
  }
}
