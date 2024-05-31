import 'package:flutter/material.dart';
import 'package:speedy_delivery/admin/sample.dart';

class AdminScreen extends StatelessWidget {
  const AdminScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Admin"),
      ),
      body: SizedBox(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const Text(
              "Hello, Admin",
              style: TextStyle(fontSize: 30, fontFamily: 'Gilroy-ExtraBold'),
            ),
            ElevatedButton(
              style: ButtonStyle(
                backgroundColor: WidgetStateProperty.all<Color>(Colors.black),
              ),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) =>
                          const SamplePage(method: 'Manage Users')),
                );
              },
              child: const Text(
                "Manage Users",
                style: TextStyle(color: Colors.white, fontSize: 20),
              ),
            ),
            ElevatedButton(
              style: ButtonStyle(
                backgroundColor: WidgetStateProperty.all<Color>(Colors.black),
              ),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) =>
                          const SamplePage(method: 'Manage Categories')),
                );
              },
              child: const Text(
                "Manage Categories",
                style: TextStyle(color: Colors.white, fontSize: 20),
              ),
            ),
            ElevatedButton(
              style: ButtonStyle(
                backgroundColor: WidgetStateProperty.all<Color>(Colors.black),
              ),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) =>
                          const SamplePage(method: 'Manage SubCategories')),
                );
              },
              child: const Text(
                "Manage Sub-Categories",
                style: TextStyle(color: Colors.white, fontSize: 20),
              ),
            ),
            ElevatedButton(
              style: ButtonStyle(
                backgroundColor: WidgetStateProperty.all<Color>(Colors.black),
              ),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) =>
                          const SamplePage(method: 'Manage Products')),
                );
              },
              child: const Text(
                "Manage Products",
                style: TextStyle(color: Colors.white, fontSize: 20),
              ),
            ),
            ElevatedButton(
              style: ButtonStyle(
                backgroundColor: WidgetStateProperty.all<Color>(Colors.black),
              ),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) =>
                          const SamplePage(method: 'Manage Notification')),
                );
              },
              child: const Text(
                "Manage Notification",
                style: TextStyle(color: Colors.white, fontSize: 20),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
