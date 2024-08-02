class Product2 {
  final int id;
  final String name;
  final String image;
  final bool isCustom;
  final bool isFood;
  final bool isVeg;
  final int status;
  final int stock;
  final int subCatId;
  final List<Item>? items;

  Product2({
    required this.id,
    required this.name,
    required this.image,
    required this.isCustom,
    required this.isFood,
    required this.isVeg,
    required this.status,
    required this.stock,
    required this.subCatId,
    this.items,
  });

  factory Product2.fromJson(Map<String, dynamic> json) {
    return Product2(
      id: json['id'],
      name: json['name'],
      image: json['image'],
      isCustom: json['isCustom'] ?? false,
      isFood: json['isFood'] ?? false,
      isVeg: json['isVeg'] ?? false,
      status: json['status'],
      stock: json['stock'],
      subCatId: json['sub_category_id'],
      items: (json['item'] as List<dynamic>?)?.map((item) => Item.fromJson(item)).toList(),
    );
  }
}

class Item {
  final int mrp;
  final int price;
  final String unit;

  Item({
    required this.mrp,
    required this.price,
    required this.unit,
  });

  factory Item.fromJson(Map<String, dynamic> json) {
    return Item(
      mrp: json['mrp'],
      price: json['price'],
      unit: json['unit'],
    );
  }
}
