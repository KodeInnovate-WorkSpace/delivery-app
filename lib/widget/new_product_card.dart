import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

import '../models/product_model.dart';
import 'add_to_cart_button.dart';

class NewProductCard extends StatefulWidget {
  final List<Product> productList;

  const NewProductCard({
    super.key,
    required this.productList,
  });

  @override
  State<NewProductCard> createState() => _NewProductCardState();
}

class _NewProductCardState extends State<NewProductCard>
    with SingleTickerProviderStateMixin {
  late AnimationController _imageAnimationController;

  @override
  void initState() {
    _imageAnimationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    );
    super.initState();

    _imageAnimationController.addListener(() {
      setState(() {});
    });
    _imageAnimationController.forward();
  }

  @override
  void dispose() {
    _imageAnimationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
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
                mainAxisSpacing: 0,
                crossAxisSpacing: 0,
                childAspectRatio: 0.58,
              ),
              itemBuilder: (context, index) {
                final product = widget.productList[index];
                return GestureDetector(
                  onTap: () {},
                  child: Stack(
                    alignment: Alignment.bottomCenter,
                    children: [
                      Container(
                          padding: const EdgeInsets.only(
                              left: 12, right: 12, bottom: 12),
                          margin: const EdgeInsets.only(
                              top: 10, left: 8, right: 8, bottom: 0),
                          decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(12),
                              boxShadow: [
                                BoxShadow(
                                    color: Colors.grey.withOpacity(0.12),
                                    offset: const Offset(0, 12),
                                    spreadRadius: 1,
                                    blurRadius: 24),
                              ]),
                          child: Container(
                            width: double.infinity,
                          )),
                      Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Flexible(
                            flex: 5,
                            child: Padding(
                              padding: const EdgeInsets.all(20.0),
                              child: GestureDetector(
                                onTap: () {
                                  // Navigator.of(context).pushNamed(
                                  //   ProductPage.id,
                                  //   arguments: widget.product,
                                  // );
                                },
                                child: Container(
                                  decoration: BoxDecoration(
                                      color: const Color(0xffeaf1fc),
                                      borderRadius: BorderRadius.circular(24)),

                                  child: Stack(
                                    children: [
                                      AspectRatio(
                                        aspectRatio: 1,
                                        child: Padding(
                                          padding: const EdgeInsets.all(10.0),
                                          child: CachedNetworkImage(
                                            imageUrl: product.image,
                                            errorWidget:
                                                (context, url, error) =>
                                                    const Icon(Icons.error),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 24, vertical: 0),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Expanded(
                                        child: Text(
                                      product.name,
                                      maxLines: 2,
                                      // textAlign: TextAlign.center,
                                      style: const TextStyle(
                                          fontSize: 15,
                                          fontFamily: 'Gilroy-SemiBold'),
                                    )),
                                  ],
                                ),
                                Row(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          '\u20B9 ${product.price}',
                                          style: const TextStyle(
                                              fontSize: 15,
                                              fontFamily: 'Gilroy-SemiBold'),
                                        )
                                      ],
                                    ),

                                  ],
                                ),
                                Center(
                                  child: AddToCartButton(
                                    productName: product.name,
                                    productPrice: product.price,
                                    productImage: product.image,
                                    productUnit: product.unit,
                                  ),
                                ),
                              ],
                            ),
                          ),

                        ],
                      )
                    ],
                  ),
                );
              },
            ),
    );
  }
}
