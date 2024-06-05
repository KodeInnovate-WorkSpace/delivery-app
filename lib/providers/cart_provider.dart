// import 'dart:developer';
//
// import 'package:flutter/cupertino.dart';
//
// import '../models/cart_model.dart';
//
// class CartProvider extends ChangeNotifier {
//   final bool _isLoading = false;
//   double deliveryCharge = 5;
//   double handlingCharge = 10;
//
//   final List<Cart> _cartItems = [];
//   List<Cart> get cart => _cartItems;
//   bool get isLoading => _isLoading;
//
//   String itemCount(Cart item) {
//     final index =
//     _cartItems.indexWhere((cartItem) => cartItem.itemName == item.itemName);
//     notifyListeners();
//     return _cartItems[index].qnt.toString();
//   }
//
//   void addItem(Cart item) {
//     final index =
//     _cartItems.indexWhere((cartItem) => cartItem.itemName == item.itemName);
//     if (index >= 0) {
//       _cartItems[index].qnt++;
//     } else {
//       _cartItems.add(item);
//     }
//     logCartContents();
//     notifyListeners();
//   }
//
//   void removeItem(Cart item) {
//     final index =
//     _cartItems.indexWhere((cartItem) => cartItem.itemName == item.itemName);
//     if (index >= 0) {
//       if (_cartItems[index].qnt > 1) {
//         _cartItems[index].qnt--;
//       } else {
//         _cartItems.removeAt(index);
//       }
//     }
//     logCartContents();
//     notifyListeners();
//   }
//
//   double calculateTotalPrice() {
//     double totalPrice = 0.0;
//     for (var item in _cartItems) {
//       totalPrice += item.itemPrice * item.qnt;
//     }
//     return totalPrice;
//   }
//
//   double calculateGrandTotal() {
//     double grandTotal = 0.0;
//
//     grandTotal += calculateTotalPrice() + deliveryCharge + handlingCharge;
//     return grandTotal;
//   }
//
//   void logCartContents() {
//     log("Current cart contents:");
//     for (var item in _cartItems) {
//       log("Item: ${item.itemName}, Price: ${item.itemPrice}, Image: ${item.itemImage}, Unit: ${item.itemUnit}, Quantity: ${item.qnt}");
//     }
//   }
// }

import 'dart:convert';
import 'dart:developer';

import 'package:flutter/cupertino.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../models/cart_model.dart';
import '../services/convert_to_json.dart';

class CartProvider extends ChangeNotifier {
  final bool _isLoading = false;
  double deliveryCharge = 5;
  double handlingCharge = 10;

  final List<Cart> _cartItems = [];
  List<Cart> get cart => _cartItems;
  bool get isLoading => _isLoading;

  String itemCount(Cart item) {
    final index =
        _cartItems.indexWhere((cartItem) => cartItem.itemName == item.itemName);
    if (index >= 0) {
      // Check if item exists before accessing it
      return _cartItems[index].qnt.toString();
    } else {
      return "ADD"; // Or any default value you prefer
    }
  }
  // String itemCount(Cart item) {
  //   final index =
  //       _cartItems.indexWhere((cartItem) => cartItem.itemName == item.itemName);
  //   notifyListeners();
  //   return _cartItems[index].qnt.toString();
  // }

  void addItem(Cart item) async {
    final index =
        _cartItems.indexWhere((cartItem) => cartItem.itemName == item.itemName);
    if (index >= 0) {
      _cartItems[index].qnt++;
    } else {
      _cartItems.add(item);

      // Convert the address to json
      String jsonCart = cartToJson(item);

      // Store in shared preferences
      SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.setString('cart_${item.itemName}', jsonCart);
    }
    logCartContents();
    notifyListeners();
  }

  void removeItem(Cart item) async {
    final index =
        _cartItems.indexWhere((cartItem) => cartItem.itemName == item.itemName);
    if (index >= 0) {
      if (_cartItems[index].qnt > 1) {
        _cartItems[index].qnt--;
      } else {
        _cartItems.removeAt(index);
        // Remove from shared preferences
        SharedPreferences prefs = await SharedPreferences.getInstance();
        await prefs.remove('cart_${item.itemName}');
      }
    }
    logCartContents();
    notifyListeners();
  }

  double calculateTotalPrice() {
    double totalPrice = 0.0;
    for (var item in _cartItems) {
      totalPrice += item.itemPrice * item.qnt;
    }
    return totalPrice;
  }

  double calculateGrandTotal() {
    double grandTotal = 0.0;

    grandTotal += calculateTotalPrice() + deliveryCharge + handlingCharge;
    return grandTotal;
  }

  Future<Cart?> getCartItems(String itemName) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? cartJson = prefs.getString('cart_$itemName');
    if (cartJson != null) {
      Map<String, dynamic> cartMap = json.decode(cartJson);
      return Cart(
        itemName: cartMap['name'],
        itemPrice: cartMap['price'],
        itemImage: cartMap['image'],
        itemUnit: cartMap['unit'],
        qnt: cartMap['qnt'],
      );
    }
    return null;
  }

  Future<void> loadCart() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final keys = prefs.getKeys();

    _cartItems.clear();
    for (String key in keys) {
      if (key.startsWith('cart_')) {
        String? cartJson = prefs.getString(key);
        if (cartJson != null) {
          Map<String, dynamic> cartMap = json.decode(cartJson);
          _cartItems.add(Cart(
            itemName: cartMap['name'],
            itemPrice: cartMap['price'],
            itemImage: cartMap['image'],
            itemUnit: cartMap['unit'],
            qnt: cartMap['qnt'],
          ));
        }
      }
    }
    notifyListeners();
  }

  void logCartContents() {
    log("Current cart contents:");
    for (var item in _cartItems) {
      log("Item: ${item.itemName}, Price: ${item.itemPrice}, Image: ${item.itemImage}, Unit: ${item.itemUnit}, Quantity: ${item.qnt}");
    }
  }
}
