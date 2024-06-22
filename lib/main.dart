import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:provider/provider.dart';
import 'package:speedy_delivery/providers/address_provider.dart';
import 'package:speedy_delivery/providers/auth_provider.dart';
import 'package:speedy_delivery/providers/cart_provider.dart';
import 'package:speedy_delivery/providers/check_user_provider.dart';
import 'package:speedy_delivery/providers/order_provider.dart';
import 'package:speedy_delivery/screens/profile_screen.dart';
import 'package:speedy_delivery/screens/search_functionality.dart';
import 'package:speedy_delivery/widget/network_handler.dart';
import 'package:speedy_delivery/screens/splash_screen.dart';

import 'deliveryPartner/provider/delivery_order_provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => MyAuthProvider()),
        ChangeNotifierProvider(create: (context) => CartProvider()),
        ChangeNotifierProvider(create: (_) => CheckUserProvider()),
        ChangeNotifierProvider(create: (_) => AddressProvider()),
        ChangeNotifierProvider(create: (_) => OrderProvider()),
        ChangeNotifierProvider(create: (_) => AllOrderProvider()),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        fontFamily: "Gilroy-Regular",
        scaffoldBackgroundColor: Colors.white,
        textSelectionTheme: const TextSelectionThemeData(
            selectionHandleColor: Colors.amberAccent),
        appBarTheme: const AppBarTheme(
          elevation: 3,
          shadowColor: Colors.black54,
          backgroundColor: Colors.white,
          surfaceTintColor: Colors.white,
          titleTextStyle: TextStyle(
            fontSize: 16,
            fontFamily: 'Gilroy-SemiBold',
            color: Colors.black,
          ),
        ),
      ),
      home: const NetworkHandler(
        child: SplashScreen(),
      ),
      routes: {
        '/profile': (context) => const NetworkHandler(
              child: ProfilePage(),
            ),
        '/search': (context) => const NetworkHandler(
              child: SearchPage(),
            ),
      },
    );
  }
}
