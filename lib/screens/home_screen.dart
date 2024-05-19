import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:speedy_delivery/shared/search_bar.dart';
import '../providers/location_provider.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    super.initState();
    final locationProvider =
        Provider.of<LocationProvider>(context, listen: false);
    locationProvider.initCurrentLocation();
  }

  @override
  Widget build(BuildContext context) {
    final locationProvider = Provider.of<LocationProvider>(context);
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        children: [
          // top part
          Container(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height / 3.5,
            decoration: const BoxDecoration(
                // color: Colors.amberAccent,
                ),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 18.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text("Delivery in",
                              style: TextStyle(
                                  fontSize: 13, fontWeight: FontWeight.bold)),
                          const Text("9 minutes",
                              style: TextStyle(
                                fontFamily: "Gilroy-Heavy",
                                fontSize: 30,
                              )),
                          GestureDetector(
                            onTap: () => locationProvider.initCurrentLocation(),
                            child: Expanded(
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    locationProvider.address.isEmpty
                                        ? 'Loading address...'
                                        : locationProvider.address,
                                    style: const TextStyle(fontSize: 16),
                                  ),
                                  GestureDetector(
                                      onTap: () {
                                        ScaffoldMessenger.of(context)
                                            .showSnackBar(const SnackBar(
                                          content: Text(
                                            "Dropdown clicked",
                                          ),
                                          showCloseIcon: true,
                                          duration: Duration(milliseconds: 500),
                                        ));
                                      },
                                      child: const Icon(Icons.arrow_drop_down)),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                      GestureDetector(
                          onTap: () async {},
                          child: Image.asset(
                            "assets/images/people.png",
                            width: 26,
                            height: 26,
                          )),
                    ],
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  // Search Bar
                  searchBar(),
                ],
              ),
            ),
          ),
          // card section
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: [
                const SizedBox(
                  width: 10,
                ),
                Card(
                    elevation: 4.0,
                    child: Column(
                      children: [
                        Container(
                          height: 150.0,
                          width: 250,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(50),
                          ),
                          child: Ink.image(
                            image: const NetworkImage(
                                'https://source.unsplash.com/random/800x600?house'),
                            fit: BoxFit.cover,
                          ),
                        ),
                      ],
                    )),
                const SizedBox(
                  width: 10,
                ),
                Card(
                    elevation: 4.0,
                    child: Column(
                      children: [
                        Container(
                          height: 150.0,
                          width: 250,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(50),
                          ),
                          child: Ink.image(
                            image: const NetworkImage(
                                'https://source.unsplash.com/random/800x600?house'),
                            fit: BoxFit.cover,
                          ),
                        ),
                      ],
                    )),
                const SizedBox(
                  width: 10,
                ),
                Card(
                    elevation: 4.0,
                    child: Column(
                      children: [
                        Container(
                          height: 150.0,
                          width: 250,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(50),
                          ),
                          child: Ink.image(
                            image: const NetworkImage(
                                'https://source.unsplash.com/random/800x600?house'),
                            fit: BoxFit.cover,
                          ),
                        ),
                      ],
                    )),
                const SizedBox(
                  width: 10,
                ),
                Card(
                    elevation: 4.0,
                    child: Column(
                      children: [
                        Container(
                          height: 150.0,
                          width: 250,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(50),
                          ),
                          child: Ink.image(
                            image: const NetworkImage(
                                'https://source.unsplash.com/random/800x600?house'),
                            fit: BoxFit.cover,
                          ),
                        ),
                      ],
                    )),
                const SizedBox(
                  width: 10,
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
