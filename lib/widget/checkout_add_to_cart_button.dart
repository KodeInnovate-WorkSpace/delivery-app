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
  final bool? isOfferProduct;
  final String? catName;

  const CheckoutAddToCartButton({
    super.key,
    required this.productName,
    required this.productPrice,
    required this.productImage,
    required this.productUnit,
    this.isOfferProduct,
    this.catName,
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
      categoryName: widget.catName,
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
                  if (widget.isOfferProduct == true) {
                    // Handle offer products
                    bool isCategorySame = cartProvider.cartItems.any((item) => item.categoryName == cartItem.categoryName);

                    if (isCategorySame) {
                      // Remove the existing item in the same category
                      cartProvider.removeItemByCategory(cartItem.categoryName!);

                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text("You can avail the offer on only one product"),
                          duration: Duration(milliseconds: 600),
                          // backgroundColor: color,
                        ),
                      );
                    }

                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text("You can only add one product at a time"),
                        duration: Duration(milliseconds: 600),
                        // backgroundColor: color,
                      ),
                    );

                    // Add the new item
                    _count = 1; // Ensure count is set to 1 for offer products
                    cartProvider.addItem(cartItem);
                    _saveCartState();
                  } else {
                    // Handle non-offer products
                    _count++;
                    cartProvider.addItem(cartItem);
                    _saveCartState();
                  }
                });
              },
            ),
          ),
        ],
      ),
    );
  }
}
