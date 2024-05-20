import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:speedy_delivery/shared/search_bar.dart';
import '../providers/category_provider.dart';
import '../widget/location_button_widget.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<CategoryProvider>(context, listen: false).fetchCategories();
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        // appBar: AppBar(
        //   title:
        // ),
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15.0),
          child: Column(
            children: [
              const Row(
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(height: 20), // Add SizedBox for spacing
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Delivery in ',
                            style: TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.bold,
                                fontSize: 12),
                          ),
                          Text(
                            '7 minutes',
                            style: TextStyle(
                                fontFamily: 'Gilroy-ExtraBold',
                                color: Colors.black,
                                fontSize: 28),
                          ),
                          LocationButton(),
                        ],
                      ),
                      // Location Button
                    ],
                  ),
                  // ProfileImage(), // Use CircularProfileImageWidget
                ],
              ),
              SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    // SearchBarWidget(),
                    searchBar(),
                    const SizedBox(height: 20),
                    // displayCategory(context),
                    // SnacksAndDrinksSection(), // New Snacks & Drinks Section
                    const SizedBox(height: 20),
                    // Additional content can be added here
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
//
// class SnacksAndDrinksSection extends StatelessWidget {
//   const SnacksAndDrinksSection({super.key});
//
//   @override
//   Widget build(BuildContext context) {
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         const Text(
//           'Snacks & Drinks',
//           style: TextStyle(fontWeight: FontWeight.bold, fontSize: 24),
//         ),
//         SizedBox(height: 10),
//         GridView.count(
//           shrinkWrap: true,
//           crossAxisCount: 4, // Set to 4 to display four images per row
//           childAspectRatio: 0.7, // Adjust this as needed for a better fit
//           physics:
//               NeverScrollableScrollPhysics(), // Prevent grid from scrolling independently
//           children: [
//            categoryItem(image, sub_category_title);
//           ],
//         ),
//       ],
//     );
//   }
// }
//
// class SnacksAndDrinksItem extends StatelessWidget {
//   final String image;
//   final String name;
//
//   const SnacksAndDrinksItem(
//       {super.key, required this.image, required this.name});
//
//   @override
//   Widget build(BuildContext context) {
//     return Column(
//       children: [
//         Card(
//           margin: const EdgeInsets.all(8.0),
//           child: Padding(
//             padding: const EdgeInsets.all(8.0), // Add padding inside the card
//             child: Image.asset(
//               image,
//               width: 70, // Decrease the width for better fit
//               height: 70, // Decrease the height for better fit
//               fit: BoxFit.cover,
//             ),
//           ),
//         ),
//         const SizedBox(height: 5),
//         Text(
//           name,
//           textAlign: TextAlign.center,
//           style: const TextStyle(fontSize: 12), // Adjust text size as needed
//         ),
//       ],
//     );
//   }
// }
