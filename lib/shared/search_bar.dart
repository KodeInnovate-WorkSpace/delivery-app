import 'dart:async';

import 'package:flutter/material.dart';

class ProductIterator {
  final List<String> products;
  late StreamController<String> _controller;
  late Stream<String> currentProductStream;
  int currentIndex = 0;

  ProductIterator(this.products) {
    _controller = StreamController<String>();
    currentProductStream = _controller.stream;
    Timer.periodic(const Duration(seconds: 2), (_) {
      _controller.add(products[(++currentIndex) % products.length]);
    });
    // Emit the first product immediately
    _controller.add(products[currentIndex]);
  }
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
                hintText: 'Search for "${snapshot.data!}"',
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
