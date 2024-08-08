import 'package:flutter/cupertino.dart';

class OfferCartProvider with ChangeNotifier {
  final Map<String, String> _cartItems = {};

  void addToCart(String categoryId, String productId) {
    // Remove any existing product in the same category
    _cartItems.remove(categoryId);

    // Add new product
    _cartItems[categoryId] = productId;

    notifyListeners();
  }

  Map<String, String> get cartItems => _cartItems;
}
