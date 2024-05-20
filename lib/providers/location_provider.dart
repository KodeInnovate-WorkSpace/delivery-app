import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';

import '../services/get_current_location.dart';

class LocationProvider with ChangeNotifier {
  Position? _currentLocation;
  String _address = "";

  String get address => _address;

  Future<void> initCurrentLocation() async {
    try {
      _currentLocation = await getCurrentLocation();
      List<Placemark> placemarks = await placemarkFromCoordinates(
          _currentLocation!.latitude, _currentLocation!.longitude);
      Placemark place = placemarks[0];
      String newAddress =
          "${place.street}, ${place.subLocality}, ${place.locality}";

      if (place.subLocality != "umbra") {
        _address = "We're currently unavailable";
      } else {
        _address = newAddress;
      }

      notifyListeners();
    } catch (e) {
      log("Error: $e");
    }
  }
}
