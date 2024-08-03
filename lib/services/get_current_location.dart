// import 'package:flutter/material.dart';
// import 'package:geolocator/geolocator.dart';
//
// Future<Position> getCurrentLocation() async {
//   late bool servicePermission = false;
//   late LocationPermission permission;
//   servicePermission = await Geolocator.isLocationServiceEnabled();
//   if (!servicePermission) {
//     permission = await Geolocator.checkPermission();
//   }
//   permission = await Geolocator.checkPermission();
//   if (permission == LocationPermission.denied) {
//     permission = await Geolocator.requestPermission();
//   }
//
//   return await Geolocator.getCurrentPosition(
//       desiredAccuracy: LocationAccuracy.high);
// }
//
// Future selectLocation(BuildContext context) {
//   return showModalBottomSheet(
//     context: context,
//     builder: (BuildContext context) {
//       return SingleChildScrollView(
//         child: Column(
//           children: [
//             ListTile(
//               title: const Text('Get Current Location'),
//               onTap: () {
//                 // Handle selection
//                 Navigator.pop(context);
//               },
//             ),
//             ListTile(
//               title: const Text('Location 2'),
//               onTap: () {
//                 // Handle selection
//                 Navigator.pop(context);
//               },
//             ),
//             // Add more ListTiles for additional locations
//           ],
//         ),
//       );
//     },
//   );
// }
