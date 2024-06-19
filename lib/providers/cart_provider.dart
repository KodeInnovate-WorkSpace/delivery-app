import 'package:flutter/cupertino.dart';
import '../models/cart_model.dart';
import 'package:flutter/material.dart';

class CartProvider extends ChangeNotifier {
  final bool _isLoading = false;
  double deliveryCharge = 29;
  double handlingCharge = 1.85;

  final List<Cart> _cartItems = [];
  List<Cart> get cart => _cartItems;
  bool get isLoading => _isLoading;

  String itemCount(Cart item) {
    final index =
    _cartItems.indexWhere((cartItem) => cartItem.itemName == item.itemName);
    if (index >= 0) {
      return _cartItems[index].qnt.toString();
    } else {
      return "ADD";
    }
  }

  int getItemCount(Cart item) {
    final index =
    _cartItems.indexWhere((cartItem) => cartItem.itemName == item.itemName);
    if (index >= 0) {
      return _cartItems[index].qnt;
    } else {
      return 0;
    }
  }

  void clearCart() {
    _cartItems.clear();
    notifyListeners();
  }

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
        // Remove item from cart when quantity is 1 or 0
        _cartItems.removeAt(index);

        // Check if the cart is now empty
        if (_cartItems.isEmpty) {
          _cartItems.clear();
        }
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
    debugPrint("Current cart contents:");
    for (var item in _cartItems) {
      debugPrint(
          "Item: ${item.itemName}, Price: ${item.itemPrice}, Image: ${item.itemImage}, Unit: ${item.itemUnit}, Quantity: ${item.qnt}");
    }
  }

  // New method to get the total count of items in the cart
  int totalItemsCount() {
    // Create a set to store unique item names
    Set<String> itemNames = {};

    // Iterate through _cartItems and add unique item names to the set
    for (var item in _cartItems) {
      itemNames.add(item.itemName);
    }

    // Return the size of the set, which represents the count of unique items
    return itemNames.length;
  }

}