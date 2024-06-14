import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:uuid/uuid.dart';
import 'dart:developer';
import 'auth_provider.dart';
import 'package:intl/intl.dart';

class CheckUserProvider with ChangeNotifier {
  bool _isUserExist = false;
  bool get isUserExist => _isUserExist;

  String username = 'Username';

  int userPhoneNum = 0;
  CheckUserProvider();

  //New Does User Exist
  Future<void> doesUserExists(String phone) async {
    final FirebaseFirestore firestore = FirebaseFirestore.instance;

    try {
      QuerySnapshot querySnapshot = await firestore
          .collection('users')
          .where('phone', isEqualTo: phone)
          .get();

      _isUserExist = querySnapshot.docs.isNotEmpty;
      notifyListeners();
    } catch (e) {
      log("Error checking user existence: $e");
      _isUserExist = false;
      notifyListeners();
    }
  }

//New StoreDetail
  Future<void> storeDetail(
      BuildContext context, String field, String value) async {
    final authProvider = Provider.of<MyAuthProvider>(context, listen: false);
    final checkUserProvider =
        Provider.of<CheckUserProvider>(context, listen: false);
    final FirebaseFirestore firestore = FirebaseFirestore.instance;

    try {
      // Get today's date
      String todayDate = DateFormat('dd-MM-yyyy').format(DateTime.now());
      // Check if the user exists
      await checkUserProvider.doesUserExists(authProvider.phone);

      if (!checkUserProvider._isUserExist) {
        // Add new user data if user does not exist
        await firestore.collection('users').add({
          'id': const Uuid().v4(),
          'phone': authProvider.phone,
          field: value,
          // Add other user data here if necessary
          'date': todayDate,
          'status': 1,
        });
        log("New user added successfully");
      } else {
        log("User already exists, updating user data");

        // Query the user document based on phone number
        QuerySnapshot querySnapshot = await firestore
            .collection('users')
            .where('phone', isEqualTo: authProvider.phone)
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
          log("User not found, which is unexpected since it should exist");
        }
      }
    } catch (e) {
      log("Error: $e");
    }
  }
}
