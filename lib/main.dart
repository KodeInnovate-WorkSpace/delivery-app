import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:speedy_delivery/admin/admin_screen.dart';
import 'package:speedy_delivery/firebase_options.dart';
import 'package:speedy_delivery/providers/auth_provider.dart';
import 'package:speedy_delivery/providers/cart_provider.dart';
import 'package:speedy_delivery/providers/category_provider.dart';
import 'package:speedy_delivery/providers/check_user_provider.dart';
import 'package:speedy_delivery/providers/connectivity_provider.dart';
import 'package:speedy_delivery/providers/product_provider.dart';
import 'package:firebase_core/firebase_core.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  runApp(MultiProvider(providers: [
    ChangeNotifierProvider(create: (_) => ConnectivityProvider()),
    ChangeNotifierProvider(create: (_) => MyAuthProvider()),
    ChangeNotifierProvider(create: (_) => CartProvider()),
    ChangeNotifierProvider(create: (_) => CheckUserProvider()),
    ChangeNotifierProvider(create: (_) => CategoryProvider()),
    ChangeNotifierProvider(create: (_) => ProductProvider()),
    ChangeNotifierProvider(create: (_) => CartProvider()),
  ], child: const MyApp()));
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  bool isLogin = false;

  @override
  void initState() {
    super.initState();
    checkIfLogin(); // Call this method when the app starts
  }

  Future<void> checkIfLogin() async {
    FirebaseAuth.instance.authStateChanges().listen((User? user) {
      if (user != null && mounted) {
        // User is logged in
        setState(() {
          isLogin = true;
        });
      } else {
        // User is not logged in
        setState(() {
          isLogin = false;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        fontFamily: "Gilroy-Regular",
        scaffoldBackgroundColor: Colors.white,
        appBarTheme: const AppBarTheme(
          elevation: 3,
          shadowColor: Colors.black54,
          backgroundColor: Colors.white,
          surfaceTintColor: Colors.white,
          titleTextStyle: TextStyle(
              fontSize: 16, fontFamily: 'Gilroy-SemiBold', color: Colors.black),
        ),
      ),
      // home: isLogin ? const HomeScreen() : const SplashScreen(),
      home: const AdminScreen(),
    );
  }
}
