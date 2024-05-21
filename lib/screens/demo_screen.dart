import 'package:flutter/material.dart';

class DemoPage extends StatefulWidget {
  const DemoPage({super.key});

  @override
  State<DemoPage> createState() => _DemoPageState();
}

class _DemoPageState extends State<DemoPage> {


  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: Text("Demo Page"),
      ),
      floatingActionButton: Icon(Icons.refresh),
    );
  }
}
