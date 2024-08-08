import 'dart:developer';

import 'package:flutter/material.dart';

class OfferCartProvider with ChangeNotifier {
  final Map<String, String> _cartItems = {};

  // Adds a product to the cart
  void addToCart(String categoryId, String productId) {
    // Remove the previous item from this category if exists
    if (_cartItems.containsKey(categoryId)) {
      _cartItems.remove(categoryId);
    }
    // Add the new item
    _cartItems[categoryId] = productId;
    log("Added to Offer Cart: ${_cartItems}");
    notifyListeners();
  }

  // Removes a product from the cart
  void removeItem(String productId) {
    _cartItems.removeWhere((key, value) => value == productId);
    notifyListeners();
  }

  // Checks if the cart contains an item from a category
  bool isItemInCart(String categoryId) {
    return _cartItems.containsKey(categoryId);
  }

  // Retrieves the product ID for a category
  String? getProductIdForCategory(String categoryId) {
    return _cartItems[categoryId];
  }
}
