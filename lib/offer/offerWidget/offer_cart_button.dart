import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:speedy_delivery/offer/offerProvider/offerCartProvider.dart';

class OfferCartButton extends StatefulWidget {
  final String categoryId;
  final String productId;
  final String productName;
  final String productPrice;
  final String productImage;
  final String productUnit;

  const OfferCartButton({
    super.key,
    required this.categoryId,
    required this.productId,
    required this.productName,
    required this.productPrice,
    required this.productImage,
    required this.productUnit,
  });

  @override
  State<OfferCartButton> createState() => _OfferCartButtonState();
}

class _OfferCartButtonState extends State<OfferCartButton> {
  late OfferCartProvider _cartProvider;
  bool _isAdded = false;

  @override
  void initState() {
    super.initState();
    _cartProvider = Provider.of<OfferCartProvider>(context, listen: false);
    // Check if the current product is already in the cart
    _isAdded = _cartProvider.getProductIdForCategory(widget.categoryId) == widget.productId;
  }

  @override
  Widget build(BuildContext context) {
    return _isAdded
        ? Container(
            width: 70,
            height: 30,
            decoration: BoxDecoration(
              color: Colors.green,
              borderRadius: BorderRadius.circular(5),
            ),
            child: Center(
              child: Text(
                'Added',
                style: const TextStyle(color: Colors.white, fontFamily: 'Gilroy-SemiBold'),
              ),
            ),
          )
        : OutlinedButton(
            onPressed: () {
              setState(() {
                _cartProvider.addToCart(widget.categoryId, widget.productId);
                _isAdded = true;
              });
            },
            style: ButtonStyle(
              backgroundColor: WidgetStateProperty.all<Color>(Colors.transparent),
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
              side: WidgetStateProperty.all<BorderSide>(const BorderSide(color: Colors.green)),
              shape: WidgetStateProperty.all<RoundedRectangleBorder>(
                const RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(4)),
                ),
              ),
              minimumSize: WidgetStateProperty.all<Size>(const Size(70, 30)),
            ),
            child: const Text(
              'Add',
              style: TextStyle(fontSize: 12, color: Colors.green, fontFamily: 'Gilroy-SemiBold'),
            ),
          );
  }
}
