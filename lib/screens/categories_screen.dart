import 'dart:developer';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import 'package:speedy_delivery/screens/checkout_screen.dart';
import 'package:speedy_delivery/widget/product_card.dart';

import '../models/category_model.dart';
import '../models/product_model.dart';
import '../widget/add_to_cart_button.dart';

class CategoryScreen extends StatefulWidget {
  final double imageWidth;
  final double imageHeight;
  final String categoryTitle;
  final List<SubCategory> subCategories;
  final int selectedSubCategoryId;

  const CategoryScreen({
    super.key,
    required this.categoryTitle,
    required this.subCategories,
    this.imageWidth = 90.0,
    this.imageHeight = 90.0,
    required this.selectedSubCategoryId,
  });

  @override
  CategoryScreenState createState() => CategoryScreenState();
}

class CategoryScreenState extends State<CategoryScreen> {
  List<Product> products = [];
  int? selectedSubCategoryId;

  @override
  void initState() {
    super.initState();
    selectedSubCategoryId = widget.selectedSubCategoryId;
    fetchProducts(selectedSubCategoryId!);
  }

  Future<void> fetchProducts(int subCategoryId) async {
    try {
      final productSnap =
          await FirebaseFirestore.instance.collection("products").get();

      if (productSnap.docs.isNotEmpty) {
        setState(() {
          products.clear();
          for (var doc in productSnap.docs) {
            final data = doc.data();
            final product = Product(
              id: data['id'] ?? 0,
              name: data['name'] ?? '',
              image: data['image'] ?? '',
              unit: data['unit'] ?? 0,
              price: data['price'] ?? 0,
              stock: data['stock'] ?? 0,
              subCatId: data['sub_category_id'] ?? 0,
            );
            products.add(product);
          }
          products =
              products.where((x) => x.subCatId == subCategoryId).toList();
          log("Products: ${products.map((p) => p.name)}");
        });
      } else {
        log("No Products Document Found!");
      }
    } catch (e) {
      log("Error fetching products: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.categoryTitle,
        ),
      ),
      body: Stack(
        children: [
          Row(
            children: [
              // Side navbar
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Container(
                  width: MediaQuery.of(context).size.width / 5,
                  color: Colors.white,
                  child: GestureDetector(
                    child: ListView.builder(
                      itemCount: widget.subCategories.length,
                      itemBuilder: (context, index) {
                        final subCategory = widget.subCategories[index];
                        return GestureDetector(
                          onTap: () {
                            fetchProducts(subCategory.id);
                          },
                          child: Column(
                            children: [
                              const SizedBox(height: 20),
                              ClipOval(
                                child: Container(
                                  color: const Color(0xffeaf1fc),
                                  height: 60,
                                  width: 60,
                                  child: CachedNetworkImage(
                                    fit: BoxFit.contain,
                                    imageUrl: subCategory.img,
                                    placeholder: (context, url) =>
                                        const CircularProgressIndicator(
                                      color: Colors.amberAccent,
                                    ),
                                    errorWidget: (context, url, error) =>
                                        const Icon(Icons.error),
                                  ),
                                ),
                              ),
                              Text(
                                subCategory.name,
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  fontSize: 11,
                                  fontFamily: 'Gilroy-Medium',
                                  color: Colors.grey[600],
                                ),
                              ),
                            ],
                          ),
                        );
                      },
                    ),
                  ),
                ),
              ),

              ProductCard(productList: products),
            ],
          ),
          Positioned(
            bottom: 25,
            right: 20,
            child: FloatingActionButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const CheckoutScreen(),
                  ),
                );
              },
              backgroundColor: Colors.white,
              child: const Icon(Icons.shopping_cart_sharp),
            ),
          ),
        ],
      ),
    );
  }
}
