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

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  // await dotenv.load(fileName: "C:/Users/Farid/Desktop/speedy_delivery/lib/.env");
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => MyAuthProvider()),
        ChangeNotifierProvider(create: (context) => CartProvider()),
        ChangeNotifierProvider(create: (_) => CheckUserProvider()),
        ChangeNotifierProvider(create: (_) => AddressProvider()),
        ChangeNotifierProvider(create: (_) => OrderProvider()),
        // Add other providers if needed
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
        // '/home': (context) => const NetworkHandler(
        //       child: HomeScreen(),
        //     ),
        '/profile': (context) => const NetworkHandler(
              child: ProfilePage(),
            ),
        // '/checkout': (context) => const NetworkHandler(
        //       child: CheckoutScreen(),
        //     ),
        '/search': (context) => const NetworkHandler(
              child: SearchPage(),
            ),
        // 'admin': (context) => const NetworkHandler(child: AdminScreen())
      },
    );
  }
}
