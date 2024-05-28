import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:speedy_delivery/providers/cart_provider.dart';

import '../models/cart_model.dart';

class AddToCartButton extends StatefulWidget {
  final String productName;
  final double productPrice;
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
        ? Row(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisSize: MainAxisSize.max,
      children: [
        Align(
          alignment: Alignment.centerRight,
          child: InkWell(
            onTap: () {
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
            child: Container(
              height: 35,
              width: 75,
              decoration: BoxDecoration(
                color: Colors.green,
                borderRadius: BorderRadius.circular(5),
              ),
              child: Padding(
                padding: const EdgeInsets.all(4.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    InkWell(
                      onTap: () {
                        setState(() {
                          if (_count > 1) {
                            _count--;
                            cartProvider.removeItem(cartItem);
                          }
                        });
                      },
                      child: const Icon(
                        Icons.remove,
                        color: Colors.white,
                        size: 15,
                      ),
                    ),
                    Text(
                      _count != 0 ? "$_count" : "Add",
                      style: const TextStyle(
                        color: Colors.white,
                        fontFamily: 'Gilroy-SemiBold',
                      ),
                    ),
                    InkWell(
                      onTap: () {
                        setState(() {
                          _count++;
                          cartProvider.addItem(cartItem);
                        });
                      },
                      child: const Icon(
                        Icons.add,
                        color: Colors.white,
                        size: 15,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
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
            }),
        side: WidgetStateProperty.all<BorderSide>(
            const BorderSide(color: Colors.green)),
        shape: WidgetStateProperty.all<RoundedRectangleBorder>(
          const RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(4)),
          ),
        ),
        minimumSize: WidgetStateProperty.all<Size>(const Size(75, 35)),
      ),
      child: const Text(
        "Add",
        style: TextStyle(
          color: Colors.green,
          fontFamily: 'Gilroy-SemiBold',
        ),
      ),
    );
  }
}
