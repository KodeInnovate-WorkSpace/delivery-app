class Cart {
  final String itemName;
  final int itemPrice;
  final String itemImage;
  final String itemUnit;
  bool? isOfferProduct;
  int qnt;

  Cart({
    required this.itemImage,
    required this.itemName,
    required this.itemPrice,
    required this.itemUnit,
    this.isOfferProduct,
    this.qnt = 1,
  });

  // Code for SP

  // Add a method to convert a Cart object to a JSON map
  Map<String, dynamic> toJson() => {
        'itemImage': itemImage,
        'itemName': itemName,
        'itemPrice': itemPrice,
        'itemUnit': itemUnit,
        'isOfferProduct': isOfferProduct,
        'qnt': qnt,
      };

  // Add a new static method named 'fromJson'
  factory Cart.fromJson(Map<String, dynamic> json) => Cart(
        itemImage: json['itemImage'] as String,
        itemName: json['itemName'] as String,
        itemPrice: json['itemPrice'] as int,
        itemUnit: json['itemUnit'] as String,
        isOfferProduct: json['isOfferProduct'] as bool,
        qnt: json['qnt'] as int,
      );
}
