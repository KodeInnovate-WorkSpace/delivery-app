// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';
// import 'package:uuid/uuid.dart';
// import 'dart:developer';
// import 'auth_provider.dart';
// import 'package:intl/intl.dart';

// class CheckUserProvider with ChangeNotifier {
//   bool _isUserExist = false;
//   bool get isUserExist => _isUserExist;

//   String username = 'Username';

//   int userPhoneNum = 0;
//   CheckUserProvider();

//   //New Does User Exist
//   Future<void> doesUserExists(String phone) async {
//     final FirebaseFirestore firestore = FirebaseFirestore.instance;

//     try {
//       QuerySnapshot querySnapshot = await firestore
//           .collection('users')
//           .where('phone', isEqualTo: phone)
//           .get();

//       _isUserExist = querySnapshot.docs.isNotEmpty;
//       notifyListeners();
//     } catch (e) {
//       log("Error checking user existence: $e");
//       _isUserExist = false;
//       notifyListeners();
//     }
//   }

// //New StoreDetail
//   Future<void> storeDetail(
//       BuildContext context, String field, String value) async {
//     final authProvider = Provider.of<MyAuthProvider>(context, listen: false);
//     final checkUserProvider =
//         Provider.of<CheckUserProvider>(context, listen: false);
//     final FirebaseFirestore firestore = FirebaseFirestore.instance;

//     try {
//       // Get today's date
//       String todayDate = DateFormat('dd-MM-yyyy').format(DateTime.now());
//       // Check if the user exists
//       await checkUserProvider.doesUserExists(authProvider.phone);

//       if (!checkUserProvider._isUserExist) {
//         // Add new user data if user does not exist
//         await firestore.collection('users').add({
//           'id': const Uuid().v4(),
//           'phone': authProvider.phone,
//           field: value,
//           // Add other user data here if necessary
//           'date': todayDate,
//           'status': 1,
//           'name': '',
//         });
//         log("New user added successfully");
//       } else {
//         log("User already exists, updating user data");

// // Query the user document based on phone number
//         QuerySnapshot querySnapshot = await firestore
//             .collection('users')
//             .where('phone', isEqualTo: authProvider.phone)
//             .get();

//         if (querySnapshot.docs.isNotEmpty) {
//           // Get the document ID of the user
//           String userDocId = querySnapshot.docs.first.id;

//           // Get the 'id' field from the user document data
//           String userId = querySnapshot.docs.first.get('id');

//           // Call updateUserDetail with the document ID and the 'id' field value
//           await updateUserDetail(context, userId, value);
//         } else {
//           log("User not found, which is unexpected since it should exist");
//         }
//       }
//     } catch (e) {
//       log("Error: $e");
//     }
//   }

// //save name of the user
//   Future<void> updateUserDetail(
//       BuildContext context, String userId, String username) async {
//     final FirebaseFirestore firestore = FirebaseFirestore.instance;

//     try {
//       // Query the user document based on phone number
//       QuerySnapshot querySnapshot = await firestore
//           .collection('users')
//           .where('id', isEqualTo: userId)
//           .get();

//       if (querySnapshot.docs.isNotEmpty) {
//         // Get the document reference of the user
//         DocumentReference userDocRef = querySnapshot.docs.first.reference;

//         // Update the specific field
//         await userDocRef.update({
//           'name': username,
//         });

//         log("User field updated successfully");
//       } else {
//         log("User not found, which is unexpected since it should exist");
//       }
//     } catch (e) {
//       log("Error updating user: $e");
//     }
//   }
// }

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:uuid/uuid.dart';
import 'dart:developer';
import 'auth_provider.dart';
import 'package:intl/intl.dart';

class CheckUserProvider with ChangeNotifier {
  bool _isUserExist = false;
  bool get isUserExist => _isUserExist;

  // check status variables
  bool _isUserActive = true;
  bool get isUserActive => _isUserActive;

  String username = 'Username';
  int userPhoneNum = 0;
  CheckUserProvider();

  //type of user
  int? _userType;
  int? get userType => _userType;

  //user token
  String? _userToken;
  String? get userToken => _userToken;

