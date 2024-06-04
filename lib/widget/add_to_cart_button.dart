// Add -> Added
// import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';
// import 'package:speedy_delivery/providers/cart_provider.dart';
// import 'package:speedy_delivery/shared/show_msg.dart';
//
// import '../models/cart_model.dart';
//
// class AddToCartButton extends StatefulWidget {
//   final String productName;
//   final int productPrice;
//   final String productImage;
//   final String productUnit;
//
//   const AddToCartButton({
//     super.key,
//     required this.productName,
//     required this.productPrice,
//     required this.productImage,
//     required this.productUnit,
//   });
//
//   @override
//   AddToCartButtonState createState() => AddToCartButtonState();
// }
//
// class AddToCartButtonState extends State<AddToCartButton> with ChangeNotifier {
//   bool _isClicked = false;
//   int _count = 0;
//
//   @override
//   Widget build(BuildContext context) {
//     final cartProvider = Provider.of<CartProvider>(context, listen: false);
//     final cartItem = Cart(
//       itemName: widget.productName,
//       itemPrice: widget.productPrice,
//       itemImage: widget.productImage,
//       itemUnit: widget.productUnit,
//     );
//
//     return _isClicked
//         ? OutlinedButton(
//             onPressed: () {
//               setState(() {
//                 if (_count > 1) {
//                   _count--;
//                   cartProvider.removeItem(cartItem);
//                   notifyListeners();
//                 } else if (_count == 1) {
//                   _isClicked = false;
//                   _count--;
//                   cartProvider.removeItem(cartItem);
//                   showMessage("Item removed from cart");
//                   notifyListeners();
//                 }
//               });
//             },
//             style: ButtonStyle(
//               backgroundColor:
//                   WidgetStateProperty.all<Color>(Colors.transparent),
//               overlayColor: WidgetStateProperty.resolveWith<Color>(
//                 (Set<WidgetState> states) {
//                   if (states.contains(WidgetState.hovered)) {
//                     return Colors.green.withOpacity(0.1);
//                   }
//                   if (states.contains(WidgetState.pressed)) {
//                     return Colors.green.withOpacity(0.3);
//                   }
//                   return Colors.green.withOpacity(0.6);
//                 },
//               ),
//               side: WidgetStateProperty.all<BorderSide>(
//                   const BorderSide(color: Colors.green)),
//               shape: WidgetStateProperty.all<RoundedRectangleBorder>(
//                 const RoundedRectangleBorder(
//                   borderRadius: BorderRadius.all(Radius.circular(4)),
//                 ),
//               ),
//               minimumSize: WidgetStateProperty.all<Size>(
//                   const Size(70, 30)), // Consistent size
//             ),
//             child: const Text(
//               "Added",
//               style: TextStyle(
//                 fontSize: 12,
//                 color: Colors.green,
//                 fontFamily: 'Gilroy-SemiBold',
//               ),
//             ),
//           )
//         // Container(
//         //         width: 70,
//         //         height: 30,
//         //         decoration: BoxDecoration(
//         //           color: Colors.green,
//         //           borderRadius: BorderRadius.circular(5),
//         //         ),
//         //         child: Row(
//         //           mainAxisAlignment: MainAxisAlignment.center,
//         //           crossAxisAlignment: CrossAxisAlignment.center,
//         //           children: [
//         //             Expanded(
//         //               child: IconButton(
//         //                 padding: EdgeInsets.zero,
//         //                 constraints: const BoxConstraints(),
//         //                 icon:
//         //                     const Icon(Icons.remove, size: 15, color: Colors.white),
//         //                 onPressed: () {
//         //                   setState(() {
//         //                     if (_count > 1) {
//         //                       _count--;
//         //                       cartProvider.removeItem(cartItem);
//         //                     } else if (_count == 1) {
//         //                       _isClicked = false;
//         //                       _count--;
//         //                       cartProvider.removeItem(cartItem);
//         //                     }
//         //                   });
//         //                 },
//         //               ),
//         //             ),
//         //             Text(
//         //               cartProvider.itemCount(cartItem),
//         //               // "${cartProvider.cart.map((c) => c.qnt)}",
//         //
//         //               style: const TextStyle(
//         //                 color: Colors.white,
//         //                 fontFamily: 'Gilroy-SemiBold',
//         //                 fontSize: 14,
//         //               ),
//         //             ),
//         //             Expanded(
//         //               child: IconButton(
//         //                 padding: EdgeInsets.zero,
//         //                 constraints: const BoxConstraints(),
//         //                 icon: const Icon(Icons.add, size: 15, color: Colors.white),
//         //                 onPressed: () {
//         //                   setState(() {
//         //                     _count++;
//         //                     cartProvider.addItem(cartItem);
//         //                   });
//         //                 },
//         //               ),
//         //               ),
//         //             ),
//         //           ],
//         //         ),
//         //       )
//         : OutlinedButton(
//             onPressed: () {
//               setState(() {
//                 _isClicked = true;
//                 _count = 1; // Start with 1 when button is first clicked
//                 cartProvider.addItem(cartItem);
//                 showMessage("Item added to cart");
//               });
//             },
//             style: ButtonStyle(
//               backgroundColor:
//                   WidgetStateProperty.all<Color>(Colors.transparent),
//               overlayColor: WidgetStateProperty.resolveWith<Color>(
//                 (Set<WidgetState> states) {
//                   if (states.contains(WidgetState.hovered)) {
//                     return Colors.green.withOpacity(0.1);
//                   }
//                   if (states.contains(WidgetState.pressed)) {
//                     return Colors.green.withOpacity(0.3);
//                   }
//                   return Colors.green.withOpacity(0.6);
//                 },
//               ),
//               side: WidgetStateProperty.all<BorderSide>(
//                   const BorderSide(color: Colors.green)),
//               shape: WidgetStateProperty.all<RoundedRectangleBorder>(
//                 const RoundedRectangleBorder(
//                   borderRadius: BorderRadius.all(Radius.circular(4)),
//                 ),
//               ),
//               minimumSize: WidgetStateProperty.all<Size>(
//                   const Size(70, 30)), // Consistent size
//             ),
//             child: const Text(
//               "Add",
//               style: TextStyle(
//                 fontSize: 12,
//                 color: Colors.green,
//                 fontFamily: 'Gilroy-SemiBold',
//               ),
//             ),
//           );
//   }
// }

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:speedy_delivery/providers/cart_provider.dart';

