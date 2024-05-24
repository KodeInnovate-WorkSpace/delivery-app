import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/auth_provider.dart';
import '../providers/product_provider.dart';

class DemoPage extends StatelessWidget {
  const DemoPage({super.key});

  @override
  Widget build(BuildContext context) {
    final productProvider =
        Provider.of<ProductProvider>(context, listen: false);
    return Scaffold(
      appBar: AppBar(
        title: const Text("Products"),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Center(child: Text("Products")),
          Consumer<ProductProvider>(
            builder: (ctx, provider, child) {
              if (provider.isLoading) {
                return const CircularProgressIndicator();
              } else if (provider.products.isEmpty) {
                return const Text("No products found");
              } else {
                return ListView.builder(
                  shrinkWrap: true,
                  itemCount: provider.products.length,
                  itemBuilder: (ctx, index) {
                    return ListTile(
                      title: Text(provider.products[index].name),
                    );
                  },
                );
              }
            },
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          productProvider.fetchProducts(context);
          fetchUserData(context);
        },
        child: const Icon(Icons.refresh),
      ),
    );
  }
}

Future<void> fetchUserData(BuildContext context) async {
  final authProvider = Provider.of<AuthProvider>(context, listen: false);

  try {
    FirebaseFirestore db = FirebaseFirestore.instance;
    // String phoneNumber =
    //     authProvider.phone; // Replace with the actual phone number
    String phoneNumber = "7977542667";
    QuerySnapshot querySnapshot = await db
        .collection("users")
        .where("phone", isEqualTo: phoneNumber)
        .get();

    if (querySnapshot.docs.isNotEmpty) {
      DocumentSnapshot document = querySnapshot.docs.first;
      String p = document.get("phone");
      // Extract other relevant fields as needed.
      log("User found: $p");
    } else {
      log("Message: User not found");
    }
  } catch (e) {
    log("Error fetching user data: $e");
  }
}
