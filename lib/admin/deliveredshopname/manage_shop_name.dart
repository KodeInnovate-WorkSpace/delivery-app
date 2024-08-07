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
        title: const Text(
          'Manage Delivered Shop',
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
      body: StreamBuilder<QuerySnapshot>(
        stream: _deliveredShopStream,
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.hasError) {
            return const Center(
                child: Text(
                  'Something went wrong',
                  style: TextStyle(color: Color(0xffb3b3b3)),
                ));
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
                color: Colors.grey[850],
                elevation: 0,
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // if (images.isNotEmpty)
                      //   SizedBox(
                      //     height: 100,
                      //     child: ListView(
                      //       scrollDirection: Axis.horizontal,
                      //       children: images.map((image) {
                      //         return Padding(
                      //           padding: const EdgeInsets.only(right: 8.0),
                      //           child: ClipRRect(
                      //             borderRadius: BorderRadius.circular(8.0),
                      //             child: CachedNetworkImage(
                      //               imageUrl: image,
                      //               width: 80,
                      //               height: 80,
                      //               fit: BoxFit.cover,
                      //             ),
                      //           ),
                      //         );
                      //       }).toList(),
                      //     ),
                      //   ),
                      const SizedBox(height: 8.0),
                      Text(
                        'Order ID: ${data['orderId']}',
                        style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16.0, color: Color(0xffb3b3b3)),
                      ),
                      const SizedBox(height: 4.0),
                      Text(
                        'Phone Number: ${data['phoneNumber']}',
                        style: const TextStyle(color: Color(0xffb3b3b3)),
                      ),
                      const SizedBox(height: 4.0),
                      Text(
                        'Shop Name: ${data['shopName']}',
                        style: const TextStyle(color: Color(0xffb3b3b3)),
                      ),
                      const SizedBox(height: 4.0),
                      Text(
                        'Time of Pickup: ${DateFormat('yyyy-MM-dd – kk:mm').format((data['timeOfPickup'] as Timestamp).toDate())}',
                        style: const TextStyle(color: Color(0xffb3b3b3)),
                      ),
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