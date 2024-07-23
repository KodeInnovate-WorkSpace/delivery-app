//Code Updated Removed Shared Preference
import 'package:flutter/cupertino.dart';
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
    // Load cart can be removed if we are not storing the cart persistently
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
    if (selectedPaymentMethod == "Online" && isDeliveryFree!) {
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
    notifyListeners();
  }

  void clearCart() {
    _cartItems.clear();
    clearCoupon();
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

      double total = calculateGrandTotal(selectedPaymentMethod) - _discount;

      if (total < maxTotalForCoupon!) {
        clearCoupon();
      }
    }

    logCartContents();
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
}