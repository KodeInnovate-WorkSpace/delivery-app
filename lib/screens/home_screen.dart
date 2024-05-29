import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:speedy_delivery/screens/profile_screen.dart';
import '../providers/category_provider.dart';
import '../shared/search_bar.dart';
import '../widget/category_widget.dart';
import '../widget/location_button_widget.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  HomeScreenState createState() => HomeScreenState();
}

class HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<CategoryProvider>(context, listen: false).fetchCategories();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 30),
        child: Column(
          children: [
            Row(
              children: [
                const Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: 20), // Add SizedBox for spacing
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Delivery in ',
                          style: TextStyle(
                              fontFamily: 'Gilroy-ExtraBold',
                              color: Colors.black,
                              fontSize: 12),
                        ),
                        Text(
                          '7 minutes',
                          style: TextStyle(
                              fontFamily: 'Gilroy-Black',
                              color: Colors.black,
                              fontSize: 28),
                        ),
                        LocationButton(),
                        SizedBox(
                          height: 18,
                        ),
                      ],
                    ),
                    // Location Button
                  ],
                ),
                const SizedBox(
                  width: 90,
                ),
                GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const ProfilePage()),
                    );
                  },
                  child: Image.asset(
                    "assets/images/profile_photo.png",
                    width: 40,
                  ),
                ),
              ],
            ),
            // Search bar
            searchBar(),
            const Expanded(
              child: SingleChildScrollView(
                child: Column(
                  // crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    SizedBox(height: 20),
                    SizedBox(height: 20),
                    CategoryWidget(),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
