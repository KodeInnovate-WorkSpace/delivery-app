import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:speedy_delivery/providers/category_provider.dart';
import 'package:speedy_delivery/screens/demo_screen.dart';

import '../models/category_model.dart';
import '../widget/product_card.dart';
import '../widget/side_navbar.dart';

class CategoryScreen extends StatefulWidget {
  final double imageWidth;
  final double imageHeight;
  final String categoryTitle;
  final List<SubCategory> subCategories;
  const CategoryScreen(
      {super.key,
      required this.categoryTitle,
      required this.subCategories,
      this.imageWidth = 90.0,
      this.imageHeight = 90.0});

  @override
  CategoryScreenState createState() => CategoryScreenState();
}

class CategoryScreenState extends State<CategoryScreen> {
  @override
  Widget build(BuildContext context) {
    final categoryProvider =
        Provider.of<CategoryProvider>(context, listen: true);

    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.categoryTitle,
        ),
      ),
      body: Row(
        children: [
          // side navbar
          sideNavbar(context),

          // products list
          Expanded(
            child: Container(
              color: Colors.grey[100],
              child: GridView.builder(
                itemCount: categoryProvider.categories.length,
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2, // Number of items per row
                  mainAxisSpacing: 5.0, // Spacing between rows
                  crossAxisSpacing: 5.0, // Spacing between columns
                  childAspectRatio: 0.58,
                ),
                itemBuilder: (context, index) {
                  // final item = categoryProvider.selectedSubCategory?.name[index];
                  return GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) =>
                                const DemoPage()), // Update with your actual page
                      );
                    },
                    child: const ProductCard(),
                  );
                },
              ),
            ),
          )
        ],
      ),
    );
  }
}
