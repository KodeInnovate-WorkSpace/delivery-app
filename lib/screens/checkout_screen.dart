import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_cashfree_pg_sdk/api/cferrorresponse/cferrorresponse.dart';
import 'package:flutter_cashfree_pg_sdk/api/cfpaymentgateway/cfpaymentgatewayservice.dart';
import 'package:flutter_cashfree_pg_sdk/api/cfsession/cfsession.dart';
import 'package:provider/provider.dart';
import 'package:speedy_delivery/providers/cart_provider.dart';
import 'package:speedy_delivery/screens/orders_screen.dart';
import 'package:speedy_delivery/shared/show_msg.dart';
import 'package:speedy_delivery/widget/checkout_bottom_section.dart';
import 'package:uuid/uuid.dart';
import '../providers/auth_provider.dart';
import '../widget/add_to_cart_button.dart';
import '../widget/network_handler.dart';
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

class _CheckoutScreenState extends State<CheckoutScreen> with ChangeNotifier {
  final uuid = const Uuid();

  //Payment gateway
  double totalAmt = 0.0;

  // Generate a unique order ID
  String orderId = const Uuid().v4();
  String customerId = const Uuid().v4();

  String customerPhone = "";

  // cashfree code
  var cfPaymentGatewayService = CFPaymentGatewayService();

  @override
  void initState() {
    super.initState();
    cfPaymentGatewayService.setCallback(verifyPayment, onError);
  }

  @override
  void dispose() {
    super.dispose(); // Ensure to call super.dispose()
  }

  createSessionID(String myOrderId) async {
    var headers = {
      'Content-Type': 'application/json',
      'x-client-id': "TEST102073159c36086010050049f41951370201",
      'x-client-secret':
          "cfsk_ma_test_85d10e30b385bd991902bfa67e3222bd_69af2996",
      'x-api-version': '2023-08-01', // This is latest version for API
    };
    debugPrint("$headers");
    var request = http.Request(
        'POST', Uri.parse('https://sandbox.cashfree.com/pg/orders'));
    request.body = json.encode({
      "order_amount": totalAmt, // Order Amount in Rupees
      "order_id": myOrderId, // OrderiD created by you it must be unique
      "order_currency": "INR", // Currency of order like INR,USD
      "customer_details": {
        "customer_id": "customerId", // Customer id
        "customer_name": "customer_name", // Name of customer
        "customer_email": "", // Email id of customer
        "customer_phone": customerPhone // Phone Number of customer
      },
      "order_meta": {"notify_url": "https://test.cashfree.com"},
      "order_note":
          "some order note here" // If you want to store something extra
    });
    request.headers.addAll(headers);

    http.StreamedResponse response = await request.send();

    if (response.statusCode == 200) {
      // If All the details is correct it will return the
      // response and you can get sessionid for checkout
      return jsonDecode(await response.stream.bytesToString());
    } else {
      debugPrint(await response.stream.bytesToString());
      debugPrint("${response.reasonPhrase}");
    }
  }

  void verifyPayment(String orderId) {
    debugPrint("Verify Payment");

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => const OrderHistoryScreen()),
    );
    showMessage("Payment Successful");
  }

  void onError(CFErrorResponse errorResponse, String orderId) {
    debugPrint(errorResponse.getMessage().toString());
    debugPrint("Error while making payment");
  }

  webCheckout() async {
    try {
      CFSession? session = await createSession();
      var cfWebCheckout =
          CFWebCheckoutPaymentBuilder().setSession(session!).build();
      cfPaymentGatewayService.doPayment(cfWebCheckout);
    } on CFException catch (e) {
      debugPrint(e.message);
    }
  }

  // New session
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

  pay() async {
    try {
      var session = await createSession();
      List<CFPaymentModes> components = <CFPaymentModes>[];
      // If you want to set payment mode to be shown to customer
      var paymentComponent =
          CFPaymentComponentBuilder().setComponents(components).build();
      // set theme of checkout session page. fonts, color
      var theme = CFThemeBuilder()
          .setNavigationBarBackgroundColorColor("#f7ce34")
          .setPrimaryFont("Menlo")
          .setSecondaryFont("Futura")
          .build();
      // Create checkout with all the settings set earlier
      var cfDropCheckoutPayment = CFDropCheckoutPaymentBuilder()
          .setSession(session!)
          .setPaymentComponent(paymentComponent)
          .setTheme(theme)
          .build();
      // Launching the payment page

      // cfPaymentGatewayService.doPayment(cfDropCheckoutPayment);
      cfPaymentGatewayService.doPayment(cfDropCheckoutPayment).then((value) {
        verifyPayment(orderId);
      });
    } on CFException catch (e) {
      debugPrint(e.message);
    }
  }
  //Payment gateway end

  @override
  Widget build(BuildContext context) {
    // providers
    final cartProvider = Provider.of<CartProvider>(context);

    // setting variables for payment gateway
    final authProvider = Provider.of<MyAuthProvider>(context);

    setState(() {
      totalAmt = cartProvider.calculateGrandTotal();
      customerPhone =
          authProvider.phone.isEmpty ? "0000000000" : authProvider.phone;
    });

    // clear cart on successful payment
    clearCartOnPayment() {
      cartProvider.clearCart();
    }

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
                            const Card(
                              elevation: 0,
                              color:
                                  Colors.white, // Set the card color to white
                              child: Padding(
                                padding: EdgeInsets.all(18.0),
                                child: Row(
                                  children: [
                                    Icon(Icons.timer),
                                    SizedBox(width: 12),
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
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
                                              style:
                                                  const TextStyle(fontSize: 16),
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
                                      // Add to Cart button
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
                            // cart code ends
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
                            const SizedBox(height: 30),
                          ],
                        ),
                      ),
                    ),
                  ),
                  // Bottom section
                  checkoutBottom(context, pay),
                ],
              ),
      ),
    );
  }
}
