import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_cashfree_pg_sdk/api/cferrorresponse/cferrorresponse.dart';
import 'package:flutter_cashfree_pg_sdk/api/cfpaymentgateway/cfpaymentgatewayservice.dart';
import 'package:flutter_cashfree_pg_sdk/api/cfsession/cfsession.dart';
import 'package:provider/provider.dart';
import 'package:speedy_delivery/providers/cart_provider.dart';
import 'package:speedy_delivery/screens/order_tracking.dart';
import 'package:speedy_delivery/screens/orders_screen.dart';
import '../providers/address_provider.dart';
import '../providers/auth_provider.dart';
import '../providers/order_provider.dart';
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

class PaymentButton extends StatefulWidget {
  final String selectedMethod;
  const PaymentButton({super.key, required this.selectedMethod});

  @override
  State<PaymentButton> createState() => _PaymentButtonState();
}

class _PaymentButtonState extends State<PaymentButton> {
  // final String widget.selectedMethod = widget.selectedMethod;
  double totalAmt = 0.0;
  String customerId = '';
  String customerPhone = "";

  var cfPaymentGatewayService = CFPaymentGatewayService();

  @override
  void initState() {
    super.initState();
    final orderProvider = Provider.of<OrderProvider>(context, listen: false);

    customerId = _generateCustomerId();
    cfPaymentGatewayService.setCallback(verifyPayment, (errorResponse, orderId) => onError(errorResponse, orderId, context, orderProvider));
  }

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
      'x-client-id': "TEST102073159c36086010050049f41951370201",
      'x-client-secret': "cfsk_ma_test_85d10e30b385bd991902bfa67e3222bd_69af2996",
      //Prod
      // 'x-client-id': "6983506cac38e05faf1b6e3085053896",
      // 'x-client-secret': "cfsk_ma_prod_d184d86eba0c9e3ff1ba85866e4c6639_abf28ea8",
      'x-api-version': '2023-08-01',
    };
    var request = http.Request('POST', Uri.parse('https://sandbox.cashfree.com/pg/orders')); // test
    // var request = http.Request('POST', Uri.parse('https://api.cashfree.com/pg/orders')); // prod
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
      MaterialPageRoute(builder: (context) => const OrderHistoryScreen()),
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

  Future<void> webCheckout(String myOrdId) async {
    try {
      CFSession? session = await createSession(myOrdId);
      var cfWebCheckout = CFWebCheckoutPaymentBuilder().setSession(session!).build();
      cfPaymentGatewayService.doPayment(cfWebCheckout);
    } on CFException catch (e) {
      debugPrint(e.message);
    }
  }

  Future<CFSession?> createSession(String myOrdId) async {
    try {
      final paymentSessionId = await createSessionID(myOrdId);
      // var session = CFSessionBuilder().setEnvironment(CFEnvironment.PRODUCTION).setOrderId(myOrdId).setPaymentSessionId(paymentSessionId["payment_session_id"]).build();
      var session = CFSessionBuilder().setEnvironment(CFEnvironment.SANDBOX).setOrderId(myOrdId).setPaymentSessionId(paymentSessionId["payment_session_id"]).build();
      return session;
    } on CFException catch (e) {
      debugPrint(e.message);
    }
    return null;
  }

  // Future<void> pay(String myOrdId) async {
  //   try {
  //     var session = await createSession(myOrdId);
  //     List<CFPaymentModes> components = <CFPaymentModes>[];
  //     var paymentComponent = CFPaymentComponentBuilder().setComponents(components).build();
  //     var theme = CFThemeBuilder().setNavigationBarBackgroundColorColor("#f7ce34").setPrimaryFont("Menlo").setSecondaryFont("Futura").build();
  //     var cfDropCheckoutPayment = CFDropCheckoutPaymentBuilder().setSession(session!).setPaymentComponent(paymentComponent).setTheme(theme).build();
  //     cfPaymentGatewayService.doPayment(cfDropCheckoutPayment);
  //   } on CFException catch (e) {
  //     debugPrint(e.message);
  //   }
  // }

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

  @override
  Widget build(BuildContext context) {
    final cartProvider = Provider.of<CartProvider>(context);
    final authProvider = Provider.of<MyAuthProvider>(context);
    final addressProvider = Provider.of<AddressProvider>(context);

    setState(() {
      totalAmt = cartProvider.calculateGrandTotal();
      customerPhone = authProvider.phone.isEmpty ? "0000000000" : authProvider.phone;
    });
    return ElevatedButton(
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

        if (widget.selectedMethod == 'Banks') {
          // pay(myOrderId).then((value) {
          webCheckout(myOrderId).then((value) {
            List<Order> orders = cartProvider.cart.map((item) {
              return Order(
                orderId: myOrderId,
                paymentMode: widget.selectedMethod,
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
        } else if (widget.selectedMethod == 'Cash') {
          Navigator.of(context).push(MaterialPageRoute(builder: (context) => const OrderConfirmationPage())).then((value) {
            List<Order> orders = cartProvider.cart.map((item) {
              return Order(
                orderId: myOrderId,
                paymentMode: widget.selectedMethod,
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
    );
  }
}
