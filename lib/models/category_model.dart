class Category {
  final String name;
  final List<SubCategory> subCategories;

  Category({required this.name, required this.subCategories});
}

class SubCategory {
  final String name;
  final String image;

  SubCategory({required this.name, required this.image});
}
