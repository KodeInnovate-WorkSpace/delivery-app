import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:badges/badges.dart' as badges;
import '../providers/cart_provider.dart';
import '../screens/checkout_screen.dart';

class CartButton extends StatefulWidget {
  const CartButton({super.key});

  @override
  State<CartButton> createState() => _CartButtonState();
}

class _CartButtonState extends State<CartButton> {
  @override
  Widget build(BuildContext context) {
    return Positioned(
      bottom: 25,
      right: 20,
      child: Consumer<CartProvider>(
        builder: (context, cartProvider, child) {
          int itemCount = cartProvider.totalItemsCount(); // Assuming this method exists in CartProvider

          return Stack(
            alignment: Alignment.topRight,
            children: [
              FloatingActionButton(
                hoverColor: Colors.transparent,
                elevation: 2,
                onPressed: () {
                  HapticFeedback.vibrate();
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const CheckoutScreen()),
                  );
                  // Navigator.pushNamed(context, '/checkout');
                },
                backgroundColor: Colors.white,
                child: const Icon(
                  Icons.shopping_cart_sharp,
                  color: Colors.black,
                ),
              ),
              if (itemCount > 0)
                badges.Badge(
                  badgeContent: Padding(
                    padding: const EdgeInsets.all(2.0),
                    child: Text(
                      itemCount.toString(),
                      style: const TextStyle(color: Colors.white, fontFamily: 'Gilroy-SemiBold', fontSize: 10),
                    ),
                  ),
                  position: badges.BadgePosition.topEnd(top: 0, end: 0),
                  badgeStyle: const badges.BadgeStyle(
                    badgeColor: Colors.green,
                  ),
                ),
            ],
          );
        },
      ),
    );
  }
}
