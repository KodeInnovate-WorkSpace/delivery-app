import 'dart:developer';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:speedy_delivery/shared/show_msg.dart';
import '../screens/home_screen.dart';
import '../screens/sign_in_screen.dart';
import '../screens/verify_phone_num_screen.dart';

class MyAuthProvider with ChangeNotifier {
  final TextEditingController textController = TextEditingController();
  bool isButtonEnabled = false;
  bool isLoading = false;
  String? _verificationId;

  String get phone => textController.text;

  //disable/enable button
  void setButtonEnabled(bool value) {
    isButtonEnabled = value;
    notifyListeners();
  }

  MyAuthProvider() {
    textController.addListener(checkInputLength);
  }

  void checkInputLength() {
    isButtonEnabled = textController.text.length == 10;
    notifyListeners();
  }

  Future<void> setPhone() async {
    FirebaseAuth.instance.authStateChanges().listen((User? user) async {
      if (user != null) {
        textController.text = user.phoneNumber.toString().substring(3);
      } else {
        // User is not logged in, navigate to SignInScreen
      }
    });
  }

  Future<void> verifyPhoneNumber(
      BuildContext context, String phoneNumber) async {
    if (isButtonEnabled) {
      isLoading = true;
      notifyListeners();

      // phone number verification logic
      await FirebaseAuth.instance.verifyPhoneNumber(
        verificationCompleted: (PhoneAuthCredential credential) async {
          await FirebaseAuth.instance.signInWithCredential(credential);
          await _setLoginState(true);

          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => const HomeScreen()),
          );
        },
        verificationFailed: (FirebaseAuthException ex) {
          showMessage("Verification Failed, Please try again");
          log("Verification failed: ${ex.message}");
          isLoading = false;
          notifyListeners();
        },
        codeSent: (String verificationId, int? resendToken) {
          _verificationId = verificationId;
          isLoading = false;
          notifyListeners();
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => VerifyPhoneNumScreen(
                  verificationId: verificationId, phoneNumber: phoneNumber),
            ),
          );
        },
        codeAutoRetrievalTimeout: (String verificationId) {
          _verificationId = verificationId;
          isLoading = false;
          notifyListeners();
        },
        timeout: const Duration(seconds: 60),
        phoneNumber: "+91$phoneNumber",
      );
    }
  }

  Future<void> _setLoginState(bool isLoggedIn) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('isLoggedIn', isLoggedIn);
  }

  void reset() {
    textController.clear();
    isButtonEnabled = false;
    isLoading = false;
    _verificationId = '';
    notifyListeners();
  }
}
