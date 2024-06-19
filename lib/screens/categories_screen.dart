import 'dart:developer';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:badges/badges.dart' as badges;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:speedy_delivery/screens/checkout_screen.dart';
import 'package:speedy_delivery/widget/product_card.dart';
import '../models/category_model.dart';
import '../models/product_model.dart';
import '../providers/cart_provider.dart';
import '../widget/sidebar.dart';
import '../widget/network_handler.dart'; // Import NetworkHandler

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
              unit: data['unit'] ?? '0',
              price: data['price'] ?? 0,
              stock: data['stock'] ?? 0,
              subCatId: data['sub_category_id'] ?? 0,
              status: data['status'],
            );

            if (product.status == 1) {
              products.add(product);
            }
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
    return NetworkHandler(
      child: Scaffold(
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
                sidebar(context, widget.subCategories, fetchProducts,
                    selectedSubCategoryId, (id) {
                  setState(() {
                    selectedSubCategoryId = id;
                    fetchProducts(id);
                  });
                }),
                ProductCard(
                  productList: products,
                ),
              ],
            ),
            Positioned(
              bottom: 55,
              right: 20,
              child: Consumer<CartProvider>(
                builder: (context, cartProvider, child) {
                  int itemCount = cartProvider.totalItemsCount(); // Assuming this method exists in CartProvider
                  return badges.Badge(
                    badgeContent: Text(
                      itemCount.toString(),
                      style: const TextStyle(color: Colors.white),
                    ),
                    position: badges.BadgePosition.topEnd(top: 0, end: 0),
                    badgeStyle: const badges.BadgeStyle(
                        badgeColor: Colors.red
                    ),
                    child: FloatingActionButton(
                      hoverColor: Colors.transparent,
                      elevation: 2,
                      onPressed: () {
                        HapticFeedback.vibrate();
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => const CheckoutScreen()),
                        );
                        // Navigator.pushNamed(context, '/checkout');
                      },
                      backgroundColor: Colors.white,
                      child: const Icon(
                        Icons.shopping_cart_sharp,
                        color: Colors.black,
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
