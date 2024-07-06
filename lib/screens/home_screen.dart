import 'dart:developer';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';
import 'package:provider/provider.dart';
import 'package:speedy_delivery/screens/not_in_location_screen.dart';
import 'package:speedy_delivery/shared/constants.dart';
import 'package:speedy_delivery/widget/cart_button.dart';
import 'package:speedy_delivery/widget/home_top_widget.dart';
import '../providers/cart_provider.dart';
import '../widget/advertisement_widget.dart';
import '../widget/network_handler.dart';
import '../models/category_model.dart';
import '../models/product_model.dart';
import 'categories_screen.dart';

class HomeScreen extends StatefulWidget {
  final bool temporaryAccess;

  const HomeScreen({super.key, this.temporaryAccess = false});

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

    if (!widget.temporaryAccess) {
      checkLocationService();
    }
    // initialize cart provider for loading cart items
    final initiateCartProvider = Provider.of<CartProvider>(context, listen: false);
    // calling method to load the cart items
    initiateCartProvider.loadCart();

    fetchDataFuture = fetchData();
  }

  Future<void> fetchData() async {
    await fetchCategory();
    await fetchSubCategory();
  }

  Future<void> _handleRefresh() async {
    if (!widget.temporaryAccess) {
      checkLocationService();
    }
    fetchData();
    fetchConstantFromFirebase();
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
    List<Placemark> placemarks = await placemarkFromCoordinates(position.latitude, position.longitude);
    Placemark place = placemarks[0];
    String postalCode = place.postalCode ?? '';

    log("PostalCode: $postalCode");

    // Check Firestore for status
    await checkAccess(postalCode);
  }

  Future<void> checkAccess(String postalCode) async {
    try {
      // Fetch all documents from the "location" collection
      QuerySnapshot querySnapshot = await FirebaseFirestore.instance.collection('location').get();

      // Check if there are any documents in the collection
      if (querySnapshot.docs.isNotEmpty) {
        // Iterate through each document
        for (DocumentSnapshot document in querySnapshot.docs) {
          // Assuming each document has 'postal_code' and 'status' fields
          int docPostalCode = document['postal_code'];
          int status = document['status'];

          // Check if the postal code matches and the status is 1
          if (postalCode == docPostalCode.toString() && status == 1) {
            log("Access granted");
            return; // Exit the function if access is granted
          }
        }
        // If no document with matching postal code and status 1 is found
        log("No document with matching postal code and status 1 found in Firestore");
      } else {
        log("No documents found in Firestore");
      }
      // If no document with matching postal code and status 1 is found or no documents are found
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
    ).then((_) => checkLocationService()); // Check location service again after dialog is closed
  }

  Future<void> fetchCategory() async {
    try {
      final snapshot = await FirebaseFirestore.instance.collection("category").get();

      if (snapshot.docs.isNotEmpty) {
        setState(() {
          categories.clear();
          for (var doc in snapshot.docs) {
            final data = doc.data();
            final category = Category(
              id: data['category_id'],
              name: data['category_name'],
              status: data['status'],
              priority: data['priority'],
            );

            if (category.status == 1) {
              categories.add(category);
            }
          }
          // Sort categories by priority
          categories.sort((a, b) => a.priority.compareTo(b.priority));
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
      final subSnapshot = await FirebaseFirestore.instance.collection("sub_category").get();

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
              // priority: data['priority'], // Ensure priority is included in the model
            );

            if (subCategory.status == 1) {
              subCategories.add(subCategory);
            }
          }
          // Sort subcategories by priority
          // subCategories.sort((a, b) => a.priority.compareTo(b.priority));
        });
      } else {
        log("No Sub-Category Document Found!");
      }
    } catch (e) {
      log("Error fetching sub-category: $e");
    }
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
                  HomeTop(scaffoldKey: scaffoldKey),
                  // Alerts
                  StreamBuilder<QuerySnapshot>(
                    stream: FirebaseFirestore.instance.collection('AlertLabel').snapshots(),
                    builder: (context, snapshot) {
                      if (!snapshot.hasData) {
                        return SliverToBoxAdapter(
                          child: Container(),
                        );
                      }

                      final alerts = snapshot.data!.docs
                          .where((doc) => doc['status'] == 1)
                          .map((doc) => {
                                'message': doc['message'],
                                'color': doc['color'],
                                'textcolor': doc['textcolor'],
                              })
                          .toList();

                      if (alerts.isEmpty) {
                        return SliverToBoxAdapter(child: Container());
                      }
                      return SliverList(
                        delegate: SliverChildBuilderDelegate(
                          (context, index) {
                            final alert = alerts[index];
                            return Container(
                              color: Color(int.parse(alert['color'].replaceFirst('#', '0xff'))),
                              padding: const EdgeInsets.symmetric(vertical: 10),
                              child: Center(
                                child: Text(
                                  alert['message'],
                                  style: TextStyle(
                                    color: Color(int.parse(alert['textcolor'].replaceFirst('#', '0xff'))),
                                    fontSize: 14,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            );
                          },
                          childCount: alerts.length,
                        ),
                      );
                    },
                  ),
                  // Advertisement Widget
                  SliverToBoxAdapter(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 10.0),
                      child: SizedBox(
                        height: MediaQuery.of(context).size.height / 4, // Adjust height as needed
                        child: const AdvertisementWidget(),
                      ),
                    ),
                  ),
                  // Displaying categories
                  SliverList(
                    delegate: SliverChildBuilderDelegate(
                      (BuildContext context, int index) {
                        return Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 0),
                          child: FutureBuilder<void>(
                            future: fetchDataFuture,
                            builder: (context, snapshot) {
                              if (snapshot.connectionState == ConnectionState.waiting) {
                                return const Center(
                                  child: CircularProgressIndicator(
                                    color: Colors.black,
                                  ),
                                );
                              } else if (snapshot.hasError) {
                                return const Center(child: Text("Error"));
                              } else {
                                return Column(
                                  children: categories.map((category) {
                                    final filteredSubCategories = subCategories.where((subCategory) => subCategory.catId == category.id).toList();

                                    return Stack(
                                      children: [
                                        Padding(
                                          padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 0.0), // Reduced vertical padding
                                          child: Row(
                                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                            children: [
                                              Text(
                                                category.name,
                                                style: const TextStyle(fontSize: 18, fontFamily: "Gilroy-Bold"),
                                              ),
                                            ],
                                          ),
                                        ),
                                        GridView.builder(
                                          shrinkWrap: true,
                                          physics: const NeverScrollableScrollPhysics(),
                                          // itemCount: filteredSubCategories.length,
                                          itemCount: 8,
                                          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                                            crossAxisCount: 4,
                                            // childAspectRatio: 0.65,
                                            childAspectRatio: 0.68,
                                          ),
                                          itemBuilder: (context, subIndex) {
                                            final subCategory = filteredSubCategories[subIndex];
                                            return Column(
                                              children: [
                                                GestureDetector(
                                                  onTap: () {
                                                    Navigator.push(
                                                      context,
                                                      MaterialPageRoute(
                                                        builder: (context) => CategoryScreen(
                                                          categoryTitle: category.name,
                                                          subCategories: filteredSubCategories,
                                                          selectedSubCategoryId: subCategory.id, // Pass the selected sub-category ID
                                                        ),
                                                      ),
                                                    );
                                                  },
                                                  child: Container(
                                                    width: 100,
                                                    margin: const EdgeInsets.symmetric(horizontal: 4, vertical: 0), // Reduced vertical margin
                                                    decoration: const BoxDecoration(
                                                      color: Color(0xffeaf1fc),
                                                      borderRadius: BorderRadius.all(Radius.circular(10)),
                                                    ),
                                                    child: Padding(
                                                      padding: const EdgeInsets.all(8.0),
                                                      child: CachedNetworkImage(
                                                        height: 60,
                                                        imageUrl: subCategory.img,
                                                        placeholder: (context, url) => const CircularProgressIndicator(color: Colors.amberAccent),
                                                        errorWidget: (context, url, error) => const Icon(Icons.error),
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                                const SizedBox(height: 4),
                                                // sub-category name
                                                Text(
                                                  subCategory.name,
                                                  textAlign: TextAlign.center,
                                                  style: const TextStyle(fontSize: 12),
                                                ),
                                              ],
                                            );
                                          },
                                        ),

                                        //See all button
                                        Positioned(
                                            left: 0,
                                            right: -265,
                                            top: -10,
                                            child: TextButton(
                                              onPressed: () {
                                                Navigator.push(
                                                  context,
                                                  MaterialPageRoute(
                                                    builder: (context) => CategoryScreen(
                                                      categoryTitle: category.name,
                                                      subCategories: filteredSubCategories,
                                                      selectedSubCategoryId: 0,
                                                    ),
                                                  ),
                                                );
                                              },
                                              style: ButtonStyle(
                                                overlayColor: WidgetStateProperty.all(Colors.transparent), // Removes the hover effect
                                                backgroundColor: WidgetStateProperty.all(Colors.transparent), // Ensures no background color
                                              ),
                                              child: const Text(
                                                "See All",
                                                style: TextStyle(fontSize: 10, fontFamily: "Gilroy-ExtraBold", color: Colors.green),
                                              ),
                                            )),
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
              const CartButton(),
            ],
          ),
        ),
      ),
    );
  }
}
