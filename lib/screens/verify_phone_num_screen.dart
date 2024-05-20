import 'dart:developer';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:pinput/pinput.dart';

import '../widget/terms_privacy_line.dart';
import 'home_screen.dart';

class VerifyPhoneNumScreen extends StatefulWidget {
  final String verificationId;
  final String phoneNumber;
  const VerifyPhoneNumScreen(
      {super.key, required this.verificationId, required this.phoneNumber});

  @override
  State<VerifyPhoneNumScreen> createState() => _VerifyPhoneNumScreenState();
}

class _VerifyPhoneNumScreenState extends State<VerifyPhoneNumScreen> {
  final TextEditingController _otpController = TextEditingController();
  bool _isLoading = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SizedBox(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height / 2,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(
              height: 8,
            ),
            const Text(
              "Verification",
              style: TextStyle(
                  fontFamily: "Gilroy-Regular",
                  fontWeight: FontWeight.bold,
                  fontSize: 24),
            ),
            const Text(
              "Enter the code sent to the number",
              style: TextStyle(
                  fontFamily: "Gilroy-Regular",
                  color: Colors.grey,
                  // fontWeight: FontWeight.bold,
                  fontSize: 16),
            ),
            Text(
              widget.phoneNumber,
              style: const TextStyle(
                  fontFamily: "Gilroy-Regular",
                  // color: Colors.grey,
                  fontWeight: FontWeight.w700,
                  fontSize: 16),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 30),
              child: Pinput(
                controller: _otpController,
                keyboardType: TextInputType.phone,
                length: 6,
                autofocus: true,
                defaultPinTheme: PinTheme(
                    height: 55,
                    width: 40,
                    decoration: BoxDecoration(
                        // color: Colors.white,
                        color: Colors.amber[50],
                        borderRadius: BorderRadius.circular(10))),
              ),
            ),
            ElevatedButton(
              onPressed: () async {
                try {
                  if (_otpController.text.length != 6) {
                    throw Exception("Invalid OTP");
                  }
                  PhoneAuthCredential credential = PhoneAuthProvider.credential(
                      verificationId: widget.verificationId,
                      smsCode: _otpController.text);

                  await FirebaseAuth.instance.signInWithCredential(credential);

                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (context) =>  HomeScreen()),
                  );

                  setState(() {
                    _isLoading = !_isLoading;
                  });
                } catch (e) {
                  log("Error: $e");
                }
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
              ), // Disable the button by setting onPressed to null
              child: _isLoading
                  ? const SizedBox(
                      width: 250,
                      height: 50.0,
                      child: Center(
                        child: CircularProgressIndicator(
                          color: Colors.white, // Adjust color as needed
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
    );
  }
}
