import 'package:flutter/material.dart';
import 'package:in_app_update/in_app_update.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
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
import 'package:speedy_delivery/services/sendPushNotification.dart';
import 'package:speedy_delivery/shared/constants.dart';
import 'package:speedy_delivery/widget/network_handler.dart';
import 'deliveryPartner/provider/delivery_order_provider.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

void main() async {
  await dotenv.load(fileName: 'lib/.env');

  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  // Push notification setup
  final fcmToken = await FirebaseMessaging.instance.getToken(
    vapidKey: "dEfbk9IZT3qlnpTwEaV-Uz:APA91bHLHxsF7f77TrQHCGTylgbWGp6P4GOdRKQYxFXICoBn16phq_mBuluj9IW8z1v-GW9NWBZUlwr-wxA-cmbmKmoPfOsLbYe5toOOscBXlHIw8nYWM1r86-SZzNmdxRjUjW7VvAwf",
  );

  await FirebaseMessaging.instance.setForegroundNotificationPresentationOptions(alert: true, badge: true, sound: true);
  await NotificationService.initializeNotification();

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
          selectionHandleColor: Colors.amberAccent,
        ),
        appBarTheme: const AppBarTheme(
          elevation: 3,
          shadowColor: Colors.black54,
          backgroundColor: Colors.white,
          titleTextStyle: TextStyle(
            fontSize: 16,
            fontFamily: 'Gilroy-SemiBold',
            color: Colors.black,
          ),
        ),
      ),
      home: const MyAppState(),
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

class MyAppState extends StatefulWidget {
  const MyAppState({super.key});

  @override
  State<MyAppState> createState() => _MyAppState();
}

class _MyAppState extends State<MyAppState> {
  // late Future<User?> _authCheckFuture;
  late Future<bool> _loginCheckFuture;

  @override
  void initState() {
    checkForUpdate();
    super.initState();
    // _authCheckFuture = _checkAuthStatus();
    _loginCheckFuture = _checkLoginStatus();
    _initAuthProvider();
  }

  // Future<User?> _checkAuthStatus() async {
  //   return FirebaseAuth.instance.currentUser;
  // }

  Future<bool> _checkLoginStatus() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getBool('isLoggedIn') ?? false;
  }

  void _initAuthProvider() {
    final authProvider = Provider.of<MyAuthProvider>(context, listen: false);
    authProvider.retrievePhone(); // Initialize any necessary data for auth provider
  }

  Future<void> checkForUpdate() async {
    log('checking for Update');
    InAppUpdate.checkForUpdate().then((info) {
      setState(() {
        if (info.updateAvailability == UpdateAvailability.updateAvailable) {
          log('update available');
          update();
        }
      });
    }).catchError((e) {
      log(e.toString());
    });
  }

  void update() async {
    log('Updating');
    await InAppUpdate.startFlexibleUpdate();
    InAppUpdate.completeFlexibleUpdate().then((_) {}).catchError((e) {
      log(e.toString());
    });
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<bool?>(
      future: _loginCheckFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(
            backgroundColor: Colors.amberAccent,
            body: Center(
              child: CircularProgressIndicator(
                color: Colors.green,
              ),
            ),
          );
        } else {
          // if (snapshot.hasData && snapshot.data != null) {
          if (snapshot.hasData && snapshot.data == true) {
            return const HomeScreen();
          } else {
            return const SigninScreen();
          }
        }
      },
    );
  }
}
