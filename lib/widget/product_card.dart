import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/cart_model.dart';
import '../models/product_model.dart';
import '../providers/cart_provider.dart';
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
  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        color: Colors.grey[100],
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
                  childAspectRatio: 0.58,
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
                      elevation: 1.6,
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
                                errorWidget: (context, url, error) =>
                                    const Icon(Icons.error),
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
                                fontFamily: 'Gilroy-SemiBold',
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
                              height: 50,
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    "\u20B9 ${product.price}",
                                    style: const TextStyle(
                                      fontFamily: "Gilroy-medium",
                                    ),
                                  ),
                                  AddToCartButton(
                                    productName: product.name,
                                    productPrice: product.price,
                                    productImage: product.image,
                                    productUnit: product.unit,
                                  ),
                                ],
                              ),
                            ),
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
