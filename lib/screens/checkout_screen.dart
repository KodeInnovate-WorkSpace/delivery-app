import 'dart:math';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_cashfree_pg_sdk/api/cferrorresponse/cferrorresponse.dart';
import 'package:flutter_cashfree_pg_sdk/api/cfpaymentgateway/cfpaymentgatewayservice.dart';
import 'package:flutter_cashfree_pg_sdk/api/cfsession/cfsession.dart';
import 'package:provider/provider.dart';
import 'package:speedy_delivery/providers/address_provider.dart';
import 'package:speedy_delivery/providers/cart_provider.dart';
import 'package:speedy_delivery/screens/orders_screen.dart';
import 'package:speedy_delivery/shared/constants.dart';
import 'package:speedy_delivery/shared/show_msg.dart';
import '../providers/auth_provider.dart';
import '../providers/order_provider.dart';
import '../widget/checkout_add_to_cart_button.dart';
import '../widget/network_handler.dart';
import 'address_input.dart';
import 'order_confirmation_screen.dart';
import 'dart:convert';
import 'package:flutter_cashfree_pg_sdk/api/cfpayment/cfdropcheckoutpayment.dart';
import 'package:flutter_cashfree_pg_sdk/api/cfpayment/cfwebcheckoutpayment.dart';
import 'package:flutter_cashfree_pg_sdk/api/cfpaymentcomponents/cfpaymentcomponent.dart';
import 'package:flutter_cashfree_pg_sdk/api/cftheme/cftheme.dart';
import 'package:flutter_cashfree_pg_sdk/utils/cfenums.dart';
import 'package:flutter_cashfree_pg_sdk/utils/cfexceptions.dart';
import 'package:http/http.dart' as http;

class CheckoutScreen extends StatefulWidget {
  const CheckoutScreen({super.key});

  @override
  State<CheckoutScreen> createState() => _CheckoutScreenState();
}

class _CheckoutScreenState extends State<CheckoutScreen> {
  String _defaultAdd = "No address available";
  String _newAdd = '';
  String _selectedPaymentMethod = 'Banks';
  double totalAmt = 0.0;
  late String orderId;
  String customerId = '';
  String customerPhone = "";

  var cfPaymentGatewayService = CFPaymentGatewayService();

  @override
  void initState() {
    super.initState();
    // Use the orderId from the provider or generate it if not available
    final orderProvider = Provider.of<OrderProvider>(context, listen: false);
    orderId = orderProvider.orders.isNotEmpty
        ? orderProvider.orders.first.orderId
        : _generateOrderId();
    customerId = _generateCustomerId();
    cfPaymentGatewayService.setCallback(verifyPayment, onError);
  }

  String _generateOrderId() {
    int randomNumber = Random().nextInt(9000) + 1000;
    String timestamp = DateTime.now().millisecondsSinceEpoch.toString();
    return 'ORD_${timestamp}_$randomNumber';
  }

  String _generateCustomerId() {
    int randomNumber = Random().nextInt(9000) + 1000;
    String timestamp = DateTime.now().millisecondsSinceEpoch.toString();
    return 'CUST_${timestamp}_$randomNumber';
  }

  Future<Map<String, dynamic>> createSessionID(String myOrderId) async {
    var headers = {
      'Content-Type': 'application/json',
      'x-client-id': "TEST102073159c36086010050049f41951370201",
      'x-client-secret':
          "cfsk_ma_test_85d10e30b385bd991902bfa67e3222bd_69af2996",
      'x-api-version': '2023-08-01',
    };
    var request = http.Request(
        'POST', Uri.parse('https://sandbox.cashfree.com/pg/orders'));
    request.body = json.encode({
      "order_amount": totalAmt,
      "order_id": myOrderId,
      "order_currency": "INR",
      "customer_details": {
        "customer_id": customerId,
        "customer_name": "customer_name",
        "customer_email": "",
        "customer_phone": customerPhone,
      },
      "order_meta": {"notify_url": "https://test.cashfree.com"},
      "order_note": "some order note here"
    });
    request.headers.addAll(headers);

    http.StreamedResponse response = await request.send();

    if (response.statusCode == 200) {
      return jsonDecode(await response.stream.bytesToString());
    } else {
      debugPrint(await response.stream.bytesToString());
      debugPrint("${response.reasonPhrase}");
      throw Exception("Failed to create session ID");
    }
  }

