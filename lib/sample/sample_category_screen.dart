import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:speedy_delivery/sample/model.dart';
import 'package:speedy_delivery/screens/checkout_screen.dart';

class SampleCategoryScreen extends StatefulWidget {
  final double imageWidth;
  final double imageHeight;
  final String categoryTitle;
  final List<SubCategory> subCategories;

  const SampleCategoryScreen({
    super.key,
    required this.categoryTitle,
    required this.subCategories,
    this.imageWidth = 90.0,
    this.imageHeight = 90.0,
  });

  @override
  SampleCategoryScreenState createState() => SampleCategoryScreenState();
}

class SampleCategoryScreenState extends State<SampleCategoryScreen> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.categoryTitle),
      ),
      body: Stack(
        children: [
          Row(
            children: [
              // Side navbar displaying sub-categories
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Container(
                  width: MediaQuery.of(context).size.width / 5,
                  color: Colors.white,
                  child: ListView.builder(
                    itemCount: widget.subCategories.length,
                    itemBuilder: (context, index) {
                      final subCategory = widget.subCategories[index];
                      return Column(
                        children: [
                          const SizedBox(height: 20),
                          ClipOval(
                            child: Container(
                              color: const Color(0xffeaf1fc),
                              height: 60,
                              width: 60,
                              child: CachedNetworkImage(
                                fit: BoxFit.contain,
                                imageUrl: subCategory.img,
                                placeholder: (context, url) =>
                                    const CircularProgressIndicator(
                                  color: Colors.amberAccent,
                                ), // Placeholder while loading
                                errorWidget: (context, url, error) =>
                                    const Icon(Icons.error), // Error widget
                              ),
                            ),
                          ),
                          Text(
                            subCategory.name,
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                fontSize: 11,
                                fontFamily: 'Gilroy-Medium',
                                color: Colors.grey[600]),
                          ),
                        ],
                      );
                    },
                  ),
                ),
              ),

              // Products list
              Expanded(
                child: Container(
                  color: Colors.grey[100],
                  // Displaying products or other relevant content
                  child: const Center(
                    child: Text('Display products here'),
                  ),
                ),
              ),
            ],
          ),
          Positioned(
            bottom: 25,
            right: 20,
            child: FloatingActionButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const CheckoutScreen(),
                  ),
                );
              },
              backgroundColor: Colors.white,
              child: const Icon(Icons.shopping_cart_sharp),
            ),
          ),
        ],
      ),
    );
  }
}
