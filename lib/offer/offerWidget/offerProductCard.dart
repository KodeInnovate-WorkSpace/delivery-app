import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import '../offerScreen/offerCategory_Screen.dart';

Future<List<DocumentSnapshot>> _fetchProducts(int categoryId) async {
  final snapshot = await FirebaseFirestore.instance.collection("offerProduct").where('categoryId', isEqualTo: categoryId).where('status', isEqualTo: 1).where('isOfferProduct', isEqualTo: true).get();
  return snapshot.docs;
}

Widget offerProductCard(int categoryId, String categoryName) {
  return FutureBuilder<List<DocumentSnapshot>>(
    future: _fetchProducts(categoryId),
    builder: (context, snapshot) {
      if (snapshot.connectionState == ConnectionState.waiting) {
        return const Center(
          child: CircularProgressIndicator(
            color: Colors.black,
          ),
        );
      } else if (snapshot.hasError) {
        return const SizedBox.shrink();
      } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
        return const SizedBox.shrink();
      } else {
        final products = snapshot.data!;

        return GridView.builder(
          shrinkWrap: true, // Make GridView take only the space it needs
          physics: const NeverScrollableScrollPhysics(), // Disable GridView's internal scrolling
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 3, // 3 items per row
            childAspectRatio: 0.9, // size of each content inside grid view
            mainAxisSpacing: 10, // Spacing between rows
            crossAxisSpacing: 10, // Spacing between columns
          ),
          itemCount: products.length,
          itemBuilder: (context, index) {
            final product = products[index];
            final data = product.data() as Map<String, dynamic>;

            return GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => OfferCategoryScreen(
                      categoryTitle: categoryName,
                      categoryID: categoryId,
                    ),
                  ),
                );
              },
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: const BorderRadius.all(Radius.circular(8)),
                  border: Border.all(
                    color: Colors.grey.shade100,
                    width: 1,
                  ),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    // Product name
                    Center(
                      child: Text(
                        data["name"],
                        style: const TextStyle(fontFamily: 'cgblack', fontSize: 10),
                      ),
                    ),
                    // Image
                    Container(
                      decoration: BoxDecoration(
                        borderRadius: const BorderRadius.only(
                          topLeft: Radius.circular(10),
                          topRight: Radius.circular(10),
                        ),
                        image: DecorationImage(
                          image: CachedNetworkImageProvider(data['image']),
                          fit: BoxFit.cover,
                        ),
                      ),
                      width: double.infinity,
                      height: 70,
                    ),
                  ],
                ),
              ),
            );
          },
        );
      }
    },
  );
}