  void verifyPayment(String oId) {
    debugPrint("Verify Payment");
    debugPrint("Order ID = $oId");
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => const OrderHistoryScreen()),
    );
    showMessage("Payment Successful");
  }

  void onError(CFErrorResponse errorResponse, String orderId) {
    debugPrint(errorResponse.getMessage().toString());
    debugPrint("Error while making payment");
    debugPrint("Order ID is $orderId");
  }

  Future<void> webCheckout() async {
    try {
      CFSession? session = await createSession();
      var cfWebCheckout =
          CFWebCheckoutPaymentBuilder().setSession(session!).build();
      cfPaymentGatewayService.doPayment(cfWebCheckout);
    } on CFException catch (e) {
      debugPrint(e.message);
    }
  }

  Future<CFSession?> createSession() async {
    try {
      final paymentSessionId = await createSessionID(orderId);
      var session = CFSessionBuilder()
          .setEnvironment(CFEnvironment.SANDBOX)
          .setOrderId(orderId)
          .setPaymentSessionId(paymentSessionId["payment_session_id"])
          .build();
      return session;
    } on CFException catch (e) {
      debugPrint(e.message);
    }
    return null;
  }

  Future<void> pay() async {
    try {
      var session = await createSession();
      List<CFPaymentModes> components = <CFPaymentModes>[];
      var paymentComponent =
          CFPaymentComponentBuilder().setComponents(components).build();
      var theme = CFThemeBuilder()
          .setNavigationBarBackgroundColorColor("#f7ce34")
          .setPrimaryFont("Menlo")
          .setSecondaryFont("Futura")
          .build();
      var cfDropCheckoutPayment = CFDropCheckoutPaymentBuilder()
          .setSession(session!)
          .setPaymentComponent(paymentComponent)
          .setTheme(theme)
          .build();

      cfPaymentGatewayService.doPayment(cfDropCheckoutPayment);
    } on CFException catch (e) {
      debugPrint(e.message);
    }
  }

  @override
  Widget build(BuildContext context) {
    // providers
    final cartProvider = Provider.of<CartProvider>(context);
    final addressProvider = Provider.of<AddressProvider>(context);

    if (addressProvider.address.isNotEmpty) {
      _defaultAdd =
          "${addressProvider.address[0].flat}, ${addressProvider.address[0].building}, ${addressProvider.address[0].mylandmark}";
    }

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        addressProvider.loadAddresses();
      }
    });

    // setting variables for payment gateway
    final authProvider = Provider.of<MyAuthProvider>(context);

    setState(() {
      totalAmt = cartProvider.calculateGrandTotal();
      customerPhone =
          authProvider.phone.isEmpty ? "0000000000" : authProvider.phone;
    });

    return NetworkHandler(
      child: Scaffold(
        resizeToAvoidBottomInset:
            true, // Enable auto-resizing when keyboard appears
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
                    height: MediaQuery.of(context)
                        .size
                        .height, //covers the entire screen (responsive)
                    color: const Color(
                        0xffeaf1fc), // Set the background color to grey
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: SingleChildScrollView(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Delivery information
                            Card(
                              elevation: 0,
                              color:
                                  Colors.white, // Set the card color to white
                              child: Padding(
                                padding: const EdgeInsets.all(18.0),
                                child: Row(
                                  children: [
                                    const Icon(Icons.timer),
                                    const SizedBox(width: 12),
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            'Delivery within $deliveryTime minutes',
                                            style: const TextStyle(
                                                fontSize: 18,
                                                fontFamily: 'Gilroy-ExtraBold'),
                                          ),
                                          const Text(
                                            'Shipment of 1 item',
                                            style: TextStyle(
                                                fontSize: 12,
                                                color: Colors.grey),
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
                            Consumer<CartProvider>(
                              builder: (context, cartProvider, _) {
                                return Column(
                                  children: cartProvider.cart.map((item) {
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
                                                  Text(
                                                    item.itemName,
                                                    style: const TextStyle(
                                                        fontSize: 16),
                                                  ),
                                                  Text(
                                                    item.itemUnit.toString(),
                                                    style: const TextStyle(
                                                        color: Colors.grey),
                                                  ),
                                                  const SizedBox(height: 4),
                                                  Text(
                                                    'Total: ₹${item.itemPrice * item.qnt}',
                                                    style: const TextStyle(
                                                      fontSize: 14,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                            const SizedBox(width: 2),
                                            Column(
                                              children: [
                                                CheckoutAddToCartButton(
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
                                  }).toList(),
                                );
                              },
                            ),

                            const SizedBox(height: 10),
                            // Bill details
                            const SizedBox(height: 10),
                            Card(
                              elevation: 0,
                              color:
                                  Colors.white, // Set the card color to white
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
                                            style:
                                                const TextStyle(fontSize: 14),
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
                                              style: const TextStyle(
                                                  fontSize: 14)),
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
                                              style: const TextStyle(
                                                  fontSize: 14)),
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
                            const SizedBox(height: 35),
                            Container(
                              decoration: const BoxDecoration(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(10)),
                                color: Colors.white,
                              ),
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Column(
                                  children: [
                                    //New address
                                    GestureDetector(
                                      onTap: () {
                                        // Address selection sheet
                                        showModalBottomSheet(
                                          context: context,
                                          backgroundColor: Colors.white,
                                          builder: (BuildContext context) {
                                            return StatefulBuilder(
                                              builder: (BuildContext context,
                                                  StateSetter setModalState) {
                                                return Container(
                                                  decoration:
                                                      const BoxDecoration(
                                                    color: Colors.white70,
                                                    borderRadius:
                                                        BorderRadius.vertical(
                                                            top:
                                                                Radius.circular(
                                                                    16.0)),
                                                  ),
                                                  child: Padding(
                                                    padding: const EdgeInsets
                                                        .symmetric(
                                                        horizontal: 25.0,
                                                        vertical: 10),
                                                    child: Column(
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .start,
                                                      children: [
                                                        // Title
                                                        const Text(
                                                          "Select address",
                                                          style: TextStyle(
                                                              fontSize: 20,
                                                              fontFamily:
                                                                  'Gilroy-Bold'),
                                                        ),
                                                        const SizedBox(
                                                            height: 20),
                                                        // Add new address row
                                                        Container(
                                                          decoration:
                                                              BoxDecoration(
                                                            color: Colors.white,
                                                            borderRadius:
                                                                const BorderRadius
                                                                    .all(
                                                                    Radius.circular(
                                                                        10.0)),
                                                            border: Border.all(
                                                                color: Colors
                                                                    .grey
                                                                    .shade200),
                                                          ),
                                                          child: ListTile(
                                                            minTileHeight: 50,
                                                            leading: const Icon(
                                                                Icons.add,
                                                                color: Colors
                                                                    .green,
                                                                size: 18),
                                                            title: const Text(
                                                              "Add new address",
                                                              style: TextStyle(
                                                                  color: Colors
                                                                      .green,
                                                                  fontFamily:
                                                                      'Gilroy-SemiBold'),
                                                            ),
                                                            trailing:
                                                                const Icon(Icons
                                                                    .chevron_right),
                                                            onTap: () {
                                                              Navigator.push(
                                                                context,
                                                                MaterialPageRoute(
                                                                    builder:
                                                                        (context) =>
                                                                            const AddressInputForm()),
                                                              ).then((value) {
                                                                // Refresh the modal state when returning from address input
                                                                setModalState(
                                                                    () {});
                                                              });
                                                            },
                                                          ),
                                                        ),
                                                        const SizedBox(
                                                            height: 35),
                                                        // Saved addresses
                                                        Text(
                                                          "Your saved addresses",
                                                          style: TextStyle(
                                                              fontSize: 13,
                                                              color: Colors
                                                                  .grey[600]),
                                                        ),
                                                        if (addressProvider
                                                            .address.isNotEmpty)
                                                          SizedBox(
                                                            height: 250,
                                                            child: ListView
                                                                .builder(
                                                              shrinkWrap: true,
                                                              itemCount:
                                                                  addressProvider
                                                                      .address
                                                                      .length,
                                                              itemBuilder:
                                                                  (context,
                                                                      index) {
                                                                final address =
                                                                    addressProvider
                                                                            .address[
                                                                        index];
                                                                return Column(
                                                                  children: [
                                                                    GestureDetector(
                                                                      onTap:
                                                                          () {
                                                                        _newAdd =
                                                                            "${address.flat}, ${address.building}, ${address.mylandmark}";
                                                                        setState(
                                                                            () {
                                                                          _defaultAdd =
                                                                              _newAdd;
                                                                        });
                                                                        Navigator.pop(
                                                                            context,
                                                                            true); // Close the bottom modal
                                                                        showMessage(
                                                                            "Address Changed!");
                                                                        // Redirect to home
                                                                        Navigator.of(context).popUntil((route) =>
                                                                            route.isFirst);
                                                                      },
                                                                      child:
                                                                          ListTile(
                                                                        title: Text(
                                                                            '${address.flat}, ${address.floor}, ${address.building}'),
                                                                        subtitle:
                                                                            Text(address.mylandmark),
                                                                        trailing:
                                                                            IconButton(
                                                                          onPressed:
                                                                              () {
                                                                            addressProvider.removeAddress(address);
                                                                            showMessage("Address Deleted!");
                                                                            setModalState(() {}); // Refresh the modal state
                                                                            setState(() {
                                                                              if (_defaultAdd == _newAdd) {
                                                                                _defaultAdd = "";
                                                                                _newAdd = "";
                                                                              }
                                                                            });
                                                                            // Redirect to home
                                                                            Navigator.of(context).popUntil((route) =>
                                                                                route.isFirst);
                                                                          },
                                                                          icon:
                                                                              const Icon(Icons.delete),
                                                                        ),
                                                                      ),
                                                                    ),
                                                                  ],
                                                                );
                                                              },
                                                            ),
                                                          ),
                                                      ],
                                                    ),
                                                  ),
                                                );
                                              },
                                            );
                                          },
                                        );
                                      },
                                      child: Container(
                                        color: Colors.transparent,
                                        child: Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: Row(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.center,
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              Row(
                                                children: [
                                                  const Icon(Icons.place),
                                                  const SizedBox(width: 5),
                                                  Column(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: [
                                                      const Text(
                                                        "Delivering to",
                                                        style: TextStyle(
                                                            fontFamily:
                                                                'Gilroy-SemiBold'),
                                                      ),
                                                      Text(
                                                        _defaultAdd.isEmpty
                                                            ? "Please select an address"
                                                            : _defaultAdd,
                                                        maxLines: 1,
                                                        overflow: TextOverflow
                                                            .ellipsis,
                                                        style: TextStyle(
                                                            color: Colors
                                                                .grey[500],
                                                            fontFamily:
                                                                'Gilroy-Medium',
                                                            fontSize: 12),
                                                      ),
                                                    ],
                                                  ),
                                                ],
                                              ),
                                              // Change address button
                                              const Text(
                                                "Change",
                                                style: TextStyle(
                                                    color: Colors.green,
                                                    fontFamily:
                                                        'Gilroy-SemiBold'),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ),
                                    const Divider(),
                                    // payment mode | place order
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceAround,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: [
                                        Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Row(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.center,
                                              children: [
                                                const Icon(
                                                  Icons.account_balance,
                                                  size: 12,
                                                ),
                                                const SizedBox(width: 10),
                                                DropdownButton<String>(
                                                  value: _selectedPaymentMethod,
                                                  icon: const Icon(
                                                      Icons.arrow_drop_down),
                                                  iconSize: 24,
                                                  elevation: 16,
                                                  style: const TextStyle(
                                                      color: Colors.black),
                                                  underline: Container(
                                                    height: 2,
                                                    color: Colors.green,
                                                  ),
                                                  onChanged:
                                                      (String? newValue) {
                                                    setState(() {
                                                      _selectedPaymentMethod =
                                                          newValue!;
                                                    });
                                                  },
                                                  items: <String>[
                                                    'Banks',
                                                    'Cash'
                                                  ].map<
                                                          DropdownMenuItem<
                                                              String>>(
                                                      (String value) {
                                                    return DropdownMenuItem<
                                                        String>(
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

                                            if (addressProvider
                                                .address.isEmpty) {
                                              showMessage(
                                                  "Please select an address");
                                              Navigator.of(context).push(
                                                MaterialPageRoute(
                                                  builder: (context) =>
                                                      const AddressInputForm(),
                                                ),
                                              );
                                              return; // Exit the function to prevent navigation to payment screen
                                            }

                                            final orderProvider =
                                                Provider.of<OrderProvider>(
                                                    context,
                                                    listen: false);

                                            if (_selectedPaymentMethod ==
                                                'Banks') {
                                              pay().then((value) {
                                                List<Order> orders =
                                                    cartProvider.cart
                                                        .map((item) {
                                                  return Order(
                                                    orderId:
                                                        orderId, // Use the same order ID for all items
                                                    paymentMode:
                                                        _selectedPaymentMethod,
                                                    productName: item.itemName,
                                                    productImage:
                                                        item.itemImage,
                                                    quantity: item.qnt,
                                                    price: item.itemPrice
                                                        .toDouble(),
                                                    totalPrice:
                                                        (item.itemPrice *
                                                                item.qnt)
                                                            .toDouble(),
                                                    address: _defaultAdd,
                                                    //transactionId: '',
                                                  );
                                                }).toList();

                                                orderProvider.addOrders(
                                                    orders, orderId);
                                                cartProvider
                                                    .clearCart(); // Clear the cart
                                              });
                                            } else if (_selectedPaymentMethod ==
                                                'Cash') {
                                              Navigator.of(context)
                                                  .push(
                                                MaterialPageRoute(
                                                  builder: (context) =>
                                                      const OrderConfirmationPage(),
                                                ),
                                              )
                                                  .then((value) {
                                                List<Order> orders =
                                                    cartProvider.cart
                                                        .map((item) {
                                                  return Order(
                                                    orderId:
                                                        orderId, // Use the same order ID for all items
                                                    paymentMode:
                                                        _selectedPaymentMethod,
                                                    productName: item.itemName,
                                                    productImage:
                                                        item.itemImage,
                                                    quantity: item.qnt,
                                                    price: item.itemPrice
                                                        .toDouble(),
                                                    totalPrice:
                                                        (item.itemPrice *
                                                                item.qnt)
                                                            .toDouble(),
                                                    address:
                                                        _defaultAdd, // Add phone number if available
                                                    // transactionId: '',
                                                  );
                                                }).toList();

                                                orderProvider.addOrders(
                                                    orders, orderId);
                                                cartProvider
                                                    .clearCart(); // Clear the cart
                                              });
                                            }
                                          },
                                          style: ButtonStyle(
                                            shape: WidgetStateProperty.all<
                                                RoundedRectangleBorder>(
                                              RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(14.0),
                                              ),
                                            ),
                                            backgroundColor: WidgetStateProperty
                                                .resolveWith<Color>(
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
