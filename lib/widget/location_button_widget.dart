import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:speedy_delivery/screens/not_in_location_screen.dart';

class LocationButton extends StatefulWidget {
  final GlobalKey<ScaffoldState> scaffoldKey;

  const LocationButton({super.key, required this.scaffoldKey});

  @override
  State<LocationButton> createState() => _LocationButtonState();
}

class _LocationButtonState extends State<LocationButton> {
  Position? position;
  String? completeAddress;
  late SharedPreferences _prefs;

  @override
  void initState() {
    super.initState();
    _initPrefs();
  }

  Future<void> _initPrefs() async {
    _prefs = await SharedPreferences.getInstance();
    completeAddress = _prefs.getString('lastAddress');
    if (completeAddress == null) {
      await _checkLocationServiceAndPermission();
    }
    setState(() {});
  }

  Future<void> _checkLocationServiceAndPermission() async {
    final BuildContext context = widget.scaffoldKey.currentContext!;
    bool serviceEnabled;
    LocationPermission permission;

    // Check if location service is enabled
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      _showLocationServiceDisabledDialog(context);
      return;
    }

    // Request location permission
    permission = await Geolocator.requestPermission();
    if (permission != LocationPermission.always &&
        permission != LocationPermission.whileInUse) {
      _showLocationPermissionRequiredDialog(context);
      return;
    }

    // Fetch and set the current location
    await fetchAndSetCurrentLocation();
  }

  Future<void> fetchAndSetCurrentLocation() async {
    try {
      Position newPosition = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );

      List<Placemark> placeMarks = await placemarkFromCoordinates(
        newPosition.latitude,
        newPosition.longitude,
      );

      if (placeMarks.isNotEmpty) {
        Placemark pMark = placeMarks[0];

        setState(() {
          completeAddress =
          '${pMark.street}, ${pMark.subLocality}, ${pMark.locality} - ${pMark.postalCode} ';
        });

        // Save the address to SharedPreferences
        await _prefs.setString('lastAddress', completeAddress!);
      }
    } catch (e) {
      log("$e");
      setState(() {
        completeAddress = 'Unable to fetch location';
      });
    }
  }

  Future<void> getCurrentLocation() async {
    final BuildContext context = widget.scaffoldKey.currentContext!;
    bool serviceEnabled;
    LocationPermission permission;

    // Check if location service is enabled
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      _showLocationServiceDisabledDialog(context);
      return;
    }

    // Request location permission
    permission = await Geolocator.requestPermission();
    if (permission != LocationPermission.always &&
        permission != LocationPermission.whileInUse) {
      _showLocationPermissionRequiredDialog(context);
      return;
    }

    // Fetch and set the current location
    await fetchAndSetCurrentLocation();

    if (completeAddress != null && !completeAddress!.contains('Mumbra')) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const NotInLocationScreen()),
      );
    }
  }

  void _showLocationServiceDisabledDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Location Service Disabled'),
          content: const Text('Please enable location services to proceed.'),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('OK'),
            ),
          ],
        );
      },
    );
  }

  void _showLocationPermissionRequiredDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Location Permission Required'),
          content: const Text('Please grant location permission to proceed.'),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('OK'),
            ),
          ],
        );
      },
    );
  }

  void _showLocationErrorDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          title: const Text('Error'),
          content: const Text('An error occurred while fetching location.'),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(dialogContext).pop(),
              child: const Text('OK'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        showModalBottomSheet(
          context: context,
          backgroundColor: Colors.white,
          builder: (BuildContext context) {
            return SingleChildScrollView(
              child: Column(
                children: [
                  _buildSelectAddressTile(context),

                  _buildCurrentLocationTile(context),
                  ListTile(
                    leading: const Icon(Icons.arrow_downward),
                    title: const Text(
                      'Recently Searched Locations',
                      style: TextStyle(color: Colors.black),
                    ),
                    onTap: () => Navigator.pop(context),
                  ),
                  ListTile(
                    leading: const Icon(Icons.location_on),
                    title: Text(
                      completeAddress ?? 'Fetching location...',
                      style: const TextStyle(color: Colors.black),
                    ),
                    onTap: () => Navigator.pop(context),
                  ),
                ],
              ),
            );
          },
        );
      },
      child: Row(
        children: [
          Text(
            completeAddress ?? 'Fetching location...',
            style: const TextStyle(color: Colors.black),
          ),
          const Icon(Icons.arrow_drop_down_sharp),
        ],
      ),
    );
  }

  ListTile _buildSelectAddressTile(BuildContext context) {
    return ListTile(
      title: const Text(
        'Select Address',
        style: TextStyle(color: Colors.black),
      ),
      onTap: () => Navigator.pop(context),
    );
  }

  ListTile _buildCurrentLocationTile(BuildContext context) {
    return ListTile(
      leading: const Icon(Icons.my_location_sharp),
      title: const Text(
        'Go to Current Location',
        style: TextStyle(color: Colors.green),
      ),
      onTap: () {
        getCurrentLocation();
        Navigator.pop(context);
      },
    );
  }
}