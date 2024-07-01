class MyOrder {
  final String orderId;
  final String productName;
  final String productImage;
  final int quantity;
  final double price;
  final double totalPrice;
  final String paymentMode;
  final String address;
  final String phone;
  int status;

  MyOrder({
    required this.orderId,
    required this.productName,
    required this.productImage,
    required this.quantity,
    required this.price,
    required this.totalPrice,
    required this.paymentMode,
    required this.address,
    required this.phone,
    this.status = 0,
  });

  MyOrder copyWith({
    String? orderId,
    int? status,
    required String phone,
  }) {
    return MyOrder(
      orderId: orderId ?? this.orderId,
      productName: productName,
      productImage: productImage,
      quantity: quantity,
      price: price,
      totalPrice: totalPrice,
      paymentMode: paymentMode,
      address: address,
      status: status ?? this.status,
      phone: this.phone,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'orderId': orderId,
      'productName': productName,
      'productImage': productImage,
      'quantity': quantity,
      'price': price,
      'totalPrice': totalPrice,
      'paymentMode': paymentMode,
      'address': address,
      'status': status,
      'phone': phone,
    };
  }

  factory MyOrder.fromMap(Map<String, dynamic> map) {
    return MyOrder(
      orderId: map['orderId'],
      productName: map['productName'],
      productImage: map['productImage'],
      quantity: map['quantity'],
      price: map['price'],
      totalPrice: map['totalPrice'],
      paymentMode: map['paymentMode'],
      address: map['address'],
      status: map['status'],
      phone: map['phone'],
    );
  }
}
