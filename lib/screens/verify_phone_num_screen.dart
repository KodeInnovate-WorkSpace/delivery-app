import 'dart:developer';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:pinput/pinput.dart';
import 'package:speedy_delivery/screens/sign_in_screen.dart';

import '../widget/terms_privacy_line.dart';
import 'home_screen.dart';

class VerifyPhoneNumScreen extends StatefulWidget {
  final String verificationId;
  final String phoneNumber;
  const VerifyPhoneNumScreen({super.key, required this.verificationId, required this.phoneNumber});

  @override
  State<VerifyPhoneNumScreen> createState() => _VerifyPhoneNumScreenState();
}

class _VerifyPhoneNumScreenState extends State<VerifyPhoneNumScreen> {
  final TextEditingController _otpController = TextEditingController();
  bool _isLoading = false;

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: _onWillPop,
      child: Scaffold(
        appBar: AppBar(
          title: const Text("OTP Verification"),
        ),
        body: SizedBox(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height / 2,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const Text(
                "We've sent a verification code to",
                style: TextStyle(fontFamily: "Gilroy-Regular", color: Colors.grey, fontSize: 16),
              ),
              Text(
                "+91 ${widget.phoneNumber}",
                style: const TextStyle(fontFamily: "Gilroy-SemiBold", fontSize: 17),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 30),
                child: Pinput(
                  controller: _otpController,
                  keyboardType: TextInputType.number,
                  length: 6,
                  autofocus: true,
                  defaultPinTheme: PinTheme(height: 55, width: 40, decoration: BoxDecoration(border: Border.all(color: Colors.black), borderRadius: BorderRadius.circular(10))),
                  onCompleted: (pin) async {
                    await _verifyOtp(pin);
                  },
                ),
              ),
              ElevatedButton(
                onPressed: () async {
                  HapticFeedback.selectionClick();
                  await _verifyOtp(_otpController.text);
                },
                style: ButtonStyle(
                  shape: WidgetStateProperty.all<RoundedRectangleBorder>(
                    RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14.0),
                    ),
                  ),
                  backgroundColor: WidgetStateProperty.resolveWith<Color>(
                    (Set<WidgetState> states) {
                      if (states.contains(WidgetState.disabled)) {
                        return Colors.black.withOpacity(0.3);
                      }
                      return Colors.black;
                    },
                  ),
                ),
                child: _isLoading
                    ? const SizedBox(
                        width: 250,
                        height: 50.0,
                        child: Center(
                          child: CircularProgressIndicator(
                            color: Colors.white,
                          ),
                        ),
                      )
                    : const SizedBox(
                        width: 250,
                        height: 50.0,
                        child: Center(
                          child: Text(
                            "Verify",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 16.0,
                            ),
                          ),
                        ),
                      ),
              ),
              termsPrivacyLine(),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _verifyOtp(String otp) async {
    if (otp.isEmpty) {
      _showSnackBar("Please enter the OTP.", Colors.red);
      return;
    }

    if (otp.length != 6) {
      _showSnackBar("Invalid OTP. Please enter a 6-digit code.", Colors.red);
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      PhoneAuthCredential credential = PhoneAuthProvider.credential(verificationId: widget.verificationId, smsCode: otp);

      await FirebaseAuth.instance.signInWithCredential(credential);

      _showSnackBar("Login Successful", Colors.green);

      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => const HomeScreen()),
        (route) => false,
      );
    } catch (e) {
      log("Error: $e");
      _showSnackBar("Incorrect OTP. Please try again.", Colors.red);
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<bool> _onWillPop() async {
    return (await showDialog(
          context: context,
          builder: (context) => AlertDialog(
            backgroundColor: Colors.white,
            title: const Text("Edit Phone Number"),
            content: const Text("Do You Want to Edit the Phone Number ?"),
            actions: <Widget>[
              TextButton(
                onPressed: () => Navigator.of(context).pop(false),
                child: const Text(
                  "No",
                  style: TextStyle(color: Colors.black),
                ),
              ),
              TextButton(
                onPressed: () {
                  // Restart.restartApp();
                  Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(builder: (context) => const SigninScreen()),
                    (route) => false,
                  );
                },
                child: const Text(
                  "Yes",
                  style: TextStyle(color: Colors.black),
                ),
              ),
            ],
          ),
        )) ??
        false;
  }

  void _showSnackBar(String message, Color color) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: color,
      ),
    );
  }
}
