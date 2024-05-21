class User {
  final String uid; // Firebase user ID
  final String phoneNum;
  final String? address; // Add optional address field

  User({required this.uid, required this.phoneNum, this.address});
}
