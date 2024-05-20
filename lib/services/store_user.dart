import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:speedy_delivery/providers/check_user_provider.dart';

import '../providers/auth_provider.dart';

class StoreUser {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> storeUserData(BuildContext context) async {
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    final checkUserProvider =
        Provider.of<CheckUserProvider>(context, listen: false);

    try {
      await checkUserProvider.doesUserExists(authProvider.phone);

      if (!checkUserProvider.isUserExist) {
        CollectionReference users = _firestore.collection('users');

        await users.add({
          'phone': authProvider.textController.text,
          // Add other user data here
        });
      }
    } catch (e) {
      log("Error: $e");
    }
  }
}
