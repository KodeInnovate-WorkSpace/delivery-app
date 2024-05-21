import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/category_provider.dart';
import '../shared/search_bar.dart';
import '../widget/category_widget.dart';
import '../widget/location_button_widget.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
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
              Expanded(
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

                    // Use Consumer to listen to CategoryProvider and display CategoryWidget
                    CategoryWidget(),
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
