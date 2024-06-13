//   import 'dart:math';
//
//   import 'package:flutter/material.dart';
//   import 'package:cloud_firestore/cloud_firestore.dart';
//
//   class Order {
//     final String orderId; // New field for order ID
//     final String productName;
//     final String productImage;
//     final int quantity;
//     final double price;
//     final double totalPrice;
//     final String paymentMode;
//     final String address;
//     final String phone;
//     final String transactionId;
//     final String userId;
//     int status;
//
//     Order({
//       required this.orderId, // Include order ID in the constructor
//       required this.productName,
//       required this.productImage,
//       required this.quantity,
//       required this.price,
//       required this.totalPrice,
//       required this.paymentMode,
//       required this.address,
//       required this.phone,
//       required this.transactionId,
//       required this.userId,
//       this.status = 0,
//     });
//
//     // Custom copyWith method
//     Order copyWith({
//       String? orderId,
//       int? status,
//     }) {
//       return Order(
//         orderId: orderId ?? this.orderId,
//         productName: productName,
//         productImage: productImage,
//         quantity: quantity,
//         price: price,
//         totalPrice: totalPrice,
//         paymentMode: paymentMode,
//         address: address,
//         phone: phone,
//         transactionId: transactionId,
//         userId: userId,
//         status: status ?? this.status,
//       );
//     }
//   }
//
//   class OrderProvider with ChangeNotifier {
//     List<Order> _orders = [];
//
//     List<Order> get orders => _orders;
//
//     OrderProvider() {
//       fetchOrders();
//     }
//
//     void addOrder(Order order) {
//       String orderId = _generateOrderId();
//       order = order.copyWith(orderId: orderId);
//
//       _orders.add(order);
//       FirebaseFirestore.instance.collection('OrderHistory').add({
//         'orderId': order.orderId,
//         'productName': order.productName,
//         'productImage': order.productImage,
//         'quantity': order.quantity,
//         'price': order.price,
//         'totalPrice': order.totalPrice,
//         'paymentMode': order.paymentMode,
//         'address': order.address,
//         'phone': order.phone,
//         'transactionId': order.transactionId,
//         'userId': order.userId,
//         'status': order.status,
//       });
//
//       notifyListeners();
//     }
//
//     String _generateOrderId() {
//       int randomNumber = Random().nextInt(9000) + 1000;
//       String timestamp = DateTime.now().millisecondsSinceEpoch.toString();
//       return 'ORD_${timestamp}_$randomNumber';
//     }
//
//
//     Future<void> fetchOrders() async {
//       final snapshot = await FirebaseFirestore.instance.collection('OrderHistory').get();
//       _orders = snapshot.docs.map((doc) {
//         final data = doc.data();
//         return Order(
//           orderId: data['orderId'],
//           productName: data['productName'],
//           productImage: data['productImage'],
//           quantity: data['quantity'],
//           price: data['price'],
//           totalPrice: data['totalPrice'],
//           paymentMode: data['paymentMode'],
//           address: data['address'],
//           phone: data['phone'],
//           transactionId: data['transactionId'],
//           userId: data['userId'],
//           status: data['status'] ?? 0,
//         );
//       }).toList();
//       notifyListeners();
//     }
//
//     Future<void> updateOrderStatus(Order order, int status) async {
//       int orderIndex = _orders.indexWhere((o) => o.orderId == order.orderId);
//       if (orderIndex != -1) {
//         _orders[orderIndex] = order.copyWith(status: status);
//         await FirebaseFirestore.instance
//             .collection('OrderHistory')
//             .doc(order.orderId)
//             .update({'status': status});
//         notifyListeners();
//       }
//     }
//
//     void deleteOrder(Order order) {
//       _orders.remove(order);
//       notifyListeners();
//     }
// // void deleteOrder(Order order) {
// //   _orders.remove(order);
// //   FirebaseFirestore.instance
// //       .collection('OrderHistory')
// //       .where('orderId', isEqualTo: order.orderId)
// //       .get()
// //       .then((snapshot) {
// //     for (var doc in snapshot.docs) {
// //       doc.reference.delete();
// //     }
// //   });
// //   notifyListeners();
// // }
// }
// import 'dart:math';
// import 'package:flutter/material.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
//
// class Order {
//   final String orderId;
//   final String productName;
//   final String productImage;
//   final int quantity;
//   final double price;
//   final double totalPrice;
//   final String paymentMode;
//   final String address;
//   final String phone;
//   final String transactionId;
//   final String userId;
//   int status;
//
//   Order({
//     required this.orderId,
//     required this.productName,
//     required this.productImage,
//     required this.quantity,
//     required this.price,
//     required this.totalPrice,
//     required this.paymentMode,
//     required this.address,
//     required this.phone,
//     required this.transactionId,
//     required this.userId,
//     this.status = 0,
//   });
//
//   Order copyWith({
//     String? orderId,
//     int? status,
//   }) {
//     return Order(
//       orderId: orderId ?? this.orderId,
//       productName: productName,
//       productImage: productImage,
//       quantity: quantity,
//       price: price,
//       totalPrice: totalPrice,
//       paymentMode: paymentMode,
//       address: address,
//       phone: phone,
//       transactionId: transactionId,
//       userId: userId,
//       status: status ?? this.status,
//     );
//   }
// }
//
// class OrderProvider with ChangeNotifier {
//   List<Order> _orders = [];
//
//   List<Order> get orders => _orders;
//
//   OrderProvider() {
//     fetchOrders();
//   }
//
//   void addOrders(List<Order> orders) {
//     String orderId = _generateOrderId();
//     List<Order> newOrders = orders.map((order) => order.copyWith(orderId: orderId)).toList();
//     _orders.addAll(newOrders);
//
//     for (var order in newOrders) {
//       FirebaseFirestore.instance.collection('OrderHistory').add({
//         'orderId': order.orderId,
//         'productName': order.productName,
//         'productImage': order.productImage,
//         'quantity': order.quantity,
//         'price': order.price,
//         'totalPrice': order.totalPrice,
//         'paymentMode': order.paymentMode,
//         'address': order.address,
//         'phone': order.phone,
//         'transactionId': order.transactionId,
//         'userId': order.userId,
//         'status': order.status,
//       });
//     }
//
//     notifyListeners();
//   }
//
//   String _generateOrderId() {
//     int randomNumber = Random().nextInt(9000) + 1000;
//     String timestamp = DateTime.now().millisecondsSinceEpoch.toString();
//     return 'ORD_${timestamp}_$randomNumber';
//   }
//
//   Future<void> fetchOrders() async {
//     final snapshot = await FirebaseFirestore.instance.collection('OrderHistory').get();
//     _orders = snapshot.docs.map((doc) {
//       final data = doc.data();
//       return Order(
//         orderId: data['orderId'],
//         productName: data['productName'],
//         productImage: data['productImage'],
//         quantity: data['quantity'],
//         price: data['price'],
//         totalPrice: data['totalPrice'],
//         paymentMode: data['paymentMode'],
//         address: data['address'],
//         phone: data['phone'],
//         transactionId: data['transactionId'],
//         userId: data['userId'],
//         status: data['status'] ?? 0,
//       );
//     }).toList();
//     notifyListeners();
//   }
//
//   Future<void> updateOrderStatus(Order order, int status) async {
//     int orderIndex = _orders.indexWhere((o) => o.orderId == order.orderId);
//     if (orderIndex != -1) {
//       _orders[orderIndex] = order.copyWith(status: status);
//       await FirebaseFirestore.instance
//           .collection('OrderHistory')
//           .doc(order.orderId)
//           .update({'status': status});
//       notifyListeners();
//     }
//   }
//
//   void deleteOrder(Order order) {
//     _orders.remove(order);
//     notifyListeners();
//   }
// }
import 'dart:convert'; // Add this import
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:shared_preferences/shared_preferences.dart';

