import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:speedy_delivery/screens/offers_screens.dart';
import '../providers/cart_provider.dart';

class ApplyCouponWidget extends StatefulWidget {
  const ApplyCouponWidget({super.key});

  @override
  State<ApplyCouponWidget> createState() => _ApplyCouponWidgetState();
}

class _ApplyCouponWidgetState extends State<ApplyCouponWidget> {
  String? selectedOffer;
  double? selectedDiscount;

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
      setState(() {
        selectedOffer = offer['offerName'];
        selectedDiscount = offer['discount'].toDouble();
        Provider.of<CartProvider>(context, listen: false).applyCoupon(selectedOffer!, selectedDiscount!);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final cartProvider = Provider.of<CartProvider>(context);

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10), // Adjust the radius as needed
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1), // Shadow color
            spreadRadius: 2, // Spread radius
            blurRadius: 5, // Blur radius
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
        onTap: selectedOffer == null
            ? () async {
                final offer = await Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const OffersScreens()),
                );
                if (offer != null) {
                  setState(() {
                    selectedOffer = offer['offerName'];
                    selectedDiscount = offer['discount'].toDouble();
                    cartProvider.applyCoupon(selectedOffer!, selectedDiscount!);
                  });
                }
              }
            : null,
      ),
    );
  }
}
