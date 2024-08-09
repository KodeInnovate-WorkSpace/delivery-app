import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:googleapis/datamigration/v1.dart';
import '../offerScreen/offerCategory_Screen.dart';
import 'offerProductCard.dart';

Widget buildOfferSection() {
  return SliverList(
    delegate: SliverChildBuilderDelegate(
      (BuildContext context, int index) {
        return Padding(
          padding: const EdgeInsets.only(left: 15.0, right: 15, bottom: 20),
          child: StreamBuilder<QuerySnapshot>(
            stream: FirebaseFirestore.instance.collection("offerCategory").where('status', isEqualTo: 1).snapshots(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(
                  child: CircularProgressIndicator(
                    color: Colors.black,
                  ),
                );
              } else if (snapshot.hasError) {
                return const SizedBox.shrink();
              } else if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                return const SizedBox.shrink();
              } else {
                final offerCategories = snapshot.data!.docs;

                return Column(
                  children: offerCategories.map((offerCat) {
                    final data = offerCat.data() as Map<String, dynamic>;
                    final name = data['name'] ?? "Buy 1 Get 1 Free";
                    int categoryId = data['id'];

                    final textColor = data['textColor'];
                    final buttonColor = data['buttonColor'];

                    // Convert hex string to Color object
                    Color colorFromHex(String hexString) {
                      final buffer = StringBuffer();
                      if (hexString.length == 6 || hexString.length == 7) {
                        buffer.write('ff'); // Add alpha value if not present
                        buffer.write(hexString.replaceAll('#', ''));
                      } else if (hexString.length == 8 || hexString.length == 9) {
                        buffer.write(hexString.replaceAll('#', ''));
                      }
                      return Color(int.parse(buffer.toString(), radix: 16));
                    }

                    return GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => OfferCategoryScreen(
                              categoryTitle: name,
                              categoryID: categoryId,
                            ),
                          ),
                        );
                      },
                      child: Container(
                        decoration: BoxDecoration(
                          image: DecorationImage(
                            image: CachedNetworkImageProvider(data['categoryImage']),
                            fit: BoxFit.cover,
                          ),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.only(left: 5, right: 5, top: 50, bottom: 0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              name != ""
                                  ? Center(
                                      child: Text(
                                        name,
                                        textAlign: TextAlign.center,
                                        style: const TextStyle(fontSize: 18, fontFamily: "Gilroy-Bold"),
                                      ),
                                    )
                                  : const SizedBox(
                                      height: 25,
                                    ),
                              SizedBox(
                                height: 300, // Adjust height as needed
                                child: offerProductCard(categoryId, name),
                              ),
                              Center(
                                child: Padding(
                                  padding: const EdgeInsets.only(bottom: 15),
                                  child: Container(
                                    decoration: BoxDecoration(color: colorFromHex(buttonColor), borderRadius: const BorderRadius.all(Radius.circular(10))),
                                    width: MediaQuery.of(context).size.width / 1.5,
                                    height: MediaQuery.of(context).size.height / 15,
                                    child: Center(
                                      child: Text(
                                        "See All",
                                        style: TextStyle(fontFamily: 'Gilroy-SemiBold', fontSize: 16, color: colorFromHex(textColor)),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  }).toList(),
                );
              }
            },
          ),
        );
      },
      childCount: 1,
    ),
  );
}
