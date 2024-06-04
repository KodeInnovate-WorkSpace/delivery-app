import 'package:flutter/material.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';

class NoInternetScreenOverlay extends StatefulWidget {
  const NoInternetScreenOverlay({Key? key}) : super(key: key);

  @override
  _NoInternetScreenOverlayState createState() =>
      _NoInternetScreenOverlayState();
}

class _NoInternetScreenOverlayState extends State<NoInternetScreenOverlay> {
  bool _isChecking = false;

  @override
  void initState() {
    super.initState();
    _checkInternet();
  }

  Future<void> _checkInternet() async {
    setState(() {
      _isChecking = true;
    });

    bool hasConnection = await InternetConnectionChecker().hasConnection;

    setState(() {
      _isChecking = false;
    });

    if (hasConnection) {
      // Connection restored, trigger a rebuild of the NetworkHandler
      // to remove the overlay
      setState(() {});
    } else {
      // ScaffoldMessenger.of(context).showSnackBar(
      //   const SnackBar(
      //     content:
      //     Text('Still no internet connection. Please try again.'),
      //   ),
      // );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.amberAccent,
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            _isChecking
                ? CircularProgressIndicator(
              color: Colors.white,
            )
                : Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Image.asset(
                  "assets/images/no_net.png",
                ),
                const Text(
                  "Seems like you don't have internet!",
                  style: TextStyle(
                      fontSize: 20,
                      fontFamily: 'Gilroy-Black',
                      color: Colors.black),
                ),
                const Text(
                  "Try connecting to internet",
                  style: TextStyle(color: Colors.black),
                ),
              ],
            ),
            SizedBox(height: 20), // Adjust spacing as needed
            ElevatedButton(
              onPressed: _isChecking
                  ? null
                  : () async {
                setState(() {
                  _isChecking = true; // Show loading animation
                });
                await _checkInternet(); // Call the function to check internet
                setState(() {
                  _isChecking = false; // Hide loading animation after checking
                });
              },
              style: ButtonStyle(
                shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                  RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14.0),
                  ),
                ),
                backgroundColor: MaterialStateProperty.resolveWith<Color>(
                      (Set<MaterialState> states) {
                    if (states.contains(MaterialState.disabled)) {
                      return Colors.grey; // Color when button is disabled
                    }
                    return Colors.black; // Color when button is enabled
                  },
                ),
              ),
              child: SizedBox(
                width: 250,
                height: 50.0,
                child: Center(
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      Text(
                        "Continue",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 16.0,
                        ),
                      ),
                      _isChecking
                          ? CircularProgressIndicator(
                        strokeWidth: 2.0,
                        valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                      )
                          : SizedBox(),
                    ],
                  ),
                ),
              ),
            ),

          ],
        ),
      ),
    );
  }
}