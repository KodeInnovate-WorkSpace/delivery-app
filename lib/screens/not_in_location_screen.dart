import 'package:flutter/material.dart';

import 'demo_screen.dart';

class NotInLocationScreen extends StatelessWidget {
  const NotInLocationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Location Check'),
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
              onPressed: () {
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
    );
  }
}
