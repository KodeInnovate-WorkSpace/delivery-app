
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:speedy_delivery/providers/auth_provider.dart';
import 'package:speedy_delivery/screens/home_screen.dart';
import 'package:speedy_delivery/screens/sign_in_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  String? userPhone;

  @override
  void initState() {
    super.initState();
    _checkIfLogin();
    final authProvider = Provider.of<MyAuthProvider>(context, listen: false);
    authProvider.setPhone();
  }

  Future<void> _checkIfLogin() async {
    // await Future.delayed(
    //     const Duration(seconds: 3));
    // Simulate a delay for the splash screen
    FirebaseAuth.instance.authStateChanges().listen((User? user) async {
      if (mounted) {
        if (user != null) {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => const HomeScreen()),
          );
        } else {
          // User is not logged in, navigate to SignInScreen
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => const SigninScreen()),
          );
        }
      }
    });
  }

  Widget splashHome() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Image.asset("assets/images/speedy.png"), // Assuming your image is here
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        decoration: const BoxDecoration(color: Colors.amberAccent),
        child: splashHome(),
      ),
    );
  }
}
