import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Order {
  final String orderId;
  final String productName;
  final String productImage;
  final int quantity;
  final double price;
  final double totalPrice;
  final String paymentMode;
  final String address;
  final String phone;
  int status;

  Order({
    required this.orderId,
    required this.productName,
    required this.productImage,
    required this.quantity,
    required this.price,
    required this.totalPrice,
    required this.paymentMode,
    required this.address,
    required this.phone,
    this.status = 0,
  });

  Order copyWith({
    String? orderId,
    int? status,
    required String phone,
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
      status: status ?? this.status,
      phone: this.phone,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'orderId': orderId,
      'productName': productName,
      'productImage': productImage,
      'quantity': quantity,
      'price': price,
      'totalPrice': totalPrice,
      'paymentMode': paymentMode,
      'address': address,
      'status': status,
      'phone': phone,
    };
  }

  factory Order.fromMap(Map<String, dynamic> map) {
    return Order(
      orderId: map['orderId'],
      productName: map['productName'],
      productImage: map['productImage'],
      quantity: map['quantity'],
      price: map['price'],
      totalPrice: map['totalPrice'],
      paymentMode: map['paymentMode'],
      address: map['address'],
      status: map['status'],
      phone: map['phone'],
    );
  }
}

class OrderProvider with ChangeNotifier {
  List<Order> _orders = [];

  List<Order> get orders => _orders;

  OrderProvider() {
    fetchOrders();
  }

  void addOrders(List<Order> orders, String ordId, String phone) {
    List<Order> newOrders = orders.map((order) => order.copyWith(orderId: ordId, phone: phone)).toList();
    _orders.addAll(newOrders);

    _saveOrdersToFirebase(newOrders);
    _saveOrdersToPreferences();

    notifyListeners();
  }

  void _saveOrdersToFirebase(List<Order> orders) {
    if (orders.isEmpty) return;

    double overallTotal = orders.fold(0.0, (sum, order) => sum + order.price);

    Map<String, dynamic> combinedOrderData = {
      'orderId': orders.first.orderId,
      'address': orders.first.address,
      'paymentMode': orders.first.paymentMode,
      'status': orders.first.status,
      'overallTotal': overallTotal,
      'phone': orders.first.phone,
      'orders': orders.map((order) {
        return {
          'productName': order.productName,
          'productImage': order.productImage,
          'quantity': order.quantity,
          'price': order.price,
          'totalPrice': order.totalPrice,
        };
      }).toList(),
    };

    FirebaseFirestore.instance.collection('OrderHistory').doc(orders.first.orderId).set(combinedOrderData);
  }

  Future<void> fetchOrders() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final String? ordersString = prefs.getString('orders');

    if (ordersString != null) {
      final List<dynamic> decodedList = jsonDecode(ordersString);
      _orders = decodedList.map((orderMap) => Order.fromMap(orderMap)).toList();
    } else {
      final snapshot = await FirebaseFirestore.instance.collection('OrderHistory').get();
      _orders = snapshot.docs.expand((doc) {
        final data = doc.data();
        List<dynamic> ordersData = data['orders'];
        return ordersData
            .map((orderData) => Order(
                  orderId: data['orderId'],
                  productName: orderData['productName'],
                  productImage: orderData['productImage'],
                  quantity: orderData['quantity'],
                  price: 0.0,
                  totalPrice: orderData['totalPrice'],
                  paymentMode: data['paymentMode'],
                  address: data['address'],
                  phone: data['phone'],
                  status: data['status'] ?? 0,
                ))
            .toList();
      }).toList();
    }

    // Sort orders by some criteria if needed (e.g., timestamp)
    // For simplicity, assuming that orders have an orderId that can be sorted
    _orders.sort((a, b) => b.orderId.compareTo(a.orderId)); // descending order

    notifyListeners();
  }

  Stream<List<Order>> streamOrdersByPhone(String phone) {
    return FirebaseFirestore.instance.collection('OrderHistory').where('phone', isEqualTo: phone).snapshots().map((snapshot) {
      return snapshot.docs.expand((doc) {
        final data = doc.data();
        List<dynamic> ordersData = data['orders'];
        return ordersData
            .map((orderData) => Order(
                  orderId: data['orderId'],
                  productName: orderData['productName'],
                  productImage: orderData['productImage'],
                  quantity: orderData['quantity'],
                  price: orderData['price'], // fixed the price field
                  totalPrice: orderData['totalPrice'],
                  paymentMode: data['paymentMode'],
                  address: data['address'],
                  phone: data['phone'],
                  status: data['status'] ?? 0,
                ))
            .toList();
      }).toList();
    });
  }

  Future<void> updateOrderStatus(Order order, int status, String phone) async {
    int orderIndex = _orders.indexWhere((o) => o.orderId == order.orderId);
    if (orderIndex != -1) {
      _orders[orderIndex] = order.copyWith(status: status, phone: phone);
      await _updateOrderStatusInFirebase(order.orderId, status);
      _saveOrdersToPreferences();
      notifyListeners();
    }
  }

  Future<void> _updateOrderStatusInFirebase(String orderId, int status) async {
    final docRef = FirebaseFirestore.instance.collection('OrderHistory').doc(orderId);
    final doc = await docRef.get();
    if (doc.exists) {
      await docRef.update({'status': status});
    }
  }

  Future<void> cancelOrder(String orderId) async {
    await _updateOrderStatusInFirebase(orderId, 5);
    notifyListeners();
  }

  void deleteOrder(Order order) {
    _orders.remove(order);
    _saveOrdersToPreferences();
    notifyListeners();
  }

  Future<void> _saveOrdersToPreferences() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final String encodedData = jsonEncode(_orders.map((order) => order.toMap()).toList());
    await prefs.setString('orders', encodedData);
  }
}
