import 'package:flutter/material.dart';

class DemoPage extends StatelessWidget {
  const DemoPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Demo Page'),
      ),
      body: const Center(
        child: Text(
          'This is the demo page',
          style: TextStyle(fontSize: 24),
        ),
      ),
    );
  }
}