import 'dart:async';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:speedy_delivery/screens/home_screen.dart';
import 'package:speedy_delivery/screens/manual_location_screen.dart';
import 'dart:developer';

class NotInLocationScreen extends StatefulWidget {
  const NotInLocationScreen({super.key});

  @override
  _NotInLocationScreenState createState() => _NotInLocationScreenState();
}

class _NotInLocationScreenState extends State<NotInLocationScreen> {
  bool locationCorrect = false;
  bool isLoading = false;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _startPeriodicCheck();
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  void _startPeriodicCheck() {
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (!isLoading) {
        checkLocation();
      }
    });
  }

  Future<void> checkLocation() async {
    try {
      Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );
      List<Placemark> placemarks =
      await placemarkFromCoordinates(position.latitude, position.longitude);
      Placemark place = placemarks[0];
      String postalCode = place.postalCode ?? '';

      QuerySnapshot querySnapshot =
      await FirebaseFirestore.instance.collection('location').get();
      for (DocumentSnapshot document in querySnapshot.docs) {
        int docPostalCode = document['postal_code'];
        int status = document['status'];
        if (postalCode == docPostalCode.toString() && status == 1) {
          setState(() {
            locationCorrect = true;
            isLoading = false;
          });
          if (!mounted) return;
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => const HomeScreen()),
          );
          return;
        }
      }
      setState(() {
        locationCorrect = false;
        isLoading = false;
      });
    } catch (e) {
      log("Error checking location: $e");
      setState(() {
        locationCorrect = false;
        isLoading = false;
      });
    }
  }

  void refreshLocationCheck() async {
    setState(() {
      isLoading = true;
    });
    await checkLocation();
  }

  void navigateToManualLocation() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const ManualLocationScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => false,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Location Check'),
          automaticallyImplyLeading: false,
        ),
        body: Center(
          child: locationCorrect
              ? const Text('Location is correct, proceed further')
              : Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              const Icon(
                Icons.location_off,
                size: 100,
              ),
              const SizedBox(height: 20),
              const Text(
                'Sorry, We Are Currently Not in This Location',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 20),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: isLoading ? null : refreshLocationCheck,
                style: ButtonStyle(
                  shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                    RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14.0),
                    ),
                  ),
                  backgroundColor: MaterialStateProperty.resolveWith<Color>(
                        (Set<MaterialState> states) {
                      return Colors.black;
                    },
                  ),
                ),
                child: SizedBox(
                  width: 200,
                  height: 58,
                  child: Center(
                    child: isLoading
                        ? const CircularProgressIndicator(
                      valueColor: AlwaysStoppedAnimation<Color>(
                          Colors.white),
                    )
                        : const Text(
                      "Try changing location",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16.0,
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: navigateToManualLocation,
                style: ButtonStyle(
                  shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                    RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14.0),
                    ),
                  ),
                  backgroundColor: MaterialStateProperty.resolveWith<Color>(
                        (Set<MaterialState> states) {
                      return Colors.green;
                    },
                  ),
                ),
                child: const SizedBox(
                  width: 200,
                  height: 58,
                  child: Center(
                    child: Text(
                      "Add location manually",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16.0,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}