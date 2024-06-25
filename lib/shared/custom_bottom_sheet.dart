import 'package:flutter/material.dart';

Widget customBottomSheet(BuildContext context) {
  return Container(
    decoration: const BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.only(
        topLeft: Radius.circular(0.0),
        topRight: Radius.circular(0.0),
      ),
    ),
    child: Padding(
      padding: const EdgeInsets.all(18.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const ElevatedButton(
              onPressed: null,
              child: Icon(
                Icons.remove,
                size: 15,
              )),
          const Text("Your Item"),
          ElevatedButton(
              onPressed: null,
              style: ButtonStyle(
                backgroundColor: WidgetStateProperty.all<Color>(Colors.green),
                side: WidgetStateProperty.all<BorderSide>(
                    const BorderSide(color: Colors.green)),
                shape: WidgetStateProperty.all<RoundedRectangleBorder>(
                  const RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(Radius.circular(4)),
                  ),
                ),
                minimumSize: WidgetStateProperty.all<Size>(const Size(10, 30)),
              ),
              child: const Icon(
                Icons.add,
                size: 15,
                color: Colors.white,
              )),
          ElevatedButton(
              onPressed: null,
              style: ButtonStyle(
                backgroundColor: WidgetStateProperty.all<Color>(Colors.green),
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
                minimumSize: WidgetStateProperty.all<Size>(const Size(25, 35)),
              ),
              child: const Row(
                children: [
                  Text(
                    "Next",
                    style: TextStyle(
                        fontSize: 20,
                        fontFamily: 'Gilroy-Bold',
                        color: Colors.white),
                  ),
                  Icon(
                    Icons.navigate_next_rounded,
                    color: Colors.white,
                  ),
                ],
              ))
        ],
      ),
    ),
  );
}
