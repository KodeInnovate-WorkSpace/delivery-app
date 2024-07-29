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
  final bool isVeg; // New field

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
    this.isVeg = false, // Default value set to false
  });

  // Assuming you'll have a method to convert the Product to JSON for Firestore
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
      'isVeg': isVeg, // New field
    };
  }

  // Assuming you'll have a method to create a Product from JSON
  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      id: json['id'],
      name: json['name'],
      price: json['price'],
      mrp: json['mrp'],
      image: json['image'],
      stock: json['stock'],
      unit: json['unit'],
      subCatId: json['sub_category_id'],
      status: json['status'],
      isVeg: json['isVeg'] ?? false, // Handle previous products without isVeg field
    );
  }
}
