import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/category_model.dart';
import '../providers/category_provider.dart';
import '../shared/capitalise.dart';

Widget sideNavbar(BuildContext context) {
  final categories = Provider.of<CategoryProvider>(context);

  return SingleChildScrollView(
    child: Container(
      width: MediaQuery.of(context).size.width / 5,
      decoration: const BoxDecoration(
        color: Colors.white,
      ),
      child: Column(
        children: [
          const SizedBox(height: 20),
          categories.isLoading
              ? const Center(child: CircularProgressIndicator())
              : (categories.detailCategories.isEmpty)
                  ? const Center(child: Text("No detail categories available"))
                  : ListView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: categories.detailCategories.length,
                      itemBuilder: (context, index) {
                        final detailCategory =
                            categories.detailCategories[index];
                        return detailCategoryInfo(detailCategory);
                      },
                    ),
        ],
      ),
    ),
  );
}

Widget detailCategoryInfo(DetailCategory detailCategory) {
  return Padding(
    padding: const EdgeInsets.all(8.0),
    child: Column(
      children: [
        ClipOval(
          child: Container(
            color: const Color(0xffeaf1fc),
            height: 60,
            width: 60,
            child: Image.network(detailCategory.image),
          ),
        ),
        Text(
          toSentenceCase(detailCategory.name),
          textAlign: TextAlign.center,
          style: TextStyle(
              fontSize: 11,
              fontFamily: 'Gilroy-Medium',
              color: Colors.grey[600]),
        ),
      ],
    ),
  );
}


