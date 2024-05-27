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

  late List<DetailCategory> _detailCategory = [];

  List<Category> get categories => _categories;
  bool get isLoading => _isLoading;

  // categories getter
  Category? get selectedCategory => _selectedCategory;
  SubCategory? get selectedSubCategory => _selectedSubCategory;
  List<DetailCategory> get detailCategories => _detailCategory;

  Future<void> fetchCategories() async {
    _isLoading = true;
    notifyListeners();

    try {
      final QuerySnapshot snapshot =
          await FirebaseFirestore.instance.collection("main_category").get();
      List<Category> loadedCategory = [];

      for (var doc in snapshot.docs) {
        List<SubCategory> subCategories = [];
        final subCategoriesSnapshot =
            await doc.reference.collection("sub_category").get();

        for (var subDoc in subCategoriesSnapshot.docs) {
          // log("Sub-Category Data = ${subDoc.data()}"); // Log the actual data

          subCategories
              .add(SubCategory(image: subDoc['image'], name: subDoc['name']));
        }

        loadedCategory
            .add(Category(name: doc['name'], subCategories: subCategories));
      }
      _categories = loadedCategory;
    } catch (e) {
      log("Categories not fetched: $e");
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> fetchDetailCategories(
      String category, String subCategory) async {
    _isLoading = true;
    notifyListeners();

    log("Fetched Category: $category");
    log("Fetched Sub-Category: $subCategory");

    if (subCategory.isEmpty) {
      _isLoading = false;
      notifyListeners();
      return;
    }

    try {
      // Fetch the main category document based on the provided category name
      final QuerySnapshot mainCategorySnapshot = await FirebaseFirestore
          .instance
          .collection("main_category")
          .where("name", isEqualTo: category)
          .get();

      // Check if any main categories were found
      if (mainCategorySnapshot.docs.isEmpty) {
        log("No matching main categories found.");
        _isLoading = false;
        notifyListeners();
        return;
      }

      List<DetailCategory> loadedDetailCategories = [];

      // Iterate through each matching main category
      for (var mainDoc in mainCategorySnapshot.docs) {
        final subCategoryCollection =
            mainDoc.reference.collection('sub_category');
        final subCategorySnapshot = await subCategoryCollection
            .where("name", isEqualTo: subCategory)
            .get();

        // Check if any sub-categories were found within the main category
        if (subCategorySnapshot.docs.isEmpty) {
          log("No matching sub-categories found within '$category'.");
          continue;
        }

        // Process sub-categories within the current main category
        for (var subDoc in subCategorySnapshot.docs) {
          final detailCategoryCollection =
              subDoc.reference.collection('detail_category');
          final detailCategorySnapshot = await detailCategoryCollection.get();

          // Process detail categories within the current sub-category
          for (var detailDoc in detailCategorySnapshot.docs) {
            final detailCategoryData = detailDoc.data();

            // Extract relevant details
            final String name = detailCategoryData['name'];
            final String image = detailCategoryData['image'];

            // Initialize products if needed
            final List<Product> products = [];

            loadedDetailCategories.add(DetailCategory(
              name: name,
              image: image,
              products: products,
            ));
          }
        }
      }

      _detailCategory = loadedDetailCategories;
      log("Loaded Detail Categories: ${_detailCategory.map((c) => c.name).toList()}");
    } catch (e) {
      log("Detail Categories not fetched: $e");
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

  void selectSubCategory(SubCategory subCategory) async {
    _selectedSubCategory = subCategory;
    log("Selected Sub-Category: ${_selectedSubCategory.toString()}");
    if (_selectedCategory != null && _selectedSubCategory != null) {
      await fetchDetailCategories(_selectedCategory!.name, subCategory.name);
    }
  }
}
