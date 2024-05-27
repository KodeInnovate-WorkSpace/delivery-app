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

class Product {
  final String name;
  final int price;
  final String image;
  final String stock;
  final String unit;

  Product({
    required this.name,
    required this.price,
    required this.image,
    required this.stock,
    required this.unit,
  });
}
