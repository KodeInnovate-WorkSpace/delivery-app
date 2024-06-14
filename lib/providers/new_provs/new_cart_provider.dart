import 'package:flutter/material.dart';

import '../../models/cart_model.dart';

class NewCartProvider extends ChangeNotifier {
  List<Cart> cart = [];

  int itemCount = 0;
  final index = 0;

  void addItem(Cart item) {
    final existingItem = cart.firstWhere(
      (cartItem) => cartItem.itemName == item.itemName,
      // orElse: () => null,
    );

    // Item already exists, increase quantity
    existingItem.qnt++;
      notifyListeners();
  }

  void removeItem(String itemName) {
    cart.removeWhere((item) => item.itemName == itemName);
    notifyListeners();
  }

  void updateCart(String itemName, int newQuantity) {
    final existingItem = cart.firstWhere(
      (cartItem) => cartItem.itemName == itemName,
      // orElse: () => null,
    );

    existingItem.qnt = newQuantity;
    if (newQuantity <= 0) {
      // Remove item if quantity becomes zero
      removeItem(itemName);
    }
    notifyListeners();
    }

  void deleteCartItem() {}
}
