import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import '../offerScreen/offerCategory_Screen.dart';
import 'offerProductCard.dart';

Widget buildOfferSection() {
  return SliverList(
    delegate: SliverChildBuilderDelegate(
      (BuildContext context, int index) {
        return Padding(
          padding: const EdgeInsets.only(left: 15.0, right: 15, bottom: 20),
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

                    return GestureDetector(
                      onTap: () {
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
                      child: Container(
                        decoration: BoxDecoration(
                          // image: const DecorationImage(
                          //   image: AssetImage('assets/background_image.png'), // Add your background image path here
                          //   fit: BoxFit.cover,
                          // ),
                          color: const Color.fromRGBO(255, 252, 127, 0.8),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.only(left: 5, right: 5, top: 20, bottom: 0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              name != ""
                                  ? Center(
                                      child: Text(
                                        name,
                                        textAlign: TextAlign.center,
                                        style: const TextStyle(fontSize: 18, fontFamily: "Gilroy-Bold"),
                                      ),
                                    )
                                  : const SizedBox(
                                      height: 25,
                                    ),
                              SizedBox(
                                height: 300, // Adjust height as needed
                                child: offerProductCard(categoryId, name),
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  }).toList(),
                );
              }
            },
          ),
        );
      },
      childCount: 1,
    ),
  );
}
