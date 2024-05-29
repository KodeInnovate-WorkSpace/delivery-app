import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class SampleScreen extends StatefulWidget {
  const SampleScreen({super.key});

  @override
  State<SampleScreen> createState() => _SampleScreenState();
}

class _SampleScreenState extends State<SampleScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
          child: ElevatedButton(
        onPressed: () async {
          fetchCategory();
        },
        child: const Text("Click"),
      )),
    );
  }

  Future<void> fetchCategory() async {
    try {
      final snapshot = await FirebaseFirestore.instance
          .collection("category")
          .where('category_id', isEqualTo: 3)
          .get();

      // fetches with where()
      if(snapshot.docs.isNotEmpty) {
        for (var doc in snapshot.docs) {
          final data = doc.data();
          final catId = data['category_id'];
          final catName = data['category_name'];
          log("Category: \n ID: $catId | Name: $catName");
        }
      }else{
        log("Category not present");
      }
      // fetches: collection -> doc -> all
      // all the documents are fetched
      // if (snapshot.docs.isNotEmpty) {
      //   for (var doc in snapshot.docs) {
      //     final data = doc.data();
      //     final catId = data['category_id'];
      //     final catName = data['category_name'];
      //     log("Category: \n ID: $catId | Name: $catName");
      //   }
      // } else {
      //   log("Document does not exist.");
      // }
      // fetches collection -> doc('specific id') -> fields
      // fetches a particular doc with doc id
      // if (snapshot.exists) {
      //   final data = snapshot.data();
      //   final catId = data?['category_id'];
      //   final catName = data?['category_name'];
      //   log("Category: \n ID: $catId | Name: $catName");
      // } else {
      //   log("Document does not exist.");
      // }
    } catch (e) {
      log("Error fetching category: $e");
    }
  }
}
