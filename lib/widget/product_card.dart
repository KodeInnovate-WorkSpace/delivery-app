import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import '../models/product_model2.dart';
import 'add_to_cart_button.dart';

class ProductCard extends StatefulWidget {
  final List<Product2> productList;

  const ProductCard({super.key, required this.productList});

  @override
  State<ProductCard> createState() => _ProductCardState();
}

class _ProductCardState extends State<ProductCard> {
  String? selectedUnit;

  void showProductImage(BuildContext context, String imageUrl) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12.0),
          ),
          child: Container(
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
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: const Text('Close'),
                ),
              ],
            ),
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
                  mainAxisSpacing: 5.0,
                  crossAxisSpacing: 5.0,
                  childAspectRatio: 0.48,
                ),
                itemBuilder: (context, index) {
                  final product = widget.productList[index];
                  final defaultItem = product.items?.first;

                  return GestureDetector(
                    onTap: () {},
                    child: Card(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(6.0),
                      ),
                      color: Colors.white,
                      elevation: 1,
                      shadowColor: const Color(0xfff1f1f1),
                      child: Stack(
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                // item image
                                GestureDetector(
                                  onTap: () {
                                    showProductImage(context, product.image);
                                  },
                                  child: Center(
                                    child: CachedNetworkImage(
                                      imageUrl: product.image,
                                      height: 75,
                                      fit: BoxFit.contain,
                                      errorWidget: (context, url, error) => const Icon(Icons.error),
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 15),
                                // item name
                                Text(
                                  product.name,
                                  textAlign: TextAlign.left,
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                  style: const TextStyle(
                                    fontSize: 14,
                                    fontFamily: 'Gilroy-Bold',
                                  ),
                                ),
                                const SizedBox(height: 10),
                                // Display default item details
                                if (defaultItem != null) ...[
                                  Text("MRP: ${defaultItem.mrp}"),
                                  Text("Price: ${defaultItem.price}"),
                                  SizedBox(
                                    width: MediaQuery.of(context).size.width,
                                    height: MediaQuery.of(context).size.height / 22,
                                    child: AddToCartButton(
                                      productName: product.name,
                                      productPrice: defaultItem.price,
                                      productImage: product.image,
                                      productUnit: defaultItem.unit,
                                      productItems: product.items,
                                    ),
                                  ),
                                ],
                              ],
                            ),
                          ),
                          if (product.isVeg)
                            Positioned(
                              top: 8,
                              left: 8,
                              child: Container(
                                padding: const EdgeInsets.all(4.0),
                                decoration: BoxDecoration(
                                  border: Border.all(color: Colors.green, width: 2.0),
                                  borderRadius: BorderRadius.circular(4.0), // Square outline
                                ),
                                child: const Icon(
                                  Icons.circle,
                                  color: Colors.green,
                                  size: 5,
                                ),
                              ),
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
