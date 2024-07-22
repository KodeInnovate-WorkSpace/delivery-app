import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:restart_app/restart_app.dart';
import '../providers/auth_provider.dart';
import '../widget/input_box.dart';
import '../widget/terms_privacy_line.dart';

class EmailScreen extends StatefulWidget {
  final String phoneNumber;
  const EmailScreen({super.key, required this.phoneNumber});

  @override
  State<EmailScreen> createState() => _EmailScreenState();
}

class _EmailScreenState extends State<EmailScreen> {
  bool isEmailValid = false;
  bool isLoading = false;

  String email = '';

  @override
  void initState() {
    super.initState();
    // TODO: implement initState
    final authProvider = context.read<MyAuthProvider>();
    authProvider.isLoading = !authProvider.isLoading;
    authProvider.textEmailController.addListener(_validateEmail);
    email = authProvider.textEmailController.text;
  }

  @override
  Widget build(BuildContext context) {
    final authProvider = context.read<MyAuthProvider>();
    email = authProvider.textEmailController.text;

    return WillPopScope(
        onWillPop: _onWillPop,
        child: Scaffold(
            appBar: AppBar(
              title: const Text("Email Verification"),
              elevation: 0,
              backgroundColor: const Color(0xfff7f7f7),
              surfaceTintColor: Colors.transparent,
              leading: IconButton(
                icon: Icon(Icons.arrow_back),
                onPressed: () {
                  Restart.restartApp();
                },
              ),
            ),
            backgroundColor: const Color(0xfff7f7f7),
            body: SizedBox(
              width: MediaQuery
                  .of(context)
                  .size
                  .width,
              height: MediaQuery
                  .of(context)
                  .size
                  .height / 2,
              child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const Center(
                      child:  Padding(
                        padding: EdgeInsets.all(16.0),
                        child: Text("Please provide your email id for verification",
                        textAlign: TextAlign.center,
                        style: TextStyle(fontFamily: "Gilroy-Bold",
                            color: Color(0xffc9cace),
                            fontSize: 16),
                      ),),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 30),
                      child: Column(
                        children: [
                          SizedBox(
                            width: MediaQuery
                                .of(context)
                                .size
                                .width,
                            child: InputBox(
                              hintText: "Email",
                              myIcon: Icons.mail_outline,
                              myController: authProvider.textEmailController,
                              keyboardType: TextInputType.emailAddress,
                            ),
                          ),
                          SizedBox(height: 20),
                          ElevatedButton(
                            onPressed: isEmailValid
                                ? () async => await _onVerifyPressed()
                                : null,
                            style: ButtonStyle(
                              shape: MaterialStateProperty.all<
                                  RoundedRectangleBorder>(
                                RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(14.0),
                                ),
                              ),
                              backgroundColor: MaterialStateProperty
                                  .resolveWith<Color>(
                                    (Set<MaterialState> states) {
                                  if (states.contains(MaterialState.disabled)) {
                                    return Colors.black.withOpacity(0.3);
                                  }
                                  return Colors.black;
                                },
                              ),
                            ),
                            child: isLoading
                                ? SizedBox(
                              width: 250,
                              height: 50.0,
                              child: Center(
                                child: CircularProgressIndicator(
                                  color: Colors.white,
                                ),
                              ),
                            )
                                : SizedBox(
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
                          SizedBox(height: 10),
                          termsPrivacyLine(),
                        ],
                      ),
                    ),
                  ]),
            )));
  }

  void _validateEmail() {
    setState(() {
      isEmailValid = _isValidEmail(email);
    });
  }

  bool _isValidEmail(String email) {
    // Simple email validation using RegExp
    return RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(email);
  }

  Future<bool> _onWillPop() async {
    return (await showDialog(
      context: context,
      builder: (context) =>
          AlertDialog(
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
                  Restart.restartApp();
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

  Future<void> _onVerifyPressed() async {
    final authProvider = context.read<MyAuthProvider>();
    String phoneNumber;

    if (!isEmailValid) return;

    // Perform your button action here, e.g., sending mail
    setState(() {
      isLoading = true;
    });

    QuerySnapshot querySnapshot = await FirebaseFirestore.instance
        .collection('users')
        .where('email', isEqualTo: authProvider.email)
        .get();

// Check if any documents match the query
    if (querySnapshot.docs.isNotEmpty) {
      var userDocument = querySnapshot.docs[0]; // Accessing the first document

      phoneNumber = userDocument['phone'];

      _showSnackBar(
          "These email id is already registered with phone number $phoneNumber, please try some other email id or phone number",
          Colors.red);
    } else {
      await authProvider.sendMail(
          context, authProvider.textEmailController.text,
          authProvider.generateOtp());
    }

    setState(() {
      isLoading = false;
    });
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
