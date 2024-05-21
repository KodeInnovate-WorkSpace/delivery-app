import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:speedy_delivery/firebase_options.dart';
import 'package:speedy_delivery/providers/auth_provider.dart';
import 'package:speedy_delivery/providers/category_provider.dart';
import 'package:speedy_delivery/providers/check_user_provider.dart';
import 'package:speedy_delivery/providers/connectivity_provider.dart';
import 'package:speedy_delivery/providers/location_provider.dart';
import 'package:speedy_delivery/screens/home_screen.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  await Supabase.initialize(
    url: 'https://kaxlzersgiszdagvmxrc.supabase.co',
    anonKey:
        'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImtheGx6ZXJzZ2lzemRhZ3ZteHJjIiwicm9sZSI6ImFub24iLCJpYXQiOjE3MTYyODkxODksImV4cCI6MjAzMTg2NTE4OX0.FqsR6440f7dHvXz4gEdVdFZoyJK4zmesh3Jh0QwXloU',
  );

  runApp(MultiProvider(providers: [
    ChangeNotifierProvider(create: (_) => ConnectivityProvider()),
    ChangeNotifierProvider(create: (_) => AuthProvider()),
    ChangeNotifierProvider(create: (_) => LocationProvider()),
    ChangeNotifierProvider(create: (_) => CheckUserProvider()),
    ChangeNotifierProvider(create: (_) => CategoryProvider()),
  ], child: const MyApp()));
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
              fontSize: 16, fontFamily: 'Gilroy-SemiBold', color: Colors.black),
        ),
      ),
      home: const Scaffold(
        body: Center(
          // child: SplashScreen(),
          child: HomeScreen(),
        ),
      ),
    );
  }
}
