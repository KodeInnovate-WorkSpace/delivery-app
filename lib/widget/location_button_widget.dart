import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';

import '../screens/not_in_location_screen.dart';

class LocationButton extends StatefulWidget {
  const LocationButton({super.key});

  @override
  _LocationButtonState createState() => _LocationButtonState();
}

class _LocationButtonState extends State<LocationButton> {
  Position? position;
  List<Placemark>? placeMarks;
  String? completeAddress;

  Future<void> getCurrentLocation(BuildContext context) async {
    bool serviceEnabled;
    LocationPermission permission;

    // Check if location service is enabled
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
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
      return;
    }

    // Request location permission
    permission = await Geolocator.requestPermission();
    if (permission == LocationPermission.denied) {
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
      return;
    }

    if (permission == LocationPermission.deniedForever) {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('Location Permission Denied'),
            content: const Text(
                'Location permission is permanently denied, we cannot request permissions.'),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(),
                child: const Text('OK'),
              ),
            ],
          );
        },
      );
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

      Placemark pMark = placeMarks[0];

      setState(() {
        completeAddress =
            ' ${pMark.street}, ${pMark.subLocality}, ${pMark.postalCode}';

        // Check sublocality and redirect if not "Mumbra"
        if (pMark.subLocality != "Mumbra") {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
                builder: (context) => const NotInLocationScreen()),
          );
        }
      });
    } catch (e) {
      log("$e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        showModalBottomSheet(
          context: context,
          backgroundColor: Colors.white, // Set the background color
          builder: (BuildContext context) {
            return SingleChildScrollView(
              child: Column(
                // mainAxisSize: MainAxisSize.min,
                children: [
                  ListTile(
                    title: const Text(
                      'Select Address',
                      style: TextStyle(color: Colors.black),
                    ),
                    onTap: () => Navigator.pop(context),
                  ),
                  const ListTile(
                    leading: Icon(Icons.search),
                    title: TextField(
                      style: TextStyle(color: Colors.black), // Set text color
                      decoration: InputDecoration(
                        hintText: 'Search for area, street name...',
                        hintStyle: TextStyle(color: Colors.black),
                        filled: true,
                        fillColor: Colors.transparent,
                        border: OutlineInputBorder(),
                      ),
                    ),
                  ),
                  ListTile(
                    leading: const Icon(Icons.my_location_sharp),
                    title: const Text(
                      'Go to Current Location',
                      style: TextStyle(color: Colors.green),
                    ),
                    onTap: () {
                      getCurrentLocation(context);
                      Navigator.pop(
                          context); // Close the bottom sheet after initiating location fetch
                    },
                  ),
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
                  // Add more list tiles as needed
                ],
              ),
            );
          },
        );
      },
      child: Row(
        children: [
          Text(
            completeAddress ?? 'Thane, Maharashtra, India ',
            style: const TextStyle(color: Colors.black),
          ),
          const Icon(Icons.arrow_drop_down_sharp),
        ],
      ),
    );
  }
}
