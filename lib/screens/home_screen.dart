// New Code
import 'dart:developer';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';
import 'package:speedy_delivery/screens/not_in_location_screen.dart';
import '../widget/network_handler.dart';
import '../models/category_model.dart';
import '../models/product_model.dart';
import '../shared/search_bar.dart';
import '../widget/location_button_widget.dart';
import 'categories_screen.dart';
import 'checkout_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  HomeScreenState createState() => HomeScreenState();
}

class HomeScreenState extends State<HomeScreen> {
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
  final List<Category> categories = [];
  final List<SubCategory> subCategories = [];
  late Future<void> fetchDataFuture;

  // products
  List<Product> products = [];

  @override
  void initState() {
    super.initState();
    fetchDataFuture = fetchData();
    checkLocationService();
  }

  Future<void> fetchData() async {
    await fetchCategory();
    await fetchSubCategory();
  }

  Future<void> fetchCategory() async {
    try {
      final snapshot =
          await FirebaseFirestore.instance.collection("category").get();

      if (snapshot.docs.isNotEmpty) {
        setState(() {
          categories.clear();
          for (var doc in snapshot.docs) {
            final data = doc.data();
            final category = Category(
              id: data['category_id'],
              name: data['category_name'],
              status: data['status'],
            );

            if (category.status == 1) {
              categories.add(category);
            }

            // log("Category: \n ID: ${category.id} | Name: ${category.name}");
          }
        });
      } else {
        log("No Category Document Found!");
      }
    } catch (e) {
      log("Error fetching category: $e");
    }
  }

  Future<void> fetchSubCategory() async {
    try {
      final subSnapshot =
          await FirebaseFirestore.instance.collection("sub_category").get();

      if (subSnapshot.docs.isNotEmpty) {
        setState(() {
          subCategories.clear();
          for (var doc in subSnapshot.docs) {
            final data = doc.data();
            final subCategory = SubCategory(
              id: data['sub_category_id'],
              name: data['sub_category_name'],
              img: data['sub_category_img'],
              catId: data['category_id'],
              status: data['status'],
            );

            if (subCategory.status == 1) {
              subCategories.add(subCategory);
            }

            // fetchProducts();
            // log("Sub-Category \n ID: ${subCategory.id} | Name: ${subCategory.name} | Cat Id: ${subCategory.catId}");
          }
        });
      } else {
        log("No Sub-Category Document Found!");
      }
    } catch (e) {
      log("Error fetching sub-category: $e");
    }
  }

  Future<void> _handleRefresh() async {
    fetchData();
    checkLocationService();
  }

