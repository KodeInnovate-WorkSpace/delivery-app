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
  late CartProvider cartProvider;
  late Cart cartItem;

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
    cartProvider = Provider.of<CartProvider>(context, listen: true);
    cartItem = Cart(
      itemName: widget.productName,
      itemPrice: widget.productPrice,
      itemImage: widget.productImage,
      itemUnit: widget.productUnit,
    );

    // Update state based on provider
    _count = cartProvider.getItemCount(cartItem);
    _isClicked = _count > 0;

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
                //Remove button
                Expanded(
                  child: IconButton(
                    padding: EdgeInsets.zero,
                    constraints: const BoxConstraints(),
                    icon:
                        const Icon(Icons.remove, size: 15, color: Colors.white),
                    onPressed: () async {
                      setState(() {
                        if (_count > 1) {
                          _count--;
                          cartProvider.removeItem(cartItem);
                        } else if (_count == 1) {
                          _count--;
                          cartProvider.removeItem(cartItem);
                          _isClicked = false;
                        }
                        _saveCartState();
                      });
                      // Code for shared preference
                      // await cartProvider.saveCart();
                    },
                  ),
                ),
                // Item Count Display
                Text(
                  _count.toString(),
                  style: const TextStyle(
                    color: Colors.white,
                    fontFamily: 'Gilroy-SemiBold',
                    fontSize: 14,
                  ),
                ),
                // Add button
                Expanded(
                  child: IconButton(
                    padding: EdgeInsets.zero,
                    constraints: const BoxConstraints(),
                    icon: const Icon(Icons.add, size: 15, color: Colors.white),
                    onPressed: () async {
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
            onPressed: () async {
              setState(() {
                _isClicked = true;
                _count = 1;
                cartProvider.addItem(cartItem);
                _saveCartState();
              });
              // Code for shared preference
              await cartProvider.saveCart();
              // Show Snackbar
              // showMessage('${widget.productName} added to cart');
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
              minimumSize: WidgetStateProperty.all<Size>(const Size(70, 30)),
            ),
            child: const Text(
              'Add',
              style: TextStyle(
                fontSize: 12,
                color: Colors.green,
                fontFamily: 'Gilroy-SemiBold',
              ),
            ),
          );
  }
}
