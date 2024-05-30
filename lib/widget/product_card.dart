import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:speedy_delivery/shared/capitalise.dart';
import '../models/product_model.dart';
import '../shared/remove_trailing_zero.dart';
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
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Image.asset(
                        'assets/images/no_product.png',
                        width: 800,
                        height: 800,
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
                            Center(
                              child: CachedNetworkImage(
                                imageUrl: product.image,
                                width: 90,
                                height: 80,
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
                            Text(
                              product.unit.toString(),
                              style: const TextStyle(
                                color: Colors.grey,
                              ),
                            ),
                            const SizedBox(height: 10),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
