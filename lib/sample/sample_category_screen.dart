import 'dart:developer';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:speedy_delivery/sample/model.dart';
import '../screens/checkout_screen.dart';
import '../widget/add_to_cart_button.dart';

class SampleCategoryScreen extends StatefulWidget {
  final double imageWidth;
  final double imageHeight;
  final String categoryTitle;
  final List<SubCategory> subCategories;

  const SampleCategoryScreen({
    super.key,
    required this.categoryTitle,
    required this.subCategories,
    this.imageWidth = 90.0,
    this.imageHeight = 90.0,
  });

  @override
  SampleCategoryScreenState createState() => SampleCategoryScreenState();
}

class SampleCategoryScreenState extends State<SampleCategoryScreen> {
  List<Product> products = [];

  @override
  void initState() {
    super.initState();
    // Fetch products for the first sub-category by default
    if (widget.subCategories.isNotEmpty) {
      fetchProducts(widget.subCategories.first.id);
    }
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
        title: Text(widget.categoryTitle),
      ),
      body: Stack(
        children: [
          Row(
            children: [
              // Side navbar displaying sub-categories
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

              // Products list
              Expanded(
                child: Container(
                  color: Colors.grey[100],
                  child: products.isEmpty
                      ? Center(
                          child: Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Image.asset(
                                  'images/assets/empty.png',
                                  width: 800,
                                  height: 800,
                                ),
                                const SizedBox(height: 20),
                              ],
                            ),
                          ),
                        )
                      : GridView.builder(
                          itemCount: products.length,
                          gridDelegate:
                              const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2,
                            mainAxisSpacing: 5.0,
                            crossAxisSpacing: 5.0,
                            childAspectRatio: 0.58,
                          ),
                          itemBuilder: (context, index) {
                            final product = products[index];
                            return GestureDetector(
                              onTap: () {},
                              child: Card(
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(6.0),
                                ),
                                color: Colors.white,
                                elevation: 1.6,
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Center(
                                        child: CachedNetworkImage(
                                          imageUrl: product.image,
                                          width: 90,
                                          fit: BoxFit.contain,
                                          errorWidget: (context, url, error) =>
                                              const Icon(Icons.error),
                                        ),
                                      ),
                                      const SizedBox(height: 15),
                                      // item name
                                      Text(
                                        product.name,
                                        textAlign: TextAlign.left,
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                        style: const TextStyle(
                                          fontFamily: 'Gilroy-SemiBold',
                                        ),
                                      ),
                                      Text(
                                        product.unit.toString(),
                                        style: const TextStyle(
                                          color: Colors.grey,
                                        ),
                                      ),
                                      const SizedBox(height: 10),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text(
                                            "\u20B9 ${product.price}",
                                            style: const TextStyle(
                                              fontFamily: "Gilroy-medium",
                                            ),
                                          ),
                                          AddToCartButton(
                                            productName: product.name,
                                            productPrice: product.price,
                                            productImage: product.image,
                                            productUnit: product.unit,
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            );
                          },
                        ),
                ),
              ),
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
