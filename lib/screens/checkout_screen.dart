import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:speedy_delivery/providers/cart_provider.dart';
import 'package:speedy_delivery/widget/address_selection.dart';
import 'package:speedy_delivery/widget/apply_coupon_widget.dart';
import 'package:speedy_delivery/widget/bill_details_widget.dart';
import 'package:speedy_delivery/widget/checkout_top.dart';
import 'package:speedy_delivery/widget/display_cartItems.dart';
import '../providers/order_provider.dart';
import '../widget/network_handler.dart';
import 'dart:math';
import 'package:flutter/services.dart';
import 'package:flutter_cashfree_pg_sdk/api/cferrorresponse/cferrorresponse.dart';
import 'package:flutter_cashfree_pg_sdk/api/cfpaymentgateway/cfpaymentgatewayservice.dart';
import 'package:flutter_cashfree_pg_sdk/api/cfsession/cfsession.dart';
import 'package:speedy_delivery/screens/order_tracking.dart';
import '../providers/address_provider.dart';
import '../providers/auth_provider.dart';
import 'package:speedy_delivery/shared/show_msg.dart';
import 'dart:convert';
import 'package:flutter_cashfree_pg_sdk/api/cfpayment/cfdropcheckoutpayment.dart';
import 'package:flutter_cashfree_pg_sdk/api/cfpayment/cfwebcheckoutpayment.dart';
import 'package:flutter_cashfree_pg_sdk/api/cfpaymentcomponents/cfpaymentcomponent.dart';
import 'package:flutter_cashfree_pg_sdk/api/cftheme/cftheme.dart';
import 'package:flutter_cashfree_pg_sdk/utils/cfenums.dart';
import 'package:flutter_cashfree_pg_sdk/utils/cfexceptions.dart';
import 'package:http/http.dart' as http;
import '../screens/address_input.dart';
import '../screens/order_confirmation_screen.dart';

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

    customerId = _generateCustomerId();
    cfPaymentGatewayService.setCallback(verifyPayment, (errorResponse, orderId) => onError(errorResponse, orderId, context, orderProvider));
  }

  //Payment Gateway Code
  double totalAmt = 0.0;
  String customerId = '';
  String customerPhone = "";

  var cfPaymentGatewayService = CFPaymentGatewayService();

  String generateOrderId() {
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
      //Test
      // 'x-client-id': "TEST102073159c36086010050049f41951370201",
      // 'x-client-secret': "cfsk_ma_test_85d10e30b385bd991902bfa67e3222bd_69af2996",
      //Prod
      'x-client-id': "6983506cac38e05faf1b6e3085053896",
      'x-client-secret': "cfsk_ma_prod_d184d86eba0c9e3ff1ba85866e4c6639_abf28ea8",
      'x-api-version': '2023-08-01',
    };
    // var request = http.Request('POST', Uri.parse('https://sandbox.cashfree.com/pg/orders')); // test
    var request = http.Request('POST', Uri.parse('https://api.cashfree.com/pg/orders')); // prod
    request.body = json.encode({
      "order_amount": totalAmt.toStringAsFixed(2),
      "order_id": myOrderId,
      "order_currency": "INR",
      "customer_details": {
        "customer_id": customerId,
        "customer_name": "",
        "customer_email": "",
        "customer_phone": customerPhone,
      },
      "order_meta": {"notify_url": "https://test.cashfree.com"},
      "order_note": ""
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
    final cartProvider = Provider.of<CartProvider>(context, listen: false);
    cartProvider.clearCart();
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => const OrderConfirmationPage()),
    );

    showMessage("Payment Successful");
  }

  void onError(CFErrorResponse errorResponse, String orderId, BuildContext context, OrderProvider orderProvider) async {
    debugPrint(errorResponse.getMessage().toString());
    debugPrint("Error while making payment");
    debugPrint("Order ID is $orderId");

    await orderProvider.cancelOrder(orderId);

    // Navigate to OrderTrackingScreen
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => OrderTrackingScreen(orderId: orderId),
      ),
    );
  }

  Future<CFSession?> createSession(String myOrdId) async {
    try {
      final paymentSessionId = await createSessionID(myOrdId);
      var session = CFSessionBuilder().setEnvironment(CFEnvironment.PRODUCTION).setOrderId(myOrdId).setPaymentSessionId(paymentSessionId["payment_session_id"]).build();
      // var session = CFSessionBuilder().setEnvironment(CFEnvironment.SANDBOX).setOrderId(myOrdId).setPaymentSessionId(paymentSessionId["payment_session_id"]).build();
      return session;
    } on CFException catch (e) {
      debugPrint(e.message);
    }
    return null;
  }

  Future<void> pay(String myOrdId) async {
    try {
      var session = await createSession(myOrdId);
      if (session == null) {
        debugPrint("Session creation failed");
        return;
      }
      List<CFPaymentModes> components = <CFPaymentModes>[];
      var paymentComponent = CFPaymentComponentBuilder().setComponents(components).build();
      var theme = CFThemeBuilder().setNavigationBarBackgroundColorColor("#f7ce34").setPrimaryFont("Menlo").setSecondaryFont("Futura").build();
      var cfDropCheckoutPayment = CFDropCheckoutPaymentBuilder().setSession(session).setPaymentComponent(paymentComponent).setTheme(theme).build();
      cfPaymentGatewayService.doPayment(cfDropCheckoutPayment);
    } on CFException catch (e) {
      debugPrint("Payment exception: ${e.message}");
    }
  }

  Future<void> webCheckout(String myOrdId) async {
    try {
      CFSession? session = await createSession(myOrdId);
      var theme = CFThemeBuilder().setNavigationBarBackgroundColorColor("#2b2b2a").setPrimaryFont("Menlo").setSecondaryFont("Futura").build();
      var cfWebCheckout = CFWebCheckoutPaymentBuilder().setSession(session!).setTheme(theme).build();
      cfPaymentGatewayService.doPayment(cfWebCheckout);
    } on CFException catch (e) {
      debugPrint(e.message);
    }
  }

  //Payment Gateway Code End

  @override
  Widget build(BuildContext context) {
    final cartProvider = Provider.of<CartProvider>(context);

    //Payment Gateway Code
    final authProvider = Provider.of<MyAuthProvider>(context);
    final addressProvider = Provider.of<AddressProvider>(context);

    setState(() {
      totalAmt = cartProvider.calculateGrandTotal();
      customerPhone = authProvider.phone.isEmpty ? "0000000000" : authProvider.phone;
    });

    //Payment Gateway Code End

    return NetworkHandler(
      child: Scaffold(
        resizeToAvoidBottomInset: true,
        appBar: AppBar(
          title: const Text("Checkout", style: TextStyle(color: Color(0xff666666), fontFamily: 'Gilroy-Bold')),
          iconTheme: const IconThemeData(color: Color(0xff666666)),
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
          backgroundColor: const Color(0xfff7f7f7),
          elevation: 0,
        ),
        backgroundColor: const Color(0xfff7f7f7),
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
                  SizedBox(
                    height: MediaQuery.of(context).size.height,
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: SingleChildScrollView(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const CheckoutTop(),
                            const SizedBox(height: 20),
                            const DisplayCartItems(),
                            const SizedBox(height: 20),
                            const BillDetails(),
                            const SizedBox(height: 20),
                            const ApplyCouponWidget(),
                            const SizedBox(height: 20),
                            Container(
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
                                        // PaymentButton(selectedMethod: _selectedPaymentMethod),
                                        ElevatedButton(
                                          onPressed: () {
                                            HapticFeedback.heavyImpact();

                                            //generate order id
                                            final myOrderId = generateOrderId();

                                            if (cartProvider.cart.isEmpty) {
                                              showMessage("Cart is empty");
                                              return;
                                            }

                                            if (addressProvider.address.isEmpty && addressProvider.selectedAddress.isEmpty) {
                                              showMessage("Please select an address");
                                              Navigator.of(context).push(
                                                MaterialPageRoute(
                                                  builder: (context) => const AddressInputForm(),
                                                ),
                                              );
                                              return;
                                            }

                                            final orderProvider = Provider.of<OrderProvider>(context, listen: false);

                                            if (_selectedPaymentMethod == 'Banks') {
                                              // pay(myOrderId).then((value) {
                                              webCheckout(myOrderId).then((value) {
                                                List<Order> orders = cartProvider.cart.map((item) {
                                                  return Order(
                                                    orderId: myOrderId,
                                                    paymentMode: _selectedPaymentMethod,
                                                    productName: item.itemName,
                                                    productImage: item.itemImage,
                                                    quantity: item.qnt,
                                                    price: item.itemPrice.toDouble(),
                                                    // totalPrice: (item.itemPrice * item.qnt).toDouble(),
                                                    // totalPrice: cartProvider.calculateGrandTotal(),
                                                    address: addressProvider.selectedAddress,
                                                    phone: authProvider.phone,
                                                    // overallTotal: cartProvider.calculateGrandTotal(),
                                                    overallTotal: totalAmt,
                                                  );
                                                }).toList();

                                                orderProvider.addOrders(orders, myOrderId, authProvider.phone);
                                                cartProvider.clearCart();
                                              });
                                            } else if (_selectedPaymentMethod == 'Cash') {
                                              Navigator.of(context).push(MaterialPageRoute(builder: (context) => const OrderConfirmationPage())).then((value) {
                                                List<Order> orders = cartProvider.cart.map((item) {
                                                  return Order(
                                                    orderId: myOrderId,
                                                    paymentMode: _selectedPaymentMethod,
                                                    productName: item.itemName,
                                                    productImage: item.itemImage,
                                                    quantity: item.qnt,
                                                    price: item.itemPrice.toDouble(),
                                                    // totalPrice: cartProvider.calculateGrandTotal(),
                                                    // totalPrice: (item.itemPrice * item.qnt).toDouble(),
                                                    address: addressProvider.selectedAddress,
                                                    phone: authProvider.phone,
                                                    // overallTotal: cartProvider.calculateGrandTotal(),
                                                    overallTotal: totalAmt,
                                                  );
                                                }).toList();

                                                orderProvider.addOrders(orders, myOrderId, authProvider.phone);
                                                cartProvider.clearCart();
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
                                        )
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
