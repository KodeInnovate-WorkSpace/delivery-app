import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:speedy_delivery/shared/show_msg.dart';

class UserModel extends ChangeNotifier {
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

  Future<void> updateUser(String field, dynamic newValue,
      {String? userField, dynamic fieldValue}) async {
    try {
      Query query = FirebaseFirestore.instance.collection('users');

      // Add conditions to your query if any
      if (userField != null && fieldValue != null) {
        query = query.where(userField, isEqualTo: fieldValue);
      }

      // Get the documents matching the query
      QuerySnapshot querySnapshot = await query.get();
      for (QueryDocumentSnapshot doc in querySnapshot.docs) {
        await doc.reference.update({field: newValue});
      }
    } catch (e) {
      log("Error updating users: $e");
    }
  }

  Future<void> deleteUser(dynamic fieldValue) async {
    try {
      Query query = FirebaseFirestore.instance.collection('users');

      // Add conditions to your query if any
      if (fieldValue != null) {
        query = query.where(FieldPath(const ['id']), isEqualTo: fieldValue);
      }

      // Get the documents matching the query
      QuerySnapshot querySnapshot = await query.get();
      for (QueryDocumentSnapshot doc in querySnapshot.docs) {
        await doc.reference.delete();
      }
      log("User Deleted!");
      showMessage("Users Deleted!");
    } catch (e) {
      log("Error deleting users: $e");
    }
  }

  Future<Widget> manageNotification() async {
    return const Text("Manage Notification");
  }
}

class SubCatModel extends ChangeNotifier {
  Future<List<Map<String, dynamic>>> manageSubCategories() async {
    try {
      final querySnapshot =
          await FirebaseFirestore.instance.collection('sub_category').get();
      return querySnapshot.docs
          .map((doc) => {
                ...doc.data(),
                // 'sub_category_id': doc.id, // Include the document ID
              })
          .toList();
    } catch (e) {
      log("Error: $e");
      return [];
    }
  }

  Future<void> updateSubCategory(String field, dynamic newValue,
      {String? categoryField, dynamic categoryValue}) async {
    try {
      Query query = FirebaseFirestore.instance.collection('sub_category');

      // Add conditions to your query if any
      if (categoryField != null && categoryValue != null) {
        query = query.where(categoryField, isEqualTo: categoryValue);
      }

      // Get the documents matching the query
      QuerySnapshot querySnapshot = await query.get();
      for (QueryDocumentSnapshot doc in querySnapshot.docs) {
        // Update each field separately
        await doc.reference.update({field: newValue});
      }
    } catch (e) {
      log("Error updating sub-category: $e");
    }
  }

  // Future<void> updateSubCategory(String field, dynamic newValue,
  //     {String? categoryField, dynamic categoryValue}) async {
  //   try {
  //     Query query = FirebaseFirestore.instance.collection('sub_category');
  //
  //     // Add conditions to your query if any
  //     if (categoryField != null && categoryValue != null) {
  //       query = query.where(categoryField, isEqualTo: categoryValue);
  //     }
  //
  //     // Get the documents matching the query
  //     QuerySnapshot querySnapshot = await query.get();
  //     for (QueryDocumentSnapshot doc in querySnapshot.docs) {
  //       await doc.reference.update({field: newValue});
  //     }
  //   } catch (e) {
  //     log("Error updating sub-category: $e");
  //   }
  // }

  Future<void> newUpdateSubCategory(String field, dynamic newValue,
      {required String categoryId}) async {
    try {
      // Query the collection for the specific category ID
      QuerySnapshot querySnapshot = await FirebaseFirestore.instance
          .collection('sub_category')
          .where('sub_category_id', isEqualTo: int.parse(categoryId))
          .get();

      // Update the document(s) that match the query
      for (QueryDocumentSnapshot doc in querySnapshot.docs) {
        await doc.reference.update(
          {field: newValue},
        );
      }
    } catch (e) {
      log("Error updating category: $e");
    }
  }

  Future<void> deleteSubCategory(dynamic categoryValue) async {
    try {
      Query query = FirebaseFirestore.instance.collection('sub_category');

      // Add conditions to your query if any
      if (categoryValue != null) {
        query = query.where(FieldPath(const ['sub_category_id']),
            isEqualTo: categoryValue); // Assuming 'catId' is the field name
      }

      // Get the documents matching the query
      QuerySnapshot querySnapshot = await query.get();
      for (QueryDocumentSnapshot doc in querySnapshot.docs) {
        await doc.reference.delete();
      }
      log("Sub-Category Deleted!");
      showMessage("Sub-Category Deleted!");
    } catch (e) {
      log("Error deleting sub-category: $e");
    }
  }
}

class CatModel extends ChangeNotifier {
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

  Future<void> updateCategory(String field, dynamic newValue,
      {String? categoryField, dynamic categoryValue}) async {
    try {
      Query query = FirebaseFirestore.instance.collection('category');

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

  Future<void> newupdateCategory(String field, dynamic newValue,
      {required String categoryId}) async {
    try {
      // Query the collection for the specific category ID
      QuerySnapshot querySnapshot = await FirebaseFirestore.instance
          .collection('category')
          .where('category_id', isEqualTo: int.parse(categoryId))
          .get();

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
      Query query = FirebaseFirestore.instance.collection('category');

      // Add conditions to your query if any
      if (categoryValue != null) {
        query = query.where(FieldPath(const ['category_id']),
            isEqualTo: categoryValue); // Assuming 'catId' is the field name
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

class ProductModel extends ChangeNotifier {
  Future<List<Map<String, dynamic>>> manageProducts() async {
    try {
      final querySnapshot =
          await FirebaseFirestore.instance.collection('products').get();
      return querySnapshot.docs.map((doc) => doc.data()).toList();
    } catch (e) {
      debugPrint("Error: $e");
      return [];
    }
  }

  Future<void> updateProduct(String field, dynamic newValue,
      {String? categoryField, dynamic categoryValue}) async {
    try {
      Query query = FirebaseFirestore.instance.collection('products');

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
      debugPrint("Error updating product: $e");
    }
  }

  Future<void> deleteProduct(dynamic categoryValue) async {
    try {
      Query query = FirebaseFirestore.instance.collection('products');

      // Add conditions to your query if any
      if (categoryValue != null) {
        query = query.where(FieldPath(const ['id']),
            isEqualTo: categoryValue); // Assuming 'catId' is the field name
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
