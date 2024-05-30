import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:speedy_delivery/providers/cart_provider.dart';

import '../models/cart_model.dart';

class AddToCartButton extends StatefulWidget {
  final String productName;
  final int productPrice;
  final String productImage;
  final int productUnit;

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

  @override
  Widget build(BuildContext context) {
    final cartProvider = Provider.of<CartProvider>(context, listen: false);
    final cartItem = Cart(
      itemName: widget.productName,
      itemPrice: widget.productPrice,
      itemImage: widget.productImage,
      itemUnit: widget.productUnit,
    );

    return Container(
      decoration: BoxDecoration(
        color: Colors.green,
        borderRadius: BorderRadius.circular(5),
      ),
      height: 30,
      width: 70, // Ensure this size is consistent for both states
      child: _isClicked
          ? Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                IconButton(
                  padding: EdgeInsets.zero,
                  constraints: const BoxConstraints(),
                  icon: const Icon(Icons.remove, size: 15, color: Colors.black),
                  onPressed: () {
                    setState(() {
                      if (_count > 1) {
                        _count--;
                        cartProvider.removeItem(cartItem);
                      } else if (_count == 1) {
                        _isClicked = false;
                        _count--;
                        cartProvider.removeItem(cartItem);
                      }
                    });
                  },
                ),
                Text(
                  "$_count",
                  style: const TextStyle(
                    color: Colors.black,
                    fontFamily: 'Gilroy-SemiBold',
                    fontSize: 14,
                  ),
                ),
                IconButton(
                  padding: EdgeInsets.zero,
                  constraints: const BoxConstraints(),
                  icon: const Icon(Icons.add, size: 15, color: Colors.black),
                  onPressed: () {
                    setState(() {
                      _count++;
                      cartProvider.addItem(cartItem);
                    });
                  },
                ),
              ],
            )
          : OutlinedButton(
              onPressed: () {
                setState(() {
                  _isClicked = true;
                  _count = 1; // Start with 1 when button is first clicked
                  cartProvider.addItem(cartItem);
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
                  color: Colors.white,
                  fontFamily: 'Gilroy-SemiBold',
                ),
              ),
            ),
    );
  }
}
