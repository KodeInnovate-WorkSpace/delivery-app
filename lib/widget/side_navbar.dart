import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/category_model.dart';
import '../providers/category_provider.dart';

Widget sideNavbar(BuildContext context) {
  final categories = Provider.of<CategoryProvider>(context);

  return SingleChildScrollView(
    child: Container(
      width: MediaQuery.of(context).size.width / 5,
      decoration: const BoxDecoration(
        color: Colors.white,
      ),
      child: Column(
        children: [
          const SizedBox(height: 20),
          categories.isLoading
              ? const Center(child: CircularProgressIndicator())
              : (categories.categories.isEmpty)
                  ? const Center(child: Text("No categories available"))
                  : ListView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount:
                          getAllSubcategories(categories.categories).length,
                      itemBuilder: (context, index) {
                        final subCategory =
                            getAllSubcategories(categories.categories)[index];
                        return subCategoryInfo(subCategory);
                      },
                    ),
        ],
      ),
    ),
  );
}

Widget subCategoryInfo(SubCategory subCategory) {
  return Padding(
    padding: const EdgeInsets.all(8.0),
    child: Column(
      children: [
        ClipOval(
          child: Container(
            color: Colors.grey[100], // Background color
            height: 60, // Adjust as per your requirement
            width: 60, // Adjust as per your requirement
            child: Image.network(
                subCategory.image) // Assuming first sub-category image
            , // Handle empty sub-category case (optional)
          ),
        ),
        Text(
          subCategory.name,
          textAlign: TextAlign.center,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
      ],
    ),
  );
}

List<SubCategory> getAllSubcategories(List<Category> categories) {
  List<SubCategory> subCategories = [];
  for (var category in categories) {
    subCategories.addAll(category.subCategories);
  }
  return subCategories;
}
