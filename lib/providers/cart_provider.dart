import 'dart:convert';
import 'dart:developer';
import 'package:flutter/cupertino.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/cart_model.dart';
import '../services/convert_to_json.dart';

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

  void addItem(Cart item) async {
    final index =
        _cartItems.indexWhere((cartItem) => cartItem.itemName == item.itemName);
    // SharedPreferences prefs = await SharedPreferences.getInstance();

    if (index >= 0) {
      _cartItems[index].qnt++;
      // Update the stored value
      String jsonCart = cartToJson(_cartItems[index]);
      // await prefs.setString('cart_${item.itemName}', jsonCart);
    } else {
      _cartItems.add(item);
      // Convert the address to json
      String jsonCart = cartToJson(item);
      // Store in shared preferences
      // await prefs.setString('cart_${item.itemName}', jsonCart);
    }
    logCartContents();
    notifyListeners();
  }

  void removeItem(Cart item) async {
    final index =
        _cartItems.indexWhere((cartItem) => cartItem.itemName == item.itemName);
    // SharedPreferences prefs = await SharedPreferences.getInstance();

    if (index >= 0) {
      if (_cartItems[index].qnt > 1) {
        _cartItems[index].qnt--;
        // Update the stored value
        String jsonCart = cartToJson(_cartItems[index]);
        // await prefs.setString('cart_${item.itemName}', jsonCart);
      } else {
        _cartItems.removeAt(index);
        // Remove from shared preferences
        // await prefs.remove('cart_${item.itemName}');
      }
    }
    logCartContents();
    notifyListeners();
  }

  void clearCart() {
    _cartItems.clear();
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
    double grandTotal = calculateTotalPrice() + deliveryCharge + handlingCharge;
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
          Cart cartItem = Cart(
            itemName: cartMap['name'],
            itemPrice: cartMap['price'],
            itemImage: cartMap['image'],
            itemUnit: cartMap['unit'],
          );
          final index = _cartItems
              .indexWhere((item) => item.itemName == cartItem.itemName);
          if (index >= 0) {
            _cartItems[index].qnt++;
          } else {
            _cartItems.add(cartItem);
          }
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

// void addItem(Cart item) {
//   final index =
//       _cartItems.indexWhere((cartItem) => cartItem.itemName == item.itemName);
//   if (index != -1) {
//     _cartItems[index].qnt += item.qnt;
//   } else {
//     _cartItems.add(item);
//   }
//   notifyListeners();
// }
//
// void removeItem(Cart item) {
//   final index =
//       _cartItems.indexWhere((cartItem) => cartItem.itemName == item.itemName);
//   if (index != -1) {
//     if (_cartItems[index].qnt > 1) {
//       _cartItems[index].qnt -= item.qnt;
//     } else {
//       _cartItems.removeAt(index);
//     }
//   }
//   notifyListeners();
// }
//
// void clearCart() {
//   _cartItems = [];
//   notifyListeners();
// }
}
