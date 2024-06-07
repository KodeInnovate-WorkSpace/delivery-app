import 'dart:convert';
import 'dart:developer';

import 'package:crypto/crypto.dart';
import 'package:flutter/material.dart';
import 'package:phonepe_payment_sdk/phonepe_payment_sdk.dart';

class PaymentScreen extends StatefulWidget {
  const PaymentScreen({super.key});

  @override
  State<PaymentScreen> createState() => _PaymentScreenState();
}

class _PaymentScreenState extends State<PaymentScreen> {
  String environment = "PRODUCTION";
  String appId = '';
  String merchantId = "PGTESTPAYUAT";
  bool enableLogging = true;
  String saltKey = "099eb0cd-02cf-4e2a-8aca-3e6c6aff0399";
  String saltIndex = "1";

  Object? result;
  String apiEndPoint = "/pg/v1/pay";

  @override
  void initState() {
    super.initState();
    initPayment();
    body = getChecksum();
  }

  void initPayment() {
    PhonePePaymentSdk.init(environment, appId, merchantId, enableLogging)
        .then((val) {
      setState(() {
        result = 'PhonePe SDK Initialized - $val';
      });
    }).catchError((error) {
      handleError(error);
    });
  }


  String body = '';
  String callback = "https://webhook.site/32a895c1-60e8-418f-a1f8-7b0b3db1c75d";
  // String callback = "https://webhook.site/6166a46e-4cd6-480a-b6a8-72b559e53313";
  String checksum = '';
  String packageName = '';

  void startTransaction() async {
    try {
      PhonePePaymentSdk.startTransaction(body, callback, checksum, packageName)
          .then((response) => {
        setState(() {
          if (response != null) {
            String status = response['status'].toString();
            String error = response['error'].toString();
            if (status == 'SUCCESS') {
              result = "Flow Completed - Status: Success!";
            } else {
              result =
              "Flow Completed - Status: $status and Error: $error";
            }
          } else {
            result = "Flow Incomplete";
          }
        })
      })
          .catchError((error) {
        handleError(error);
        return <dynamic>{};
      });
    } catch (error) {
      handleError(error);
    }
  }

  void handleError(error) {
    setState(() {
      if (error is Exception) {
        result = error.toString();
        log("Error: $result");
      } else {
        result = {"error": error};
        log("Error: $result");
      }
    });
  }

  String getChecksum() {
    final reqData = {
      "merchantId": merchantId,
      "merchantTransactionId": "t_52554",
      "merchantUserId": "MUID123",
      "amount": 10000,
      "callbackUrl": callback,
      "mobileNumber": "9999999999",
      "paymentInstrument": {"type": "PAY_PAGE"}
    };
    String base64body = base64.encode(utf8.encode(json.encode(reqData)));
    checksum =
        "${sha256.convert(utf8.encode(base64body + apiEndPoint + saltKey)).toString()}###$saltIndex";
    return base64body;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const Text("Go to payment gateway"),
            ElevatedButton(
              onPressed: () {
                startTransaction();
              },
              child: const Text("Payment Gateway"),
            ),
            if (result != null) Text(result.toString()),
          ],
        ),
      ),
    );
  }
}
