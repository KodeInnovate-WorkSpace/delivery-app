import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:speedy_delivery/shared/show_msg.dart';


class OfferCatModel extends ChangeNotifier {
  Future<List<Map<String, dynamic>>> manageCategories() async {
    try {
      final querySnapshot = await FirebaseFirestore.instance.collection('offerCategory').get();
      return querySnapshot.docs.map((doc) => doc.data()).toList();
    } catch (e) {
      log("Error: $e");
      return [];
    }
  }

  Future<void> updateCategory(String field, dynamic newValue, {String? categoryField, dynamic categoryValue}) async {
    try {
      Query query = FirebaseFirestore.instance.collection('offerCategory');

      // Add conditions to your query if any
      if (categoryField != null && categoryValue != null) {
        query = query.where(categoryField, isEqualTo: categoryValue);
      }

      // Get the documents matching the query
      QuerySnapshot querySnapshot = await query.get();
      for (QueryDocumentSnapshot doc in querySnapshot.docs) {
        await doc.reference.update({field: newValue});
      }
    } catch (e) {
      log("Error updating category: $e");
    }
  }

  Future<void> newupdateCategory(String field, dynamic newValue, {required String id}) async {
    try {
      // Query the collection for the specific category ID
      QuerySnapshot querySnapshot = await FirebaseFirestore.instance.collection('offerCategory').where('id', isEqualTo: int.parse(id)).get();

      // Update the document(s) that match the query
      for (QueryDocumentSnapshot doc in querySnapshot.docs) {
        await doc.reference.update({field: newValue});
      }
    } catch (e) {
      log("Error updating category: $e");
    }
  }

  Future<void> deleteCategory(dynamic categoryValue) async {
    try {
      Query query = FirebaseFirestore.instance.collection('offerCategory');

      // Add conditions to your query if any
      if (categoryValue != null) {
        query = query.where(FieldPath(const ['id']), isEqualTo: categoryValue); // Assuming 'catId' is the field name
      }

      // Get the documents matching the query
      QuerySnapshot querySnapshot = await query.get();
      for (QueryDocumentSnapshot doc in querySnapshot.docs) {
        await doc.reference.delete();
      }
      log("Category Deleted!");
      showMessage("Category Deleted!");
    } catch (e) {
      showMessage("Error deleting category");

      log("Error deleting category: $e");
    }
  }
}

class OfferProductModel extends ChangeNotifier {
  Future<List<Map<String, dynamic>>> manageProducts() async {
    try {
      final querySnapshot = await FirebaseFirestore.instance.collection('offerProduct').get();
      return querySnapshot.docs.map((doc) => doc.data()).toList();
    } catch (e) {
      debugPrint("Error: $e");
      return [];
    }
  }

  Future<void> updateProduct(String field, dynamic newValue, {String? productField, dynamic productValue}) async {
    try {
      Query query = FirebaseFirestore.instance.collection('offerProduct');

      // Add conditions to your query if any
      if (productField != null && productValue != null) {
        query = query.where(productField, isEqualTo: productValue);
      }

      // Get the documents matching the query
      QuerySnapshot querySnapshot = await query.get();
      for (QueryDocumentSnapshot doc in querySnapshot.docs) {
        await doc.reference.update({field: newValue});
      }
    } catch (e) {
      debugPrint("Error updating product: $e");
    }
  }

  Future<void> deleteProduct(dynamic categoryValue) async {
    try {
      Query query = FirebaseFirestore.instance.collection('offerProduct');

      // Add conditions to your query if any
      if (categoryValue != null) {
        query = query.where(FieldPath(const ['id']), isEqualTo: categoryValue); // Assuming 'catId' is the field name
      }

      // Get the documents matching the query
      QuerySnapshot querySnapshot = await query.get();
      for (QueryDocumentSnapshot doc in querySnapshot.docs) {
        await doc.reference.delete();
      }
      log("Product Deleted!");
      showMessage("Product Deleted!");
    } catch (e) {
      showMessage("Error deleting product");

      log("Error deleting product: $e");
    }
  }
}