class Category {
  final int id;
  final String name;
  final int status;
  final int priority;
  final String? logoUrl;
  final bool? isOffer;

  Category({
    required this.id,
    required this.name,
    required this.status,
    required this.priority,
    this.logoUrl,
    this.isOffer,
  });
}

class SubCategory {
  final int id;
  final String name;
  final String img;
  final int catId;
  final int status;

  SubCategory({
    required this.id,
    required this.name,
    required this.img,
    required this.catId,
    required this.status,
  });
}