import 'dart:developer';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import '../models/category_model.dart';

class CategoryProvider with ChangeNotifier {
  List<Category> _categories = [];
  bool _isLoading = false;

  // these are gonna be used in product provider
  Category? _selectedCategory;
  SubCategory? _selectedSubCategory;

  List<Category> get categories => _categories;
  bool get isLoading => _isLoading;

  // categories getter
  Category? get selectedCategory => _selectedCategory;
  SubCategory? get selectedSubCategory => _selectedSubCategory;

  Future<void> fetchCategories() async {
    _isLoading = true;
    notifyListeners();

    try {
      final QuerySnapshot snapshot =
          await FirebaseFirestore.instance.collection("category").get();
      List<Category> loadedCategory = [];

      for (var doc in snapshot.docs) {
        List<SubCategory> subCategories = [];
        final subCategoriesSnapshot =
            await doc.reference.collection("sub-category").get();

        for (var subDoc in subCategoriesSnapshot.docs) {
          // log("Sub-Category Data = ${subDoc.data()}"); // Log the actual data

          subCategories.add(SubCategory(
              image: subDoc['image'], name: subDoc['sub_category_name']));
        }

        loadedCategory.add(
            Category(name: doc['category_name'], subCategories: subCategories));
      }
      _categories = loadedCategory;

      // log("Categories = ${_categories.map((c) => c.name).toList()}"); // Log category names for clarity
    } catch (e) {
      log("Categories not fetched: $e");
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  void selectCategory(Category category) {
    _selectedCategory = category;
    _selectedSubCategory = null;
    log("Selected Category: ${_selectedCategory.toString()}");
    notifyListeners();
  }

  void selectSubCategory(SubCategory subCategory) {
    _selectedSubCategory = subCategory;
    log("Selected Sub-Category: ${_selectedSubCategory.toString()}");
    notifyListeners();
  }
}
