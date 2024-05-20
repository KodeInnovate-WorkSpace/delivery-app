import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:connectivity_plus/connectivity_plus.dart';

class ConnectivityProvider with ChangeNotifier {
  bool _isConnected = true;

  bool get isConnected => _isConnected;

  ConnectivityProvider() {
    checkConnectivity();
    Connectivity().onConnectivityChanged.listen((result) {
      _isConnected = result != ConnectivityResult.none;
      notifyListeners();
    });
  }

  Future<bool> checkConnectivity() async {
    try {
      var result = await Connectivity().checkConnectivity();
      _isConnected = result != ConnectivityResult.none;
      notifyListeners();
      return _isConnected;
    } catch (e) {
      log("Error: $e");
      _isConnected = false;
      notifyListeners();
      return false;
    }
  }
}
