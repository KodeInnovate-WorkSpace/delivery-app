import 'dart:math';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:mailer/mailer.dart';
import 'package:mailer/smtp_server.dart';

import '../screens/verify_phone_num_screen.dart';

class MyAuthProvider with ChangeNotifier {
  final TextEditingController textController = TextEditingController();
  final TextEditingController textEmailController = TextEditingController();
  bool isButtonEnabled = false;
  bool isLoading = false;
  String? _verificationId;

  String get phone => textController.text;
  String get email => textEmailController.text;

  int? get specificNumber => int.tryParse(phone);

  set isKeyboardOpen(bool isKeyboardOpen) {}

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
    final prefs = await SharedPreferences.getInstance();

    FirebaseAuth.instance.authStateChanges().listen((User? user) async {
      if (user != null) {
        textController.text = user.phoneNumber.toString().substring(3);
        textController.text = prefs.getString('userPhone')?.substring(3) ?? '';

        textEmailController.text = user.email.toString().substring(3);
        textEmailController.text = prefs.getString('userEmail')?.substring(3) ?? '';
      } else {
        // User is not logged in, navigate to SignInScreen

      }
    });
  }

  Future<void> sendMail(BuildContext context, String receiverEmail, String code) async {
    String username = dotenv.env['EMAIL']!;
    String password = dotenv.env['APP_PASSWORD']!;

    final smtpServer = gmail(username, password);

    final message = Message()
      ..from = Address(username, 'Delivo App')
      ..recipients.add(receiverEmail)
      ..subject = 'Verification Code: $code'
      ..html = '''
    <div
      style="
      max-width: 680px;
      margin: 0 auto;
      padding: 45px 30px 60px;
      background: #f4f7ff;
      background-image: url('https://archisketch-resources.s3.ap-northeast-2.amazonaws.com/vrstyler/1661497957196_595865/email-template-background-banner');
      background-repeat: no-repeat;
      background-size: 800px 452px;
      background-position: top center;
      font-size: 14px;
      color: #434343;
      "
    >
      <main>
        <div
          style="
          margin: 0;
          margin-top: 70px;
          padding: 92px 30px 115px;
          background: #ffffff;
          border-radius: 30px;
          text-align: center;
          "
        >
          <div style="width: 100%; max-width: 489px; margin: 0 auto;">
            <h1 style="margin: 0; font-size: 24px; font-weight: 500; color: #1f1f1f;">Your OTP</h1>
            <p style="margin: 0; margin-top: 60px; font-size: 40px; font-weight: 600; letter-spacing: 25px; color: #ba3d4f;">$code</p>
            <p style="margin: 0; margin-top: 17px; font-weight: 500; letter-spacing: 0.56px;">
              Thank you for choosing Delivo App. Use the following OTP to complete the procedure to authenticate your phone number. OTP is valid for
              <span style="font-weight: 600; color: #1f1f1f;">5 minutes</span>. Do not share this code with others, including Delivo App employees.
            </p>
          </div>
        </div>

        <p
          style="
          max-width: 400px;
          margin: 0 auto;
          margin-top: 90px;
          text-align: center;
          font-weight: 500;
          color: #8c8c8c;
          "
        >
          Need help? Ask at
          <a href="mailto:info@kodeinnovate.in" style="color: #499fb6; text-decoration: none;">info@kodeinnovate.in</a>
          
        </p>
      </main>
    </div>
    ''';

    try {
      final sendReport = await send(message, smtpServer);
      debugPrint('Message sent: $sendReport');
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => VerifyPhoneNumScreen(email: receiverEmail, otp: code)),
      );
    } catch (e) {
      debugPrint('Message not sent: $e');
    }
  }

  String generateOtp() {
    var rng = Random();
    return (rng.nextInt(900000) + 100000).toString();
  }

  // Future<void> verifyPhoneNumber(BuildContext context, String phoneNumber) async {
  //   if (isButtonEnabled) {
  //     isLoading = true;
  //     notifyListeners();
  //     // phone number verification logic
  //     await FirebaseAuth.instance.verifyPhoneNumber(
  //       verificationCompleted: (PhoneAuthCredential credential) async {
  //         await FirebaseAuth.instance.signInWithCredential(credential);
  //         await _setLoginState(true);
  //
  //         // await OneSignal.login(phoneNumber);
  //         // await OneSignal.User.addTagWithKey("userId", phoneNumber);
  //         // var sendTags = {'userId': phoneNumber};
  //         // await OneSignal.User.addTags(sendTags);
  //         // await OneSignal.User.getTags();
  //
  //         Navigator.pushReplacement(
  //           context,
  //           MaterialPageRoute(builder: (context) => const HomeScreen()),
  //         );
  //       },
  //       verificationFailed: (FirebaseAuthException ex) {
  //         showMessage("Verification Failed, Please try again");
  //         log("Verification failed: ${ex.message}");
  //         isLoading = false;
  //         notifyListeners();
  //       },
  //       codeSent: (String verificationId, int? resendToken) {
  //         _verificationId = verificationId;
  //         isLoading = false;
  //         notifyListeners();
  //         Navigator.push(
  //           context,
  //           MaterialPageRoute(
  //             builder: (context) => VerifyPhoneNumScreen(verificationId: verificationId, phoneNumber: phoneNumber),
  //           ),
  //         );
  //       },
  //       codeAutoRetrievalTimeout: (String verificationId) {
  //         _verificationId = verificationId;
  //         isLoading = false;
  //         notifyListeners();
  //       },
  //       timeout: const Duration(seconds: 60),
  //       phoneNumber: "+91$phoneNumber",
  //     );
  //   }
  // }

  Future<void> setLoginState(bool isLoggedIn) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('isLoggedIn', isLoggedIn);
  }

  Future<void> setUserPhone(String phone, String email) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('userPhone', phone);
    await prefs.setString('userEmail', email);

    if (textController.text.isEmpty) {
      textController.text = prefs.getString('userPhone') ?? '';
    }

    if (textEmailController.text.isEmpty) {
      textEmailController.text = prefs.getString('userEmail') ?? '';
    }
  }

  Future<void> retrievePhone() async {
    final prefs = await SharedPreferences.getInstance();
    textController.text = prefs.getString('userPhone') ?? '';
    textEmailController.text = prefs.getString('userEmail') ?? '';
  }

  void reset() {
    textController.clear();
    isButtonEnabled = false;
    isLoading = false;
    _verificationId = '';
    textEmailController.clear();
    notifyListeners();
  }
}
