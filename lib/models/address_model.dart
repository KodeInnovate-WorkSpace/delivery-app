class Address {
  final String flat;
  final String floor;
  final String building;
  final String mylandmark;
  final String phoneNumber;
  final int pincode;

  Address({
    required this.flat,
    required this.floor,
    required this.building,
    required this.mylandmark,
    required this.phoneNumber,
    required this.pincode,
  });

  factory Address.fromJson(Map<String, dynamic> json) {
    return Address(
      flat: json['flat'] ?? '',
      floor: json['floor'] ?? '',
      building: json['building'] ?? 'N/A',
      mylandmark: json['mylandmark'] ?? '',
      phoneNumber: json['phoneNumber'] ?? '',
      pincode: json['pincode'] ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'flat': flat,
      'floor': floor,
      'building': building,
      'mylandmark': mylandmark,
      'phoneNumber': phoneNumber,
      'pincode': pincode,
    };
  }
}