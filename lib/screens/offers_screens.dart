import 'package:cached_network_image/cached_network_image.dart';
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
        elevation: 0,
        backgroundColor: const Color(0xfff7f7f7),
        surfaceTintColor: Colors.transparent,
      ),
      backgroundColor: const Color(0xfff7f7f7),
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
              String offerImage = offer['image'];
              final status = offer["status"];

              return status == 1
                  ? GestureDetector(
                      onTap: () {
                        Navigator.pop(context, offer);
                      },
                      child: Stack(
                        children: [
                          Card(
                            elevation: 0,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20), // Set the desired border radius
                            ),
                            color: Colors.white,
                            child: offerImage.isNotEmpty ? CachedNetworkImage(imageUrl: offerImage) : Image.asset("assets/images/placeholder_banner.png"),
                          ),
                          // Positioned(
                          //     top: 10,
                          //     left: 20,
                          //     child: Text(
                          //       "$offerName: Rs.$discount Off",
                          //       style: const TextStyle(fontFamily: 'Gilroy-Black', fontSize: 20),
                          //     )),
                        ],
                      ),
                    )
                  : const SizedBox();
            },
          );
        },
      ),
    );
  }
}
