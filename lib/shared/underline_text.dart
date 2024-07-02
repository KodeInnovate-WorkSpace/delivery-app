import 'package:flutter/material.dart';

Widget underlineText(String str) {
  return GestureDetector(
    onTap: () {},
    child: Text(
      str,
      style: TextStyle(
          decoration: TextDecoration.combine([
            TextDecoration.underline,
          ]),
          decorationStyle: TextDecorationStyle.dashed,
          // You can also specify other styles such as color and font size here
          // color: Colors.black,
          color: const Color(0xff666666),
          fontSize: 10),
    ),
  );
}
