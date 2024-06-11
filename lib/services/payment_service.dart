import 'dart:convert';
import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:flutter_cashfree_pg_sdk/api/cferrorresponse/cferrorresponse.dart';
import 'package:flutter_cashfree_pg_sdk/api/cfpayment/cfdropcheckoutpayment.dart';
import 'package:flutter_cashfree_pg_sdk/api/cfpayment/cfwebcheckoutpayment.dart';
import 'package:flutter_cashfree_pg_sdk/api/cfpaymentcomponents/cfpaymentcomponent.dart';
import 'package:flutter_cashfree_pg_sdk/api/cfpaymentgateway/cfpaymentgatewayservice.dart';
import 'package:flutter_cashfree_pg_sdk/api/cfsession/cfsession.dart';
import 'package:flutter_cashfree_pg_sdk/api/cftheme/cftheme.dart';
import 'package:flutter_cashfree_pg_sdk/utils/cfenums.dart';
import 'package:flutter_cashfree_pg_sdk/utils/cfexceptions.dart';
import 'package:provider/provider.dart';
import 'package:speedy_delivery/providers/auth_provider.dart';
import 'package:speedy_delivery/providers/cart_provider.dart';
import 'package:http/http.dart' as http;
import 'package:uuid/uuid.dart';

class PaymentApp extends StatefulWidget {
  const PaymentApp({super.key});

  @override
  State<PaymentApp> createState() => _PaymentAppState();
}

class _PaymentAppState extends State<PaymentApp> {
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

  createSessionID(String myOrderId) async {
    var headers = {
      'Content-Type': 'application/json',
      'x-client-id': "TEST102073159c36086010050049f41951370201",
      'x-client-secret':
          "cfsk_ma_test_85d10e30b385bd991902bfa67e3222bd_69af2996",
      'x-api-version': '2023-08-01', // This is latest version for API
      // 'x-request-id': 'fluterwings'
    };
    log("$headers");
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
      log(await response.stream.bytesToString());
      log("${response.reasonPhrase}");
    }
  }

  void verifyPayment(String orderId) {
    log("Verify Payment");
  }

  void onError(CFErrorResponse errorResponse, String orderId) {
    log(errorResponse.getMessage().toString());
    log("Error while making payment");
  }

  webCheckout() async {
    try {
      CFSession? session = await createSession();
      var cfWebCheckout =
          CFWebCheckoutPaymentBuilder().setSession(session!).build();
      cfPaymentGatewayService.doPayment(cfWebCheckout);
    } on CFException catch (e) {
      log(e.message);
    }
  }

  // New session
  Future<CFSession?> createSession() async {
    try {
      final paymentSessionId = await createSessionID(orderId);
      var session = CFSessionBuilder()
          .setEnvironment(CFEnvironment.SANDBOX)
          // .setOrderId(orderId)
          .setOrderId(orderId)
          .setPaymentSessionId(paymentSessionId["payment_session_id"])
          // .setPaymentSessionId(
          //     "session_bjAYHa4w9LurE8ge89_X86D60IfWekLhirl4H0m4VxeBaj88_7OFP1Q0XYBh7dsJR_ELh6czuupBif2bWvLDWYdWq3OkCu24XZXfPb5bKqDr") // Set the retrieved token here
          .build();
      return session;
    } on CFException catch (e) {
      log(e.message);
    }
    return null;
  }

  pay() async {
    try {
      var session = await createSession();
      List<CFPaymentModes> components = <CFPaymentModes>[];
      // If you want to set paument mode to be shown to customer
      var paymentComponent =
          CFPaymentComponentBuilder().setComponents(components).build();
      // We will set theme of checkout session page like fonts, color
      var theme = CFThemeBuilder()
          .setNavigationBarBackgroundColorColor("#FF0000")
          .setPrimaryFont("Menlo")
          .setSecondaryFont("Futura")
          .build();
      // Create checkout with all the settings we have set earlier
      var cfDropCheckoutPayment = CFDropCheckoutPaymentBuilder()
          .setSession(session!)
          .setPaymentComponent(paymentComponent)
          .setTheme(theme)
          .build();
      // Launching the payment page

      cfPaymentGatewayService.doPayment(cfDropCheckoutPayment);
    } on CFException catch (e) {
      log(e.message);
    }
  }

  @override
  Widget build(BuildContext context) {
    final cartProvider = Provider.of<CartProvider>(context);
    final authProvider = Provider.of<MyAuthProvider>(context);

    setState(() {
      totalAmt = cartProvider.calculateGrandTotal();
      customerPhone =
          authProvider.phone.isEmpty ? "0000000000" : authProvider.phone;
    });

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Get UPI Apps'),
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const Text("Click below to open the payment gateway page"),
              ElevatedButton(
                onPressed: () {
                  // webCheckout();
                  pay();
                },
                child: const Text("Get Apps"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
