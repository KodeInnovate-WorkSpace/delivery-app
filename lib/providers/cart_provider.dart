import 'package:flutter/cupertino.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:speedy_delivery/shared/show_msg.dart';
import '../models/cart_model.dart';
import 'package:flutter/material.dart';
import 'dart:convert' as convert;
import '../shared/constants.dart';
import 'dart:math';

class CartProvider extends ChangeNotifier {
  final bool _isLoading = false;
   bool isCouponApplied = false;
  final List<Cart> _cartItems = [];
  double _discount = 0.0;
  String? _selectedCoupon;
  String? selectedPaymentMethod = "Online";

  List<Cart> get cart => _cartItems;
  bool get isLoading => _isLoading;
  double get Discount => _discount;

  CartProvider() {
    loadCart();
  }

  double calculateTotalPrice() {
    double total = 0.0;
    for (var item in _cartItems) {
      total += item.itemPrice * item.qnt;
    }
    return total;
  }

  calculateGrandTotal([String? selectedValue]) {
    double finalDeliveryCharges = deliveryCharge!;
    selectedPaymentMethod = selectedValue;
    if(selectedPaymentMethod == "Online" && isDeliveryFree!){
      finalDeliveryCharges = 0;
    }

    final grandTotal = calculateTotalPrice() + (finalDeliveryCharges ?? 0) + calculateHandlingCharge() - _discount;
    calculateTotalDiscount(finalDeliveryCharges);
    return grandTotal.ceilToDouble();
  }

  double calculateTotalDiscount(double delCharge) {
    final grandTotal = calculateTotalPrice() + calculateHandlingCharge();
    double totalSave = 0;

    if (isCouponApplied) {
      totalSave = _discount + (delCharge == 0 ? deliveryCharge! : 0);
    } else if (delCharge == 0) {
      totalSave = deliveryCharge!;
    }

    return totalSave;
  }

  calculateHandlingCharge() {
    final totalPrice = calculateTotalPrice();
    final deliveryChargeValue = deliveryCharge ?? 0;
    final discountValue = _discount ?? 0;
    var handlingCharge = (totalPrice + deliveryChargeValue - discountValue) * 0.018;
    handlingCharge = max(handlingCharge, 1.8);
    return handlingCharge.floorToDouble();
    // return double.parse(handlingCharge.toStringAsFixed(2));
  }

  String itemCount(Cart item) {
    final index = _cartItems.indexWhere((cartItem) => cartItem.itemName == item.itemName);
    if (index >= 0) {
      return _cartItems[index].qnt.toString();
    } else {
      return "ADD";
    }
  }

  int getItemCount(Cart item) {
    final index = _cartItems.indexWhere((cartItem) => cartItem.itemName == item.itemName);
    if (index >= 0) {
      return _cartItems[index].qnt;
    } else {
      return 0;
    }
  }

  void applyCouponLogic(String coupon, double discount) {
    double grandTotal = calculateGrandTotal(selectedPaymentMethod);
    if (grandTotal > maxTotalForCoupon!) {
      _selectedCoupon = coupon;
      _discount = discount;
      isCouponApplied = true;
      notifyListeners();
    } else {
      clearCoupon();
      debugPrint("Your total is less than Rs. $maxTotalForCoupon, so this coupon cannot be applied.");
      showMessage("Your total is less than Rs. $maxTotalForCoupon, so this coupon cannot be applied.");
      notifyListeners();
    }
  }

  void clearCoupon() {
    _selectedCoupon = null;
    _discount = 0.0;
    isCouponApplied = false;
    notifyListeners(); // Notify listeners when coupon is cleared
  }

  void clearCart() {
    _cartItems.clear();
    clearCoupon();
    saveCart();
    notifyListeners();
  }

  void addItem(Cart item) {
    final index = _cartItems.indexWhere((cartItem) => cartItem.itemName == item.itemName);

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
    final index = _cartItems.indexWhere((cartItem) => cartItem.itemName == item.itemName);

    if (index >= 0) {
      if (_cartItems[index].qnt > 1) {
        _cartItems[index].qnt--;
      } else {
        _cartItems.removeAt(index);
        if (_cartItems.isEmpty) {
          _cartItems.clear();
        }
      }

      double total = calculateGrandTotal(selectedPaymentMethod) -_discount;

      // Check if grand total falls below threshold after removing item
       if (total < maxTotalForCoupon!) {
         clearCoupon();
       }
    }

    logCartContents();
    saveCart(); // Save cart state to SP after removing an item
    notifyListeners();
  }

  void applyDiscount(double discount) {
    _discount = discount;
    notifyListeners();
  }

  void logCartContents() {
    debugPrint("Current cart contents:");
    for (var item in _cartItems) {
      debugPrint("Item: ${item.itemName}, Price: ${item.itemPrice}, Image: ${item.itemImage}, Unit: ${item.itemUnit}, Quantity: ${item.qnt}");
    }
  }

  int totalItemsCount() {
    Set<String> itemNames = {};

    for (var item in _cartItems) {
      itemNames.add(item.itemName);
    }

    return itemNames.length;
  }

  Future<void> loadCart() async {
    final List<Cart> cartItemsSP = await retrieveCart();
    _cartItems.clear();
    _cartItems.addAll(cartItemsSP);
    notifyListeners();
  }

  Future<void> saveCart() async {
    await storeCart(_cartItems);
  }

  static const String CARTITEM_KEY = 'cart_items';

  Future<void> storeCart(List<Cart> cartItems) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final String encodedCart = convert.jsonEncode(cartItems.map((item) => item.toJson()).toList());
      await prefs.setString(CARTITEM_KEY, encodedCart);
      print("Item Stored in SP");
    } catch (e) {
      print("Error storing cart in shared preference: $e");
    }
  }

  Future<List<Cart>> retrieveCart() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final String? encodedCart = prefs.getString(CARTITEM_KEY);
      if (encodedCart == null) {
        print("No cart data exists");
        return [];
      }
      final List<dynamic> decodedCart = convert.jsonDecode(encodedCart);
      return decodedCart.map((item) => Cart.fromJson(item)).toList();
    } catch (e) {
      print("Error retrieving cart for SP: $e");
      rethrow;
    }
  }
}
