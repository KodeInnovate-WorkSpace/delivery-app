import 'package:flutter/material.dart';
import 'package:speedy_delivery/screens/search_functionality.dart';

Widget searchBar(BuildContext context) {
  return GestureDetector(
    onTap: () {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => SearchPage()), // Replace SearchScreen with your desired screen
      );
    },
    child: AbsorbPointer(
      child: TextField(
        cursorColor: Colors.black,
        decoration: InputDecoration(
          hintText: 'Search for \'product\'',
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
}
