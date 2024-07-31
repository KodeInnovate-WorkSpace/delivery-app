import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:speedy_delivery/providers/cart_provider.dart';

import '../models/cart_model.dart';

class CheckoutAddToCartButton extends StatefulWidget {
  final String productName;
  final int productPrice;
  final String productImage;
  final String productUnit;
  final int productSubCat;

  const CheckoutAddToCartButton({
    super.key,
    required this.productName,
    required this.productPrice,
    required this.productImage,
    required this.productUnit,
    required this.productSubCat,
  });

  @override
  CheckoutAddToCartButtonState createState() => CheckoutAddToCartButtonState();
}

class CheckoutAddToCartButtonState extends State<CheckoutAddToCartButton> {
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
      itemSubCat: widget.productSubCat,
    );

    return Container(
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
              icon: const Icon(Icons.remove, size: 15, color: Colors.white),
              onPressed: () {
                setState(() {
                  cartProvider.removeItem(cartItem);
                  _saveCartState();
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
    );
  }
}
