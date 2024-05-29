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


