import 'dart:convert';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_cashfree_pg_sdk/api/cferrorresponse/cferrorresponse.dart';
import 'package:flutter_cashfree_pg_sdk/api/cfpayment/cfwebcheckoutpayment.dart';
import 'package:flutter_cashfree_pg_sdk/api/cfpaymentgateway/cfpaymentgatewayservice.dart';
import 'package:flutter_cashfree_pg_sdk/api/cfsession/cfsession.dart';
import 'package:flutter_cashfree_pg_sdk/utils/cfenums.dart';
import 'package:flutter_cashfree_pg_sdk/utils/cfexceptions.dart';
import 'package:provider/provider.dart';
import 'package:speedy_delivery/providers/cart_provider.dart';
import 'package:speedy_delivery/services/random_number.dart';
import 'package:http/http.dart' as http;

class OrderResponse {
  final String orderId;
  final String paymentSessionId;

  OrderResponse({required this.orderId, required this.paymentSessionId});

  factory OrderResponse.fromJson(Map<String, dynamic> json) {
    return OrderResponse(
      orderId: json['orderId'],
      paymentSessionId: json['payment_session_id'], // updated key
    );
  }
}

class PaymentApp extends StatefulWidget {
  const PaymentApp({super.key});

  @override
  State<PaymentApp> createState() => _PaymentAppState();
}

class _PaymentAppState extends State<PaymentApp> {
  double totalAmt = 0.0;

  var cfPaymentGatewayService = CFPaymentGatewayService();

  @override
  void initState() {
    super.initState();
    cfPaymentGatewayService.setCallback(verifyPayment, onError);
  }

  // void createOrder() async {
  Future<OrderResponse?> createOrder() async {
    var url = Uri.parse('https://sandbox.cashfree.com/pg/orders');
    var headers = {
      'Content-Type': 'application/json',

      'x-api-version': '2023-08-01',
    };

    var request = {
      "order_amount": totalAmt.toString(),
      "order_currency": "INR",
      "customer_details": {
        "customer_id": "node_sdk_test",
        "customer_name": "",
        "customer_email": "example@gmail.com",
        "customer_phone": "9999999999"
      },
      "order_meta": {
        "return_url":
            "https://test.cashfree.com/pgappsdemos/return.php?order_id=${randomWithNDigits(6).toString()}"
      },
      "order_note": ""
    };

    try {
      var response = await http.post(
        url,
        headers: headers,
        body: jsonEncode(request),
      );

      if (response.statusCode == 200) {
        var responseData = jsonDecode(response.body);
        log(responseData);
      } else {
        log('Failed to create order. Status code: ${response.statusCode}');
      }
    } catch (e) {
      log('Error setting up order request: $e');
    }
    return null;
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

  Future<CFSession?> createSession() async {
    try {
      var orderResponse = await createOrder();
      var session = CFSessionBuilder()
          .setEnvironment(CFEnvironment.SANDBOX)
          .setOrderId(randomWithNDigits(6).toString())
          // .setOrderId(orderResponse!.orderId.toString())
          .setPaymentSessionId(
              "session_lLhK7q0b89n7--tbYa47IkKm90xZtH_aYjZmHJLZEiq17KLZvKTEweAyiut_Za9FHEzipACnjLoXpQkaG3t_8IoxAhP3KVeKJcq5z6q5nNTU")
          .build();
      return session;
    } on CFException catch (e) {
      log(e.message);
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    final cartProvider = Provider.of<CartProvider>(context);

    setState(() {
      totalAmt = cartProvider.calculateGrandTotal();
    });

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Cashfree Payment Screen'),
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const Text("Click below to open the payment gateway page"),
              TextButton(onPressed: webCheckout, child: const Text("Pay Now")),
            ],
          ),
        ),
      ),
    );
  }
}
