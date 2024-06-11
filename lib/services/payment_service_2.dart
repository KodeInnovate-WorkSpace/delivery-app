import 'dart:developer';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_cashfree_pg_sdk/api/cfcard/cfcardwidget.dart';
import 'package:flutter_cashfree_pg_sdk/api/cferrorresponse/cferrorresponse.dart';
import 'package:flutter_cashfree_pg_sdk/api/cfpayment/cfdropcheckoutpayment.dart';
import 'package:flutter_cashfree_pg_sdk/api/cfpayment/cfupi.dart';
import 'package:flutter_cashfree_pg_sdk/api/cfpayment/cfupipayment.dart';
import 'package:flutter_cashfree_pg_sdk/api/cfpayment/cfwebcheckoutpayment.dart';
import 'package:flutter_cashfree_pg_sdk/api/cfpaymentcomponents/cfpaymentcomponent.dart';
import 'package:flutter_cashfree_pg_sdk/api/cfpaymentgateway/cfpaymentgatewayservice.dart';
import 'package:flutter_cashfree_pg_sdk/api/cfsession/cfsession.dart';
import 'package:flutter_cashfree_pg_sdk/api/cftheme/cftheme.dart';
import 'package:flutter_cashfree_pg_sdk/utils/cfenums.dart';
import 'package:flutter_cashfree_pg_sdk/utils/cfexceptions.dart';
import 'package:flutter_cashfree_pg_sdk/api/cfupi/cfupiutils.dart';
import 'package:http/http.dart' as http;
import 'package:speedy_delivery/services/random_number.dart';
import 'package:uuid/uuid.dart';

class PaymentApp2 extends StatefulWidget {
  const PaymentApp2({super.key});

  @override
  State<PaymentApp2> createState() => _PaymentApp2State();
}

class _PaymentApp2State extends State<PaymentApp2> {
  var cfPaymentGatewayService = CFPaymentGatewayService();

  @override
  void initState() {
    super.initState();
    cfPaymentGatewayService.setCallback(verifyPayment, onError);
    final GlobalKey<CFCardWidgetState> myWidgetKey =
        GlobalKey<CFCardWidgetState>();
    try {
      createSession();
    } on CFException catch (e) {
      log(e.message);
    }

    CFUPIUtils().getUPIApps().then((value) {
      log("value");
      log("$value");
      for (var i = 0; i < (value?.length ?? 0); i++) {
        var a = value?[i]["id"] as String;
        if (a.contains("cashfree")) {
          selectedId = value?[i]["id"];
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Plugin example app'),
        ),
        body: Center(
          child: Column(
            children: [
              TextButton(onPressed: pay, child: const Text("Pay")),
              TextButton(
                  onPressed: webCheckout, child: const Text("Web Checkout")),
              TextButton(
                  onPressed: upiCollectPay,
                  child: const Text("UPI Collect Pay")),
              TextButton(
                  onPressed: upiIntentPay, child: const Text("UPI Intent Pay")),
            ],
          ),
        ),
      ),
    );
  }

  void verifyPayment(String orderId) {
    log("Verify Payment");
  }

  void onError(CFErrorResponse errorResponse, String orderId) {
    log("onError:  ${errorResponse.getMessage()}");
    log("Error while making payment");
  }

  // Generate a unique order ID
  String orderId = const Uuid().v4();
  // String orderId = randomWithNDigits(6).toString();
  String paymentSessionId = "";

  void receivedEvent(String event_name, Map<dynamic, dynamic> meta_data) {
    log(event_name);
    log("${meta_data}");
  }

  // CFEnvironment environment = CFEnvironment.SANDBOX;
  String selectedId = "";

  upiCollectPay() async {
    try {
      var session = await createSession();
      var upi = CFUPIBuilder()
          .setChannel(CFUPIChannel.COLLECT)
          .setUPIID("kaif.shariff1234-1@okhdfcbank")
          .build();
      var upiPayment =
          CFUPIPaymentBuilder().setSession(session!).setUPI(upi).build();
      cfPaymentGatewayService.doPayment(upiPayment);
    } on CFException catch (e) {
      log(e.message);
    }
  }

  upiIntentPay() async {
    try {
      cfPaymentGatewayService.setCallback(verifyPayment, onError);
      var session = await createSession();
      var upi = CFUPIBuilder()
          .setChannel(CFUPIChannel.INTENT)
          .setUPIID("kaif.shariff1234-1@okhdfcbank")
          .build();
      var upiPayment =
          CFUPIPaymentBuilder().setSession(session!).setUPI(upi).build();
      cfPaymentGatewayService.doPayment(upiPayment);
    } on CFException catch (e) {
      log(e.message);
    }
  }

  pay() async {
    try {
      var session = await createSession();
      List<CFPaymentModes> components = <CFPaymentModes>[];
      components.add(CFPaymentModes.UPI);
      var paymentComponent =
          CFPaymentComponentBuilder().setComponents(components).build();

      var theme = CFThemeBuilder()
          .setNavigationBarBackgroundColorColor("#FF0000")
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
      log(e.message);
    }
  }

  Future<CFSession?> createSession() async {
    try {
      paymentSessionId = await getAccessToken();
      var session = CFSessionBuilder()
          .setEnvironment(CFEnvironment.SANDBOX)
          .setOrderId(randomWithNDigits(6).toString())
          .setPaymentSessionId(paymentSessionId) // Set the retrieved token here
          .build();
      return session;
    } on CFException catch (e) {
      log(e.message);
    }
    return null;
  }

  Future<String> getAccessToken() async {
    var res = await http.post(
      Uri.https("test.cashfree.com", "api/v2/cftoken/order"),
      // Uri.https("https://sandbox.cashfree.com/pg/orders", "api/v2/cftoken/order"),
      headers: <String, String>{
        'Content-Type': 'application/json',
        'X-Client-Id':
            'TEST102073159c36086010050049f41951370201', // Replace with your Client ID
        'X-Client-Secret':
            'cfsk_ma_test_85d10e30b385bd991902bfa67e3222bd_69af2996', // Replace with your Client Secret
        // 'x-api-version': '2024-08-01',
      },
      body: jsonEncode({
        "orderId": orderId,
        "orderAmount": 1,
        "orderCurrency": "INR",
      }),
    );
    if (res.statusCode == 200) {
      var jsonResponse = jsonDecode(res.body);
      if (jsonResponse['status'] == 'OK') {
        return jsonResponse['cftoken'];
      }
    }
    log('Failed to get token: ${res.body}');
    return '';
  }

  newPay() async {
    cfPaymentGatewayService = CFPaymentGatewayService();
    cfPaymentGatewayService.setCallback((p0) async {
      log(p0);
    }, (p0, p1) async {
      log("$p0");
      log(p1);
    });
    webCheckout();
  }

  webCheckout() async {
    try {
      CFSession? session = await createSession();
      var theme = CFThemeBuilder()
          .setNavigationBarBackgroundColorColor("#ff00ff")
          .setNavigationBarTextColor("#ffffff")
          .build();
      var cfWebCheckout = CFWebCheckoutPaymentBuilder()
          .setSession(session!)
          .setTheme(theme)
          .build();
      cfPaymentGatewayService.doPayment(cfWebCheckout);
    } on CFException catch (e) {
      log(e.message);
    }
  }
}
