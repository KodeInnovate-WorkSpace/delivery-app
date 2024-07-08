import 'dart:developer';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:speedy_delivery/deliveryPartner/screen/delivery_home.dart';
import 'package:speedy_delivery/providers/auth_provider.dart';
import 'package:speedy_delivery/providers/check_user_provider.dart';
import 'package:speedy_delivery/screens/account_disabled.dart';
import 'package:speedy_delivery/widget/terms_privacy_line.dart';
import 'package:speedy_delivery/widget/network_handler.dart';
import 'package:url_launcher/url_launcher.dart';

class SigninScreen extends StatefulWidget {
  const SigninScreen({super.key});

  @override
  State<SigninScreen> createState() => _SigninScreenState();
}

class _SigninScreenState extends State<SigninScreen> {
  final FocusNode _focusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    _focusNode.addListener(() {
      if (_focusNode.hasFocus) {
        SystemChannels.textInput.invokeMethod('TextInput.setKeyboard', 'number');
      }
    });
    resetAuthProviderState();
  }

  @override
  void dispose() {
    _focusNode.dispose();
    super.dispose();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
  }

  void resetAuthProviderState() {
    final authProvider = Provider.of<MyAuthProvider>(context, listen: false);
    authProvider.reset();
  }

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<MyAuthProvider>(context);
    final userProvider = Provider.of<CheckUserProvider>(context);

    void launchUrl(String url) async {
      if (await canLaunch(url)) {
        await launch(url);
      } else {
        throw 'Could not launch $url';
      }
    }

    bool isBtnLoading = false;

    return Scaffold(
      resizeToAvoidBottomInset: true,
      body: NetworkHandler(
        child: Container(
          decoration: const BoxDecoration(
            color: Colors.amberAccent,
          ),
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                splashWidget(),
                const SizedBox(height: 50),
                const SizedBox(height: 50),
                Container(
                  width: MediaQuery.of(context).size.width,
                  height: MediaQuery.of(context).size.height / 3.5,
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(30.0),
                      topRight: Radius.circular(30.0),
                    ),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      const SizedBox(height: 8),
                      const Text(
                        "Log in or sign up",
                        style: TextStyle(fontFamily: "Gilroy-Bold", fontSize: 20),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 30),
                        child: TextField(
                          focusNode: _focusNode,
                          controller: authProvider.textController,
                          maxLength: 10,
                          autofocus: true,
                          keyboardType: TextInputType.number,
                          inputFormatters: [
                            FilteringTextInputFormatter.digitsOnly,
                            LengthLimitingTextInputFormatter(10),
                            CustomInputFormatter(),
                          ],
                          decoration: InputDecoration(
                            hintText: "Enter Mobile Number",
                            hintStyle: TextStyle(color: Colors.grey[400], fontFamily: 'Gilroy-SemiBold'),
                            prefixIcon: const Padding(
                              padding: EdgeInsets.all(18.0),
                              child: Text(
                                "+91",
                                style: TextStyle(fontWeight: FontWeight.bold, fontFamily: 'Gilroy-SemiBold'),
                              ),
                            ),
                            prefixIconConstraints: const BoxConstraints(minWidth: 0, minHeight: 0),
                            contentPadding: const EdgeInsets.symmetric(vertical: 15, horizontal: 20),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(14.0),
                              borderSide: BorderSide(color: Colors.grey.shade50),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(14.0),
                              borderSide: BorderSide(color: Colors.grey.shade100),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(14.0),
                              borderSide: const BorderSide(color: Colors.grey, width: 1.0),
                            ),
                          ),
                        ),
                      ),

                      //Continue Button / sign in button
                      ElevatedButton(
                        onPressed: authProvider.isButtonEnabled
                            ? () async {
                                HapticFeedback.selectionClick();

                                //store user
                                await userProvider.storeDetail(context, 'phone', authProvider.textController.text);

                                // store fcm token

                                FirebaseMessaging.instance.getToken().then((String? token) async {
                                  assert(token != null);
                                  log("FCM Token: $token");
                                  // Save this token to Firestore under the user's document
                                  await userProvider.storeDetail(context, 'fcmToken', token!);
                                });

                                await userProvider.checkUserStatus(authProvider.textController.text);
                                await userProvider.checkUserType(authProvider.phone);

                                if (userProvider.isUserActive) {
                                  if (userProvider.userType == 2) {
                                    Navigator.pushReplacement(
                                      context,
                                      MaterialPageRoute(builder: (context) => const DeliveryHomeScreen()),
                                    );
                                  }

                                  await authProvider.verifyPhoneNumber(context, authProvider.textController.text);
                                } else {
                                  Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const AccountDisabled()));
                                }
                              }
                            : null,
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
                        child: authProvider.isLoading
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
                                    "Continue",
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 16.0,
                                    ),
                                  ),
                                ),
                              ),
                      ),

                      // Continue Button / sign in button
                      // ElevatedButton(
                      //   onPressed: authProvider.isButtonEnabled && !authProvider.isLoading
                      //       ? () async {
                      //           HapticFeedback.selectionClick();
                      //
                      //           // Set loading state to true
                      //           authProvider.isLoading = true;
                      //           // authProvider.notifyListeners();
                      //
                      //           await userProvider.storeDetail(context, 'phone', authProvider.textController.text);
                      //
                      //           await userProvider.checkUserStatus(authProvider.textController.text);
                      //
                      //           if (userProvider.isUserActive) {
                      //             await authProvider.verifyPhoneNumber(context, authProvider.textController.text);
                      //           } else {
                      //             Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const AccountDisabled()));
                      //           }
                      //
                      //           // Set loading state to false after the operation
                      //           authProvider.isLoading = false;
                      //           // authProvider.notifyListeners();
                      //         }
                      //       : null,
                      //   style: ElevatedButton.styleFrom(
                      //     shape: RoundedRectangleBorder(
                      //       borderRadius: BorderRadius.circular(14.0),
                      //     ),
                      //     backgroundColor: authProvider.isButtonEnabled && !authProvider.isLoading ? Colors.black : Colors.black.withOpacity(0.3),
                      //   ),
                      //   child: authProvider.isLoading
                      //       ? const SizedBox(
                      //           width: 250,
                      //           height: 50.0,
                      //           child: Center(
                      //             child: CircularProgressIndicator(
                      //               color: Colors.white,
                      //             ),
                      //           ),
                      //         )
                      //       : const SizedBox(
                      //           width: 250,
                      //           height: 50.0,
                      //           child: Center(
                      //             child: Text(
                      //               "Continue",
                      //               style: TextStyle(
                      //                 color: Colors.white,
                      //                 fontSize: 16.0,
                      //               ),
                      //             ),
                      //           ),
                      //         ),
                      // ),

                      const SizedBox(
                        height: 5,
                      ),
                      termsPrivacyLine(),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          GestureDetector(
                            onTap: () {
                              launchUrl("https://kodeinnovate.in");
                            },
                            child: const Text(
                              "Developed by Kodeinnovate Solutions",
                              style: TextStyle(fontSize: 10, color: Color(0xff666666)),
                            ),
                          )
                        ],
                      )
                    ],
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}

Widget splashWidget() {
  return Column(
    mainAxisAlignment: MainAxisAlignment.center,
    children: [
      Image.asset("assets/icon.png"),
    ],
  );
}

class CustomInputFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(TextEditingValue oldValue, TextEditingValue newValue) {
    return newValue.copyWith(text: newValue.text.replaceAll(' ', ''));
  }
}
