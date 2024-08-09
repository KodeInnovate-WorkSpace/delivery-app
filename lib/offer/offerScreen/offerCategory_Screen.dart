import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:speedy_delivery/widget/cart_button.dart';
import '../../models/product_model.dart';
import '../../shared/showProductImage.dart';
import '../../widget/add_to_cart_button.dart';
import '../../widget/network_handler.dart';

class OfferCategoryScreen extends StatelessWidget {
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
  Widget build(BuildContext context) {
    return NetworkHandler(
      child: Stack(
        children: [
          Scaffold(
            appBar: AppBar(
              title: Text(
                categoryTitle,
              ),
              backgroundColor: const Color(0xfff7f7f7),
              surfaceTintColor: Colors.transparent,
            ),
            body: StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance.collection("offerProduct").where('categoryId', isEqualTo: categoryID).snapshots(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }
                if (snapshot.hasError) {
                  return Center(child: Text('Error: ${snapshot.error}'));
                }
                if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                  return const Center(child: Text('No Products Found!'));
                }

                final products = snapshot.data!.docs
                    .map((doc) {
                      final data = doc.data() as Map<String, dynamic>;
                      return Product(
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
                        isOfferProduct: data['isOfferProduct'] ?? false,
                      );
                    })
                    .where((product) => product.status == 1)
                    .toList();

                return GridView.builder(
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    childAspectRatio: 0.75, // Adjust aspect ratio as needed
                    mainAxisSpacing: 10, // Spacing between rows
                    crossAxisSpacing: 10, // Spacing between columns
                  ),
                  itemCount: products.length,
                  itemBuilder: (context, index) {
                    final product = products[index];
                    return Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(
                            color: Colors.grey.shade100,
                            width: 1,
                          ),
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Image
                            GestureDetector(
                              onTap: () {
                                showProductImage(context, product.image);
                              },
                              child: Container(
                                decoration: const BoxDecoration(
                                  borderRadius: BorderRadius.only(
                                    topLeft: Radius.circular(10),
                                    topRight: Radius.circular(10),
                                  ),
                                ),
                                width: double.infinity,
                                height: 100,
                                child: CachedNetworkImage(
                                  imageUrl: product.image,
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 10),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  // Product Name
                                  Text(
                                    product.name,
                                    style: const TextStyle(
                                      color: Colors.black,
                                      fontFamily: 'Gilroy-ExtraBold',
                                    ),
                                  ),
                                  // Product weight
                                  Text(
                                    product.unit,
                                    style: TextStyle(
                                      color: Colors.grey.shade400,
                                      fontSize: 12,
                                      fontFamily: 'Gilroy-Bold',
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(
                              height: 50,
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                children: [
                                  Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      // Product price
                                      Text(
                                        "Rs. ${product.price.toString()}",
                                        style: const TextStyle(
                                          color: Colors.black,
                                          fontFamily: "Gilroy-ExtraBold",
                                        ),
                                      ),
                                      // Product MRP
                                      Text(
                                        "Rs. ${product.mrp.toString()}",
                                        style: TextStyle(
                                          color: Colors.grey.shade400,
                                          fontSize: 12,
                                          fontFamily: 'Gilroy-Bold',
                                          decoration: TextDecoration.lineThrough,
                                        ),
                                      ),
                                    ],
                                  ),
                                  // Add button
                                  AddToCartButton(
                                    productName: product.name,
                                    productPrice: product.price,
                                    productImage: product.image,
                                    productUnit: product.unit,
                                    isOfferProduct: product.isOfferProduct,
                                    catName: categoryTitle,
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                );
              },
            ),
          ),
          const Positioned(
            right: 20.0,
            bottom: 25.0,
            child: CartButton(),
          ),
        ],
      ),
    );
  }
}
