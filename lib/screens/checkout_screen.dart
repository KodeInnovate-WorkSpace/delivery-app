import 'dart:developer';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:speedy_delivery/providers/address_provider.dart';
import 'package:speedy_delivery/providers/cart_provider.dart';
import 'package:speedy_delivery/shared/show_msg.dart';

import '../payment/cf_payment_screen.dart';
import '../services/payment_service.dart';
import '../widget/add_to_cart_button.dart';
import '../widget/network_handler.dart';
import 'address_input.dart';
import 'order_confirmation_screen.dart';

class CheckoutScreen extends StatefulWidget {
  const CheckoutScreen({super.key});

  @override
  State<CheckoutScreen> createState() => _CheckoutScreenState();
}

class _CheckoutScreenState extends State<CheckoutScreen> with ChangeNotifier {
  String _defaultAdd = "No address available";
  String _newAdd = 'No address selected';
  String _selectedPaymentMethod = 'Banks';

  @override
  Widget build(BuildContext context) {
    // providers
    final cartProvider = Provider.of<CartProvider>(context);
    final addressProvider = Provider.of<AddressProvider>(context);

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        addressProvider.loadAddresses().then((_) {
          setState(() {
            if (addressProvider.address.isNotEmpty) {
              _defaultAdd =
                  "${addressProvider.address[0].flat}, ${addressProvider.address[0].building}, ${addressProvider.address[0].mylandmark}";
            } else {
              _defaultAdd =
                  "No address available"; // Set default message if empty
            }
          });
        });
      }
    });
    cartProvider.loadCart();

    setState(() {
      if (addressProvider.address.isNotEmpty) {
        _defaultAdd =
            "${addressProvider.address[0].flat}, ${addressProvider.address[0].building}, ${addressProvider.address[0].mylandmark}";
      }
    });
    return NetworkHandler(
      child: Scaffold(
        resizeToAvoidBottomInset:
            true, // Enable auto-resizing when keyboard appears
        appBar: AppBar(
          title: const Text('Checkout'),
        ),
        body: Stack(
          children: [
            Container(
              height: MediaQuery.of(context)
                  .size
                  .height, //covers the entire screen (responsive)
              color:
                  const Color(0xffeaf1fc), // Set the background color to grey
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Delivery information
                      const Card(
                        elevation: 0,
                        color: Colors.white, // Set the card color to white
                        child: Padding(
                          padding: EdgeInsets.all(18.0),
                          child: Row(
                            children: [
                              Icon(Icons.timer),
                              SizedBox(width: 12),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'Delivery in 7 minutes',
                                      style: TextStyle(
                                          fontSize: 18,
                                          fontFamily: 'Gilroy-ExtraBold'),
                                    ),
                                    Text(
                                      'Shipment of 1 item',
                                      style: TextStyle(
                                          fontSize: 12, color: Colors.grey),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(height: 10),
                      // Display cart items
                      if (cartProvider.cart.isEmpty)
                        Center(
                          child: Column(children: [
                            Image.asset("assets/images/empty.png"),
                            const Text(
                              "No item in cart",
                              style: TextStyle(fontSize: 20),
                            ),
                          ]),
                        ),
                      if (cartProvider.cart.isNotEmpty)
                        ...cartProvider.cart.map((item) {
                          return Card(
                            elevation: 0,
                            color: Colors.white,
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Row(
                                children: [
                                  CachedNetworkImage(
                                    imageUrl: item.itemImage,
                                    width: 50,
                                    height: 50,
                                  ),
                                  const SizedBox(width: 15),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        // Item name
                                        Text(
                                          item.itemName,
                                          style: const TextStyle(fontSize: 16),
                                        ),
                                        // Item Unit kg, g, L, etc
                                        Text(
                                          item.itemUnit.toString(),
                                          style: const TextStyle(
                                              color: Colors.grey),
                                        ),
                                        const SizedBox(height: 4),
                                        // Item price
                                        Text(
                                          'Total: ₹${item.itemPrice * item.qnt}',
                                          style: const TextStyle(
                                            fontSize: 14,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  const SizedBox(width: 2),

                                  //add to Cart button
                                  Column(
                                    children: [
                                      AddToCartButton(
                                        productName: item.itemName,
                                        productPrice: item.itemPrice,
                                        productImage: item.itemImage,
                                        productUnit: item.itemUnit,
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          );
                        }),
                      const SizedBox(height: 10),
                      // Bill details
                      const SizedBox(height: 10),
                      Card(
                        color: Colors.white, // Set the card color to white
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text('Bill details',
                                  style: TextStyle(
                                      fontSize: 18,
                                      fontFamily: 'Gilroy-Black')),
                              // Row 1
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  const Row(
                                    children: [
                                      Icon(
                                        Icons.receipt_long,
                                        size: 14,
                                      ),
                                      SizedBox(width: 4),
                                      Text('Item total',
                                          style: TextStyle(fontSize: 14)),
                                    ],
                                  ),
                                  Align(
                                    alignment: Alignment.centerRight,
                                    child: Text(
                                      '\u20B9 ${cartProvider.calculateTotalPrice()}',
                                      style: const TextStyle(fontSize: 14),
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 4),
                              // Row 2
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  const Row(
                                    children: [
                                      Icon(
                                        Icons.sports_motorsports,
                                        size: 14,
                                      ),
                                      SizedBox(width: 4),
                                      Text('Delivery Charge',
                                          style: TextStyle(fontSize: 14)),
                                    ],
                                  ),
                                  Align(
                                    alignment: Alignment.centerRight,
                                    child: Text(
                                        '\u20B9 ${cartProvider.deliveryCharge}',
                                        style: const TextStyle(fontSize: 14)),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 4),
                              // Row 3
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  const Row(
                                    children: [
                                      Icon(
                                        Icons.shopping_bag,
                                        size: 14,
                                      ),
                                      SizedBox(width: 4),
                                      Text('Convenience Fee',
                                          style: TextStyle(fontSize: 14)),
                                    ],
                                  ),
                                  Align(
                                    alignment: Alignment.centerRight,
                                    child: Text(
                                        '\u20B9 ${cartProvider.handlingCharge}',
                                        style: const TextStyle(fontSize: 14)),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 4),
                              // Row 4
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  const Text('Grand total',
                                      style: TextStyle(
                                          fontSize: 16,
                                          fontFamily: 'Gilroy-Medium')),
                                  Text(
                                      '\u20B9 ${cartProvider.calculateGrandTotal()}',
                                      style: const TextStyle(
                                          fontSize: 16,
                                          fontFamily: 'Gilroy-Medium')),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(height: 50),
                    ],
                  ),
                ),
              ),
            ),

            // bottom section
            Positioned(
              bottom: 10,
              left: MediaQuery.of(context).size.width / 30,
              right: MediaQuery.of(context).size.width / 30,
              child: Container(
                decoration: const BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(10)),
                  color: Colors.white,
                ),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    children: [
                      // location section
                      GestureDetector(
                        onTap: () {
                          // address selection sheet
                          showModalBottomSheet(
                            context: context,
                            backgroundColor: Colors.white,
                            builder: (BuildContext context) {
                              return Container(
                                decoration: const BoxDecoration(
                                  color: Colors.white70,
                                  borderRadius: BorderRadius.vertical(
                                      top: Radius.circular(16.0)),
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 25.0, vertical: 10),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      // title
                                      const Text(
                                        "Select address",
                                        style: TextStyle(
                                            fontSize: 20,
                                            fontFamily: 'Gilroy-Bold'),
                                      ),
                                      const SizedBox(
                                        height: 20,
                                      ),
                                      // add new address row
                                      Container(
                                          decoration: BoxDecoration(
                                              color: Colors.white,
                                              borderRadius:
                                                  const BorderRadius.all(
                                                      Radius.circular(10.0)),
                                              border: Border.all(
                                                  color: Colors.grey.shade200)),
                                          child: ListTile(
                                            minTileHeight: 50,
                                            leading: const Icon(Icons.add,
                                                color: Colors.green, size: 18),
                                            title: const Text(
                                              "Add new address",
                                              style: TextStyle(
                                                  color: Colors.green,
                                                  fontFamily:
                                                      'Gilroy-SemiBold'),
                                            ),
                                            trailing:
                                                const Icon(Icons.chevron_right),
                                            onTap: () {
                                              Navigator.push(
                                                  context,
                                                  MaterialPageRoute(
                                                      builder: (context) =>
                                                          const AddressInputForm()));
                                            },
                                          )),
                                      const SizedBox(
                                        height: 35,
                                      ),
                                      // saved addresses
                                      Text(
                                        "Your saved addresses",
                                        style: TextStyle(
                                            fontSize: 13,
                                            color: Colors.grey[600]),
                                      ),
                                      Column(
                                        children: [
                                          if (addressProvider
                                              .address.isNotEmpty)
                                            SizedBox(
                                              height: 250,
                                              child: ListView.builder(
                                                shrinkWrap: true,
                                                itemCount: addressProvider
                                                    .address.length,
                                                itemBuilder: (context, index) {
                                                  final address =
                                                      addressProvider
                                                          .address[index];
                                                  return Column(
                                                    children: [
                                                      GestureDetector(
                                                        onTap: () {
                                                          _newAdd =
                                                              "${addressProvider.address[index].flat}, ${addressProvider.address[index].building}, ${addressProvider.address[index].mylandmark}";
                                                          setState(() {
                                                            _defaultAdd =
                                                                _newAdd;
                                                          });
                                                          setState(() {});
                                                          Navigator.pop(context,
                                                              true); // Close the bottom modal
                                                          showMessage(
                                                              "Address Changed!");
                                                          log("Address: $_defaultAdd");
                                                        },
                                                        child: ListTile(
                                                          title: Text(
                                                              '${address.flat}, ${address.floor}, ${address.building}'),
                                                          subtitle: Text(address
                                                              .mylandmark),
                                                          trailing: IconButton(
                                                              onPressed: () {
                                                                addressProvider
                                                                    .removeAddress(
                                                                        address);
                                                                Navigator.pop(
                                                                    context);
                                                              },
                                                              icon: const Icon(
                                                                  Icons
                                                                      .delete)),
                                                        ),
                                                      ),
                                                    ],
                                                  );
                                                },
                                              ),
                                            ),
                                        ],
                                      )
                                    ],
                                  ),
                                ),
                              );
                            },
                          );
                        },
                        child: Container(
                          color: Colors.transparent,
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Row(
                                  children: [
                                    const Icon(Icons.place),
                                    const SizedBox(width: 5),
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        const Text(
                                          "Delivering to",
                                          style: TextStyle(
                                              fontFamily: 'Gilroy-SemiBold'),
                                        ),
                                        Text(
                                          _defaultAdd == "" &&
                                                  _defaultAdd != _newAdd
                                              ? "Please select an address"
                                              : _newAdd,
                                          // _newAdd.isNotEmpty
                                          //     ? _newAdd
                                          //     : "Please select an address",
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                          style: TextStyle(
                                              color: Colors.grey[500],
                                              fontFamily: 'Gilroy-Medium',
                                              fontSize: 12),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                                // change address button
                                const Text(
                                  "Change",
                                  style: TextStyle(
                                      color: Colors.green,
                                      fontFamily: 'Gilroy-SemiBold'),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      const Divider(),
                      // payment mode | place order
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
                                    underline: Container(
                                      height: 2,
                                      color: Colors.green,
                                    ),
                                    onChanged: (String? newValue) {
                                      setState(() {
                                        _selectedPaymentMethod = newValue!;
                                      });
                                    },
                                    items: <String>['Banks', 'Cash']
                                        .map<DropdownMenuItem<String>>(
                                            (String value) {
                                      return DropdownMenuItem<String>(
                                        value: value,
                                        child: Text(value),
                                      );
                                    }).toList(),
                                  ),
                                ],
                              ),
                              Text(_selectedPaymentMethod)
                            ],
                          ),
                          ElevatedButton(
                            onPressed: () {
                              HapticFeedback.heavyImpact();

                              if (cartProvider.cart.isEmpty) {
                                showMessage("Cart is empty");
                                return;
                              }

                              if (addressProvider.address.isEmpty) {
                                showMessage("Please select an address");
                                Navigator.of(context).push(
                                  MaterialPageRoute(
                                    builder: (context) =>
                                        const AddressInputForm(),
                                  ),
                                );
                                return; // Exit the function to prevent navigation to payment screen
                              }

                              if (_selectedPaymentMethod == 'Banks') {
                                // webCheckout(phoneNumber, uName, total_amount);
                                Navigator.of(context).push(
                                  MaterialPageRoute(
                                    builder: (context) => const PaymentApp(),
                                    // builder: (context) => const PaymentScreen(),
                                  ),
                                );
                              } else if (_selectedPaymentMethod == 'Cash') {
                                Navigator.of(context).push(
                                  MaterialPageRoute(
                                    builder: (context) =>
                                        const OrderConfirmationPage(),
                                  ),
                                );
                              }
                            },
                            style: ButtonStyle(
                              shape: WidgetStateProperty.all<
                                  RoundedRectangleBorder>(
                                RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(14.0),
                                ),
                              ),
                              backgroundColor:
                                  WidgetStateProperty.resolveWith<Color>(
                                (Set<WidgetState> states) {
                                  return Colors.black;
                                },
                              ),
                            ),
                            child: const SizedBox(
                              width: 120,
                              height: 50.0,
                              child: Center(
                                child: Text(
                                  "Continue",
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 16.0,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      )
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
