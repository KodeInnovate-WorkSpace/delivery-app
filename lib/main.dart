import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:speedy_delivery/providers/auth_provider.dart';
import 'package:speedy_delivery/screens/home_screen.dart';
import 'package:speedy_delivery/screens/profile_screen.dart';
import 'package:speedy_delivery/screens/search_functionality.dart';
import 'package:speedy_delivery/screens/sign_in_screen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'dart:developer';
import 'package:firebase_app_check/firebase_app_check.dart';
import 'package:speedy_delivery/providers/cart_provider.dart';
import 'package:speedy_delivery/providers/check_user_provider.dart';
import 'package:speedy_delivery/providers/address_provider.dart';
import 'package:speedy_delivery/providers/order_provider.dart';
import 'package:speedy_delivery/providers/valet_provider.dart';
import 'package:speedy_delivery/screens/skeleton.dart';
import 'package:speedy_delivery/shared/constants.dart';
import 'package:speedy_delivery/widget/network_handler.dart';

import 'deliveryPartner/provider/delivery_order_provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  // Push notification setup
  final fcmToken = await FirebaseMessaging.instance.getToken(vapidKey: "dEfbk9IZT3qlnpTwEaV-Uz:APA91bHLHxsF7f77TrQHCGTylgbWGp6P4GOdRKQYxFXICoBn16phq_mBuluj9IW8z1v-GW9NWBZUlwr-wxA-cmbmKmoPfOsLbYe5toOOscBXlHIw8nYWM1r86-SZzNmdxRjUjW7VvAwf");
  FirebaseMessaging messaging = FirebaseMessaging.instance;

  await messaging.requestPermission(
    alert: true,
    announcement: false,
    badge: true,
    carPlay: false,
    criticalAlert: false,
    provisional: true,
    sound: true,
  );

  FirebaseMessaging.onMessage.listen((RemoteMessage message) {
    log('Got a message whilst in the foreground!');
    log('Message data: ${message.data}');

    if (message.notification != null) {
      log('Message also contained a notification: ${message.notification}');
    }
  });

  await FirebaseMessaging.instance.setAutoInitEnabled(true);
  log("FCM: $fcmToken");

  // App Check setup
  await FirebaseAppCheck.instance.activate(
    androidProvider: AndroidProvider.playIntegrity,
  );

  await fetchConstantFromFirebase();

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => MyAuthProvider()),
        ChangeNotifierProvider(create: (context) => CartProvider()),
        ChangeNotifierProvider(create: (_) => CheckUserProvider()),
        ChangeNotifierProvider(create: (_) => AddressProvider()),
        ChangeNotifierProvider(create: (_) => OrderProvider()),
        ChangeNotifierProvider(create: (_) => AllOrderProvider()),
        ChangeNotifierProvider(create: (_) => ValetProvider()),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  late Future<User?> _authCheckFuture;

  @override
  void initState() {
    super.initState();
    _authCheckFuture = _checkAuthStatus();
    _initAuthProvider();
  }

  Future<User?> _checkAuthStatus() async {
    await Future.delayed(const Duration(seconds: 2)); // Add a delay to show the splash screen
    return FirebaseAuth.instance.currentUser;
  }

  void _initAuthProvider() {
    final authProvider = Provider.of<MyAuthProvider>(context, listen: false);
    authProvider.setPhone();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        fontFamily: "Gilroy-Regular",
        scaffoldBackgroundColor: Colors.white,
        textSelectionTheme: const TextSelectionThemeData(selectionHandleColor: Colors.amberAccent),
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
      home: FutureBuilder<User?>(
        future: _authCheckFuture,
        builder: (context, snapshot) {
          // Show a loading indicator while checking auth status
          if (snapshot.connectionState == ConnectionState.waiting) {
            // return const Scaffold(
            //   backgroundColor: Colors.amberAccent,
            //   body: Center(
            //     child: CircularProgressIndicator(
            //       color: Colors.green,
            //     ),
            //   ),
            // );

            return const SkeletonScreen();
            // return Container(
            //   width: double.infinity,
            //   height: double.infinity,
            //   color: Colors.amberAccent,
            //   child: splashHome(),
            // );

          }

          // Navigate to HomeScreen or Sign in Screen based on auth status
          if (snapshot.hasData && snapshot.data != null) {
            return const HomeScreen();
          } else {
            return const SigninScreen();
          }
        },
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

  Widget splashHome() {
    return Center(
      child: Image.asset("assets/icon.png"),
    );
  }
}
