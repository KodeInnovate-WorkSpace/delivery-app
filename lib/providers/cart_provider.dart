import 'dart:developer';

import 'package:flutter/cupertino.dart';

import '../models/cart_model.dart';

class CartProvider extends ChangeNotifier {
  final bool _isLoading = false;
  double deliveryCharge = 5;
  double handlingCharge = 10;

  final List<Cart> _cartItems = [];
  List<Cart> get cart => _cartItems;
  bool get isLoading => _isLoading;

  void addItem(Cart item) {
    final index =
        _cartItems.indexWhere((cartItem) => cartItem.itemName == item.itemName);
    if (index >= 0) {
      _cartItems[index].qnt++;
    } else {
      _cartItems.add(item);
    }
    logCartContents();
    notifyListeners();
  }

  void removeItem(Cart item) {
    final index =
        _cartItems.indexWhere((cartItem) => cartItem.itemName == item.itemName);
    if (index >= 0) {
      if (_cartItems[index].qnt > 1) {
        _cartItems[index].qnt--;
      } else {
        _cartItems.removeAt(index);
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

  void logCartContents() {
    log("Current cart contents:");
    for (var item in _cartItems) {
      log("Item: ${item.itemName}, Price: ${item.itemPrice}, Image: ${item.itemImage}, Unit: ${item.itemUnit}, Quantity: ${item.qnt}");
    }
  }
}
