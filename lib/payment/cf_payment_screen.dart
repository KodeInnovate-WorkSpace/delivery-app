import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';

class CFPaymentScreen extends StatefulWidget {
  const CFPaymentScreen({super.key});

  @override
  State<CFPaymentScreen> createState() => _CFPaymentScreenState();
}

class _CFPaymentScreenState extends State<CFPaymentScreen> {
  String res = '';

  Future<void> createOrder() async {
    final url = Uri.parse(
        'http://192.168.0.195:3000'); // Use http for local development
    final response = await http
        .get(url); // Use get instead of post for your current endpoint

    if (response.statusCode == 200) {
      setState(() {
        res = response.body;
      });
    } else {
      setState(() {
        res = 'Failed to load';
      });
    }
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
              onPressed: () async {
                await createOrder(); // Call createOrder and wait for it to complete
              },
              child: Text(res == '' ? "NO RESPONSE" : res),
            ),
          ],
        ),
      ),
    );
  }
}
