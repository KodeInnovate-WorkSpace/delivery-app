import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../offerProvider/offerCartProvider.dart';

Widget offerProductCard(int categoryId) {
  return StreamBuilder<QuerySnapshot>(
    stream: FirebaseFirestore.instance.collection("product2").where('categoryId', isEqualTo: categoryId).snapshots(),
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
        final products = snapshot.data!.docs;

        return SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: products.map<Widget>((product) {
              final data = product.data() as Map<String, dynamic>;
              final productId = product.id;

              return Padding(
                padding: const EdgeInsets.only(top: 35, bottom: 10, left: 5, right: 5),
                child: Container(
                  width: 140,
                  height: 180,
                  color: const Color.fromRGBO(200, 0, 0, 0.2),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      //image
                      Container(
                        width: 40,
                        height: 40,
                        decoration: BoxDecoration(image: DecorationImage(image: CachedNetworkImageProvider(data['image']))),
                      ),
                      //name
                      Text(data["name"]),
                      //price
                      Text("Price: ${(data["price"] ?? 00).toString()}"),
                      //mrp
                      Text("Mrp: ${(data["mrp"] ?? 00).toString()}"),
                      //unit
                      ElevatedButton(
                        onPressed: () {
                          // Add the product to the cart
                          final offerCartProvider = Provider.of<OfferCartProvider>(context, listen: false);
                          offerCartProvider.addToCart(categoryId.toString(), productId);
                        },
                        child: const Text("Add"),
                      ),
                    ],
                  ),
                ),
              );
            }).toList(),
          ),
        );
      }
    },
  );
}
