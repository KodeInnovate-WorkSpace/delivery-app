class AllOrder {
  final String orderId;
  final String address;
  final List<OrderDetail> orders;
  final double overallTotal;
  final String paymentMode;
  final int status;
  final String phone;

  AllOrder({
    required this.orderId,
    required this.address,
    required this.orders,
    required this.overallTotal,
    required this.paymentMode,
    required this.status,
    required this.phone,
  });
}

class OrderDetail {
  final double price;
  final String productImage;
  final String productName;
  final int quantity;
  // final double totalPrice;

  OrderDetail({
    required this.price,
    required this.productImage,
    required this.productName,
    required this.quantity,
    // required this.totalPrice,
  });
}