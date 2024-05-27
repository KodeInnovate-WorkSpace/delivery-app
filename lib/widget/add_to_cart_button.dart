import 'package:flutter/material.dart';

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
    return _isClicked
        ? Row(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisSize: MainAxisSize.max,
      children: [
        Align(
          alignment: Alignment.centerRight,
          child: InkWell(
            onTap: () {},
            child: Container(
              height: 35,
              width: 75,
              decoration: BoxDecoration(
                  color: Colors.green,
                  borderRadius: BorderRadius.circular(5)),
              child: Padding(
                padding: const EdgeInsets.all(4.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    InkWell(
                        onTap: () {
                          setState(() {
                            if (_count > 1) {
                              _count--;
                            } else if (_count == 1) {
                              _isClicked = false;
                              _count--;
                            }
                          });
                        },
                        child: const Icon(
                          Icons.remove,
                          color: Colors.white,
                          size: 15,
                        )),
                    Text(
                        _count != 0
                            ? "$_count"
                            : "Add",
                        style: const TextStyle(
                            color: Colors.white,
                            fontFamily: 'Gilroy-SemiBold')),
                    InkWell(
                        onTap: () {
                          setState(() {
                            _count++;
                          });
                        },
                        child: const Icon(
                          Icons.add,
                          color: Colors.white,
                          size: 15,
                        )),
                  ],
                ),
              ),
            ),
          ),
        )
      ],
    )
        : OutlinedButton(
      onPressed: () {
        setState(() {
          _isClicked = true;
          _count = 1;  // Start with 1 when button is first clicked
        });
      },
      style: ButtonStyle(
        backgroundColor: WidgetStateProperty.all<Color>(Colors.transparent),
        overlayColor: WidgetStateProperty.resolveWith<Color>(
                (Set<WidgetState> states) {
              if (states.contains(WidgetState.hovered)) {
                return Colors.green.withOpacity(0.1);
              }
              if (states.contains(WidgetState.pressed)) {
                return Colors.green.withOpacity(0.3);
              }
              return Colors.green.withOpacity(0.6);
            }),
        side: WidgetStateProperty.all<BorderSide>(
            const BorderSide(color: Colors.green)),
        shape: WidgetStateProperty.all<RoundedRectangleBorder>(
          const RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(4)),
          ),
        ),
        minimumSize: WidgetStateProperty.all<Size>(const Size(75, 35)),
      ),
      child: const Text(
        "Add",
        style: TextStyle(
          color: Colors.green,
          fontFamily: 'Gilroy-SemiBold',
        ),
      ),
    );
  }
}