import 'package:flutter/material.dart';

class ApplyCouponWidget extends StatefulWidget {
  const ApplyCouponWidget({super.key});

  @override
  State<ApplyCouponWidget> createState() => _ApplyCouponWidgetState();
}

class _ApplyCouponWidgetState extends State<ApplyCouponWidget> {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.height / 12,
      decoration: BoxDecoration(
        color: Colors.black,
      ),
      child: Text("Apply Coupon"),
    );
  }
}
