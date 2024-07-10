import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:url_launcher/url_launcher.dart';

class ValetProvider extends ChangeNotifier {
  String? valetName;
  String? valetPhone;

  Stream<QuerySnapshot> fetchValetDetails(String orderId) {
    return FirebaseFirestore.instance.collection('OrderHistory').where('orderId', isEqualTo: orderId).snapshots();
  }

  Widget buildValetDetailsTable(String orderId) {
    return StreamBuilder<QuerySnapshot>(
      stream: fetchValetDetails(orderId),
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const CircularProgressIndicator();
        } else if (snapshot.hasError) {
          return Text('Error: ${snapshot.error}');
        } else if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
          return const Text('No valet details available');
        } else {
          DocumentSnapshot doc = snapshot.data!.docs.first;
          valetPhone = doc['valet'] == "" ? 'Unavailable' : doc['valet'];

          return Container(
            padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
            decoration: BoxDecoration(
              color: Colors.grey[200],
              borderRadius: BorderRadius.circular(5.0),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  "Valet Details",
                  style: TextStyle(fontSize: 20, fontFamily: 'Gilroy-ExtraBold'),
                ),
                const SizedBox(height: 8.0),
                // Name
                const Row(
                  children: [
                    Text(
                      "Name: ",
                      style: TextStyle(
                        fontSize: 16,
                      ),
                    ),
                    // Text("${valetName!.isEmpty ? "Name Unavailable" : valetName}", style: const TextStyle(fontSize: 16)),
                    Text("Unavailable", style: TextStyle(fontSize: 16)),
                  ],
                ),
                // Phone
                Row(
                  children: [
                    const Text(
                      "Phone: ",
                      style: TextStyle(
                        fontSize: 16,
                      ),
                    ),
                    GestureDetector(
                      onTap: () async {
                        Uri dialNumber = Uri(scheme: 'tel', path: valetPhone!);
                        await launchUrl(dialNumber);
                      },
                      child: Text(
                        valetPhone!,
                        // style:const TextStyle(fontFamily: 'Gilroy-Bold'),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          );
        }
      },
    );
  }
}
