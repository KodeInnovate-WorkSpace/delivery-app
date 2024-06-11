import 'dart:math';

import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class Order {
  final String orderId; // New field for order ID
  final String productName;
  final String productImage;
  final int quantity;
  final double price;
  final double totalPrice;
  final String paymentMode;
  final String address;
  final String phone;
  final String transactionId;
  final String userId;
  int status;

  Order({
    required this.orderId, // Include order ID in the constructor
    required this.productName,
    required this.productImage,
    required this.quantity,
    required this.price,
    required this.totalPrice,
    required this.paymentMode,
    required this.address,
    required this.phone,
    required this.transactionId,
    required this.userId,
    this.status = 0,
  });

  // Custom copyWith method
  Order copyWith({
    String? orderId,
    int? status,
  }) {
    return Order(
      orderId: orderId ?? this.orderId,
      productName: productName,
      productImage: productImage,
      quantity: quantity,
      price: price,
      totalPrice: totalPrice,
      paymentMode: paymentMode,
      address: address,
      phone: phone,
      transactionId: transactionId,
      userId: userId,
      status: status ?? this.status,
    );
  }
}

class OrderProvider with ChangeNotifier {
  List<Order> _orders = [];

  List<Order> get orders => _orders;

  OrderProvider() {
    fetchOrders();
  }

  void addOrder(Order order) {
    String orderId = _generateOrderId();
    order = order.copyWith(orderId: orderId);

    _orders.add(order);
    FirebaseFirestore.instance.collection('Extras').add({
      'orderId': order.orderId,
      'productName': order.productName,
      'productImage': order.productImage,
      'quantity': order.quantity,
      'price': order.price,
      'totalPrice': order.totalPrice,
      'paymentMode': order.paymentMode,
      'address': order.address,
      'phone': order.phone,
      'transactionId': order.transactionId,
      'userId': order.userId,
      'status': order.status,
    });

    notifyListeners();
  }

  String _generateOrderId() {
    int randomNumber = Random().nextInt(9000) + 1000;
    String timestamp = DateTime.now().millisecondsSinceEpoch.toString();
    return 'ORD_${timestamp}_$randomNumber';
  }


  Future<void> fetchOrders() async {
    final snapshot = await FirebaseFirestore.instance.collection('Extras').get();
    _orders = snapshot.docs.map((doc) {
      final data = doc.data();
      return Order(
        orderId: data['orderId'],
        productName: data['productName'],
        productImage: data['productImage'],
        quantity: data['quantity'],
        price: data['price'],
        totalPrice: data['totalPrice'],
        paymentMode: data['paymentMode'],
        address: data['address'],
        phone: data['phone'],
        transactionId: data['transactionId'],
        userId: data['userId'],
        status: data['status'] ?? 0,
      );
    }).toList();
    notifyListeners();
  }

  Future<void> updateOrderStatus(Order order, int status) async {
    int orderIndex = _orders.indexWhere((o) => o.orderId == order.orderId);
    if (orderIndex != -1) {
      _orders[orderIndex] = order.copyWith(status: status);
      await FirebaseFirestore.instance
          .collection('Extras')
          .doc(order.orderId)
          .update({'status': status});
      notifyListeners();
    }
  }

  void deleteOrder(Order order) {
    _orders.remove(order);
    notifyListeners();
  }
// void deleteOrder(Order order) {
//   _orders.remove(order);
//   FirebaseFirestore.instance
//       .collection('Extras')
//       .where('orderId', isEqualTo: order.orderId)
//       .get()
//       .then((snapshot) {
//     for (var doc in snapshot.docs) {
//       doc.reference.delete();
//     }
//   });
//   notifyListeners();
// }
}