import '../models/cart_model.dart';

class AddToCartButton extends StatefulWidget {
  final String productName;
  final int productPrice;
  final String productImage;
  final String productUnit;

  const AddToCartButton({
    super.key,
    required this.productName,
    required this.productPrice,
    required this.productImage,
    required this.productUnit,
  });

  @override
  AddToCartButtonState createState() => AddToCartButtonState();
}

class AddToCartButtonState extends State<AddToCartButton> {
  bool _isClicked = false;
  int _count = 0;
  late SharedPreferences _prefs;

  @override
  void initState() {
    super.initState();
    _loadCartState();
  }

  Future<void> _loadCartState() async {
    _prefs = await SharedPreferences.getInstance();
    setState(() {
      _isClicked = _prefs.getBool('isClicked${widget.productName}') ?? false;
      _count = _prefs.getInt('count${widget.productName}') ?? 0;
    });
  }

  Future<void> _saveCartState() async {
    await _prefs.setBool('isClicked${widget.productName}', _isClicked);
    await _prefs.setInt('count${widget.productName}', _count);
  }

  @override
  Widget build(BuildContext context) {
    final cartProvider = Provider.of<CartProvider>(context, listen: false);
    final cartItem = Cart(
      itemName: widget.productName,
      itemPrice: widget.productPrice,
      itemImage: widget.productImage,
      itemUnit: widget.productUnit,
    );

    return _isClicked
        ? Container(
            width: 70,
            height: 30,
            decoration: BoxDecoration(
              color: Colors.green,
              borderRadius: BorderRadius.circular(5),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Expanded(
                  child: IconButton(
                    padding: EdgeInsets.zero,
                    constraints: const BoxConstraints(),
                    icon:
                        const Icon(Icons.remove, size: 15, color: Colors.white),
                    onPressed: () {
                      setState(() {
                        if (_count > 1) {
                          _count--;
                          cartProvider.removeItem(cartItem);
                          _saveCartState();
                        } else if (_count == 1) {
                          _isClicked = false;
                          _count--;
                          cartProvider.removeItem(cartItem);
                          _saveCartState();
                        }
                      });
                    },
                  ),
                ),
                Text(
                  cartProvider.itemCount(cartItem),
                  style: const TextStyle(
                    color: Colors.white,
                    fontFamily: 'Gilroy-SemiBold',
                    fontSize: 14,
                  ),
                ),
                Expanded(
                  child: IconButton(
                    padding: EdgeInsets.zero,
                    constraints: const BoxConstraints(),
                    icon: const Icon(Icons.add, size: 15, color: Colors.white),
                    onPressed: () {
                      setState(() {
                        _count++;
                        cartProvider.addItem(cartItem);
                        _saveCartState();
                      });
                    },
                  ),
                ),
              ],
            ),
          )
        : OutlinedButton(
            onPressed: () {
              setState(() {
                _isClicked = true;
                _count = 1; // Start with 1 when button is first clicked
                cartProvider.addItem(cartItem);
                _saveCartState();
              });
            },
            style: ButtonStyle(
              backgroundColor:
                  WidgetStateProperty.all<Color>(Colors.transparent),
              overlayColor: WidgetStateProperty.resolveWith<Color>(
                (Set<WidgetState> states) {
                  if (states.contains(WidgetState.hovered)) {
                    return Colors.green.withOpacity(0.1);
                  }
                  if (states.contains(WidgetState.pressed)) {
                    return Colors.green.withOpacity(0.3);
                  }
                  return Colors.green.withOpacity(0.6);
                },
              ),
              side: WidgetStateProperty.all<BorderSide>(
                  const BorderSide(color: Colors.green)),
              shape: WidgetStateProperty.all<RoundedRectangleBorder>(
                const RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(4)),
                ),
              ),
              minimumSize: WidgetStateProperty.all<Size>(
                  const Size(70, 30)), // Consistent size
            ),
            child: const Text(
              "Add",
              style: TextStyle(
                fontSize: 12,
                color: Colors.green,
                fontFamily: 'Gilroy-SemiBold',
              ),
            ),
          );
  }
}
