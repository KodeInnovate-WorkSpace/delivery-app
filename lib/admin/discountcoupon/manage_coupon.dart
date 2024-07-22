import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:speedy_delivery/admin/discountcoupon/update_coupon.dart';

import 'edit_coupon.dart';

class MainDisplayScreen extends StatelessWidget {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  MainDisplayScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Offers',
          style: TextStyle(color: Color(0xffb3b3b3)),
        ),
        elevation: 0,
        backgroundColor: const Color(0xff1a1a1c),
        surfaceTintColor: Colors.transparent,
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: const Icon(
            Icons.keyboard_backspace,
            color: Color(0xffb3b3b3),
          ),
        ),
      ),
      backgroundColor: const Color(0xff1a1a1c),
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
                color: Colors.grey[850],
                elevation: 0,
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
                    style: const TextStyle(color: Color(0xffb3b3b3), fontWeight: FontWeight.bold),
                  ),
                  subtitle: Text(
                    'Discount: ${offer['discount']}%',
                    style: const TextStyle(color: Color(0xffb3b3b3)),
                  ),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        icon: const Icon(
                          Icons.edit,
                          color: Color(0xffb3b3b3),
                        ),
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
                        icon: const Icon(Icons.delete, color: Color(0xffb3b3b3)),
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
        backgroundColor: Colors.black,
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const AddOfferScreen()),
          );
        },
        child: const Icon(
          Icons.add,
          color: Color(0xffb3b3b3),
        ),
      ),
    );
  }
}
