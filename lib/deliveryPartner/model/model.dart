class AllOrder {
  final String orderId;
  final String address;
  final List<OrderDetail> orders;
  final double overallTotal;
  final String paymentMode;
  final int status;
  final String phone;
  final String time;

  AllOrder({
    required this.orderId,
    required this.address,
    required this.orders,
    required this.overallTotal,
    required this.paymentMode,
    required this.status,
    required this.phone,
    required this.time,
  });
}

class OrderDetail {
  final double price;
  final String productImage;
  final String productName;
  final int quantity;
  final String unit;

  OrderDetail({
    required this.price,
    required this.productImage,
    required this.productName,
    required this.quantity,
    required this.unit,
  });

  factory OrderDetail.fromMap(Map<String, dynamic> data) {
    return OrderDetail(
      price: data['price'] != null ? data['price'].toDouble() : 0.0,
      productImage: data['productImage'] ?? '',
      productName: data['productName'] ?? 'Unknown',
      quantity: data['quantity'] != null ? data['quantity'].toInt() : 0,
      unit: data['unit'] ?? 'Unknown',
    );
  }
}

