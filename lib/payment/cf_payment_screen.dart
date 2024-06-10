import 'dart:convert';
import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:flutter_cashfree_pg_sdk/api/cferrorresponse/cferrorresponse.dart';
import 'package:flutter_cashfree_pg_sdk/api/cfpayment/cfwebcheckoutpayment.dart';
import 'package:flutter_cashfree_pg_sdk/api/cfpaymentgateway/cfpaymentgatewayservice.dart';
import 'package:flutter_cashfree_pg_sdk/api/cfsession/cfsession.dart';
import 'package:flutter_cashfree_pg_sdk/utils/cfenums.dart';
import 'package:flutter_cashfree_pg_sdk/utils/cfexceptions.dart';
import 'package:http/http.dart' as http;

import '../services/random_number.dart';

class PaymentScreen extends StatefulWidget {
  const PaymentScreen({super.key});

  @override
  State<PaymentScreen> createState() => _PaymentScreenState();
}

class _PaymentScreenState extends State<PaymentScreen> {
  @override
  void initState() {
    super.initState();
    CFPaymentGatewayService().setCallback(onVerify, onError);
  }

  String customOrderId = randomWithNDigits(6).toString();

  Future<String?> createSession() async {
    try {
      final response = await http.post(
        Uri.parse('http://localhost:3000/createOrder'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(<String, dynamic>{
          'orderId': customOrderId,
          'orderAmount': 1.00,
          'customerDetails': {
            'customer_id': 'walterwNrcMi',
            'customer_phone': '7977542667',
            'customer_name': 'Walter White',
            'customer_email': 'walter.white@example.com',
          },
        }),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return data['payment_session_id'];
      } else {
        log('Failed to create session: ${response.body}');
      }
    } catch (e) {
      log('Error creating session: $e');
    }
    return null;
  }

  webCheckout() async {
    try {
      final sessionId = await createSession();
      if (sessionId != null) {
        var session = CFSessionBuilder()
            .setEnvironment(CFEnvironment.SANDBOX)
            .setOrderId(customOrderId)
            .setPaymentSessionId(sessionId)
            .build();

        var cfWebCheckout = CFWebCheckoutPaymentBuilder().setSession(session);
        CFPaymentGatewayService().doPayment(cfWebCheckout.build());
      } else {
        log('Failed to obtain session ID');
      }
    } on CFException catch (e) {
      log('Checkout error: ${e.message}');
    }
  }

  void onVerify(String orderId) {
    // Verify Payment status from the backend using order Status API
  }

  void onError(CFErrorResponse errorResponse, String orderId) {
    // Configure Error callback
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Cashfree Flutter Integration'),
        ),
        body: Center(
          child: Column(
            children: [
              const Text("Click below to open the checkout page"),
              TextButton(onPressed: webCheckout, child: const Text("Pay Now")),
            ],
          ),
        ),
      ),
    );
  }
}
