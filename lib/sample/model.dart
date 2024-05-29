class Category {
  final int id;
  final String name;

  Category({required this.id, required this.name});
}

class SubCategory {
  final int id;
  final String name;
  final String img;
  final int catId;

  SubCategory(
      {required this.id,
      required this.name,
      required this.img,
      required this.catId});
}

class Product {
  final int id;
  final String name;
  final int price;
  final String image;
  final int stock;
  final int unit;
  final int subCatId;

  Product({
    required this.id,
    required this.name,
    required this.price,
    required this.image,
    required this.stock,
    required this.unit,
    required this.subCatId,
  });
}
