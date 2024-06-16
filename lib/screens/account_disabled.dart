import 'package:flutter/material.dart';
import 'package:flutter_phone_direct_caller/flutter_phone_direct_caller.dart';
import 'package:speedy_delivery/shared/show_msg.dart';
import 'package:url_launcher/url_launcher.dart';

class AccountDisabled extends StatelessWidget {
  const AccountDisabled({super.key});

  @override
  Widget build(BuildContext context) {
    Uri dialNumber = Uri(scheme: 'tel', path: '1234567890');

    callnumber() async {
      await launchUrl(dialNumber);
    }

    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Image.asset(
            "assets/images/stop2.png",
            width: 180,
          ),
          const Text(
            "Sorry, your account is disabled",
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 30, fontFamily: 'Gilroy-Black'),
          ),
          const SizedBox(
            height: 10,
          ),
          const Text(
            "Please contact us to know why",
            style: TextStyle(fontFamily: 'Gilroy-SemiBold', fontSize: 15),
          ),
          const SizedBox(
            height: 20,
          ),
          ElevatedButton(
            onPressed: callnumber,
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
              width: 250,
              height: 50.0,
              child: Center(
                child: Text(
                  "Contact Us",
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 20.0,
                      fontFamily: 'Gilroy-ExtraBold'),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
