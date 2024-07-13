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
                  mainAxisSpacing: 5.0,
                  crossAxisSpacing: 5.0,
                  // childAspectRatio: 0.52,
                  childAspectRatio: 0.48,
                ),
                itemBuilder: (context, index) {
                  final product = widget.productList[index];
                  return GestureDetector(
                    onTap: () {},
                    child: Card(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(6.0),
                      ),
                      color: Colors.white,
                      elevation: 1,
                      shadowColor: const Color(0xfff1f1f1),
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // item image
                            Center(
                              child: CachedNetworkImage(
                                imageUrl: product.image,
                                height: 75,
                                fit: BoxFit.contain,
                                errorWidget: (context, url, error) => const Icon(Icons.error),
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
                                fontSize: 14,
                                fontFamily: 'Gilroy-Bold',
                              ),
                            ),
                            // Item unit
                            Text(
                              product.unit,
                              style: const TextStyle(
                                color: Colors.grey,
                              ),
                            ),

                            const SizedBox(height: 10),
                            // Item price
                            SizedBox(
                              height: 40,
                              child: Column(
                                // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    "Rs.${product.price}",
                                    style: const TextStyle(
                                      fontSize: 14,
                                      fontFamily: "Gilroy-SemiBold",
                                    ),
                                  ),
                                  Text(
                                    "Rs.${product.mrp.toString()}",
                                    style: const TextStyle(
                                      fontSize: 11,
                                      color: Colors.grey,
                                      decoration: TextDecoration.lineThrough,
                                    ),
                                  ),
                                ],
                              ),
                            ),

                            SizedBox(
                              width: MediaQuery.of(context).size.width,
                              height: MediaQuery.of(context).size.height / 22,
                              child: AddToCartButton(
                                productName: product.name,
                                productPrice: product.price,
                                productImage: product.image,
                                productUnit: product.unit,
                                // refreshCart: refreshCart,
                              ),
                            )
                          ],
                        ),
                      ),
                    ),
                  );
                },
              ),
      ),
    );
  }
}
