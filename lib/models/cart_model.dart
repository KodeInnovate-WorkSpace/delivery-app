class Cart {
  final String itemName;
  final int itemPrice;
  final String itemImage;
  final String itemUnit;
  int qnt;

  Cart({
    required this.itemImage,
    required this.itemName,
    required this.itemPrice,
    required this.itemUnit,
    this.qnt = 1,
  });
}