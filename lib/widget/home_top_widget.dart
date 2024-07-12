import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
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
      elevation: 0,
      backgroundColor: Colors.amberAccent,
      shape: const ContinuousRectangleBorder(
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(40),
          bottomRight: Radius.circular(40),
        ),
      ),
      flexibleSpace: Container(
        // decoration: const BoxDecoration(
        //   gradient: LinearGradient(
        //     begin: Alignment.topRight,
        //     end: Alignment.bottomLeft,
        //     colors: [
        //       Colors.amber,
        //       Colors.amberAccent,
        //       Colors.yellow,
        //     ],
        //   ),
        //   borderRadius: BorderRadius.only(
        //     bottomLeft: Radius.circular(15),
        //     bottomRight: Radius.circular(15),
        //   ),
        // ),
        child: Padding(
          // padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 20),
          padding: const EdgeInsets.only(top: 25, right: 20, bottom: 10, left: 20),
          child: Stack(
            fit: StackFit.expand,
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
                                const SizedBox(height: 20),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const Text(
                                      'Delivery within ',
                                      style: TextStyle(fontFamily: 'Gilroy-ExtraBold', color: Color(0xff1c1c1c), fontSize: 14),
                                    ),
                                    Text(
                                      '$deliveryTime minutes',
                                      style: const TextStyle(fontFamily: 'Gilroy-Black', color: Color(0xff1c1c1c), fontSize: 28),
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
                            child: SvgPicture.asset("assets/images/profile_icon.svg"),
                          ),
                        )
                      ],
                    ),
                  ],
                ),
              ),
              //Search Bar
              Positioned(
                bottom: 0.0, // Adjust padding as needed
                left: 0,
                right: 0,
                child: searchBar(context),
              ),
            ],
          ),
        ),
      ),
    );
  }
}