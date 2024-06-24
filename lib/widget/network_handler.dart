import 'package:flutter/material.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';

import '../screens/no_internet_screen.dart';

class NetworkHandler extends StatefulWidget {
  final Widget child;

  const NetworkHandler({required this.child, super.key});

  @override
  State<NetworkHandler> createState() => _NetworkHandlerState();
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