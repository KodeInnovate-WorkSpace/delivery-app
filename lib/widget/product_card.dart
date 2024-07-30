import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:speedy_delivery/screens/home_screen.dart';
import '../models/product_model.dart';
import 'add_to_cart_button.dart';

class ProductCard extends StatefulWidget {
  final List<Product> productList;

  const ProductCard({
    super.key,
    required this.productList,
  });

  @override
  State<ProductCard> createState() => _ProductCardState();
}

class _ProductCardState extends State<ProductCard> {
  Future<void> refreshCart() async {
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(
        builder: (context) => const HomeScreen(),
      ),
    );
  }

  void showProductImage(BuildContext context, String imageUrl) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12.0),
          ),
          child: Stack(
            children: [
              Container(
                width: MediaQuery.of(context).size.width * 0.8,
                height: MediaQuery.of(context).size.height * 0.6,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12.0),
                  color: Colors.white,
                ),
                child: Column(
                  children: [
                    Expanded(
                      child: CachedNetworkImage(
                        imageUrl: imageUrl,
                        fit: BoxFit.contain,
                        errorWidget: (context, url, error) => const Icon(Icons.error),
                      ),
                    ),
                  ],
                ),
              ),
              Positioned(
                  top: 0,
                  right: 0,
                  child: IconButton(
                    icon: const Icon(
                      Icons.close,
                      size: 20,
                    ),
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                  )),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        color: const Color(0xfff7f7f7),
        child: widget.productList.isEmpty
            ? Center(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    children: [
                      const SizedBox(
                        height: 165,
                      ),
                      Image.asset(
                        'assets/images/no_product.png',
                        width: MediaQuery.of(context).size.width,
                        height: MediaQuery.of(context).size.height / 4,
                        fit: BoxFit.contain,
                      ),
                    ],
                  ),
                ),
              )
            : GridView.builder(
                itemCount: widget.productList.length,
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  // mainAxisSpacing: 5.0,
                  // crossAxisSpacing: 5.0,
                  // childAspectRatio: 0.48,
                  mainAxisSpacing: 0,
                  crossAxisSpacing: 0.0,
                  childAspectRatio: 0.55,
                ),
                itemBuilder: (context, index) {
                  final product = widget.productList[index];
                  // return Card(
                  //   shape: RoundedRectangleBorder(
                  //     borderRadius: BorderRadius.circular(6.0),
                  //   ),
                  //   color: Colors.white,
                  //   elevation: 1,
                  //   shadowColor: const Color(0xfff1f1f1),
                  //   child: Stack(
                  //     children: [
                  //       Padding(
                  //         padding: const EdgeInsets.all(8.0),
                  //         child: Column(
                  //           mainAxisAlignment: MainAxisAlignment.center,
                  //           crossAxisAlignment: CrossAxisAlignment.start,
                  //           children: [
                  //             // item image
                  //             GestureDetector(
                  //               onTap: () {
                  //                 showProductImage(context, product.image);
                  //               },
                  //               child: Center(
                  //                 child: CachedNetworkImage(
                  //                   imageUrl: product.image,
                  //                   height: 75,
                  //                   fit: BoxFit.contain,
                  //                   errorWidget: (context, url, error) => const Icon(Icons.error),
                  //                 ),
                  //               ),
                  //             ),
                  //             const SizedBox(height: 15),
                  //             // item name
                  //             Text(
                  //               product.name,
                  //               textAlign: TextAlign.left,
                  //               maxLines: 2,
                  //               overflow: TextOverflow.ellipsis,
                  //               style: const TextStyle(
                  //                 fontSize: 14,
                  //                 fontFamily: 'Gilroy-Bold',
                  //               ),
                  //             ),
                  //             // Item unit
                  //             Text(
                  //               product.unit,
                  //               style: const TextStyle(
                  //                 color: Colors.grey,
                  //               ),
                  //             ),
                  //             const SizedBox(height: 10),
                  //             // Item price
                  //             SizedBox(
                  //               height: 40,
                  //               child: Column(
                  //                 crossAxisAlignment: CrossAxisAlignment.start,
                  //                 children: [
                  //                   Text(
                  //                     "Rs.${product.price}",
                  //                     style: const TextStyle(
                  //                       fontSize: 14,
                  //                       fontFamily: "Gilroy-SemiBold",
                  //                     ),
                  //                   ),
                  //                   Text(
                  //                     "Rs.${product.mrp.toString()}",
                  //                     style: const TextStyle(
                  //                       fontSize: 11,
                  //                       color: Colors.grey,
                  //                       decoration: TextDecoration.lineThrough,
                  //                     ),
                  //                   ),
                  //                 ],
                  //               ),
                  //             ),
                  //             SizedBox(
                  //               width: MediaQuery.of(context).size.width,
                  //               height: MediaQuery.of(context).size.height / 22,
                  //               child: AddToCartButton(
                  //                 productName: product.name,
                  //                 productPrice: product.price,
                  //                 productImage: product.image,
                  //                 productUnit: product.unit,
                  //               ),
                  //             )
                  //           ],
                  //         ),
                  //       ),
                  //     ],
                  //   ),
                  // );
                  return Card(
                    color: Colors.white,
                    child: Padding(
                      // padding: const EdgeInsets.all(8.0),
                      padding: const EdgeInsets.symmetric(horizontal: 2, vertical: 8),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          //Image
                          GestureDetector(
                            onTap: () {
                              showProductImage(context, product.image);
                            },
                            child: Container(
                              decoration: const BoxDecoration(
                                borderRadius: BorderRadius.only(topLeft: Radius.circular(10), topRight: Radius.circular(10)),
                              ),
                              width: double.infinity,
                              height: 100,
                              child: CachedNetworkImage(
                                imageUrl: product.image,
                                fit: BoxFit.contain,
                              ),
                            ),
                          ),

                          //Product Name
                          Text(
                            product.name,
                            style: const TextStyle(color: Colors.black, fontFamily: 'Gilroy-Bold'),
                          ),

                          //Product weight
                          Text(
                            product.unit,
                            style: const TextStyle(color: Colors.black),
                          ),

                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  //Product price
                                  Text(
                                    "Rs. ${product.price.toString()}",
                                    style: const TextStyle(
                                      color: Colors.black,
                                      fontFamily: "Gilroy-SemiBold",
                                    ),
                                  ),

                                  //Product mrp
                                  Text(
                                    "Rs. ${product.mrp.toString()}",
                                    style: const TextStyle(
                                      color: Colors.grey,
                                      fontSize: 12,
                                      decoration: TextDecoration.lineThrough,
                                    ),
                                  ),
                                ],
                              ),

                              //cart button
                              SizedBox(
                                width: MediaQuery.of(context).size.width / 5,
                                height: MediaQuery.of(context).size.height / 25,
                                child: AddToCartButton(
                                  productName: product.name,
                                  productPrice: product.price,
                                  productImage: product.image,
                                  productUnit: product.unit,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
      ),
    );
  }
}
