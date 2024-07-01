import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:speedy_delivery/shared/constants.dart';
import 'package:speedy_delivery/providers/cart_provider.dart';
import 'package:speedy_delivery/widget/address_selection.dart';
import 'package:speedy_delivery/widget/apply_coupon_widget.dart';
import 'package:speedy_delivery/widget/bill_details_widget.dart';
import 'package:speedy_delivery/widget/display_cartItems.dart';
import '../providers/order_provider.dart';
import '../services/payment_button.dart';
import '../widget/network_handler.dart';

class CheckoutScreen extends StatefulWidget {
  const CheckoutScreen({super.key});

  @override
  State<CheckoutScreen> createState() => _CheckoutScreenState();
}

class _CheckoutScreenState extends State<CheckoutScreen> {
  String _selectedPaymentMethod = 'Banks';
  IconData _paymentIcon = Icons.account_balance;

  @override
  void initState() {
    super.initState();
    final orderProvider = Provider.of<OrderProvider>(context, listen: false);
  }

  @override
  Widget build(BuildContext context) {
    final cartProvider = Provider.of<CartProvider>(context);

    return NetworkHandler(
      child: Scaffold(
        resizeToAvoidBottomInset: true,
        appBar: AppBar(
          title: const Text('Checkout'),
        ),
        body: cartProvider.cart.isEmpty
            ? Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset("assets/images/empty.png"),
              const Text(
                "No item in cart",
                style: TextStyle(fontSize: 20),
              ),
            ],
          ),
        )
            : Stack(
          children: [
            Container(
              height: MediaQuery.of(context).size.height,
              color: const Color(0xffeaf1fc),
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Card(
                        elevation: 0,
                        color: Colors.white,
                        child: Padding(
                          padding: const EdgeInsets.all(18.0),
                          child: Row(
                            children: [
                              const Icon(Icons.timer),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'Delivery within $deliveryTime minutes',
                                      style: const TextStyle(fontSize: 18, fontFamily: 'Gilroy-ExtraBold'),
                                    ),
                                    const Text(
                                      'Shipment of 1 item',
                                      style: TextStyle(fontSize: 12, color: Colors.grey),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),
                      const DisplayCartItems(),
                      const SizedBox(height: 20),
                      const BillDetails(),
                      const SizedBox(height: 20),
                      const ApplyCouponWidget(),
                      const SizedBox(height: 20),
                      Container(
                        decoration: const BoxDecoration(
                          borderRadius: BorderRadius.all(Radius.circular(10)),
                          color: Colors.white,
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Column(
                            children: [
                              const AddressSelection(),
                              const Divider(),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceAround,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Row(
                                        crossAxisAlignment: CrossAxisAlignment.center,
                                        children: [
                                          Icon(
                                            _paymentIcon,
                                            size: 12,
                                          ),
                                          const SizedBox(width: 10),
                                          DropdownButton<String>(
                                            value: _selectedPaymentMethod,
                                            icon: const Icon(Icons.arrow_drop_down),
                                            iconSize: 24,
                                            elevation: 16,
                                            style: const TextStyle(color: Colors.black),
                                            underline: Container(),
                                            onChanged: (String? newValue) {
                                              setState(() {
                                                _selectedPaymentMethod = newValue!;
                                                _paymentIcon = newValue == 'Banks' ? Icons.account_balance : Icons.currency_rupee;
                                              });
                                            },
                                            items: <String>['Banks', 'Cash'].map<DropdownMenuItem<String>>((String value) {
                                              return DropdownMenuItem<String>(
                                                value: value,
                                                child: Text(value),
                                              );
                                            }).toList(),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                  PaymentButton(selectedMethod: _selectedPaymentMethod),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}