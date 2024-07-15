import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:speedy_delivery/screens/offers_screens.dart';
import '../providers/cart_provider.dart';
import '../shared/constants.dart';

class ApplyCouponWidget extends StatefulWidget {
  const ApplyCouponWidget({super.key});

  @override
  State<ApplyCouponWidget> createState() => _ApplyCouponWidgetState();
}

class _ApplyCouponWidgetState extends State<ApplyCouponWidget> {
  String? selectedOffer;
  double? selectedDiscount;

  @override
  void initState() {
    super.initState();
    // Listen to changes in CartProvider
    final cartProvider = Provider.of<CartProvider>(context, listen: false);
    cartProvider.addListener(_updateCouponState);
  }

  @override
  void dispose() {
    // Remove listener to avoid memory leaks
    final cartProvider = Provider.of<CartProvider>(context, listen: false);
    cartProvider.removeListener(_updateCouponState);
    super.dispose();
  }

  void _updateCouponState() {
    final cartProvider = Provider.of<CartProvider>(context, listen: false);
    if (cartProvider.Discount == 0) {
      setState(() {
        selectedOffer = null;
        selectedDiscount = null;
      });
    }
  }

  void _removeCoupon() {
    setState(() {
      selectedOffer = null;
      selectedDiscount = null;
      Provider.of<CartProvider>(context, listen: false).clearCoupon();
    });
  }

  Future<void> applyCoupon(BuildContext context) async {
    final offer = await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const OffersScreens()),
    );
    if (offer != null) {
      final cartProvider = Provider.of<CartProvider>(context, listen: false);

      final delCharge = await fetchDeliveryCharge();

      cartProvider.applyCouponLogic(offer['offerName'], offer['discount'].toDouble());

      // Check if coupon was successfully applied
      if (cartProvider.Discount != 0) {
        setState(() {
          selectedOffer = offer['offerName'];
          selectedDiscount = offer['discount'].toDouble();
        });
      } else {
        setState(() {
          selectedOffer = null;
          selectedDiscount = null;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 2,
            blurRadius: 5,
            offset: const Offset(0, 2), // Shadow offset (x, y)
          ),
        ],
      ),
      child: ListTile(
        minLeadingWidth: 0,
        leading: const Icon(
          Icons.confirmation_number_sharp,
          color: Colors.black,
        ),
        title: Text(selectedOffer ?? "Apply Coupon"),
        trailing: selectedOffer == null
            ? const Icon(Icons.chevron_right_rounded)
            : IconButton(
                icon: const Icon(
                  Icons.delete,
                  size: 18,
                ),
                onPressed: _removeCoupon,
              ),
        onTap: selectedOffer == null ? () => applyCoupon(context) : null,
      ),
    );
  }
}
