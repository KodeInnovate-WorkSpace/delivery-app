class Product {
  final int id;
  final String name;
  final int price;
  final int mrp;
  final String image;
  final int stock;
  final String unit;
  final int subCatId;
  final int status;
  final bool isVeg;
  final bool isFood;
  bool? isOfferProduct;

  Product({
    required this.id,
    required this.name,
    required this.price,
    required this.mrp,
    required this.image,
    required this.stock,
    required this.unit,
    required this.subCatId,
    required this.status,
    this.isVeg = false,
    this.isFood = false,
    this.isOfferProduct = false,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'price': price,
      'mrp': mrp,
      'image': image,
      'stock': stock,
      'unit': unit,
      'sub_category_id': subCatId,
      'status': status,
      'isVeg': isVeg,
      'isFood': isFood,
      'isOfferProduct': isOfferProduct,
    };
  }

  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      id: json['id'],
      name: json['name'],
      price: json['price'],
      mrp: json['mrp'],
      image: json['image'] ?? '', // Handle missing image
      stock: json['stock'],
      unit: json['unit'],
      subCatId: json['sub_category_id'],
      status: json['status'],
      isVeg: json['isVeg'] ?? false,
      isFood: json['isFood'] ?? false,
      isOfferProduct: json['isOfferProduct'] ?? false,
    );
  }
}
