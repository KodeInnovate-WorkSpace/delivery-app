import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import '../offerScreen/offerCategory_Screen.dart';

Widget offerProductCard(int categoryId, String categoryName) {
  return StreamBuilder<QuerySnapshot>(
    stream: FirebaseFirestore.instance.collection("offerProduct").where('categoryId', isEqualTo: categoryId).where('status', isEqualTo: 1).where('isOfferProduct', isEqualTo: true).snapshots(),
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

        return GridView.builder(
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
                // showProductImage(context, data['image']);
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
                    //product name
                    Center(
                        child: Text(
                      data["name"],
                      style: const TextStyle(fontFamily: 'cgblack', fontSize: 10),
                    )),

                    // Image
                    Container(
                      decoration: BoxDecoration(
                          borderRadius: const BorderRadius.only(
                            topLeft: Radius.circular(10),
                            topRight: Radius.circular(10),
                          ),
                          image: DecorationImage(image: CachedNetworkImageProvider(data['image']))),
                      width: double.infinity,
                      height: 70,

                      // child: CachedNetworkImage(
                      //   imageUrl: data["image"],
                      //   fit: BoxFit.cover,
                      // ),
                    ),

                    // Padding(
                    //   padding: const EdgeInsets.symmetric(horizontal: 10),
                    //   child: Column(
                    //     crossAxisAlignment: CrossAxisAlignment.start,
                    //     children: [
                    //       // Product Name
                    //       Text(
                    //         data["name"],
                    //         style: const TextStyle(color: Colors.black, fontFamily: 'Gilroy-ExtraBold'),
                    //       ),
                    //       // Product weight
                    //       Text(
                    //         data["unit"],
                    //         style: TextStyle(color: Colors.grey.shade400, fontSize: 12, fontFamily: 'Gilroy-Bold'),
                    //       ),
                    //     ],
                    //   ),
                    // ),
                    // SizedBox(
                    //   height: 50,
                    //   child: Row(
                    //     mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    //     children: [
                    //       Column(
                    //         crossAxisAlignment: CrossAxisAlignment.start,
                    //         children: [
                    //           // Product price
                    //           Text(
                    //             "Rs. ${data["price"].toString()}",
                    //             style: const TextStyle(
                    //               color: Colors.black,
                    //               fontFamily: "Gilroy-ExtraBold",
                    //             ),
                    //           ),
                    //           // Product MRP
                    //           Text(
                    //             "Rs. ${data["mrp"].toString()}",
                    //             style: TextStyle(
                    //               color: Colors.grey.shade400,
                    //               fontSize: 12,
                    //               fontFamily: 'Gilroy-Bold',
                    //               decoration: TextDecoration.lineThrough,
                    //             ),
                    //           ),
                    //         ],
                    //       ),
                    //       // Add button
                    //       AddToCartButton(
                    //         productName: data["name"],
                    //         productPrice: data["price"],
                    //         productImage: data["image"],
                    //         productUnit: data["unit"],
                    //         isOfferProduct: data['isOfferProduct'],
                    //         catName: categoryName,
                    //       ),
                    //     ],
                    //   ),
                    // ),
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
