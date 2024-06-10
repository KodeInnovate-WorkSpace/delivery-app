import 'dart:math';

import 'package:flutter/material.dart';

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
      productName: this.productName,
      productImage: this.productImage,
      quantity: this.quantity,
      price: this.price,
      totalPrice: this.totalPrice,
      paymentMode: this.paymentMode,
      address: this.address,
      phone: this.phone,
      transactionId: this.transactionId,
      userId: this.userId,
      status: status ?? this.status,
    );
  }
}

class OrderProvider with ChangeNotifier {
  List<Order> _orders = [];

  List<Order> get orders => _orders;

  void addOrder(Order order) {
    // Generate a unique order ID
    String orderId = _generateOrderId();
    order = order.copyWith(orderId: orderId);

    _orders.add(order);
    notifyListeners();
  }

  String _generateOrderId() {
    int randomNumber = Random().nextInt(9000) + 1000;
    String timestamp = DateTime.now().millisecondsSinceEpoch.toString();
    return 'ORD_$timestamp$randomNumber';
  }

  void updateOrderStatus(Order order, int status) {
    int orderIndex = _orders.indexWhere((o) => o.orderId == order.orderId);
    if (orderIndex != -1) {
      _orders[orderIndex] = order.copyWith(status: status);
      notifyListeners();
    }
  }

  void deleteOrder(Order order) {
    _orders.remove(order);
    notifyListeners();
  }

  // delete from firebase
  // Future<void> deleteCategory(dynamic categoryValue) async {
  //   try {
  //     Query query = FirebaseFirestore.instance.collection('category');
  //
  //     // Add conditions to your query if any
  //     if (categoryValue != null) {
  //       query = query.where(FieldPath(const ['category_id']),
  //           isEqualTo: categoryValue); // Assuming 'catId' is the field name
  //     }
  //
  //     // Get the documents matching the query
  //     QuerySnapshot querySnapshot = await query.get();
  //     for (QueryDocumentSnapshot doc in querySnapshot.docs) {
  //       await doc.reference.delete();
  //     }
  //     log("Category Deleted!");
  //     showMessage("Category Deleted!");
  //   } catch (e) {
  //     showMessage("Error deleting category");
  //
  //     log("Error deleting category: $e");
  //   }
  // }
}
