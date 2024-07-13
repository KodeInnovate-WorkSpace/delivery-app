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
    _deliveredShopStream = FirebaseFirestore.instance.collection('DeliveredShopName').snapshots();
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
            return const Text('Something went wrong');
          }

          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          return ListView(
            children: snapshot.data!.docs.map((DocumentSnapshot document) {
              Map<String, dynamic> data = document.data()! as Map<String, dynamic>;
              List<dynamic> images = data['images'] ?? [];

              return Card(
                child: ListTile(
                  leading: images.isNotEmpty
                      ? SizedBox(
                    width: 100, // Adjust width as needed
                    child: Wrap(
                      spacing: 5.0, // Adjust spacing as needed
                      children: images.map((image) {
                        return SizedBox(
                          width: 50, // Adjust width as needed
                          child: CachedNetworkImage(imageUrl: image),
                        );
                      }).toList(),
                    ),
                  )
                      : null,
                  title: Text('Order ID: ${data['orderId']}'),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Phone Number: ${data['phoneNumber']}'),
                      Text('Shop Name: ${data['shopName']}'),
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
