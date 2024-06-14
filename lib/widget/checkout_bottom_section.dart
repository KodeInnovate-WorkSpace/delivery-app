import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

import '../providers/address_provider.dart';
import '../providers/cart_provider.dart';
import '../providers/order_provider.dart';
import '../screens/address_input.dart';
import '../screens/order_confirmation_screen.dart';
import '../shared/show_msg.dart';

Widget checkoutBottom(BuildContext context, Function pay) {
  String defaultAdd = "No address available";
  String newAdd = '';
  String selectedPaymentMethod = 'Banks';

  String generateOrderId() {
    int randomNumber = Random().nextInt(9000) + 1000;
    String timestamp = DateTime.now().millisecondsSinceEpoch.toString();
    return 'ORD_${timestamp}_$randomNumber';
  }

  final addressProvider = Provider.of<AddressProvider>(context);
  final cartProvider = Provider.of<CartProvider>(context);

  if (addressProvider.address.isNotEmpty) {
    defaultAdd =
        "${addressProvider.address[0].flat}, ${addressProvider.address[0].building}, ${addressProvider.address[0].mylandmark}";
  }
  return Container(
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
                      borderRadius:
                          BorderRadius.vertical(top: Radius.circular(16.0)),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 25.0, vertical: 10),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // title
                          const Text(
                            "Select address",
                            style: TextStyle(
                                fontSize: 20, fontFamily: 'Gilroy-Bold'),
                          ),
                          const SizedBox(
                            height: 20,
                          ),
                          // add new address row
                          Container(
                              decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: const BorderRadius.all(
                                      Radius.circular(10.0)),
                                  border:
                                      Border.all(color: Colors.grey.shade200)),
                              child: ListTile(
                                minTileHeight: 50,
                                leading: const Icon(Icons.add,
                                    color: Colors.green, size: 18),
                                title: const Text(
                                  "Add new address",
                                  style: TextStyle(
                                      color: Colors.green,
                                      fontFamily: 'Gilroy-SemiBold'),
                                ),
                                trailing: const Icon(Icons.chevron_right),
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
                                fontSize: 13, color: Colors.grey[600]),
                          ),
                          Column(
                            children: [
                              if (addressProvider.address.isNotEmpty)
                                SizedBox(
                                  height: 250,
                                  child: ListView.builder(
                                    shrinkWrap: true,
                                    itemCount: addressProvider.address.length,
                                    itemBuilder: (context, index) {
                                      final address =
                                          addressProvider.address[index];
                                      return Column(
                                        children: [
                                          GestureDetector(
                                            onTap: () {
                                              newAdd =
                                                  "${addressProvider.address[index].flat}, ${addressProvider.address[index].building}, ${addressProvider.address[index].mylandmark}";

                                              defaultAdd = newAdd;

                                              Navigator.pop(context,
                                                  true); // Close the bottom modal
                                              showMessage("Address Changed!");
                                              debugPrint(
                                                  "Address: $defaultAdd");
                                            },
                                            child: ListTile(
                                              title: Text(
                                                  '${address.flat}, ${address.floor}, ${address.building}'),
                                              subtitle:
                                                  Text(address.mylandmark),
                                              trailing: IconButton(
                                                  onPressed: () {
                                                    addressProvider
                                                        .removeAddress(address);
                                                    Navigator.pop(context);
                                                  },
                                                  icon:
                                                      const Icon(Icons.delete)),
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
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              "Delivering to",
                              style: TextStyle(fontFamily: 'Gilroy-SemiBold'),
                            ),
                            Text(
                              defaultAdd == "" && defaultAdd != newAdd
                                  ? "Please select an address"
                                  : newAdd,
                              // newAdd.isNotEmpty
                              //     ? newAdd
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
                          color: Colors.green, fontFamily: 'Gilroy-SemiBold'),
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
                        value: selectedPaymentMethod,
                        icon: const Icon(Icons.arrow_drop_down),
                        iconSize: 24,
                        elevation: 16,
                        style: const TextStyle(color: Colors.black),
                        underline: Container(
                          height: 2,
                          color: Colors.green,
                        ),
                        onChanged: (String? newValue) {
                          selectedPaymentMethod = newValue!;
                        },
                        items: <String>['Banks', 'Cash']
                            .map<DropdownMenuItem<String>>((String value) {
                          return DropdownMenuItem<String>(
                            value: value,
                            child: Text(value),
                          );
                        }).toList(),
                      ),
                    ],
                  ),
                  Text(selectedPaymentMethod)
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
                        builder: (context) => const AddressInputForm(),
                      ),
                    );
                    return; // Exit the function to prevent navigation to payment screen
                  }

                  final orderProvider =
                      Provider.of<OrderProvider>(context, listen: false);
                  String orderId = generateOrderId();

                  if (selectedPaymentMethod == 'Banks') {
                    pay().then((value) {
                      List<Order> orders = cartProvider.cart.map((item) {
                        return Order(
                          orderId:
                              orderId, // Use the same order ID for all items
                          paymentMode: selectedPaymentMethod,
                          productName: item.itemName,
                          productImage: item.itemImage,
                          quantity: item.qnt,
                          price: item.itemPrice.toDouble(),
                          totalPrice: (item.itemPrice * item.qnt).toDouble(),
                          address: defaultAdd,
                          // Add phone number if available
                          // transactionId: '',
                        );
                      }).toList();

                      orderProvider.addOrders(orders, orderId);
                      // cartProvider.clearCart(); // Clear the cart
                    });
                  } else if (selectedPaymentMethod == 'Cash') {
                    Navigator.of(context)
                        .push(
                      MaterialPageRoute(
                        builder: (context) => const OrderConfirmationPage(),
                      ),
                    )
                        .then((value) {
                      List<Order> orders = cartProvider.cart.map((item) {
                        return Order(
                          orderId:
                              orderId, // Use the same order ID for all items
                          paymentMode: selectedPaymentMethod,
                          productName: item.itemName,
                          productImage: item.itemImage,
                          quantity: item.qnt,
                          price: item.itemPrice.toDouble(),
                          totalPrice: (item.itemPrice * item.qnt).toDouble(),
                          address: defaultAdd,
                          // Add phone number if available
                          // transactionId: '',
                        );
                      }).toList();

                      orderProvider.addOrders(orders, orderId);
                      // cartProvider.clearCart(); // Clear the cart
                    });
                  }
                },
                style: ButtonStyle(
                  shape: WidgetStateProperty.all<RoundedRectangleBorder>(
                    RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14.0),
                    ),
                  ),
                  backgroundColor: WidgetStateProperty.resolveWith<Color>(
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
  );
}
