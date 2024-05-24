import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:speedy_delivery/providers/connectivity_provider.dart';
import 'package:speedy_delivery/screens/no_internet_screen.dart';
import 'package:speedy_delivery/screens/sign_in_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder<bool>(
        future: Provider.of<ConnectivityProvider>(context, listen: false)
            .checkConnectivity(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            final isConnected = snapshot.data!;
            if (isConnected) {
              return const SigninScreen();
            } else {
              return const NoInternetScreen();
            }
          } else {
            return Container(
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height,
              decoration: const BoxDecoration(color: Colors.amberAccent),
              child: splashWidget(),
            );
          }
        },
      ),
    );
  }
}
