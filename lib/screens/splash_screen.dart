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
      body: Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        decoration: const BoxDecoration(color: Colors.amberAccent),
        child: splashWidget(),
      ),
    );
  }
}
