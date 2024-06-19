import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:speedy_delivery/screens/home_screen.dart';

class NotInLocationScreen extends StatelessWidget {
  const NotInLocationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => false, // Prevent back button press
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
              ),
              const SizedBox(height: 20),
              const Text(
                'Sorry, We Are Currently Not in This Location',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 20),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  Navigator.of(context).pushAndRemoveUntil(
                    MaterialPageRoute(builder: (context) => const HomeScreen()),
                    (Route<dynamic> route) => false,
                  );
                },
                style: ButtonStyle(
                  shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                    RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14.0),
                    ),
                  ),
                  backgroundColor: MaterialStateProperty.resolveWith<Color>(
                    (Set<MaterialState> states) {
                      return Colors.black;
                    },
                  ),
                ),
                child: const SizedBox(
                  width: 200,
                  height: 58,
                  child: Center(
                    child: Text(
                      "Try changing location",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16.0,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
