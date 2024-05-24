import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:speedy_delivery/screens/categories_screen.dart';
import '../providers/category_provider.dart';

class CategoryWidget extends StatelessWidget {
  const CategoryWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<CategoryProvider>(
      builder: (context, categoryProvider, child) {
        if (categoryProvider.isLoading) {
          return const Center(child: CircularProgressIndicator());
        }

        if (categoryProvider.categories.isEmpty) {
          return const Center(child: Text("No categories available"));
        }
        return ListView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: categoryProvider.categories.length,
          itemBuilder: (context, index) {
            final category = categoryProvider.categories[index];
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    category.name,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                GridView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: category.subCategories.length,
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 4,
                    childAspectRatio: 0.59,
                  ),
                  itemBuilder: (context, subIndex) {
                    final subCategory = category.subCategories[subIndex];
                    return Column(
                      children: [
                        GestureDetector(
                          onTap: () {


                            log("Sub-Category Name: ${category.subCategories[subIndex].name.toLowerCase()}");

                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => CategoryScreen(
                                        // categoryTitle: category.subCategories[subIndex].name // displays sub-category name
                                        categoryTitle: category.name,
                                        subCategories: category.subCategories,
                                        // displays category name
                                      )),
                            );
                          },
                          child: Container(
                            margin: const EdgeInsets.symmetric(horizontal: 3),
                            decoration: const BoxDecoration(
                              color: Color(0xffeaf1fc),
                              borderRadius:
                                  BorderRadius.all(Radius.circular(10)),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Image.network(
                                subCategory.image,
                                width: 70,
                                height: 70,
                                fit: BoxFit.contain,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 10),
                        Text(
                          subCategory.name,
                          textAlign: TextAlign.center,
                          style: const TextStyle(fontSize: 12),
                        ),
                      ],
                    );
                  },
                ),
              ],
            );
          },
        );
      },
    );
  }
}
