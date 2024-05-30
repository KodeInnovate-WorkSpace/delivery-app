import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

import '../models/category_model.dart';

Widget sidebar(BuildContext context, List<SubCategory> subCategories, Function(int) fetchProducts){

  return Padding(
    padding: const EdgeInsets.all(8.0),
    child: Container(
      width: MediaQuery.of(context).size.width / 5,
      color: Colors.white,
      child: GestureDetector(
        child: ListView.builder(
          itemCount: subCategories.length,
          itemBuilder: (context, index) {
            final subCategory = subCategories[index];
            return GestureDetector(
              onTap: () {
                fetchProducts(subCategory.id);
              },
              child: Column(
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
                        ),
                        errorWidget: (context, url, error) =>
                        const Icon(Icons.error),
                      ),
                    ),
                  ),
                  Text(
                    subCategory.name,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 11,
                      fontFamily: 'Gilroy-Medium',
                      color: Colors.grey[600],
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    ),
  );
}