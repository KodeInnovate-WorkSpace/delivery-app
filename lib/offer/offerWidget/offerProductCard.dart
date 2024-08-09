import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:speedy_delivery/widget/add_to_cart_button.dart';

import '../../shared/showProductImage.dart';

Widget offerProductCard(int categoryId, String categoryName) {
  return StreamBuilder<QuerySnapshot>(
    stream: FirebaseFirestore.instance.collection("offerProduct").where('categoryId', isEqualTo: categoryId).snapshots(),
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
              return Padding(
                padding: const EdgeInsets.only(top: 35, bottom: 10, left: 5, right: 5),
                child: Container(
                  width: 140,
                  height: 220,
                  decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: const BorderRadius.all(Radius.circular(8)),
                      border: Border.all(
                        color: Colors.grey.shade100,
                        width: 1,
                      )),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      //image
                      GestureDetector(
                        onTap: () {
                          showProductImage(context, data['image']);
                        },
                        child: Container(
                          decoration: const BoxDecoration(
                            borderRadius: BorderRadius.only(topLeft: Radius.circular(10), topRight: Radius.circular(10)),
                          ),
                          width: double.infinity,
                          height: 100,
                          child: CachedNetworkImage(
                            imageUrl: data["image"],
                            fit: BoxFit.contain,
                          ),
                        ),
                      ),

                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 10),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            //Product Name
                            Text(
                              data["name"],
                              style: const TextStyle(color: Colors.black, fontFamily: 'Gilroy-ExtraBold'),
                            ),
                            //Product weight
                            Text(
                              data["unit"],
                              style: TextStyle(color: Colors.grey.shade400, fontSize: 12, fontFamily: 'Gilroy-Bold'),
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
                                //Product price
                                Text(
                                  "Rs. ${data["price"].toString()}",
                                  style: const TextStyle(
                                    color: Colors.black,
                                    fontFamily: "Gilroy-ExtraBold",
                                  ),
                                ),
                                //Product mrp
                                Text(
                                  "Rs. ${data["mrp"].toString()}",
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
                              productName: data["name"],
                              productPrice: data["price"],
                              productImage: data["image"],
                              productUnit: data["unit"],
                              isOfferProduct: data['isOfferProduct'],
                              catName: categoryName,
                            ),
                          ],
                        ),
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

