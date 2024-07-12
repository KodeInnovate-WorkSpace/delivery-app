import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:speedy_delivery/shared/show_msg.dart';

class UserModel extends ChangeNotifier {
  Future<List<Map<String, dynamic>>> manageUsers() async {
    try {
      final querySnapshot = await FirebaseFirestore.instance.collection('users').get();
      return querySnapshot.docs.map((doc) => doc.data()).toList();
    } catch (e) {
      log("Error: $e");
      return [];
    }
  }

  Future<void> updateUser(String field, dynamic newValue, {String? userField, dynamic fieldValue}) async {
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
      final querySnapshot = await FirebaseFirestore.instance.collection('sub_category').get();
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

  Future<void> updateSubCategory(String field, dynamic newValue, {String? categoryField, dynamic categoryValue}) async {
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

  Future<void> newUpdateSubCategory(String field, dynamic newValue, {required String categoryId}) async {
    try {
      // Query the collection for the specific category ID
      QuerySnapshot querySnapshot = await FirebaseFirestore.instance.collection('sub_category').where('sub_category_id', isEqualTo: int.parse(categoryId)).get();

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
        query = query.where(FieldPath(const ['sub_category_id']), isEqualTo: categoryValue); // Assuming 'catId' is the field name
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
      final querySnapshot = await FirebaseFirestore.instance.collection('category').get();
      return querySnapshot.docs.map((doc) => doc.data()).toList();
    } catch (e) {
      log("Error: $e");
      return [];
    }
  }

  Future<void> updateCategory(String field, dynamic newValue, {String? categoryField, dynamic categoryValue}) async {
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

  Future<void> newupdateCategory(String field, dynamic newValue, {required String categoryId}) async {
    try {
      // Query the collection for the specific category ID
      QuerySnapshot querySnapshot = await FirebaseFirestore.instance.collection('category').where('category_id', isEqualTo: int.parse(categoryId)).get();

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
        query = query.where(FieldPath(const ['category_id']), isEqualTo: categoryValue); // Assuming 'catId' is the field name
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

class AppMaintenance {
  String id;
  int isAppEnabled;

  AppMaintenance({required this.id, required this.isAppEnabled});

  factory AppMaintenance.fromFirestore(DocumentSnapshot doc) {
    Map data = doc.data() as Map;
    return AppMaintenance(
      id: doc.id,
      isAppEnabled: data['isAppEnabled'] ?? 0,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'isAppEnabled': isAppEnabled,
    };
  }
}


class ProductModel extends ChangeNotifier {
  Future<List<Map<String, dynamic>>> manageProducts() async {
    try {
      final querySnapshot = await FirebaseFirestore.instance.collection('products').get();
      return querySnapshot.docs.map((doc) => doc.data()).toList();
    } catch (e) {
      debugPrint("Error: $e");
      return [];
    }
  }

  Future<void> updateProduct(String field, dynamic newValue, {String? productField, dynamic productValue}) async {
    try {
      Query query = FirebaseFirestore.instance.collection('products');

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
      Query query = FirebaseFirestore.instance.collection('products');

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

class BannerModel extends ChangeNotifier {
  Future<List<Map<String, dynamic>>> manageBanner() async {
    try {
      final querySnapshot = await FirebaseFirestore.instance.collection('Advertisement').get();
      return querySnapshot.docs.map((doc) => doc.data()).toList();
    } catch (e) {
      log("Error: $e");
      return [];
    }
  }

  Future<void> updateBanner(String field, dynamic newValue, {String? bannerField, dynamic bannerValue}) async {
    try {
      Query query = FirebaseFirestore.instance.collection('Advertisement');

      // Add conditions to your query if any
      if (bannerField != null && bannerValue != null) {
        query = query.where(bannerField, isEqualTo: bannerValue);
      }

      // Get the documents matching the query
      QuerySnapshot querySnapshot = await query.get();
      for (QueryDocumentSnapshot doc in querySnapshot.docs) {
        await doc.reference.update({field: newValue});
      }
    } catch (e) {
      log("Error updating banner: $e");
    }
  }

  Future<void> newupdateBanner(String field, dynamic newValue, {required String bannerId}) async {
    try {
      // Query the collection for the specific banner ID
      QuerySnapshot querySnapshot = await FirebaseFirestore.instance.collection('Advertisement').where('id', isEqualTo: int.parse(bannerId)).get();

      // Update the document(s) that match the query
      for (QueryDocumentSnapshot doc in querySnapshot.docs) {
        await doc.reference.update({field: newValue});
      }
    } catch (e) {
      log("Error updating banner: $e");
    }
  }

  Future<void> deleteBanner(dynamic bannerValue) async {
    try {
      Query query = FirebaseFirestore.instance.collection('Advertisement');

      // Add conditions to your query if any
      if (bannerValue != null) {
        query = query.where(FieldPath(const ['id']), isEqualTo: bannerValue); // Assuming 'catId' is the field name
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

class ValetModel extends ChangeNotifier {
  Future<List<Map<String, dynamic>>> manageOrder() async {
    try {
      final querySnapshot = await FirebaseFirestore.instance.collection('OrderHistory').get();
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

  Future<List<Map<String, dynamic>>> manageValet() async {
    try {
      final querySnapshot = await FirebaseFirestore.instance
          .collection('users')
          .where('type', isEqualTo: 2) // Filter by type == 2
          .get();
      return querySnapshot.docs
          .map((doc) => {
                ...doc.data(),
              })
          .toList();
    } catch (e) {
      log("Error: $e");
      return [];
    }
  }

  Future<void> assignValet(String id, String phone) async {
    try {
      // Fetch the user's name based on the phone number
      String valetName = await getValetName(phone);

      // Get the order document(s) matching the given order ID
      Query query = FirebaseFirestore.instance.collection('OrderHistory').where("orderId", isEqualTo: id);
      QuerySnapshot querySnapshot = await query.get();

      // Update the 'valet' field in the matching order document(s)
      for (QueryDocumentSnapshot doc in querySnapshot.docs) {
        await doc.reference.update({'valetName': valetName, 'valetPhone': phone});
      }
    } catch (e) {
      log("Error updating valet: $e");
    }
  }

  Future<String> getValetName(String phone) async {
    try {
      Query query = FirebaseFirestore.instance.collection('users').where("phone", isEqualTo: phone);
      QuerySnapshot querySnapshot = await query.get();

      // Assuming there is only one user document for the given phone number
      if (querySnapshot.docs.isNotEmpty) {
        DocumentSnapshot userDoc = querySnapshot.docs.first;
        Map<String, dynamic> userData = userDoc.data() as Map<String, dynamic>;
        return userData['name'] as String; // Assuming 'name' field exists
      } else {
        log("No user found with phone number: $phone");
        return '';
      }
    } catch (e) {
      log("Error fetching valet name: $e");
      return '';
    }
  }

  Future<void> updateStatus(String id, int status) async {
    try {
      Query query = FirebaseFirestore.instance.collection('OrderHistory').where("orderId", isEqualTo: id);

      // Get the documents matching the query
      QuerySnapshot querySnapshot = await query.get();
      for (QueryDocumentSnapshot doc in querySnapshot.docs) {
        await doc.reference.update({'status': status});
      }
    } catch (e) {
      log("Error updating status: $e");
    }
  }


}
