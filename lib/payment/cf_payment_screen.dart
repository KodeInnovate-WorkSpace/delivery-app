import 'dart:developer';

import 'package:cashfree_pg/cashfree_pg.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:speedy_delivery/providers/cart_provider.dart';

class CFPaymentScreen extends StatefulWidget {
  const CFPaymentScreen({super.key});

  @override
  State<CFPaymentScreen> createState() => _CFPaymentScreenState();
}

class _CFPaymentScreenState extends State<CFPaymentScreen> {
  var response = "";
  var didResponse = false;

  double amount = 0;

  responseReceived() {
    setState(() {
      this.didResponse = true;
    });
  }

  void startTransaction() async {
    try {
      Map<String, String> inputParams = {
        "orderId": "4",
        // "orderAmount": amount.toString(),
        "orderAmount": "10",
        "customerName": "Kaif",
        "tokenData":"sY9JCVXpkI6ICc5RnIsICN4MzUIJiOicGbhJye.2e0nI0IiOiQWSyVGZy9mIsIiUOlkI6ISej5WZyJXdDJXZkJ3biwiIwEjI6ICduV3btFkclRmcvJCL4kjM0QzN3EzNxojIwhXZiwiImlWYLJiOiUWbh5kcl12b0NXdjJCLiMGOihjYldTMiJjN2YjI6ICdsF2cfJye.lRCVnf60PMvxqz1u8A2mFpavPiWLbL18q9VFZ1LPLLVzJewl5x3iCh4HoJ-4S4EUgs",
        "orderCurrency": "INR",
        "appId": "TEST10205657ccca08a88e3f624d6c4175650201",
        "customerPhone": "7977542667",
        "customerEmail": "kaif.shariff1234@gmail.com",
        "stage": "TEST",
        "notifyUrl": ""
      };

      CashfreePGSDK.doPayment(inputParams)
          .then((value) => value?.forEach((key, value) {
                this.responseReceived();
                log("$key : $value");
                response += "\"$key\":\"$value\"\n";
              }));
    } catch (error) {
      log("Error: $error");
    }
  }

  @override
  Widget build(BuildContext context) {
    final cartProvider = Provider.of<CartProvider>(context);

    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const Text("Go to payment gateway"),
            ElevatedButton(
              onPressed: () async {
                setState(() {
                  amount = cartProvider.calculateGrandTotal();
                });

                startTransaction();
              },
              child: const Text("Payment Gateway"),
            ),
          ],
        ),
      ),
    );
  }
}
