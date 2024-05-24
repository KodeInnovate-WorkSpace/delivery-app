import 'package:flutter/material.dart';

import '../shared/custom_bottom_sheet.dart';

class AddToCartButton extends StatefulWidget {
  const AddToCartButton({super.key});

  @override
  AddToCartButtonState createState() => AddToCartButtonState();
}

class AddToCartButtonState extends State<AddToCartButton> {
  bool _isClicked = false;
  int _count = 0;

  @override
  Widget build(BuildContext context) {
    return OutlinedButton(
      onPressed: () {
        setState(() {
          _isClicked = !_isClicked;
          if (_isClicked) {
            _count++;
          }
        });

        showModalBottomSheet(
          context: context,
          builder: (BuildContext context) => customBottomSheet(context),
        );
      },
      style: ButtonStyle(
        backgroundColor: _isClicked
            ? WidgetStateProperty.all<Color>(Colors.green)
            : WidgetStateProperty.all<Color>(Colors.transparent),
        overlayColor:
            WidgetStateProperty.resolveWith<Color>((Set<WidgetState> states) {
          if (states.contains(WidgetState.hovered)) {
            return Colors.green.withOpacity(0.1);
          }
          if (states.contains(WidgetState.pressed)) {
            return Colors.green.withOpacity(0.3);
          }
          return Colors.green.withOpacity(0.6);
        }),
        side: WidgetStateProperty.all<BorderSide>(
            const BorderSide(color: Colors.green)), // Outline color
        shape: WidgetStateProperty.all<RoundedRectangleBorder>(
          const RoundedRectangleBorder(
            borderRadius:
                BorderRadius.all(Radius.circular(4)), // No border radius
          ),
        ),
        minimumSize: WidgetStateProperty.all<Size>(const Size(25, 35)),
      ),
      child: _isClicked
          ? const Text(
              "Add",
              style: TextStyle(
                color: Colors.white,
              ),
            )
          : const Text(
              "Add",
              style: TextStyle(
                color: Colors.green,
              ),
            ),
    );
  }
}
