import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

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

        return GridView.count(
          shrinkWrap: true,
          crossAxisCount:
              3, // Adjust this to set how many items you want per row
          childAspectRatio: 0.7, // Adjust this as needed for a better fit
          physics:
              const NeverScrollableScrollPhysics(), // Prevent grid from scrolling independently
          children: categoryProvider.categories.expand((category) {
            return category.subCategories.map((subCategory) {
              return Column(
                children: [
                  Card(
                    margin: const EdgeInsets.all(8.0),
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Image.network(
                        subCategory.image,
                        width: 70, // Adjust these sizes as needed
                        height: 70,
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  const SizedBox(height: 5),
                  Text(
                    subCategory.name,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                        fontSize: 12), // Adjust text size as needed
                  ),
                ],
              );
            }).toList();
          }).toList(),
        );
      },
    );
  }
}

/*

return ListView.builder(
          shrinkWrap: true,
          physics: NeverScrollableScrollPhysics(),
          itemCount: categoryProvider.categories.length,
          itemBuilder: (context, index) {
            final category = categoryProvider.categories[index];
            return ExpansionTile(
              title: Text(category.name),
              children: category.subCategories.map((subCategory) {
                return ListTile(
                  leading: Image.network(
                    subCategory.image,
                    fit: BoxFit.cover,
                    height: 50,
                    width: 50,
                  ),
                  title: Text(subCategory.name),
                );
              }).toList(),
            );
          },
        );

*/
