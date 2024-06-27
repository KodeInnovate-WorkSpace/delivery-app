import 'dart:developer';
import 'package:cloud_firestore/cloud_firestore.dart';

int? deliveryTime;

String? appVer;

double? deliveryCharge;
double? handlingCharge;

Future<void> fetchConstantFromFirebase() async {
  try {
    // Access Firestore instance
    FirebaseFirestore firestore = FirebaseFirestore.instance;

    // Access 'Constant' collection and retrieve document
    DocumentSnapshot constantDoc = await firestore
        .collection('constants')
        .doc("0xK0fWb6SCtRls6k3uwb")
        .get();

    // Check if the document exists and fetch values
    if (constantDoc.exists) {
      // Assuming 'deliveryCharge' and 'handlingCharge' are fields in your document
      deliveryCharge = (constantDoc.get('deliveryCharge') ?? 29).toDouble();
      handlingCharge = (constantDoc.get('handlingCharge') ?? 1.85).toDouble();
      deliveryTime = constantDoc.get('deliveryTime');
      appVer = constantDoc.get('app_version');
      // Now you can use these values as needed in your app
      log('Delivery Charge: $deliveryCharge');
      log('Handling Charge: $handlingCharge');
      log('Delivery Time: $deliveryTime');
      log('Version: $appVer');
    } else {
      log('Document does not exist');
    }
  } catch (e) {
    log('Error fetching Constant: $e');
    // Handle error as needed
  }
}
