// import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';
// import '../providers/category_provider.dart';

// Widget displayCategory(BuildContext context) {
//   return Consumer<CategoryProvider>(
//     builder: (context, categoryProvider, child) {
//       if (categoryProvider.isLoading) {
//         return const Center(
//           child: CircularProgressIndicator(),
//         );
//       }
//
//       if (categoryProvider.categories.isEmpty) {
//         return const Center(
//           child: Text('No categories available'),
//         );
//       }
//
//       return ListView.builder(
//         itemCount: categoryProvider.categories.length,
//         itemBuilder: (context, index) {
//           final category = categoryProvider.categories[index];
//           return Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               Text(
//                 category.name,
//                 style:
//                     const TextStyle(fontWeight: FontWeight.bold, fontSize: 24),
//               ),
//               const SizedBox(height: 10),
//               SizedBox(
//                 height: 200, // Adjust height as needed
//                 child: GridView.count(
//                   crossAxisCount: 4,
//                   childAspectRatio: 0.7,
//                   physics: const NeverScrollableScrollPhysics(),
//                   children: category.subCategories.map((subCategory) {
//                     return categoryItem(subCategory.image, subCategory.name);
//                   }).toList(),
//                 ),
//               ),
//             ],
//           );
//         },
//       );
//     },
//   );
// }
//
// Widget categoryItem(String imageUrl, String title) {
//   return Column(
//     children: [
//       Image.network(
//         imageUrl,
//         fit: BoxFit.cover,
//         height: 100, // Adjust height as needed
//         width: 100, // Adjust width as needed
//       ),
//       Text(title),
//     ],
//   );
// }
