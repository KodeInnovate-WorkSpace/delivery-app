import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:speedy_delivery/screens/demo_screen.dart';

import 'home_screen.dart';

class NotInLocationScreen extends StatelessWidget {
  const NotInLocationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        // Prevent the back button from working
        return false;
      },
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Location Check'),
          automaticallyImplyLeading: false, // Removes the back button
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              const Icon(
                Icons.location_off,
                size: 100,
                color: Colors.red,
              ),
              const SizedBox(height: 20),
              const Text(
                'Sorry, We Are Currently Not in This Location',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 20),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () async {
                  // Navigate to the DemoPage and save state
                  SharedPreferences prefs = await SharedPreferences.getInstance();
                  await prefs.setBool('notInLocation', true);

                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const DemoPage()),
                  );
                },
                child: const Text('Try Changing Location'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// Usage example to check the state and navigate accordingly when the app starts
void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  SharedPreferences prefs = await SharedPreferences.getInstance();
  bool? notInLocation = prefs.getBool('notInLocation');

  runApp(MyApp(notInLocation: notInLocation ?? false));
}

class MyApp extends StatelessWidget {
  final bool notInLocation;

  const MyApp({super.key, required this.notInLocation});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: notInLocation ? const NotInLocationScreen() : const HomeScreen(),
    );
  }
}
