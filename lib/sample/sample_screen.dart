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
              fetchSubCategory();
              fetchProducts();
            },
            child: const Text("Click"),
          )),
    );
  }

  Future<void> fetchCategory() async {
    try {
      final snapshot =
      await FirebaseFirestore.instance.collection("category").get();

      // fetches with where()
      // if (snapshot.docs.isNotEmpty) {
      //   for (var doc in snapshot.docs) {
      //     final data = doc.data();
      //     final catId = data['category_id'];
      //     final catName = data['category_name'];
      //     log("Category: \n ID: $catId | Name: $catName");
      //   }
      // } else {
      //   log("Category not present");
      // }
      // fetches: collection -> doc -> all
      // all the documents are fetched
      if (snapshot.docs.isNotEmpty) {
        for (var doc in snapshot.docs) {
          final data = doc.data();
          final catId = data['category_id'];
          final catName = data['category_name'];
          log("Category: \n ID: $catId | Name: $catName");
        }
      } else {
        log("Document does not exist.");
      }
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

  Future<void> fetchSubCategory() async {
    try {
      final subSnapshot =
      await FirebaseFirestore.instance.collection("sub_category").get();

      if (subSnapshot.docs.isNotEmpty) {
        for (var doc in subSnapshot.docs) {
          final data = doc.data();
          final subCatId = data['sub_category_id'];
          final catId = data['category_id'];
          final subCatName = data['sub_category_name'];
          log(
              "Sub-Category \n ID: $subCatId | Name: $subCatName | Cat Id: $catId");
        }
      } else {
        log("No Sub-Category Document Found!");
      }
    } catch (e) {
      log("No sub-category fetched: $e");
    }
  }


  Future<void> fetchProducts() async {
    try {
      final subSnapshot =
      await FirebaseFirestore.instance.collection("products").get();

      if (subSnapshot.docs.isNotEmpty) {
        for (var doc in subSnapshot.docs) {
          final data = doc.data();
          final proid = data['id'];
          final proimage = data['image'];
          final proname = data['name'];
          final proprice = data['price'];
          final prostock = data['stock'];
          final prosubid  = data['sub_category_id'];
          final prounit = data['unit'];
          log(
              "Product \n ID: $proid | Image: $proimage | Name: $proname | Price : $proprice | Stock : $prostock | Sub_ID : $prosubid | Unit : $prounit");
        }
      } else {
        log("No Product Document Found!");
      }
    } catch (e) {
      log("No products fetched: $e");
    }
  }
}
