class Cart {
  final String itemName;
  final int itemPrice;
  final String itemImage;
  final String itemUnit;
  //new value
  final int itemSubCat;
  int qnt;

  Cart({
    required this.itemImage,
    required this.itemName,
    required this.itemPrice,
    required this.itemUnit,
    //new value
    required this.itemSubCat,
    this.qnt = 1,
  });

  // Code for SP

  // Add a method to convert a Cart object to a JSON map
  Map<String, dynamic> toJson() => {
    'itemImage': itemImage,
    'itemName': itemName,
    'itemPrice': itemPrice,
    'itemUnit': itemUnit,
    'itemSubCat': itemSubCat,
    'qnt': qnt,
  };

  // Add a new static method named 'fromJson'
  factory Cart.fromJson(Map<String, dynamic> json) => Cart(
    itemImage: json['itemImage'] as String,
    itemName: json['itemName'] as String,
    itemPrice: json['itemPrice'] as int,
    itemUnit: json['itemUnit'] as String,
    itemSubCat: json['itemSubCat'] ,
    qnt: json['qnt'] as int,
  );
}