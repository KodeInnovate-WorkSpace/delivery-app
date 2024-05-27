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

  // products
  List<Product> _products = [];
  List<Product> get products => _products;

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
      String myCategory, String mySubCategory) async {
    _isLoading = true;
    notifyListeners();

    log("Fetched Category: $myCategory");
    log("Fetched Sub-Category: $mySubCategory");

    if (mySubCategory.isEmpty) {
      _isLoading = false;
      notifyListeners();
      return;
    }

    try {
      // Fetch the main category document based on the provided category name
      final QuerySnapshot mainCategorySnapshot = await FirebaseFirestore
          .instance
          .collection("main_category")
          .where("name", isEqualTo: myCategory)
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
            .where("name", isEqualTo: mySubCategory)
            .get();

        // Check if any sub-categories were found within the main category
        if (subCategorySnapshot.docs.isEmpty) {
          log("No matching sub-categories found within '$myCategory'.");
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

      fetchProducts(
          myCategory, mySubCategory, _detailCategory.map((c) => c.name).first);
    } catch (e) {
      log("Detail Categories not fetched: $e");
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> fetchProducts(
      String category, String subCategory, String detailCategory) async {
    _isLoading = true;
    notifyListeners();

    log("fetchProducts: category = $category, sub-category = $subCategory, detail-category = $detailCategory");

    try {
      // Fetch the main category document based on the provided category name
      final QuerySnapshot mainCategorySnapshot = await FirebaseFirestore.instance
          .collection("main_category")
          .where("name", isEqualTo: category)
          .get();

      if (mainCategorySnapshot.docs.isEmpty) {
        log("No matching main category found for $category");
        _isLoading = false;
        notifyListeners();
        return;
      }

      // Assuming you have only one document for the main category name
      final mainCategoryDoc = mainCategorySnapshot.docs.first;

      final subCategoryCollection = mainCategoryDoc.reference.collection('sub_category');
      final subCategorySnapshot = await subCategoryCollection
          .where("name", isEqualTo: subCategory)
          .get();

      if (subCategorySnapshot.docs.isEmpty) {
        log("No matching sub-category found within '$category' for sub-category '$subCategory'.");
        _isLoading = false;
        notifyListeners();
        return;
      }

      // Assuming you have only one document for the sub-category name
      final subCategoryDoc = subCategorySnapshot.docs.first;

      final detailCategoryCollection = subCategoryDoc.reference.collection('detail_category');
      final detailCategorySnapshot = await detailCategoryCollection
          .where("name", isEqualTo: detailCategory)
          .get();

      if (detailCategorySnapshot.docs.isEmpty) {
        log("No matching detail category found within '$subCategory' for detail-category '$detailCategory'.");
        _isLoading = false;
        notifyListeners();
        return;
      }

      // Assuming you have only one document for the detail category name
      final detailCategoryDoc = detailCategorySnapshot.docs.first;

      final productCollection = detailCategoryDoc.reference.collection('products');
      final QuerySnapshot productSnapshot = await productCollection.get();

      if (productSnapshot.docs.isEmpty) {
        log("No products found in '$detailCategory'.");
      } else {
        log("Products found: ${productSnapshot.docs.length}");
      }

      List<Product> loadedProducts = [];

      for (var productDoc in productSnapshot.docs) {
        log("Product Data: ${productDoc.data()}");

        loadedProducts.add(Product(
          name: productDoc['name'],
          price: productDoc['price'],
          image: productDoc['image'],
          stock: productDoc['stock'],
          unit: productDoc['unit'],
        ));
      }

      _products = loadedProducts;
      log("Loaded Products: ${_products.map((p) => p.name).toList()}");
    } catch (e) {
      log("Failed to fetch products: $e");
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
