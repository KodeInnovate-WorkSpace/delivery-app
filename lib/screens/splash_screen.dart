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
  @override
  void initState() {
    super.initState();
    _initAuthProvider();
    _navigateBasedOnAuth();
  }

  void _initAuthProvider() {
    final authProvider = Provider.of<MyAuthProvider>(context, listen: false);
    authProvider.setPhone();
  }

  Future<void> _navigateBasedOnAuth() async {
    await Future.delayed(
        const Duration(seconds: 2)); // Add a delay to show the splash screen
    FirebaseAuth.instance.authStateChanges().listen((User? user) {
      if (mounted) {
        if (user != null) {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => const HomeScreen()),
          );
        } else {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => const SigninScreen()),
          );
        }
      }
    });
  }

  Widget splashHome() {
    return Center(
      child: Image.asset("assets/icon.png"),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        color: Colors.amberAccent,
        child: splashHome(),
      ),
    );
  }
}
//updated the splash screen
