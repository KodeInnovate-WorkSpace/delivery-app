import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class ManageDeliveredShopScreen extends StatefulWidget {
  const ManageDeliveredShopScreen({super.key});

  @override
  State<ManageDeliveredShopScreen> createState() => _ManageDeliveredShopScreenState();
}

class _ManageDeliveredShopScreenState extends State<ManageDeliveredShopScreen> {
  late Stream<QuerySnapshot> _deliveredShopStream;

  @override
  void initState() {
    super.initState();
    _deliveredShopStream = FirebaseFirestore.instance
        .collection('DeliveredShopName')
        .orderBy('timeOfPickup', descending: true)
        .snapshots();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Manage Delivered Shop'),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: _deliveredShopStream,
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.hasError) {
            return const Center(child: Text('Something went wrong'));
          }

          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          return ListView(
            padding: const EdgeInsets.all(8.0),
            children: snapshot.data!.docs.map((DocumentSnapshot document) {
              Map<String, dynamic> data = document.data()! as Map<String, dynamic>;
              List<dynamic> images = data['images'] ?? [];

              return Card(
                margin: const EdgeInsets.symmetric(vertical: 8.0),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10.0),
                ),
                elevation: 4.0,
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      if (images.isNotEmpty)
                        SizedBox(
                          height: 100,
                          child: ListView(
                            scrollDirection: Axis.horizontal,
                            children: images.map((image) {
                              return Padding(
                                padding: const EdgeInsets.only(right: 8.0),
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(8.0),
                                  child: CachedNetworkImage(
                                    imageUrl: image,
                                    width: 80,
                                    height: 80,
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              );
                            }).toList(),
                          ),
                        ),
                      const SizedBox(height: 8.0),
                      Text(
                        'Order ID: ${data['orderId']}',
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16.0,
                        ),
                      ),
                      const SizedBox(height: 4.0),
                      Text('Phone Number: ${data['phoneNumber']}'),
                      const SizedBox(height: 4.0),
                      Text('Shop Name: ${data['shopName']}'),
                      const SizedBox(height: 4.0),
                      Text('Time of Pickup: ${DateFormat('yyyy-MM-dd – kk:mm').format((data['timeOfPickup'] as Timestamp).toDate())}'),
                    ],
                  ),
                ),
              );
            }).toList(),
          );
        },
      ),
    );
  }
}
