import 'dart:developer';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:speedy_delivery/screens/categories_screen.dart';
import 'package:speedy_delivery/screens/profile_screen.dart';
import '../models/category_model.dart';
import '../models/product_model.dart';
import '../shared/search_bar.dart';
import '../widget/location_button_widget.dart';
import 'checkout_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  HomeScreenState createState() => HomeScreenState();
}

class HomeScreenState extends State<HomeScreen> {
  final List<Category> categories = [];
  final List<SubCategory> subCategories = [];
  late Future<void> fetchDataFuture;

  // products
  List<Product> products = [];

  @override
  void initState() {
    super.initState();
    fetchDataFuture = fetchData();
  }

  Future<void> fetchData() async {
    await fetchCategory();
    await fetchSubCategory();
  }

  Future<void> fetchCategory() async {
    try {
      final snapshot =
          await FirebaseFirestore.instance.collection("category").get();

      if (snapshot.docs.isNotEmpty) {
        setState(() {
          categories.clear();
          for (var doc in snapshot.docs) {
            final data = doc.data();
            final category = Category(
              id: data['category_id'],
              name: data['category_name'],
            );
            categories.add(category);
            // log("Category: \n ID: ${category.id} | Name: ${category.name}");
          }
        });
      } else {
        log("No Category Document Found!");
      }
    } catch (e) {
      log("Error fetching category: $e");
    }
  }

