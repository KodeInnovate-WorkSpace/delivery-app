import 'dart:developer';
import 'package:cloud_firestore/cloud_firestore.dart';

int? deliveryTime;
String? appVer;
double? deliveryCharge;
bool? isDeliveryFree;

Future<void> fetchConstantFromFirebase() async {
  try {
    FirebaseFirestore firestore = FirebaseFirestore.instance;

    DocumentSnapshot constantDoc = await firestore.collection('constants').doc("0xK0fWb6SCtRls6k3uwb").get();
    if (constantDoc.exists) {
      deliveryCharge = (constantDoc.get('deliveryCharge') ?? 29).toDouble();
      deliveryTime = (constantDoc.get('deliveryTime') ?? 20);
      appVer = constantDoc.get('app_version');
    } else {
      log('Document does not exist');
    }
  } catch (e) {
    log('Error fetching Constant: $e');
    // Handle error as needed
  }
}

Future<bool> fetchIsDeliveryFree() async {
  final docRef = FirebaseFirestore.instance.collection('constants').doc('0xK0fWb6SCtRls6k3uwb');
  final snapshot = await docRef.get();
  if (snapshot.exists) {
    return snapshot.data()!['isDeliveryFree'] as bool;
  } else {
    print('Error: Document not found in constants collection');
    return false;
  }
}

Stream<DocumentSnapshot> get constantDocumentStream {
  return FirebaseFirestore.instance.collection('constants').doc('0xK0fWb6SCtRls6k3uwb').snapshots();
}
