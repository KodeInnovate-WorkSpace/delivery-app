import 'package:flutter/material.dart';

Widget sideNavbar(BuildContext context) {
  return SingleChildScrollView(
    child: Container(
      width: MediaQuery.of(context).size.width / 5,
      decoration: const BoxDecoration(
        color: Colors.white,
      ),
      child: Column(
        children: [
          const SizedBox(
            height: 20,
          ),
          subCategoryInfo(),
          subCategoryInfo(),
          subCategoryInfo(),
          subCategoryInfo(),
          subCategoryInfo(),
          subCategoryInfo(),
          subCategoryInfo(),
          subCategoryInfo(),
        ],
      ),
    ),
  );
}

Widget subCategoryInfo() {
  return Padding(
    padding: const EdgeInsets.all(8.0),
    child: Column(
      children: [
        ClipOval(
          child: Container(
            color: Colors.grey[100], // Background color
            height: 60, // Adjust as per your requirement
            width: 60, // Adjust as per your requirement
            child: Image.network(
              "https://firebasestorage.googleapis.com/v0/b/speedy-app-e17a5.appspot.com/o/images%2Fdoritos.png?alt=media&token=66d73abe-1584-4f70-94be-60180ff4c419",
            ),
          ),
        ),
        const Text(
          "Cheetos",
          textAlign: TextAlign.center,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
      ],
    ),
  );
}
