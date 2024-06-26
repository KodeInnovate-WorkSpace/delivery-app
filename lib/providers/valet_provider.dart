import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:url_launcher/url_launcher.dart';

class ValetProvider extends ChangeNotifier {
  String? valetName ;
  String? valetPhone ;

  ValetProvider() {
    fetchValetDetails();
  }

  Future<void> fetchValetDetails() async {
    try {
      QuerySnapshot querySnapshot = await FirebaseFirestore.instance
          .collection('users')
          .where('type', isEqualTo: 2)
          .get();

      if (querySnapshot.docs.isNotEmpty) {
        DocumentSnapshot doc = querySnapshot.docs.first;
        valetName = doc['name'] ?? 'No name available';
        valetPhone = doc['phone'] ?? 'No phone number available';
        notifyListeners();
      }
    } catch (e) {
      log('Error fetching valet details: $e');
    }
  }

  Widget buildValetDetailsTable() {
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
          Row(
            children: [
              const Text(
                "Name: ",
                style: TextStyle(
                  fontSize: 16,
                ),
              ),
              Text("${valetName!.isEmpty ? "Name Unavailable" : valetName}" , style: const TextStyle(fontSize: 16)),
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
}