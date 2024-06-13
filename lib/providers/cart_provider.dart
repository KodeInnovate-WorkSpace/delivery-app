import 'package:flutter/cupertino.dart';
import '../models/cart_model.dart';
import 'package:flutter/material.dart';

// class CartProvider extends ChangeNotifier {
//   final bool _isLoading = false;
//   double deliveryCharge = 29;
//   double handlingCharge = 1.85;
//
//   // convenience fee 1.85%
//
//   final List<Cart> _cartItems = [];
//   List<Cart> get cart => _cartItems;
//   bool get isLoading => _isLoading;
//
//   String itemCount(Cart item) {
//     final index =
//     _cartItems.indexWhere((cartItem) => cartItem.itemName == item.itemName);
//     if (index >= 0) {
//       // Check if item exists before accessing it
//       return _cartItems[index].qnt.toString();
//     } else {
//       return "ADD"; // Or any default value you prefer
//     }
//   }
//   void clearCart() {
//     _cartItems.clear();
//     notifyListeners();
//   }
//   // new add item
//   void addItem(Cart item) async {
//     final index =
//     _cartItems.indexWhere((cartItem) => cartItem.itemName == item.itemName);
//     SharedPreferences prefs = await SharedPreferences.getInstance();
//
//     if (index >= 0) {
//       _cartItems[index].qnt++;
//       // Update the stored value
//       String jsonCart = cartToJson(_cartItems[index]);
//       await prefs.setString('cart_${item.itemName}', jsonCart);
//     } else {
//       _cartItems.add(item);
//       // Convert the address to json
//       String jsonCart = cartToJson(item);
//       // Store in shared preferences
//       await prefs.setString('cart_${item.itemName}', jsonCart);
//     }
//     logCartContents();
//     notifyListeners();
//   }
//
//   // new remove item
//   void removeItem(Cart item) async {
//     final index =
//     _cartItems.indexWhere((cartItem) => cartItem.itemName == item.itemName);
//     SharedPreferences prefs = await SharedPreferences.getInstance();
//
//     if (index >= 0) {
//       if (_cartItems[index].qnt > 1) {
//         _cartItems[index].qnt--;
//         // Update the stored value
//         String jsonCart = cartToJson(_cartItems[index]);
//         await prefs.setString('cart_${item.itemName}', jsonCart);
//       } else {
//         _cartItems.removeAt(index);
//         // Remove from shared preferences
//         await prefs.remove('cart_${item.itemName}');
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
//   Future<Cart?> getCartItems(String itemName) async {
//     SharedPreferences prefs = await SharedPreferences.getInstance();
//     String? cartJson = prefs.getString('cart_$itemName');
//     Map<String, dynamic> cartMap = json.decode(cartJson!);
//     return Cart(
//       itemName: cartMap['name'],
//       itemPrice: cartMap['price'],
//       itemImage: cartMap['image'],
//       itemUnit: cartMap['unit'],
//     );
//   }
//
//   // Future<void> loadCart() async {
//   //   SharedPreferences prefs = await SharedPreferences.getInstance();
//   //   final keys = prefs.getKeys();
//   //
//   //   _cartItems.clear();
//   //   for (String key in keys) {
//   //     if (key.startsWith('cart_')) {
//   //       String? cartJson = prefs.getString(key);
//   //       if (cartJson != null) {
//   //         Map<String, dynamic> cartMap = json.decode(cartJson);
//   //         _cartItems.add(Cart(
//   //           itemName: cartMap['name'],
//   //           itemPrice: cartMap['price'],
//   //           itemImage: cartMap['image'],
//   //           itemUnit: cartMap['unit'],
//   //         ));
//   //       }
//   //     }
//   //   }
//   //   notifyListeners();
//   // }
//
//   Future<void> loadCart() async {
//     SharedPreferences prefs = await SharedPreferences.getInstance();
//     final keys = prefs.getKeys();
//
//     _cartItems.clear();
//     for (String key in keys) {
//       if (key.startsWith('cart_')) {
//         String? cartJson = prefs.getString(key);
//         Map<String, dynamic> cartMap = json.decode(cartJson!);
//         Cart cartItem = Cart(
//           itemName: cartMap['name'],
//           itemPrice: cartMap['price'],
//           itemImage: cartMap['image'],
//           itemUnit: cartMap['unit'],
//         );
//         // Check if the item already exists in _cartItems
//         final index =
//         _cartItems.indexWhere((item) => item.itemName == cartItem.itemName);
//         if (index >= 0) {
//           // If it exists, update the quantity
//           _cartItems[index].qnt++;
//         } else {
//           // If it doesn't exist, add it to _cartItems
//           _cartItems.add(cartItem);
//         }
//       }
//     }
//     notifyListeners();
//   }
//
//   void logCartContents() {
//     log("Current cart contents:");
//     for (var item in _cartItems) {
//       log("Item: ${item.itemName}, Price: ${item.itemPrice}, Image: ${item.itemImage}, Unit: ${item.itemUnit}, Quantity: ${item.qnt}");
//     }
//   }
// }

// new cart provider
// class CartProvider extends ChangeNotifier {
//   final bool _isLoading = false;
//   double deliveryCharge = 29;
//   double handlingCharge = 1.85;
//
//   // Convenience fee 1.85%
//   final List<Cart> _cartItems = [];
//   List<Cart> get cart => _cartItems;
//   bool get isLoading => _isLoading;
//
//   String itemCount(Cart item) {
//     final index =
//         _cartItems.indexWhere((cartItem) => cartItem.itemName == item.itemName);
//     if (index >= 0) {
//       // Check if item exists before accessing it
//       return _cartItems[index].qnt.toString();
//     } else {
//       return "ADD"; // Or any default value you prefer
//     }
//   }
//
//   void clearCart() {
//     _cartItems.clear();
//     notifyListeners();
//   }
//
//   // Add item to the cart
//   void addItem(Cart item) {
//     final index =
//         _cartItems.indexWhere((cartItem) => cartItem.itemName == item.itemName);
//
//     if (index >= 0) {
//       _cartItems[index].qnt++;
//     } else {
//       _cartItems.add(item);
//     }
//     logCartContents();
//     notifyListeners();
//   }
//
//   // Remove item from the cart
//   void removeItem(Cart item) {
//     final index =
//         _cartItems.indexWhere((cartItem) => cartItem.itemName == item.itemName);
//
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
}
