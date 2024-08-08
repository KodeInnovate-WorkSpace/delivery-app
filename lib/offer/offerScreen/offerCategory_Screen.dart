import 'dart:developer';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:speedy_delivery/widget/cart_button.dart';

import '../../models/product_model.dart';
import '../../widget/network_handler.dart';
import '../offerWidget/offerProductCard.dart';

class OfferCategoryScreen extends StatefulWidget {
  final double imageWidth;
  final double imageHeight;
  final String categoryTitle;
  final int categoryID;

  const OfferCategoryScreen({
    super.key,
    required this.categoryTitle,
    this.imageWidth = 90.0,
    this.imageHeight = 90.0,
    required this.categoryID,
  });

  @override
  OfferCategoryScreenState createState() => OfferCategoryScreenState();
}

class OfferCategoryScreenState extends State<OfferCategoryScreen> {
  List<Product> products = [];

  @override
  void initState() {
    super.initState();

    fetchProducts();
  }

  Future<void> fetchProducts() async {
    try {
      final productSnap = await FirebaseFirestore.instance.collection("product2").where('categoryId', isEqualTo: widget.categoryID).get();

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
              mrp: data['mrp'] ?? 0,
              stock: data['stock'] ?? 0,
              subCatId: data['sub_category_id'] ?? 0,
              status: data['status'],
              isVeg: data['isVeg'] ?? false,
            );

            if (product.status == 1) {
              products.add(product);
            }
          }
          // products = products.where((x) => x.subCatId == subCategoryId).toList();
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
          backgroundColor: const Color(0xfff7f7f7),
          // elevation: 0,
          surfaceTintColor: Colors.transparent,
        ),
        body: Stack(
          children: [
            Row(
              children: [
                Expanded(
                  // child: ProductCard(
                  //   productList: products,
                  // ),
                  child: offerProductCard(widget.categoryID, widget.categoryTitle),
                ),
              ],
            ),
            const CartButton(),
          ],
        ),
      ),
    );
  }
}
