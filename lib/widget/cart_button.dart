import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:badges/badges.dart' as badges;
import '../providers/auth_provider.dart';
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

                 checkAppMaintenanceStatus(context);
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
  Future<void> checkAppMaintenanceStatus(BuildContext context) async {
    try {
      // Get the specific number from MyAuthProvider
      final specificNumber = Provider.of<MyAuthProvider>(context, listen: false).specificNumber;

      final QuerySnapshot snapshot = await FirebaseFirestore.instance.collection('AppMaintenance').get();
      for (var document in snapshot.docs) {
        var data = document.data() as Map<String, dynamic>;
        if (data['isAppEnabled'] == 0) {
          // Navigator.of(context).pushReplacement(
          //   MaterialPageRoute(
          //     builder: (context) => const ClosedScreen(),
          //   ),
          // );
          DateTime now = DateTime.now();

          // Get the current hour
          int currentHour = now.hour;

          // Check if current time is between 12 AM and 9 AM
          if (currentHour >= 0 && currentHour < 9) {
            _showSnackBar("Our App is currently closed. We’ll be back and ready to assist you at 9 AM. Thank you for your patience!", Colors.red);
          } else {
            _showSnackBar("We're currently closed for a moment. Please try again in a few minutes. Thank you for your understanding!", Colors.red);
          }
          return;
        }
        else{
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const CheckoutScreen()),
          );
        }
      }
    } catch (e) {
      log('Error checking app maintenance status: $e');
    }
  }

  void _showSnackBar(String message, Color color) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: color,
      ),
    );
  }
}
