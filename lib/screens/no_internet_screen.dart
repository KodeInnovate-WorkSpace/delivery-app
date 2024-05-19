import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:speedy_delivery/providers/connectivity_provider.dart';
import 'package:speedy_delivery/screens/home_screen.dart';

class NoInternetScreen extends StatefulWidget {
  const NoInternetScreen({super.key});

  @override
  State<NoInternetScreen> createState() => _NoInternetScreenState();
}

class _NoInternetScreenState extends State<NoInternetScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const Text("Looks like you don't have internet!"),
            ElevatedButton(
              onPressed: () async {
                final isConnected = await Provider.of<ConnectivityProvider>(
                        context,
                        listen: false)
                    .checkConnectivity();
                if (isConnected) {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (context) => const HomeScreen()),
                  );
                } else {
                  const CircularProgressIndicator();
                }
              },
              child: const Text("Retry"),
            ),
          ],
        ),
      ),
    );
  }
}
