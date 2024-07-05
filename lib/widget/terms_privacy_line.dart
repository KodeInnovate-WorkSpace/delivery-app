import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

Widget termsPrivacyLine() {
  return Row(
    mainAxisAlignment: MainAxisAlignment.center,
    children: [
      const Text(
        "By continuing, you agree to our ",
        style: TextStyle(fontSize: 10, color: Color(0xff666666)),
      ),
      underlineText("Terms of Service", "https://kodeinnovate-workspace.github.io/delivo-policy/delivo_app_terms_and_conditions.html"),
      const Text(
        " & ",
        style: TextStyle(fontSize: 10, color: Color(0xff666666)),
      ),
      underlineText("Privacy Policy", "https://kodeinnovate-workspace.github.io/delivo-policy/delivo_app_privacy_policy.html"),
    ],
  );
}

Widget underlineText(String text, String url) {
  return GestureDetector(
    onTap: () async {
      if (await canLaunch(url)) {
        await launch(url);
      } else {
        throw 'Could not launch $url';
      }
    },
    child: Text(
      text,
      style: const TextStyle(
        fontSize: 10,
        color: Color(0xff666666),
        decoration: TextDecoration.underline,
      ),
    ),
  );
}
