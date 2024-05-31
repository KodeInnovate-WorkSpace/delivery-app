import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';

class NoInternetScreen extends StatefulWidget {
  const NoInternetScreen({super.key});

  @override
  _NoInternetScreenState createState() => _NoInternetScreenState();
}

class _NoInternetScreenState extends State<NoInternetScreen> {
  bool _isChecking = false;

  Future<void> _retry() async {
    setState(() {
      _isChecking = true;
    });

    var connectivityResult = await Connectivity().checkConnectivity();

    if (connectivityResult != ConnectivityResult.none) {
      Get.back();
    } else {
      setState(() {
        _isChecking = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // backgroundColor: const Color(0xff2f2e41),
      // backgroundColor: Colors.black,
      body: Center(
        child: _isChecking
            ? const CircularProgressIndicator(
                color: Colors.black,
              )
            : Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Image.asset(
                    "assets/images/no_net.png",
                    // fit: BoxFit.fill,
                  ),

                  const Text("Seems like you don't have internet!", style: TextStyle(fontSize: 20, fontFamily: 'Gilroy-Black'),),
                  const Text("Try connecting to internet"),
                  const SizedBox(
                    height: 40,
                  ),
                  ElevatedButton(
                    onPressed: _retry,
                    style: ButtonStyle(
                      shape: WidgetStateProperty.all<RoundedRectangleBorder>(
                        RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(14.0),
                        ),
                      ),
                      backgroundColor: WidgetStateProperty.resolveWith<Color>(
                        (Set<WidgetState> states) {
                          return Colors.black;
                        },
                      ),
                    ),
                    child: const SizedBox(
                      width: 200,
                      height: 50.0,
                      child: Center(
                        child: Text(
                          "Retry",
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
    );
  }
}
