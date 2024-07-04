import 'package:flutter/material.dart';
import 'package:speedy_delivery/screens/orders_history_screen.dart';

class OrderConfirmationPage extends StatefulWidget {
  const OrderConfirmationPage({super.key});

  @override
  State<OrderConfirmationPage> createState() => _OrderConfirmationPageState();
}

class _OrderConfirmationPageState extends State<OrderConfirmationPage> {
  bool _showTick = false;

  @override
  void initState() {
    super.initState();
    // Set _showTick to true after 1 second
    Future.delayed(const Duration(seconds: 1), () {
      setState(() {
        _showTick = true;
      });
      // Navigate to home after 2 seconds (1 second for the tick animation and 1 second delay)
      Future.delayed(const Duration(seconds: 2), () {
        // Navigator.of(context).popUntil((route) => route.isFirst);
        Navigator.pushReplacement(
            context,
            MaterialPageRoute(
                builder: (context) => const OrderHistoryScreen()));
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => false,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Order Confirmation'),
          automaticallyImplyLeading: false, // This removes the back button
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              AnimatedOpacity(
                opacity: _showTick ? 1.0 : 0.0,
                duration: const Duration(seconds: 1),
                child: Container(
                  padding: const EdgeInsets.all(20.0),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.green[100],
                  ),
                  child: const Icon(
                    Icons.check_circle,
                    color: Colors.green,
                    size: 100.0,
                  ),
                ),
              ),
              const SizedBox(height: 20),
              const Text(
                'Your order has been placed successfully',
                style: TextStyle(
                  fontSize: 24.0,
                  fontWeight: FontWeight.bold,
                  color: Colors.green,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