// Add this import

class Order {
  final String orderId;
  final String productName;
  final String productImage;
  final int quantity;
  final double price;
  final double totalPrice;
  final String paymentMode;
  final String address;
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
    this.status = 0,
  });

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
      status: status ?? this.status,
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
    );
  }
}

class OrderProvider with ChangeNotifier {
  List<Order> _orders = [];

  List<Order> get orders => _orders;

  OrderProvider() {
    fetchOrders();
  }

  void addOrders(List<Order> orders) {
    String orderId = _generateOrderId();
    List<Order> newOrders =
        orders.map((order) => order.copyWith(orderId: orderId)).toList();
    _orders.addAll(newOrders);

    _saveOrdersToFirebase(newOrders);
    _saveOrdersToPreferences();

    notifyListeners();
  }

  void _saveOrdersToFirebase(List<Order> orders) {
    if (orders.isEmpty) return;

    // Calculate the overall total price including the fixed amount
    double overallTotal =
        orders.fold(0.0, (sum, order) => sum + order.totalPrice) + 30.85;

    // Combine orders into a single document
    Map<String, dynamic> combinedOrderData = {
      'orderId': orders.first.orderId,
      'address': orders.first.address,
      'paymentMode': orders.first.paymentMode,
      'status': orders.first.status,
      'overallTotal': overallTotal,
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

    FirebaseFirestore.instance
        .collection('OrderHistory')
        .doc(orders.first.orderId)
        .set(combinedOrderData);
  }

  String _generateOrderId() {
    int randomNumber = Random().nextInt(9000) + 1000;
    String timestamp = DateTime.now().millisecondsSinceEpoch.toString();
    return 'ORD_${timestamp}_$randomNumber';
  }

  Future<void> fetchOrders() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final String? ordersString = prefs.getString('orders');

    if (ordersString != null) {
      final List<dynamic> decodedList = jsonDecode(ordersString);
      _orders = decodedList.map((orderMap) => Order.fromMap(orderMap)).toList();
    } else {
      final snapshot =
          await FirebaseFirestore.instance.collection('OrderHistory').get();
      _orders = snapshot.docs.expand((doc) {
        final data = doc.data();
        List<dynamic> ordersData = data['orders'];
        return ordersData
            .map((orderData) => Order(
                  orderId: data['orderId'],
                  productName: orderData['productName'],
                  productImage: orderData['productImage'],
                  quantity: orderData['quantity'],
                  price:
                      0.0, // Since price is not stored in ordersData, set it to 0 or handle accordingly
                  totalPrice: orderData['totalPrice'],
                  paymentMode: data['paymentMode'],
                  address: data['address'],
                  status: data['status'] ?? 0,
                ))
            .toList();
      }).toList();
    }

    notifyListeners();
  }

