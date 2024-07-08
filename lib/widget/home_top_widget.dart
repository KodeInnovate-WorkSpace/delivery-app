//Working
import 'package:flutter/material.dart';
import '../shared/constants.dart';
import '../shared/search_bar.dart';
import 'location_button_widget.dart';

class HomeTop extends StatefulWidget {
  final scaffoldKey;
  const HomeTop({super.key, required this.scaffoldKey});

  @override
  State<HomeTop> createState() => _HomeTopState();
}

class _HomeTopState extends State<HomeTop> {
  @override
  Widget build(BuildContext context) {
    return SliverAppBar(
      pinned: true,
      floating: true,
      expandedHeight: 190.0,
      collapsedHeight: 80,
      elevation: 2,
      backgroundColor: Colors.amberAccent,
      // shape: const ContinuousRectangleBorder(
      //   borderRadius: BorderRadius.only(
      //     bottomLeft: Radius.circular(40),
      //     bottomRight: Radius.circular(40),
      //   ),
      // ),
      flexibleSpace: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 20),
        child: Stack(
          fit: StackFit.expand, // Ensures full-width search bar
          children: [
            FlexibleSpaceBar(
              centerTitle: true,
              background: Column(
                children: [
                  // Head Section
                  const SizedBox(height: 15),
                  Stack(
                    children: [
                      Row(
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const SizedBox(height: 20), // Add SizedBox for spacing
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Text(
                                    'Delivery within ',
                                    style: TextStyle(fontFamily: 'Gilroy-ExtraBold', color: Color(0xff1c1c1c), fontSize: 14),
                                    // style: TextStyle(fontFamily: 'Gilroy-ExtraBold', color: Colors.white, fontSize: 14),
                                  ),
                                  Text(
                                    '$deliveryTime minutes',
                                    style: const TextStyle(fontFamily: 'Gilroy-Black', color: Color(0xff1c1c1c), fontSize: 28),
                                    // style: const TextStyle(fontFamily: 'Gilroy-Black', color: Colors.white, fontSize: 28),
                                  ),
                                  LocationButton(scaffoldKey: widget.scaffoldKey),
                                  const SizedBox(height: 18),
                                ],
                              ),
                            ],
                          ),
                          //const SizedBox(width: 90),
                        ],
                      ),
                      Positioned(
                        top: 27,
                        right: 0,
                        child: GestureDetector(
                          onTap: () {
                            Navigator.pushNamed(context, '/profile');
                          },
                          child: Image.asset(
                            "assets/images/profile_photo.png",
                            width: 40,
                          ),
                        ),
                      )
                    ],
                  ),
                ],
              ),
            ),
            //Search Bar
            Positioned(
              // Position the search bar with some bottom padding
              bottom: 0.0, // Adjust padding as needed
              left: 0,
              right: 0,
              child: searchBar(context),
            ),
          ],
        ),
      ),
    );
  }
}
