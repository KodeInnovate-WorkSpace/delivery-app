import 'package:flutter/material.dart';

Widget offerProductCard() {
  return Padding(
    padding: const EdgeInsets.only(top: 35, bottom: 10, left: 5, right: 5),
    child: Container(
      width: 140,
      height: 180,
      color: const Color.fromRGBO(200, 0, 0, 0.6),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text("Image"),
          Text("Name"),
          Text("Price"),
          ElevatedButton(
            onPressed: () {},
            child: const Text("Add"),
          ),
        ],
      ),
    ),
  );
}

// old working
// Widget offerProductCard() {
//   return Padding(
//     padding: const EdgeInsets.only(top: 35, bottom: 10, left: 5, right: 5),
//     child: Container(
//       width: 140,
//       height: 180,
//       color: const Color.fromRGBO(200, 0, 0, 0.6),
//       child: Column(
//         mainAxisAlignment: MainAxisAlignment.center,
//         children: [Text("Image"), Text("Name"), Text("Price"), Text("Mrp"), ElevatedButton(onPressed: (){}, child: Text("Add"))],
//       ),
//     ),
//   );
// }
