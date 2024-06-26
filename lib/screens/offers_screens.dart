import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class OffersScreens extends StatefulWidget {
  const OffersScreens({super.key});

  @override
  State<OffersScreens> createState() => _OffersScreensState();
}

class _OffersScreensState extends State<OffersScreens> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Apply Coupon"),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance.collection('offers').snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return const Center(child: Text('Error fetching offers'));
          }

          final offers = snapshot.data!.docs;

          return ListView.builder(
            itemCount: offers.length,
            itemBuilder: (context, index) {
              final offer = offers[index];
              final offerName = offer['offerName'];
              final discount = offer['discount'];

              return ListTile(
                title: Text(offerName),
                subtitle: Text('Discount: $discount%'),
                onTap: () {
                  Navigator.pop(context, offer);
                },
              );
            },
          );
        },
      ),
    );
  }
}
