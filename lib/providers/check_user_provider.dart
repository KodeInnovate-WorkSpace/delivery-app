import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'dart:developer';
import 'auth_provider.dart';
import 'package:intl/intl.dart';

class CheckUserProvider with ChangeNotifier {
  bool _isUserExist = false;
  bool get isUserExist => _isUserExist;

  int userPhoneNum = 0;
  CheckUserProvider();

  Future<void> doesUserExists(String phone) async {
    // update user phone number
    userPhoneNum = int.parse(phone);
    notifyListeners();

    final FirebaseFirestore firestore = FirebaseFirestore.instance;
    try {
      CollectionReference users = firestore.collection('users');
      final querySnapshot = await users.where('phone', isEqualTo: phone).get();

      _isUserExist = querySnapshot.docs.isNotEmpty;
      notifyListeners();
    } catch (e) {
      log("Error: $e");
      _isUserExist = false;
      notifyListeners();
    }
  }

  // store user
  // Future<void> storeUserData(
  //     BuildContext context, String field, String value) async {
  //   final authProvider = Provider.of<MyAuthProvider>(context, listen: false);
  //   final checkUserProvider =
  //       Provider.of<CheckUserProvider>(context, listen: false);
  //   final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  //
  //   try {
  //     await checkUserProvider.doesUserExists(authProvider.phone);
  //
  //     if (!checkUserProvider.isUserExist) {
  //       CollectionReference users = _firestore.collection('users');
  //
  //       await users.add({
  //         field: value,
  //         // Add other user data here
  //       });
  //     }
  //   } catch (e) {
  //     log("Error: $e");
  //   }
  // }

  Future<void> storeDetail(
      BuildContext context, String field, String value) async {
    final authProvider = Provider.of<MyAuthProvider>(context, listen: false);
    final checkUserProvider =
        Provider.of<CheckUserProvider>(context, listen: false);
    final FirebaseFirestore _firestore = FirebaseFirestore.instance;

    try {
      // Get today's date
      String todayDate = DateFormat('dd-MM-yyyy').format(DateTime.now());
      // Check if the user exists
      await checkUserProvider.doesUserExists(authProvider.phone);

      if (!checkUserProvider.isUserExist) {
        // Add new user data if user does not exist
        await _firestore.collection('users').add({
          'phone': authProvider.phone,
          field: value,
          // Add other user data here if necessary
          'date': todayDate,
          'status': 1,
        });
      } else {
        // Query the user document based on phone number
        QuerySnapshot querySnapshot = await _firestore
            .collection('users')
            .where('phone', isEqualTo: authProvider.textController.text)
            .get();

        if (querySnapshot.docs.isNotEmpty) {
          // Get the document reference of the user
          DocumentReference userDocRef = querySnapshot.docs.first.reference;

          // Update the specific field
          await userDocRef.update({
            field: value,
          });

          log("User field updated successfully");
        } else {
          log("User not found");
        }
      }
    } catch (e) {
      log("Error: $e");
    }
  }
}
