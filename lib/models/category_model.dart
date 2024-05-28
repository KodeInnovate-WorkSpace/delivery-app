import 'package:speedy_delivery/models/product_model.dart';

class Category {
  final String name;
  final List<SubCategory> subCategories;

  Category({required this.name, required this.subCategories});
}

class SubCategory {
  final String name;
  final String image;
  SubCategory({
    required this.name,
    required this.image,
  });
}

class DetailCategory {
  final String name;
  final String image;
  final List<Product> products;

  DetailCategory({
    required this.name,
    required this.image,
    required this.products,
  });
}
