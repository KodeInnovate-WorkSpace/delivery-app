import 'package:flutter/material.dart';

import 'add_to_cart_button.dart';

class ProductCard extends StatefulWidget {
  const ProductCard({super.key});

  @override
  State<ProductCard> createState() => _ProductCardState();
}

class _ProductCardState extends State<ProductCard> {
  final bool _isClicked = false;

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(6.0), // Set the border radius here
      ),
      color: Colors.white,
      elevation: 1.6,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Adjust padding
            Center(
                child: Image.network(
              width: 90,
              "https://firebasestorage.googleapis.com/v0/b/speedy-app-e17a5.appspot.com/o/images%2Fblack_pepper_masala.png?alt=media&token=38266974-fadb-4613-b724-83ef4b66e1b0",
            )),

            const SizedBox(
              height: 15,
            ),
            const Text(
              "MDH Black Pepper Powder",
              textAlign: TextAlign.left,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(fontFamily: 'Gilroy-SemiBold'),
            ), // Replace with your actual data field
            const Text(
              "100g",
              style: TextStyle(color: Colors.grey),
            ),
            const SizedBox(
              height: 10,
            ),
            const Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "\u20B9 78",
                  style: TextStyle(
                    fontFamily: "Gilroy-medium",
                  ),
                ),

                AddToCartButton(),
                // Old Button
                // OutlinedButton(
                //   onPressed: () {
                //     setState(() {
                //       _isClicked = !_isClicked;
                //     });
                //   },
                //   style: ButtonStyle(
                //     backgroundColor: _isClicked
                //         ? WidgetStateProperty.all<Color>(Colors.green)
                //         : WidgetStateProperty.all<Color>(Colors.transparent),
                //     overlayColor: WidgetStateProperty.resolveWith<Color>(
                //         (Set<WidgetState> states) {
                //       if (states.contains(WidgetState.hovered)) {
                //         return Colors.green.withOpacity(0.1);
                //       }
                //       if (states.contains(WidgetState.pressed)) {
                //         return Colors.green.withOpacity(0.3);
                //       }
                //       return Colors.green.withOpacity(0.6);
                //     }),
                //     side: WidgetStateProperty.all<BorderSide>(
                //         const BorderSide(color: Colors.green)), // Outline color
                //     shape: WidgetStateProperty.all<RoundedRectangleBorder>(
                //       const RoundedRectangleBorder(
                //         borderRadius: BorderRadius.all(
                //             Radius.circular(4)), // No border radius
                //       ),
                //     ),
                //     minimumSize:
                //         WidgetStateProperty.all<Size>(const Size(25, 30)),
                //   ),
                //   child: _isClicked
                //       ? const Text(
                //           "Add",
                //           style: TextStyle(
                //             color: Colors.green,
                //           ),
                //         )
                //       : Container(
                //           width: 30,
                //           height: 25,
                //           color: Colors.green,
                //           child: Row(children: [
                //             TextButton(
                //                 onPressed: null,
                //                 child: Text(
                //                   "-",
                //                   style: TextStyle(color: Colors.white),
                //                 )),
                //             const Text(
                //               "1",
                //               style: TextStyle(
                //                 color: Colors.white,
                //               ),
                //             ),
                //             TextButton(
                //                 onPressed: null,
                //                 style: ButtonStyle(
                //                   shape: WidgetStateProperty.all<
                //                       RoundedRectangleBorder>(
                //                     const RoundedRectangleBorder(
                //                       borderRadius: BorderRadius.all(
                //                           Radius.circular(
                //                               4)), // No border radius
                //                     ),
                //                   ),
                //                 ),
                //                 child: const Text(
                //                   "+",
                //                   style: TextStyle(color: Colors.white),
                //                 )),
                //           ]),
                //         ),
                // ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
