import 'dart:developer';

import 'package:flutter/cupertino.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/cart_model.dart';
import 'package:flutter/material.dart';
import 'dart:convert' as convert;

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
    saveCart(); // Save cart state to SP after adding an item
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
        // Store in SP
        // saveCart();
        // Check if the cart is now empty
        if (_cartItems.isEmpty) {
          _cartItems.clear();
        }
      }
    }

    logCartContents();
    saveCart(); // Save cart state to SP after removing an item
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

  // loading and saving cart item for SP
  Future<void> loadCart() async {
    final List<Cart> cartItemsSP = await retrieveCart();
    _cartItems.clear(); // Clear existing cart items first
    _cartItems.addAll(cartItemsSP);
    notifyListeners();
  }

  Future<void> saveCart() async {
    await storeCart(_cartItems);
  }

  // Shared Preference
  static const String CARTITEM_KEY = 'cart_items';

  Future<void> storeCart(List<Cart> cartItems) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final String encodedCart =
          convert.jsonEncode(cartItems.map((item) => item.toJson()).toList());
      await prefs.setString(CARTITEM_KEY, encodedCart);
      log("Item Stored in SP");
    } catch (e) {
      log("Error storing cart in shared preference: $e");
    }
  }

  Future<List<Cart>> retrieveCart() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final String? encodedCart = prefs.getString(CARTITEM_KEY);
      if (encodedCart == null) {
        log("No cart data exists");
        return [];
      }
      final List<dynamic> decodedCart = convert.jsonDecode(encodedCart);
      return decodedCart.map((item) => Cart.fromJson(item)).toList();
    } catch (e) {
      log("Error retrieving cart for SP: $e");
      rethrow;
    }
  }

  // // final bool _isLoading = false;
  // final List<Cart> _cartItemsSP = [];
  // List<Cart> get cartSP => _cartItemsSP;
  // // bool get isLoading => _isLoading;
  //
  // void addToSP(Cart item) {
  //   final index =
  //       _cartItems.indexWhere((cartItem) => cartItem.itemName == item.itemName);
  //
  //   if (index >= 0) {
  //     _cartItems[index].qnt++;
  //   } else {
  //     _cartItems.add(item);
  //   }
  //   logCartContents();
  //   notifyListeners();
  // }
  //
  // void removeFromSP(Cart item) {
  //   final index = _cartItemsSP
  //       .indexWhere((cartItem) => cartItem.itemName == item.itemName);
  //
  //   if (index >= 0) {
  //     if (_cartItemsSP[index].qnt > 1) {
  //       _cartItemsSP[index].qnt--;
  //     } else {
  //       // Remove item from cart when quantity is 1 or 0
  //       _cartItemsSP.removeAt(index);
  //
  //       // Check if the cart is now empty
  //       if (_cartItemsSP.isEmpty) {
  //         _cartItemsSP.clear();
  //       }
  //     }
  //   }
  //
  //   logCartContents();
  //   notifyListeners();
  // }
  //
  // void storeInSP() {}
  //
  // void retrieveFromSP() {}
}