  // Check if User Exists
  Future<void> doesUserExists(String phone, BuildContext context) async {
    final FirebaseFirestore firestore = FirebaseFirestore.instance;
    final authProvider = Provider.of<MyAuthProvider>(context, listen: false);

    try {
      QuerySnapshot querySnapshot = await firestore.collection('users').where('phone', isEqualTo: phone).get();
      _isUserExist = querySnapshot.docs.isNotEmpty;

      notifyListeners();
    } catch (e) {
      log("Error checking user existence: $e");
      _isUserExist = false;
      notifyListeners();
    }
  }

  // Store or Update User Details
  Future<void> storeDetail(BuildContext context, String field, String value, {String email = ''}) async {
    final authProvider = Provider.of<MyAuthProvider>(context, listen: false);
    final checkUserProvider = Provider.of<CheckUserProvider>(context, listen: false);
    final FirebaseFirestore firestore = FirebaseFirestore.instance;

    uploadFCMToken(authProvider.phone);
    try {
      // Get today's date
      String todayDate = DateFormat('dd-MM-yyyy').format(DateTime.now());
      // Check if the user exists
      await checkUserProvider.doesUserExists(authProvider.phone, context);
      final token = await FirebaseMessaging.instance.getToken();
      //final token = await FirebaseMessaging.instance.getToken().then((token) async {});
      if (!checkUserProvider._isUserExist) {
        // Add new user data if user does not exist
        await firestore.collection('users').add({'id': const Uuid().v4(), 'phone': authProvider.phone, field: value, 'fcmToken': token, 'date': todayDate, 'status': 1, 'name': '', 'type': 0, 'email': authProvider.email});
        log("New user added successfully");
      } else {
        QuerySnapshot querySnapshot = await firestore.collection('users').where('phone', isEqualTo: authProvider.phone).get();

        if (querySnapshot.docs.isNotEmpty) {
          // Get the document ID of the user
          String userDocId = querySnapshot.docs.first.id;

          // Update the user details directly
          await firestore.collection('users').doc(userDocId).update({
            field: value,
            'email': authProvider.email,
          });
        }
      }
    } catch (e) {
      log("Error: $e");
    }
  }

  Future<void> checkUserStatus(String phone) async {
    final FirebaseFirestore firestore = FirebaseFirestore.instance;

    try {
      QuerySnapshot querySnapshot = await firestore.collection('users').where('phone', isEqualTo: phone).get();

      if (querySnapshot.docs.isNotEmpty) {
        final userDoc = querySnapshot.docs.first;
        final userStatus = userDoc.get('status');
        _isUserActive = userStatus == 1;
      } else {
        _isUserActive = false;
      }
    } catch (e) {
      log("Error checking user status: $e");
      _isUserActive = false;
    }

    notifyListeners();
  }

  Future<void> checkUserType(String phone) async {
    final FirebaseFirestore firestore = FirebaseFirestore.instance;

    try {
      QuerySnapshot querySnapshot = await firestore.collection('users').where('phone', isEqualTo: phone).get();

      if (querySnapshot.docs.isNotEmpty) {
        final userDoc = querySnapshot.docs.first;
        final userType = userDoc.get('type');
        _userType = userType;
        log("User type = $_userType");
      }
    } catch (e) {
      log("Error checking user type: $e");
    }

    notifyListeners();
  }

  Future<void> uploadFCMToken(String phone) async {
    try {
      FirebaseMessaging.instance.onTokenRefresh.listen((token) async {
        log("Refresh Token: $token");

        final FirebaseFirestore firestore = FirebaseFirestore.instance;
        final QuerySnapshot querySnapshot = await firestore.collection('users').where('phone', isEqualTo: phone).get();
        if (querySnapshot.docs.isNotEmpty) {
          final DocumentReference userDocRef = querySnapshot.docs.first.reference;
          await userDocRef.update({'fcmToken': token});
        } else {
          log('User not found for phone number: $phone');
        }
      });
    } catch (e) {
      log("Error setting user token: $e");
    }

    notifyListeners();
  }

  Future<String> getUserToken(String phone) async {
    final FirebaseFirestore firestore = FirebaseFirestore.instance;

    try {
      QuerySnapshot querySnapshot = await firestore.collection('users').where('phone', isEqualTo: phone).get();

      if (querySnapshot.docs.isNotEmpty) {
        final userDoc = querySnapshot.docs.first;
        final userToken = userDoc.get('fcmToken');
        log("User token = $_userToken");
        return _userToken = userToken;
      }
    } catch (e) {
      log("Error getting user token: $e");
    }
    notifyListeners();
    return "Token Not Found";
  }
}
