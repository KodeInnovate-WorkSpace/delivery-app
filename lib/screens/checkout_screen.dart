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
  // String _defaultAdd = "No address available";
  // String _newAdd = '';

  String _selectedPaymentMethod = 'Banks';

  @override
  void initState() {
    super.initState();
    final orderProvider = Provider.of<OrderProvider>(context, listen: false);
  }

  @override
  Widget build(BuildContext context) {
    // providers
    final cartProvider = Provider.of<CartProvider>(context);
    // final addressProvider = Provider.of<AddressProvider>(context);

    // if (addressProvider.address.isNotEmpty) {
    //   _defaultAdd = "${addressProvider.address[0].flat}, ${addressProvider.address[0].building}, ${addressProvider.address[0].mylandmark}";
    // }
    //
    // WidgetsBinding.instance.addPostFrameCallback((_) {
    //   if (mounted) {
    //     addressProvider.loadAddresses();
    //   }
    // });

    return NetworkHandler(
      child: Scaffold(
        resizeToAvoidBottomInset: true, // Enable auto-resizing when keyboard appears
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
                    height: MediaQuery.of(context).size.height, //covers the entire screen (responsive)
                    color: const Color(0xffeaf1fc), // Set the background color to grey
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: SingleChildScrollView(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Delivery information
                            Card(
                              elevation: 0,
                              color: Colors.white, // Set the card color to white
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
                            // Display cart items
                            const DisplayCartItems(),
                            const SizedBox(height: 20),
                            // Bill details
                            const BillDetails(),
                            const SizedBox(height: 20),

                            //Apply coupon
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
                                    //Address Selection
                                    const AddressSelection(),

                                    const Divider(),
                                    // payment mode | place order
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                                      crossAxisAlignment: CrossAxisAlignment.center,
                                      children: [
                                        Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            // payment mode dropdown
                                            Row(
                                              crossAxisAlignment: CrossAxisAlignment.center,
                                              children: [
                                                const Icon(
                                                  Icons.account_balance,
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
                                            // Text(_selectedPaymentMethod)
                                          ],
                                        ),
                                        //Payment Button
                                        PaymentButton(selectedMethod: _selectedPaymentMethod),
                                      ],
                                    )
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
