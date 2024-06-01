import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class Admin extends ChangeNotifier {
  Future<List<Map<String, dynamic>>> manageUsers() async {
    try {
      final querySnapshot =
          await FirebaseFirestore.instance.collection('users').get();
      return querySnapshot.docs.map((doc) => doc.data()).toList();
    } catch (e) {
      log("Error: $e");
      return [];
    }
  }

  Future<List<Map<String, dynamic>>> manageCategories() async {
    try {
      final querySnapshot =
          await FirebaseFirestore.instance.collection('category').get();
      return querySnapshot.docs.map((doc) => doc.data()).toList();
    } catch (e) {
      log("Error: $e");
      return [];
    }
  }

  Future<List<Map<String, dynamic>>> manageSubCategories() async {
    try {
      final querySnapshot =
      await FirebaseFirestore.instance.collection('sub_category').get();
      return querySnapshot.docs.map((doc) => {
        ...doc.data(),
        // 'sub_category_id': doc.id, // Include the document ID
      }).toList();
    } catch (e) {
      log("Error: $e");
      return [];
    }
  }

  Future<void> updateSubCategory(String id, String field, dynamic newValue) async {
    try {
      await FirebaseFirestore.instance.collection('sub_category').doc(id).update({field: newValue});
    } catch (e) {
      log("Error updating sub-category: $e");
    }
  }

  Future<List<Map<String, dynamic>>> manageProducts() async {
    try {
      final querySnapshot =
          await FirebaseFirestore.instance.collection('products').get();
      return querySnapshot.docs.map((doc) => doc.data()).toList();
    } catch (e) {
      log("Error: $e");
      return [];
    }
  }

  Future<Widget> manageNotification() async {
    return const Text("Manage Notification");
  }
}
