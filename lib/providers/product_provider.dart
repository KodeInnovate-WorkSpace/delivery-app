// import 'dart:developer';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:flutter/material.dart';
// import '../models/product_model.dart';
//
// class ProductProvider with ChangeNotifier {
//   List<Product> _products = [];
//   bool _isLoading = false;
//
//   List<Product> get products => _products;
//   bool get isLoading => _isLoading;
//
//   Future<void> fetchProducts(BuildContext context) async {
//     _isLoading = true;
//     notifyListeners();
//
//     try {
//       final productDoc = await FirebaseFirestore.instance
//           .collection('product')
//           .where('sub_category', isEqualTo: 'Vegetables & Fruits')
//           .get();
//
//       List<Product> loadedProducts = [];
//
//       for (var doc in productDoc.docs) {
//         log("Products Data = ${doc.data()}");
//         loadedProducts.add(Product(
//             image: doc['image'],
//             name: doc['name'],
//             unit: doc['unit'],
//             price: doc['price'],
//             stock: doc['stock'],
//             id: doc['id'],
//             subCatId: doc['sub_category_id']));
//       }
//
//       _products = loadedProducts;
//       log("Products Name = ${_products.map((p) => p.name).toList()}");
//     } catch (e) {
//       log("Products not fetched: $e");
//     } finally {
//       _isLoading = false;
//       notifyListeners();
//     }
//   }
// }