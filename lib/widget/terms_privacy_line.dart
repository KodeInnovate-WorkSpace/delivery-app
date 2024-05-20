import 'package:flutter/cupertino.dart';

import '../shared/underline_text.dart';

Widget termsPrivacyLine() {
  return Row(
    mainAxisAlignment: MainAxisAlignment.center,
    children: [
      const Text(
        "By continuing, you agree to our ",
        style: TextStyle(fontSize: 10),
      ),
      underlineText("Terms of service"),
      const Text(
        " & ",
        style: TextStyle(fontSize: 10),
      ),
      underlineText("Privacy Policy"),
    ],
  );
}
