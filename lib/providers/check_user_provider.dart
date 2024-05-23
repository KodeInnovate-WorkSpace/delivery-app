import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'dart:developer';

class CheckUserProvider with ChangeNotifier {
  bool _isUserExist = false;

  bool get isUserExist => _isUserExist;

  CheckUserProvider();

  Future<void> doesUserExists(String phone) async {
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
}