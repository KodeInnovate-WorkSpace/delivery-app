import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/category_model.dart';
import '../providers/category_provider.dart';
import '../shared/capitalise.dart';
import '../widget/product_card.dart';
import '../widget/side_navbar.dart';

class CategoryScreen extends StatefulWidget {
  final double imageWidth;
  final double imageHeight;
  final String categoryTitle;
  final List<SubCategory> subCategories;

  const CategoryScreen({
    super.key,
    required this.categoryTitle,
    required this.subCategories,
    this.imageWidth = 90.0,
    this.imageHeight = 90.0,
  });

  @override
  CategoryScreenState createState() => CategoryScreenState();
}

class CategoryScreenState extends State<CategoryScreen> {
  late Future<void> _productsFuture;

  @override
  void initState() {
    super.initState();
    _productsFuture = _fetchInitialProducts();
  }

  Future<void> _fetchInitialProducts() async {
    final categoryProvider =
        Provider.of<CategoryProvider>(context, listen: false);
    final selectedCategory = categoryProvider.selectedCategory;
    final selectedSubCategory = categoryProvider.selectedSubCategory;

    if (selectedCategory != null && selectedSubCategory != null) {
      await categoryProvider.fetchDetailCategories(
        selectedCategory.name,
        selectedSubCategory.name,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final categoryProvider = Provider.of<CategoryProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(toSentenceCase(widget.categoryTitle)),
      ),
      body: Row(
        children: [
          // side navbar
          sideNavbar(context),

          // products list
          Expanded(
            child: Container(
              color: Colors.grey[100],
              child: FutureBuilder(
                future: _productsFuture,
                builder: (ctx, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  } else if (snapshot.hasError) {
                    return Center(child: Text('Error: ${snapshot.error}'));
                  } else {
                    return Consumer<CategoryProvider>(
                      builder: (ctx, categoryProvider, _) {
                        final products = categoryProvider.products;
                        return GridView.builder(
                          itemCount: products.length,
                          gridDelegate:
                              const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2, // Number of items per row
                            mainAxisSpacing: 5.0, // Spacing between rows
                            crossAxisSpacing: 5.0, // Spacing between columns
                            childAspectRatio: 0.58,
                          ),
                          itemBuilder: (context, index) {
                            final product = products[index];
                            return ProductCard(
                              imageUrl: product.image,
                              productName: product.name,
                              productWeight: product.unit,
                              productPrice: product.price.toString(),
                            );
                          },
                        );
                      },
                    );
                  }
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}
