import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import '../models/category_model.dart';

Widget sidebar(
    BuildContext context,
    List<SubCategory> subCategories,
    Function(int) fetchProducts,
    int? selectedSubCategoryId,
    Function(int) onSubCategorySelected) {

  return Padding(
    padding: const EdgeInsets.all(8.0),
    child: Container(
      width: MediaQuery.of(context).size.width / 6.2,
      color: Colors.white,
      child: ListView.builder(
        itemCount: subCategories.length,
        itemBuilder: (context, index) {
          final subCategory = subCategories[index];
          final isSelected = selectedSubCategoryId == subCategory.id;
          return MouseRegion(
            onEnter: (_) => onSubCategorySelected(subCategory.id),
            onExit: (_) => onSubCategorySelected(subCategory.id),
            child: GestureDetector(
              onTap: () {
                fetchProducts(subCategory.id);
                onSubCategorySelected(subCategory.id);
              },
              child: Container(
                color: isSelected ? const Color(0xffeaf1fc) : Colors.transparent,

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
              ),
            ),
          );
        },
      ),
    ),
  );
}
