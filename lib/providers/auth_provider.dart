import 'dart:developer';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../screens/verify_phone_num_screen.dart';

class AuthProvider with ChangeNotifier {
  final TextEditingController textController = TextEditingController();
  bool isButtonEnabled = false;
  bool isLoading = false;

  String get phone => textController.text;

  AuthProvider() {
    textController.addListener(checkInputLength);
  }

  void checkInputLength() {
    isButtonEnabled = textController.text.length == 10;
    notifyListeners();
  }

  Future<void> verifyPhoneNumber(
      BuildContext context, String phoneNumber) async {
    if (isButtonEnabled) {
      isLoading = true;
      notifyListeners();

      // phone number verification logic
      await FirebaseAuth.instance.verifyPhoneNumber(
          verificationCompleted: (PhoneAuthCredential credential) {},
          verificationFailed: (FirebaseAuthException ex) {
            log("Verification failed: ${ex.message}");
          },
          codeSent: (String verificationId, int? resendToken) {
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => VerifyPhoneNumScreen(
                        verificationId: verificationId,
                        phoneNumber: phoneNumber)));
          },
          codeAutoRetrievalTimeout: (String verificationId) {
            log("Auto Retrieval Timeout");
          },
          phoneNumber: "+91$phoneNumber");
    }
  }

  @override
  void dispose() {
    textController.dispose();
    super.dispose();
  }
}