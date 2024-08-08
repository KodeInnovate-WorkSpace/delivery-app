import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:speedy_delivery/widget/add_to_cart_button.dart';

Widget offerProductCard(int categoryId, String categoryName) {
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

                      // Text(data["unit"]),

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
                // child: Card(
                //   color: Colors.white,
                //   child: Padding(
                //     // padding: const EdgeInsets.all(8.0),
                //     padding: const EdgeInsets.symmetric(horizontal: 2, vertical: 8),
                //     child: Column(
                //       mainAxisAlignment: MainAxisAlignment.spaceBetween,
                //       crossAxisAlignment: CrossAxisAlignment.start,
                //       children: [
                //         //Image
                //         GestureDetector(
                //           onTap: () {
                //             // showProductImage(context, product.image);
                //           },
                //           child: Container(
                //             decoration: const BoxDecoration(
                //               borderRadius: BorderRadius.only(topLeft: Radius.circular(10), topRight: Radius.circular(10)),
                //             ),
                //             width: double.infinity,
                //             height: 100,
                //             child: CachedNetworkImage(
                //               imageUrl: data["image"],
                //               fit: BoxFit.contain,
                //             ),
                //           ),
                //         ),
                //
                //         //Product Name
                //         Text(
                //           data["name"],
                //           style: const TextStyle(color: Colors.black, fontFamily: 'Gilroy-Bold'),
                //         ),
                //
                //         //Product weight
                //         Text(
                //           data["unit"],
                //           style: const TextStyle(color: Colors.black),
                //         ),
                //
                //         Row(
                //           mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                //           children: [
                //             Column(
                //               crossAxisAlignment: CrossAxisAlignment.start,
                //               children: [
                //                 //Product price
                //                 Text(
                //                   "Rs. ${data["price"].toString()}",
                //                   style: const TextStyle(
                //                     color: Colors.black,
                //                     fontFamily: "Gilroy-SemiBold",
                //                   ),
                //                 ),
                //
                //                 //Product mrp
                //                 Text(
                //                   "Rs. ${data["mrp"].toString()}",
                //                   style: const TextStyle(
                //                     color: Colors.grey,
                //                     fontSize: 12,
                //                     decoration: TextDecoration.lineThrough,
                //                   ),
                //                 ),
                //               ],
                //             ),
                //
                //             //cart button
                //             SizedBox(
                //               width: MediaQuery.of(context).size.width / 5,
                //               height: MediaQuery.of(context).size.height / 25,
                //               child: AddToCartButton(
                //                 productName: data["name"],
                //                 productPrice: data["price"],
                //                 productImage: data["image"],
                //                 productUnit: data["unit"],
                //               ),
                //             ),
                //           ],
                //         ),
                //       ],
                //     ),
                //   ),
                // ),
              );
            }).toList(),
          ),
        );
      }
    },
  );
}
