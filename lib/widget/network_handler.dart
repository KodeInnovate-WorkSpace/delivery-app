import 'package:flutter/material.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';

import '../screens/no_internet_screen.dart';

class NetworkHandler extends StatefulWidget {
  final Widget child;

  const NetworkHandler({required this.child, Key? key}) : super(key: key);

  @override
  _NetworkHandlerState createState() => _NetworkHandlerState();
}

class _NetworkHandlerState extends State<NetworkHandler> {
  bool hasConnection = true;

  @override
  void initState() {
    super.initState();
    _checkConnection();
    InternetConnectionChecker().onStatusChange.listen((status) {
      final hasInternet = status == InternetConnectionStatus.connected;
      setState(() {
        hasConnection = hasInternet;
      });
    });
  }

  Future<void> _checkConnection() async {
    final isConnected = await InternetConnectionChecker().hasConnection;
    setState(() {
      hasConnection = isConnected;
    });
  }

  @override
  Widget build(BuildContext context) {
    return hasConnection ? widget.child : const NoInternetScreenOverlay();
  }
}

// class NoInternetScreen extends StatelessWidget {
//   const NoInternetScreen({Key? key}) : super(key: key);
//
//   @override
//   // Widget build(BuildContext context) {
//   //   return Scaffold(
//   //     body: Center(
//   //       child: Column(
//   //         mainAxisAlignment: MainAxisAlignment.center,
//   //         children: [
//   //           const Icon(Icons.wifi_off, size: 80),
//   //           const SizedBox(height: 20),
//   //           const Text(
//   //             "No Internet Connection",
//   //             style: TextStyle(fontSize: 20),
//   //           ),
//   //           const SizedBox(height: 10),
//   //           ElevatedButton(
//   //             onPressed: () {
//   //               Navigator.pop(context);
//   //             },
//   //             child: const Text("Retry"),
//   //           ),
//   //         ],
//   //       ),
//   //     ),
//   //   );
//   // }
// }