  Future<void> updateOrderStatus(Order order, int status) async {
    int orderIndex = _orders.indexWhere((o) => o.orderId == order.orderId);
    if (orderIndex != -1) {
      _orders[orderIndex] = order.copyWith(status: status);
      await _updateOrderStatusInFirebase(order.orderId, status);
      _saveOrdersToPreferences();
      notifyListeners();
    }
  }

  Future<void> _updateOrderStatusInFirebase(String orderId, int status) async {
    final docRef =
        FirebaseFirestore.instance.collection('OrderHistory').doc(orderId);
    final doc = await docRef.get();
    if (doc.exists) {
      await docRef.update({'status': status});
    }
  }

  void deleteOrder(Order order) {
    _orders.remove(order);
    //_deleteOrderFromFirebase(order);
    _saveOrdersToPreferences();
    notifyListeners();
  }

  Future<void> _saveOrdersToPreferences() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final String encodedData =
        jsonEncode(_orders.map((order) => order.toMap()).toList());
    await prefs.setString('orders', encodedData);
  }
}

// void _deleteOrderFromFirebase(Order order) async {
//   final docRef = FirebaseFirestore.instance.collection('OrderHistory').doc(order.orderId);
//   final doc = await docRef.get();
//   if (doc.exists) {
//     final data = doc.data()!;
//     List<dynamic> ordersData = data['orders'];
//     ordersData.removeWhere((orderData) => orderData['productName'] == order.productName);
//     if (ordersData.isEmpty) {
//       await docRef.delete();
//     } else {
//       double overallTotal = ordersData.fold(0.0, (sum, orderData) => sum + orderData['totalPrice']) + 30.85;
//       await docRef.update({'orders': ordersData, 'overallTotal': overallTotal});
//     }
//   }
// }
