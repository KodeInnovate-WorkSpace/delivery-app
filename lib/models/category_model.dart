class Category {
  final int id;
  final String name;
  final int status;
  Category({required this.id, required this.name, required this.status});
}

class SubCategory {
  final int id;
  final String name;
  final String img;
  final int catId;
  final int status;

  SubCategory(
      {required this.id,
      required this.name,
      required this.img,
      required this.catId,
      required this.status});
}
