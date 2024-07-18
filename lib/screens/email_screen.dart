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
  final TextEditingController emailController = TextEditingController();
  bool _isLoading = false;

  @override
  Widget build(BuildContext context) {
    final authProvider = context.read<MyAuthProvider>();

    return WillPopScope(
      onWillPop: _onWillPop,
      child: Scaffold(
        appBar: AppBar(
          title: const Text("Email Verification"),
          elevation: 0,
          backgroundColor: const Color(0xfff7f7f7),
          surfaceTintColor: Colors.transparent,
        ),
        backgroundColor: const Color(0xfff7f7f7),
        body: SizedBox(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height / 2,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const Center(
                child: Text(
                  "We need your email address to send verification code",
                  textAlign: TextAlign.center,
                  style: TextStyle(fontFamily: "Gilroy-Bold", color: Color(0xffc9cace), fontSize: 16),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 30),
                child: SizedBox(
                  width: MediaQuery.of(context).size.width,
                  child: InputBox(
                    hintText: "Email",
                    myIcon: Icons.mail_outline,
                    myController: emailController,
                    keyboardType: TextInputType.text,
                  ),
                ),
              ),
              ElevatedButton(
                onPressed: () async {
                  HapticFeedback.selectionClick();

                  await authProvider.sendMail(context, emailController.text, authProvider.generateOtp());
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
}