  Future<void> checkLocationService() async {
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      showLocationDialog();
      return;
    }

    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        showLocationDialog();
        return;
      }
    }

    if (permission == LocationPermission.deniedForever) {
      showLocationDialog();
      return;
    }

    // Location services are enabled and permission is granted, get the current location
    Position position = await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.high,
    );
    log("Current Position: ${position.latitude}, ${position.longitude}");

    // Get the placemarks from the coordinates
    List<Placemark> placemarks =
        await placemarkFromCoordinates(position.latitude, position.longitude);
    Placemark place = placemarks[0];
    String subLocality = place.subLocality ?? '';
    String postalCode = place.postalCode ?? '';

    log("SubLocality: $subLocality, PostalCode: $postalCode");

    // Check Firestore for status
    await checkAccess();
  }

  Future<void> checkAccess() async {
    try {
      // Fetch all documents from the "location" collection
      QuerySnapshot querySnapshot =
          await FirebaseFirestore.instance.collection('location').get();

      // Check if there are any documents in the collection
      if (querySnapshot.docs.isNotEmpty) {
        // Get the placemarks from the coordinates
        Position position = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.high,
        );
        List<Placemark> placemarks = await placemarkFromCoordinates(
            position.latitude, position.longitude);
        Placemark place = placemarks[0];
        String subLocality = place.subLocality ?? '';
        int postalCode = int.parse(place.postalCode ?? '');

        // Iterate through each document
        for (DocumentSnapshot document in querySnapshot.docs) {
          // Assuming each document has 'sublocality', 'postal_code', and 'status' fields
          String docSubLocality = document['sublocality'];
          int docPostalCode = document['postal_code'];
          int status = document['status'];

          // Check if the sublocality and postal code match
          if (subLocality == docSubLocality &&
              postalCode == docPostalCode &&
              status == 1) {
            log("Access granted");
            return; // Exit the function if access is granted
          }
        }
        // If no document with matching sublocality, postal code, and status 1 is found
        log("No document with matching sublocality, postal code, and status 1 found in Firestore");
      } else {
        log("No documents found in Firestore");
      }
      // If no document with matching sublocality, postal code, and status 1 is found or no documents are found
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const NotInLocationScreen()),
      );
    } catch (e) {
      log("Error checking access: $e");
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const NotInLocationScreen()),
      );
    }
  }

  void showLocationDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Enable Location'),
          content: const Text('Please enable location services to proceed.'),
          actions: <Widget>[
            TextButton(
              child: const Text('OK'),
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
              },
            ),
          ],
        );
      },
    ).then((_) =>
        checkLocationService()); // Check location service again after dialog is closed
  }

  @override
  Widget build(BuildContext context) {
    return NetworkHandler(
      child: Scaffold(
        key: scaffoldKey,
        body: RefreshIndicator(
          color: Colors.black,
          backgroundColor: Colors.white,
          onRefresh: _handleRefresh,
          child: Stack(
            children: [
              CustomScrollView(
                physics: const BouncingScrollPhysics(),
                slivers: [
                  // Heading
                  SliverAppBar(
                    pinned: true,
                    floating: true,
                    expandedHeight: 190.0,
                    collapsedHeight: 80,
                    elevation: 2,
                    flexibleSpace: Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 15, vertical: 20),
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
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            const SizedBox(
                                                height:
                                                    20), // Add SizedBox for spacing
                                            Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                const Text(
                                                  'Delivery in ',
                                                  style: TextStyle(
                                                      fontFamily:
                                                          'Gilroy-ExtraBold',
                                                      color: Colors.black,
                                                      fontSize: 12),
                                                ),
                                                const Text(
                                                  '7 minutes',
                                                  style: TextStyle(
                                                      fontFamily:
                                                          'Gilroy-Black',
                                                      color: Colors.black,
                                                      fontSize: 28),
                                                ),
                                                LocationButton(
                                                    scaffoldKey: scaffoldKey),
                                                const SizedBox(height: 18),
                                              ],
                                            ),
                                          ],
                                        ),
                                        const SizedBox(width: 90),
                                      ],
                                    ),
                                    Positioned(
                                      top: 27,
                                      right: 0,
                                      child: GestureDetector(
                                        onTap: () {
                                          Navigator.pushNamed(
                                              context, '/profile');
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
                  ),
                  SliverList(
                    delegate: SliverChildBuilderDelegate(
                      (BuildContext context, int index) {
                        return Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 15.0, vertical: 0),
                          child: FutureBuilder<void>(
                            future: fetchDataFuture,
                            builder: (context, snapshot) {
                              if (snapshot.connectionState ==
                                  ConnectionState.waiting) {
                                return const Center(
                                    child: CircularProgressIndicator(
                                  color: Colors.black,
                                ));
                              } else if (snapshot.hasError) {
                                return const Center(child: Text("Error"));
                              } else {
                                return Column(
                                  children: categories.map((category) {
                                    final filteredSubCategories = subCategories
                                        .where((subCategory) =>
                                            subCategory.catId == category.id)
                                        .toList();

                                    return Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Padding(
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 8.0, vertical: 0),
                                          child: Text(
                                            category.name,
                                            style: const TextStyle(
                                              fontSize: 18,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ),
                                        GridView.builder(
                                          shrinkWrap: true,
                                          physics:
                                              const NeverScrollableScrollPhysics(),
                                          itemCount:
                                              filteredSubCategories.length,
                                          gridDelegate:
                                              const SliverGridDelegateWithFixedCrossAxisCount(
                                            crossAxisCount: 4,
                                            childAspectRatio: 0.65,
                                          ),
                                          itemBuilder: (context, subIndex) {
                                            final subCategory =
                                                filteredSubCategories[subIndex];
                                            return Column(
                                              children: [
                                                GestureDetector(
                                                  onTap: () {
                                                    Navigator.push(
                                                      context,
                                                      MaterialPageRoute(
                                                        builder: (context) =>
                                                            CategoryScreen(
                                                          categoryTitle:
                                                              category.name,
                                                          subCategories:
                                                              filteredSubCategories,
                                                          selectedSubCategoryId:
                                                              subCategory
                                                                  .id, // Pass the selected sub-category ID
                                                        ),
                                                      ),
                                                    );
                                                  },
                                                  child: Container(
                                                    width: 100,
                                                    margin: const EdgeInsets
                                                        .symmetric(
                                                        horizontal: 4,
                                                        vertical: 0),
                                                    decoration:
                                                         const BoxDecoration(
                                                      color: Color(0xffeaf1fc),
                                                      borderRadius:
                                                          BorderRadius.all(
                                                              Radius.circular(
                                                                  10)),
                                                    ),
                                                    child: Padding(
                                                      padding:
                                                          const EdgeInsets.all(
                                                              8.0),
                                                      child: CachedNetworkImage(
                                                        height: 60,
                                                        imageUrl:
                                                            subCategory.img,
                                                        placeholder: (context,
                                                                url) =>
                                                            const CircularProgressIndicator(
                                                                color: Colors
                                                                    .amberAccent),
                                                        errorWidget: (context,
                                                                url, error) =>
                                                            const Icon(
                                                                Icons.error),
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                                const SizedBox(height: 6),
                                                // sub-category name
                                                Text(
                                                  subCategory.name,
                                                  textAlign: TextAlign.center,
                                                  style: const TextStyle(
                                                      fontSize: 12),
                                                ),
                                              ],
                                            );
                                          },
                                        ),
                                      ],
                                    );
                                  }).toList(),
                                );
                              }
                            },
                          ),
                        );
                      },
                      childCount: 1, // Adjust as per your needs
                    ),
                  ),
                ],
              ),
              Positioned(
                bottom: 25,
                right: 20,
                child: FloatingActionButton(
                  hoverColor: Colors.transparent,
                  elevation: 2,
                  onPressed: () {
                    HapticFeedback.heavyImpact();

                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const CheckoutScreen()));
                    // Navigator.pushNamed(context, '/checkout');
                  },
                  backgroundColor: Colors.white,
                  child: const Icon(
                    Icons.shopping_cart_sharp,
                    color: Colors.black,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
