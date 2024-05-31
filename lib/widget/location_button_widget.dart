import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:speedy_delivery/screens/not_in_location_screen.dart';

import '../screens/demo_screen.dart';

class LocationButton extends StatefulWidget {
  final GlobalKey<ScaffoldState> scaffoldKey;

  const LocationButton({Key? key, required this.scaffoldKey}) : super(key: key);

  @override
  _LocationButtonState createState() => _LocationButtonState();
}

class _LocationButtonState extends State<LocationButton> {
  Position? position;
  String? completeAddress;

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

    // Fetch current location
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
          completeAddress = '${pMark.subLocality}, ${pMark.postalCode}';
        });

        // Check if the location is Diva
        // if (pMark.locality?.toLowerCase() != 'diva') {
        //   // If not in Diva, navigate to the demo screen
        //   Navigator.push(
        //     context,
        //     MaterialPageRoute(builder: (context) => const NotInLocationScreen()),
        //   );
        // }
        if (pMark.subLocality != 'Mumbra') {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const NotInLocationScreen()),
          );
        }

      }
    } catch (e) {
      log("$e");
      _showLocationErrorDialog(context);
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
                  const ListTile(
                    leading: Icon(Icons.search),
                    title: TextField(
                      style: TextStyle(color: Colors.black),
                      decoration: InputDecoration(
                        hintText: 'Search for area, street name...',
                        hintStyle: TextStyle(color: Colors.black),
                        filled: true,
                        fillColor: Colors.transparent,
                        border: OutlineInputBorder(),
                      ),
                    ),
                  ),
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
                    title: const Text(
                      'Thane - 400612 , Maharashtra, India',
                      style: TextStyle(color: Colors.black),
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
            completeAddress ?? 'Thane, Maharashtra, India',
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