  Future<void> fetchSubCategory() async {
    try {
      final subSnapshot =
          await FirebaseFirestore.instance.collection("sub_category").get();

      if (subSnapshot.docs.isNotEmpty) {
        setState(() {
          subCategories.clear();
          for (var doc in subSnapshot.docs) {
            final data = doc.data();
            final subCategory = SubCategory(
              id: data['sub_category_id'],
              name: data['sub_category_name'],
              img: data['sub_category_img'],
              catId: data['category_id'],
            );
            subCategories.add(subCategory);
            // fetchProducts();
            // log("Sub-Category \n ID: ${subCategory.id} | Name: ${subCategory.name} | Cat Id: ${subCategory.catId}");
          }
        });
      } else {
        log("No Sub-Category Document Found!");
      }
    } catch (e) {
      log("Error fetching sub-category: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 30),
            child: Column(
              children: [
                // Head Section
                Row(
                  children: [
                    const Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(height: 20), // Add SizedBox for spacing
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Delivery in ',
                              style: TextStyle(
                                  fontFamily: 'Gilroy-ExtraBold',
                                  color: Colors.black,
                                  fontSize: 12),
                            ),
                            Text(
                              '7 minutes',
                              style: TextStyle(
                                  fontFamily: 'Gilroy-Black',
                                  color: Colors.black,
                                  fontSize: 28),
                            ),
                            LocationButton(),
                            SizedBox(
                              height: 18,
                            ),
                          ],
                        ),
                        // Location Button
                      ],
                    ),
                    const SizedBox(
                      width: 90,
                    ),
                    GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const ProfilePage()),
                        );
                      },
                      child: Image.asset(
                        "assets/images/profile_photo.png",
                        width: 40,
                      ),
                    ),
                  ],
                ),
                // Search bar
                searchBar(context),
                // body
                // Expanded(
                //   child: SingleChildScrollView(
                //     child: Column(
                //       children: [
                //         const SizedBox(height: 20),
                //
                //         // categories grid
                //         FutureBuilder<void>(
                //           future: fetchDataFuture,
                //           builder: (context, snapshot) {
                //             if (snapshot.connectionState ==
                //                 ConnectionState.waiting) {
                //               return const Center(
                //                 child: CircularProgressIndicator(),
                //               );
                //             } else if (snapshot.hasError) {
                //               return const Center(
                //                 child: Text("Error"),
                //               );
                //             } else {
                //               return ListView.builder(
                //                 shrinkWrap: true,
                //                 physics: const NeverScrollableScrollPhysics(),
                //                 itemCount: categories.length,
                //                 itemBuilder: (context, index) {
                //                   final category = categories[index];
                //                   final filteredSubCategories = subCategories
                //                       .where((subCategory) =>
                //                           subCategory.catId == category.id)
                //                       .toList();
                //
                //                   return Column(
                //                     crossAxisAlignment:
                //                         CrossAxisAlignment.start,
                //                     children: [
                //                       Padding(
                //                         padding: const EdgeInsets.all(8.0),
                //                         child: Text(
                //                           category.name,
                //                           style: const TextStyle(
                //                             fontSize: 18,
                //                             fontWeight: FontWeight.bold,
                //                           ),
                //                         ),
                //                       ),
                //                       GridView.builder(
                //                         shrinkWrap: true,
                //                         physics:
                //                             const NeverScrollableScrollPhysics(),
                //                         itemCount: filteredSubCategories.length,
                //                         gridDelegate:
                //                             const SliverGridDelegateWithFixedCrossAxisCount(
                //                           crossAxisCount: 4,
                //                           childAspectRatio: 0.59,
                //                         ),
                //                         itemBuilder: (context, subIndex) {
                //                           final subCategory =
                //                               filteredSubCategories[subIndex];
                //                           return Column(
                //                             children: [
                //                               GestureDetector(
                //                                 onTap: () {
                //                                   Navigator.push(
                //                                     context,
                //                                     MaterialPageRoute(
                //                                       builder: (context) =>
                //                                           CategoryScreen(
                //                                         categoryTitle:
                //                                             category.name,
                //                                         subCategories:
                //                                             filteredSubCategories,
                //                                       ),
                //                                     ),
                //                                   );
                //                                 },
                //                                 child: Container(
                //                                   margin: const EdgeInsets
                //                                       .symmetric(horizontal: 3),
                //                                   decoration:
                //                                       const BoxDecoration(
                //                                     color: Color(0xffeaf1fc),
                //                                     borderRadius:
                //                                         BorderRadius.all(
                //                                             Radius.circular(
                //                                                 10)),
                //                                   ),
                //                                   child: Padding(
                //                                     padding:
                //                                         const EdgeInsets.all(
                //                                             8.0),
                //                                     child: CachedNetworkImage(
                //                                       imageUrl: subCategory.img,
                //                                       placeholder: (context,
                //                                               url) =>
                //                                           const CircularProgressIndicator(
                //                                         color:
                //                                             Colors.amberAccent,
                //                                       ),
                //                                       errorWidget: (context,
                //                                               url, error) =>
                //                                           const Icon(
                //                                               Icons.error),
                //                                     ),
                //                                   ),
                //                                 ),
                //                               ),
                //                               const SizedBox(height: 10),
                //                               Text(
                //                                 subCategory.name,
                //                                 textAlign: TextAlign.center,
                //                                 style: const TextStyle(
                //                                     fontSize: 12),
                //                               ),
                //                             ],
                //                           );
                //                         },
                //                       ),
                //                     ],
                //                   );
                //                 },
                //               );
                //             }
                //           },
                //         ),
                //       ],
                //     ),
                //   ),
                // ),
                Expanded(
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        const SizedBox(height: 20),
                        FutureBuilder<void>(
                          future: fetchDataFuture,
                          builder: (context, snapshot) {
                            if (snapshot.connectionState ==
                                ConnectionState.waiting) {
                              return const Center(
                                child: CircularProgressIndicator(),
                              );
                            } else if (snapshot.hasError) {
                              return const Center(
                                child: Text("Error"),
                              );
                            } else {
                              return ListView.builder(
                                shrinkWrap: true,
                                physics: const NeverScrollableScrollPhysics(),
                                itemCount: categories.length,
                                itemBuilder: (context, index) {
                                  final category = categories[index];
                                  final filteredSubCategories = subCategories
                                      .where((subCategory) =>
                                          subCategory.catId == category.id)
                                      .toList();

                                  return Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
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
                                        physics:
                                            const NeverScrollableScrollPhysics(),
                                        itemCount: filteredSubCategories.length,
                                        gridDelegate:
                                            const SliverGridDelegateWithFixedCrossAxisCount(
                                          crossAxisCount: 4,
                                          childAspectRatio: 0.59,
                                        ),
                                        itemBuilder: (context, subIndex) {
                                          final subCategory =
                                              filteredSubCategories[subIndex];
                                          return Column(
                                            children: [
                                              GestureDetector(
                                                onTap: () {
                                                  Navigator.push(
                                                    context,
                                                    MaterialPageRoute(
                                                      builder: (context) =>
                                                          CategoryScreen(
                                                        categoryTitle:
                                                            category.name,
                                                        subCategories:
                                                            filteredSubCategories,
                                                        selectedSubCategoryId:
                                                            subCategory
                                                                .id, // Pass the selected sub-category ID
                                                      ),
                                                    ),
                                                  );
                                                },
                                                child: Container(
                                                  margin: const EdgeInsets
                                                      .symmetric(horizontal: 3),
                                                  decoration:
                                                      const BoxDecoration(
                                                    color: Color(0xffeaf1fc),
                                                    borderRadius:
                                                        BorderRadius.all(
                                                            Radius.circular(
                                                                10)),
                                                  ),
                                                  child: Padding(
                                                    padding:
                                                        const EdgeInsets.all(
                                                            8.0),
                                                    child: CachedNetworkImage(
                                                      imageUrl: subCategory.img,
                                                      placeholder: (context,
                                                              url) =>
                                                          const CircularProgressIndicator(
                                                        color:
                                                            Colors.amberAccent,
                                                      ),
                                                      errorWidget: (context,
                                                              url, error) =>
                                                          const Icon(
                                                              Icons.error),
                                                    ),
                                                  ),
                                                ),
                                              ),
                                              const SizedBox(height: 10),
                                              Text(
                                                subCategory.name,
                                                textAlign: TextAlign.center,
                                                style: const TextStyle(
                                                    fontSize: 12),
                                              ),
                                            ],
                                          );
                                        },
                                      ),
                                    ],
                                  );
                                },
                              );
                            }
                          },
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),

          // cart floating button
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
