// import 'dart:developer';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:flutter/material.dart';
// import '../models/category_model.dart';
// import '../models/product_model.dart';
//
// class CategoryProvider with ChangeNotifier {
//   final List<Category> categories = [];
//   final List<SubCategory> subCategories = [];
//   late Future<void> fetchDataFuture;
//
//   // products
//   List<Product> products = [];
//
//   Future<void> fetchCategory() async {
//     try {
//       final snapshot =
//           await FirebaseFirestore.instance.collection("category").get();
//
//       if (snapshot.docs.isNotEmpty) {
//         categories.clear();
//         for (var doc in snapshot.docs) {
//           final data = doc.data();
//           final category = Category(
//             id: data['category_id'],
//             name: data['category_name'],
//           );
//           categories.add(category);
//           // log("Category: \n ID: ${category.id} | Name: ${category.name}");
//         }
//       } else {
//         log("No Category Document Found!");
//       }
//     } catch (e) {
//       log("Error fetching category: $e");
//     }
//   }
//
//   Future<void> fetchSubCategory() async {
//     try {
//       final subSnapshot =
//           await FirebaseFirestore.instance.collection("sub_category").get();
//
//       if (subSnapshot.docs.isNotEmpty) {
//         subCategories.clear();
//         for (var doc in subSnapshot.docs) {
//           final data = doc.data();
//           final subCategory = SubCategory(
//             id: data['sub_category_id'],
//             name: data['sub_category_name'],
//             img: data['sub_category_img'],
//             catId: data['category_id'],
//           );
//           subCategories.add(subCategory);
//           // fetchProducts();
//           // log("Sub-Category \n ID: ${subCategory.id} | Name: ${subCategory.name} | Cat Id: ${subCategory.catId}");
//         }
//       } else {
//         log("No Sub-Category Document Found!");
//       }
//     } catch (e) {
//       log("Error fetching sub-category: $e");
//     }
//   }
//
//   Future<void> fetchProducts(int subCategoryId) async {
//     try {
//       final productSnap =
//           await FirebaseFirestore.instance.collection("products").get();
//
//       if (productSnap.docs.isNotEmpty) {
//         products.clear();
//         for (var doc in productSnap.docs) {
//           final data = doc.data();
//           final product = Product(
//             id: data['id'] ?? 0,
//             name: data['name'] ?? '',
//             image: data['image'] ?? '',
//             unit: data['unit'] ?? 0,
//             price: data['price'] ?? 0,
//             stock: data['stock'] ?? 0,
//             subCatId: data['sub_category_id'] ?? 0,
//           );
//           products.add(product);
//         }
//         products = products.where((x) => x.subCatId == subCategoryId).toList();
//         log("Products: ${products.map((p) => p.name)}");
//       } else {
//         log("No Products Document Found!");
//       }
//     } catch (e) {
//       log("Error fetching products: $e");
//     }
//   }
// }
