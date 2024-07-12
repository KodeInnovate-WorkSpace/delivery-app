import 'dart:developer';
import 'package:cloud_firestore/cloud_firestore.dart';

int? deliveryTime;

String? appVer;

double? deliveryCharge;
// double? handlingCharge;
bool? isDeliveryFree;

Future<void> fetchConstantFromFirebase() async {
  try {
    FirebaseFirestore firestore = FirebaseFirestore.instance;

    DocumentSnapshot constantDoc = await firestore.collection('constants').doc("0xK0fWb6SCtRls6k3uwb").get();

    // Check if the document exists and fetch values
    if (constantDoc.exists) {
      deliveryCharge = (constantDoc.get('deliveryCharge') ?? 29).toDouble();
      deliveryTime = (constantDoc.get('deliveryTime') ?? 20);
      appVer = constantDoc.get('app_version');
      isDeliveryFree = constantDoc.get('isDeliveryFree');
    } else {
      log('Document does not exist');
    }
  } catch (e) {
    log('Error fetching Constant: $e');
    // Handle error as needed
  }
}

Stream<DocumentSnapshot> get constantDocumentStream {
  return FirebaseFirestore.instance.collection('constants').doc('0xK0fWb6SCtRls6k3uwb').snapshots();
}
