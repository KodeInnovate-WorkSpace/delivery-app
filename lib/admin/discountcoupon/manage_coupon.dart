import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:speedy_delivery/admin/discountcoupon/update_coupon.dart';

import 'edit_coupon.dart';

class MainDisplayScreen extends StatelessWidget {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Offers'),
      ),
      body: StreamBuilder(
        stream: _firestore.collection('offers').snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }
          var offers = snapshot.data!.docs;
          return ListView.builder(
            itemCount: offers.length,
            itemBuilder: (context, index) {
              var offer = offers[index];
              var offerImage = offer['image'] ?? '';
              return Card(
                margin: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
                child: ListTile(
                  contentPadding: const EdgeInsets.all(16.0),
                  leading: offerImage.isNotEmpty
                      ? Image.network(
                    offerImage,
                    width: 50,
                    height: 50,
                    fit: BoxFit.cover,
                  )
                      : null,
                  title: Text(
                    offer['offerName'],
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  subtitle: Text('Discount: ${offer['discount']}%'),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        icon: const Icon(Icons.edit),
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => UpdateOfferScreen(offerId: offer.id),
                            ),
                          );
                        },
                      ),
                      IconButton(
                        icon: const Icon(Icons.delete),
                        onPressed: () async {
                          await _firestore.collection('offers').doc(offer.id).delete();
                        },
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => AddOfferScreen()),
          );
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
