// import 'dart:developer';
//
// import 'package:connectivity_plus/connectivity_plus.dart';
// import 'package:get/get.dart';
//
// import '../screens/no_internet_screen.dart';
//
// class ConnectivityProvider extends GetxController {
//   final Connectivity _conn = Connectivity();
//
//   @override
//   void onInit() {
//     super.onInit();
//     _conn.onConnectivityChanged.listen(netStatus);
//   }
//
//   void netStatus(List<ConnectivityResult> connResList) {
//     final connRes = connResList.first; // Assuming you're interested in the first result
//     if (connRes == ConnectivityResult.none) {
//       Get.to(() => const NoInternetScreen());
//       log("No Internet");
//     } else {
//       if (Get.currentRoute == '/noInternet') {
//         Get.back();
//       }
//       log("Yes Internet");
//     }
//   }
// }
