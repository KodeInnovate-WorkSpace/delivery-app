import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'dart:developer';

import 'auth_provider.dart';

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
  Future<void> storeUserData(
      BuildContext context, String field, String value) async {
    final authProvider = Provider.of<MyAuthProvider>(context, listen: false);
    final checkUserProvider =
        Provider.of<CheckUserProvider>(context, listen: false);
    final FirebaseFirestore _firestore = FirebaseFirestore.instance;

    try {
      await checkUserProvider.doesUserExists(authProvider.phone);

      if (!checkUserProvider.isUserExist) {
        CollectionReference users = _firestore.collection('users');

        await users.add({
          field: value,
          // Add other user data here
        });
      }
    } catch (e) {
      log("Error: $e");
    }
  }
}
