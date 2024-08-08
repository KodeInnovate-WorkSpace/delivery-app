import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import '../offerScreen/offerCategory_Screen.dart';
import 'offerProductCard.dart';

Widget buildOfferSection() {
  return SliverList(
    delegate: SliverChildBuilderDelegate(
      (BuildContext context, int index) {
        return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 0),
            child: StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance.collection("offerCategory").where('status', isEqualTo: 1).snapshots(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(
                    child: CircularProgressIndicator(
                      color: Colors.black,
                    ),
                  );
                } else if (snapshot.hasError) {
                  return const SizedBox.shrink();
                } else if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                  return const SizedBox.shrink();
                } else {
                  final offerCategories = snapshot.data!.docs;

                  return Column(
                    children: offerCategories.map((offerCat) {
                      final data = offerCat.data() as Map<String, dynamic>;
                      final name = data['name'] ?? '';
                      int categoryId = data['id'];
                      return Stack(
                        children: [
                          //Display category name
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 5.0, vertical: 0.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  name,
                                  style: const TextStyle(fontSize: 18, fontFamily: "Gilroy-Bold"),
                                ),
                              ],
                            ),
                          ),
                          // Display Product

                          SingleChildScrollView(
                            scrollDirection: Axis.horizontal,
                            child: Row(
                              children: [
                                offerProductCard(categoryId, name),
                              ],
                            ),
                          ),

                          // See all button
                          Positioned(
                            left: 0,
                            right: -15,
                            top: -10,
                            child: Align(
                              alignment: Alignment.topRight,
                              child: TextButton(
                                onPressed: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => OfferCategoryScreen(
                                        categoryTitle: name,
                                        categoryID: categoryId,
                                      ),
                                    ),
                                  );
                                },
                                style: ButtonStyle(
                                  overlayColor: WidgetStateProperty.all(Colors.transparent),
                                  backgroundColor: WidgetStateProperty.all(Colors.transparent),
                                ),
                                child: const Text(
                                  "see all",
                                  style: TextStyle(fontSize: 12, fontFamily: "Gilroy-ExtraBold", color: Colors.green),
                                ),
                              ),
                            ),
                          ),
                        ],
                      );
                    }).toList(),
                  );
                }
              },
            ));
      },
      childCount: 1,
    ),
  );
}
