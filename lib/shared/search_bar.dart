import 'dart:async';

import 'package:flutter/material.dart';

class ProductIterator {
  final List<String> products;
  Stream<String>? currentProductStream;

  ProductIterator(this.products) {
    currentProductStream = Stream.periodic(const Duration(seconds: 2)).map((_) => products[(++currentIndex) % products.length]);
    currentIndex = 0;
  }

  int currentIndex = 0;
}

Widget searchBar(BuildContext context) {
  List<String> products = ["Coconut", "Vicks Action 500", "Garam Masala", "Lal Mirch", "Refined Oil"];
  final productIterator = ProductIterator(products);

  return StreamBuilder<String>(
    stream: productIterator.currentProductStream,
    builder: (context, snapshot) {
      if (snapshot.hasData) {
        return GestureDetector(
          onTap: () {
            Navigator.pushNamed(context, '/search');
          },
          child: AbsorbPointer(
            child: TextField(
              cursorColor: Colors.black,
              decoration: InputDecoration(
                hintText: 'Search for \'${snapshot.data!}\'',
                hintStyle: const TextStyle(color: Colors.grey),
                filled: true,
                fillColor: Colors.white,
                enabledBorder: OutlineInputBorder(
                  borderRadius: const BorderRadius.all(Radius.circular(5.0)),
                  borderSide: BorderSide(color: Colors.grey.shade300),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: const BorderRadius.all(Radius.circular(5.0)),
                  borderSide: BorderSide(color: Colors.grey[300]!),
                ),
                contentPadding: const EdgeInsets.symmetric(horizontal: 15),
                prefixIcon: const Icon(
                  Icons.search,
                ),
              ),
              style: const TextStyle(color: Colors.black),
            ),
          ),
        );
      } else {
        return const SizedBox();
      }
    },
  );
}
