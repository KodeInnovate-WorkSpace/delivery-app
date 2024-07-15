import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:speedy_delivery/shared/constants.dart';

class Order {
  final String orderId;
  final String productName;
  final String productImage;
  final int quantity;
  final double price;
  final double overallTotal;
  final String paymentMode;
  final String address;
  final String phone;
  int status;
  final DateTime timestamp;
  final String valetName;
  final String valetPhone;

  Order({
    required this.orderId,
    required this.productName,
    required this.productImage,
    required this.quantity,
    required this.price,
    required this.paymentMode,
    required this.address,
    required this.phone,
    this.status = 0,
    required this.overallTotal,
    required this.timestamp,
    required this.valetName,
    required this.valetPhone,
  });

  Order copyWith({
    String? orderId,
    int? status,
    String? phone,
    DateTime? timestamp,
  }) {
    return Order(
      orderId: orderId ?? this.orderId,
      productName: productName,
      productImage: productImage,
      quantity: quantity,
      price: price,
      paymentMode: paymentMode,
      address: address,
      status: status ?? this.status,
      phone: phone ?? this.phone,
      overallTotal: overallTotal,
      timestamp: timestamp ?? this.timestamp,
      valetName: valetName,
      valetPhone: valetPhone,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'orderId': orderId,
      'productName': productName,
      'productImage': productImage,
      'quantity': quantity,
      'price': price,
      'paymentMode': paymentMode,
      'address': address,
      'status': status,
      'phone': phone,
      'timestamp': timestamp.toIso8601String(),
      'overallTotal': overallTotal,
      'valetName': valetName,
      'valetPhone': valetPhone,
    };
  }

  factory Order.fromMap(Map<String, dynamic> map) {
    return Order(
      orderId: map['orderId'],
      productName: map['productName'],
      productImage: map['productImage'],
      quantity: map['quantity'],
      price: map['price'],
      paymentMode: map['paymentMode'],
      address: map['address'],
      status: map['status'],
      phone: map['phone'],
      overallTotal: map['overallTotal'],
      timestamp: DateTime.parse(map['timestamp']),
      valetName: map['valetName'],
      valetPhone: map['valetPhone'],
    );
  }
}

class OrderProvider with ChangeNotifier {
  List<Order> _orders = [];
  String _selectedPaymentMethod = 'Online';
  double delvChrg =  0;


  List<Order> get orders => _orders;
  String get selectedPaymentMethod => _selectedPaymentMethod;

  set selectedPaymentMethod(String value) {
    _selectedPaymentMethod = value;
    if(_selectedPaymentMethod == "Online" && isDeliveryFree!) {
      updateDeliveryCharge(0);
    }else{
      updateDeliveryCharge(deliveryCharge!);
    }
  }

  OrderProvider() {
    fetchOrders();
    if(_selectedPaymentMethod == "Online" && isDeliveryFree!) {
      updateDeliveryCharge(0);
    }else{
      updateDeliveryCharge(deliveryCharge!);
    }
  }

  void updateDeliveryCharge(double deliveryCharge) async {
    // bool isDeliveryFree = await fetchDeliveryChargeStatus();
    // // delvChrg = (selectedPaymentMethod == "Online" && isDeliveryFree) ? 0 : 29;
    // double charge = await fetchDeliveryCharge();

    delvChrg = deliveryCharge;

    notifyListeners();
  }

  Future<bool> fetchDeliveryChargeStatus() async {
    try {
      final querySnapshot = await FirebaseFirestore.instance.collection('constants').get();
      if (querySnapshot.docs.isNotEmpty) {
        return querySnapshot.docs.first.data()['isDeliveryFree'] as bool;
      }
    } catch (e) {
      // Handle errors appropriately
      print("Error fetching delivery charge status: $e");
    }
    return false; // Default value if there's an error or the document doesn't exist
  }

  void addOrders(List<Order> orders, String ordId, String phone) {
    DateTime now = DateTime.now();

    List<Order> newOrders = orders.map((order) => order.copyWith(orderId: ordId, phone: phone, timestamp: now)).toList();
    _orders.addAll(newOrders);

    _saveOrdersToFirebase(newOrders);
    _saveOrdersToPreferences();

    notifyListeners();
  }

  void _saveOrdersToFirebase(List<Order> orders) {
    if (orders.isEmpty) return;

    Map<String, dynamic> combinedOrderData = {
      'orderId': orders.first.orderId,
      'address': orders.first.address,
      'paymentMode': orders.first.paymentMode,
      'status': orders.first.status,
      'overallTotal': orders.first.overallTotal,
      'phone': orders.first.phone,
      'timestamp': orders.first.timestamp.toIso8601String(),
      'valetName': orders.first.valetName,
      'valetPhone': orders.first.valetPhone,
      'orders': orders.map((order) {
        return {
          'productName': order.productName,
          'productImage': order.productImage,
          'quantity': order.quantity,
          'price': order.price,
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
                  price: orderData['price'],
                  paymentMode: data['paymentMode'],
                  address: data['address'],
                  phone: data['phone'],
                  status: data['status'] ?? 0,
                  overallTotal: data['overallTotal'],
                  timestamp: DateTime.parse(data['timestamp']),
                  valetName: data['valetName'],
                  valetPhone: data['valetPhone'],
                ))
            .toList();
      }).toList();
    }

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
                  price: orderData['price'],
                  paymentMode: data['paymentMode'],
                  address: data['address'],
                  phone: data['phone'],
                  status: data['status'] ?? 0,
                  overallTotal: data['overallTotal'],
                  timestamp: DateTime.parse(data['timestamp']),
                  valetName: data['valetName'],
                  valetPhone: data['valetPhone'],
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
