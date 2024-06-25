import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'home_screen.dart';

class ManualLocationScreen extends StatefulWidget {
  const ManualLocationScreen({super.key});

  @override
  _ManualLocationScreenState createState() => _ManualLocationScreenState();
}

class _ManualLocationScreenState extends State<ManualLocationScreen> {
  final TextEditingController _locationController = TextEditingController();
  bool isLoading = false;

  Future<void> _setLocation(String location) async {
    setState(() {
      isLoading = true;
    });

    try {
      List<Location> locations = await locationFromAddress(location);
      if (locations.isNotEmpty) {
        Location loc = locations.first;
        List<Placemark> placemarks =
        await placemarkFromCoordinates(loc.latitude, loc.longitude);
        if (placemarks.isNotEmpty) {
          Placemark place = placemarks.first;
          String postalCode = place.postalCode ?? '';

          // Update Firebase status for the given postal code
          QuerySnapshot querySnapshot =
          await FirebaseFirestore.instance.collection('location').get();

          for (DocumentSnapshot document in querySnapshot.docs) {
            int docPostalCode = document['postal_code'];
            if (postalCode == docPostalCode.toString()) {
              await document.reference.update({'status': 1});
              Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(builder: (context) => const HomeScreen()),
                    (Route<dynamic> route) => false,
              );
              return;
            }
          }

          // If the postal code is not found in Firestore, add it
          await FirebaseFirestore.instance.collection('location').add({
            'postal_code': int.parse(postalCode),
            'status': 1,
          });

          Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(builder: (context) => const HomeScreen()),
                (Route<dynamic> route) => false,
          );
        } else {
          _showErrorDialog("Location not found. Please try again.");
        }
      } else {
        _showErrorDialog("Location not found. Please try again.");
      }
    } catch (e) {
      log("Error setting location: $e");
      _showErrorDialog("An error occurred. Please try again.");
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  void _showErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          title: const Text('Error'),
          content: Text(message),
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

  Future<void> _getCurrentLocation() async {
    try {
      Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );
      List<Placemark> placemarks =
      await placemarkFromCoordinates(position.latitude, position.longitude);
      if (placemarks.isNotEmpty) {
        Placemark place = placemarks.first;
        String postalCode = place.postalCode ?? '';

        // Update Firebase status for the current location
        QuerySnapshot querySnapshot =
        await FirebaseFirestore.instance.collection('location').get();

        for (DocumentSnapshot document in querySnapshot.docs) {
          int docPostalCode = document['postal_code'];
          if (postalCode == docPostalCode.toString()) {
            await document.reference.update({'status': 1});
            Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(builder: (context) => const HomeScreen()),
                  (Route<dynamic> route) => false,
            );
            return;
          }
        }

        // If the postal code is not found in Firestore, add it
        await FirebaseFirestore.instance.collection('location').add({
          'postal_code': int.parse(postalCode),
          'status': 1,
        });

        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (context) => const HomeScreen()),
              (Route<dynamic> route) => false,
        );
      } else {
        _showErrorDialog("Unable to fetch current location. Please try again.");
      }
    } catch (e) {
      log("Error getting current location: $e");
      _showErrorDialog("An error occurred. Please try again.");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Manual Location Input'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _locationController,
              decoration: const InputDecoration(
                labelText: 'Enter Location',
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: isLoading
                  ? null
                  : () {
                _setLocation(_locationController.text);
              },
              child: isLoading
                  ? const CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
              )
                  : const Text('Set Location'),
            ),
            const SizedBox(height: 20),
            // ElevatedButton(
            //   onPressed: _getCurrentLocation,
            //   style: ButtonStyle(
            //     backgroundColor: MaterialStateProperty.all(Colors.green),
            //   ),
            //   child: const Text('Use Current Location'),
            // ),
          ],
        ),
      ),
    );
  }
}
//manual location

