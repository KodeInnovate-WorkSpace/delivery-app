import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:speedy_delivery/admin/alertlabel/manage_alert_label.dart';
import 'package:speedy_delivery/admin/appmaintenance/app_maintenance_list_screen.dart';
import 'package:speedy_delivery/admin/banner/manage_banner_screen.dart';
import 'package:speedy_delivery/admin/constants/manage_constant.dart';
import 'package:speedy_delivery/admin/deliveredshopname/manage_shop_name.dart';
import 'package:speedy_delivery/admin/discountcoupon/manage_coupon.dart';
import 'package:speedy_delivery/admin/location/manage_location.dart';
import 'package:speedy_delivery/admin/product/manage_product_screen.dart';
import 'package:speedy_delivery/admin/subcategory/manage_sub_category_screen.dart';
import 'package:speedy_delivery/admin/user/manage_user_screen.dart';
import 'package:speedy_delivery/admin/valet/manage_valet_screen.dart';
import '../screens/sign_in_screen.dart';
import 'category/manage_category_screen.dart';

class AdminScreen extends StatelessWidget {
  const AdminScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Admin Panel"),
        actions: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10.0),
            child: IconButton(
              onPressed: () async {
                showDialog(
                    context: context,
                    builder: (context) => AlertDialog(
                          backgroundColor: Colors.white,
                          title: const Text(
                            "Logout",
                            style: TextStyle(fontFamily: 'Gilroy-ExtraBold'),
                          ),
                          content: const Text("Are you sure you want to logout?"),
                          actions: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                TextButton(
                                    onPressed: () => Navigator.of(context).pop(),
                                    child: const Text(
                                      "No",
                                      style: TextStyle(
                                        color: Color(0xffEF4B4B),
                                      ),
                                    )),
                                TextButton(
                                    onPressed: () async {
                                      await FirebaseAuth.instance.signOut();
                                      SharedPreferences prefs = await SharedPreferences.getInstance();
                                      await prefs.remove('isLoggedIn');
                                      Navigator.pushAndRemoveUntil(
                                        context,
                                        MaterialPageRoute(builder: (context) => const SigninScreen()),
                                        (route) => false,
                                      );
                                    },
                                    child: const Text(
                                      "Yes",
                                      style: TextStyle(color: Colors.black),
                                    )),
                              ],
                            )
                          ],
                        ));
              },
              style: ButtonStyle(
                shape: WidgetStateProperty.all<RoundedRectangleBorder>(
                  RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20.0),
                  ),
                ),
                backgroundColor: WidgetStateProperty.resolveWith<Color>(
                  (Set<WidgetState> states) {
                    if (states.contains(WidgetState.disabled)) {
                      return Colors.black.withOpacity(0.3);
                    }
                    return const Color(0xffEF4B4B);
                  },
                ),
              ),
              icon: const Icon(
                Icons.logout,
                color: Colors.white,
                size: 15,
              ),
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: SizedBox(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(
                height: 18,
              ),
              // Manage User
              ElevatedButton(
                style: ButtonStyle(
                  backgroundColor: WidgetStateProperty.all<Color>(Colors.black),
                  shape: WidgetStateProperty.all<RoundedRectangleBorder>(
                    RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                  ),
                  fixedSize: WidgetStateProperty.all<Size>(
                    const Size(260, 50), // Set your desired width and height here
                  ),
                ),
                onPressed: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const ManageUserScreen(),
                      ));
                },
                child: const Text(
                  "Manage Users",
                  style: TextStyle(color: Colors.white, fontSize: 20),
                ),
              ),
              const SizedBox(
                height: 18,
              ),

              // Manage Category
              ElevatedButton(
                style: ButtonStyle(
                  backgroundColor: WidgetStateProperty.all<Color>(Colors.black),
                  shape: WidgetStateProperty.all<RoundedRectangleBorder>(
                    RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                  ),
                  fixedSize: WidgetStateProperty.all<Size>(
                    const Size(260, 50), // Set your desired width and height here
                  ),
                ),
                onPressed: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const ManageCategoryScreen(),
                      ));
                },
                child: const Text(
                  "Manage Categories",
                  style: TextStyle(color: Colors.white, fontSize: 20),
                ),
              ),
              const SizedBox(
                height: 18,
              ),
              // Manage Sub-Category
              ElevatedButton(
                style: ButtonStyle(
                  backgroundColor: WidgetStateProperty.all<Color>(Colors.black),
                  shape: WidgetStateProperty.all<RoundedRectangleBorder>(
                    RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                  ),
                  fixedSize: WidgetStateProperty.all<Size>(
                    const Size(260, 50), // Set your desired width and height here
                  ),
                ),
                onPressed: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const ManageSubCategoryScreen(),
                      ));
                },
                child: const Text(
                  "Manage Sub-Categories",
                  style: TextStyle(color: Colors.white, fontSize: 17),
                  //changed size
                ),
              ),
              const SizedBox(
                height: 18,
              ),

              // Manage Products
              ElevatedButton(
                style: ButtonStyle(
                  backgroundColor: WidgetStateProperty.all<Color>(Colors.black),
                  shape: WidgetStateProperty.all<RoundedRectangleBorder>(
                    RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                  ),
                  fixedSize: WidgetStateProperty.all<Size>(
                    const Size(260, 50), // Set your desired width and height here
                  ),
                ),
                onPressed: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                        // builder: (context) => const ManageProductScreen(),
                        builder: (context) => const ManageProduct(),
                      ));
                },
                child: const Text(
                  "Manage Products",
                  style: TextStyle(color: Colors.white, fontSize: 20),
                ),
              ),
              const SizedBox(
                height: 18,
              ),
              ElevatedButton(
                style: ButtonStyle(
                  backgroundColor: WidgetStateProperty.all<Color>(Colors.black),
                  shape: WidgetStateProperty.all<RoundedRectangleBorder>(
                    RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                  ),
                  fixedSize: WidgetStateProperty.all<Size>(
                    const Size(260, 50), // Set your desired width and height here
                  ),
                ),
                onPressed: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const ManageBannerScreen(),
                      ));
                },
                child: const Text(
                  "Manage Banner",
                  style: TextStyle(color: Colors.white, fontSize: 20),
                ),
              ),

              const SizedBox(
                height: 18,
              ),

              //Assign Valet
              ElevatedButton(
                style: ButtonStyle(
                  backgroundColor: WidgetStateProperty.all<Color>(Colors.black),
                  shape: WidgetStateProperty.all<RoundedRectangleBorder>(
                    RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                  ),
                  fixedSize: WidgetStateProperty.all<Size>(
                    const Size(260, 50), // Set your desired width and height here
                  ),
                ),
                onPressed: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const ManageValetScreen(),
                      ));
                },
                child: const Text(
                  "Manage Orders",
                  style: TextStyle(color: Colors.white, fontSize: 20),
                ),
              ),
              const SizedBox(
                height: 18,
              ),

              //Manage App enabled
              ElevatedButton(
                style: ButtonStyle(
                  backgroundColor: WidgetStateProperty.all<Color>(Colors.black),
                  shape: WidgetStateProperty.all<RoundedRectangleBorder>(
                    RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                  ),
                  fixedSize: WidgetStateProperty.all<Size>(
                    const Size(260, 50), // Set your desired width and height here
                  ),
                ),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => AppMaintenanceListScreen(),
                    ),
                  );
                },
                child: const Align(
                  alignment: Alignment.center, // Adjust alignment as needed
                  child: Text(
                    "Manage App Enabled",
                    style: TextStyle(color: Colors.white, fontSize: 20),
                  ),
                ),
              ),
              const SizedBox(
                height: 18,
              ),
              ElevatedButton(
                style: ButtonStyle(
                  backgroundColor: WidgetStateProperty.all<Color>(Colors.black),
                  shape: WidgetStateProperty.all<RoundedRectangleBorder>(
                    RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                  ),
                  fixedSize: WidgetStateProperty.all<Size>(
                    const Size(260, 50), // Set your desired width and height here
                  ),
                ),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => LocationListScreen(),
                    ),
                  );
                },
                child: const Align(
                  alignment: Alignment.center, // Adjust alignment as needed
                  child: Text(
                    "Manage Location",
                    style: TextStyle(color: Colors.white, fontSize: 20),
                  ),
                ),
              ),
              const SizedBox(
                height: 18,
              ),
              ElevatedButton(
                style: ButtonStyle(
                  backgroundColor: WidgetStateProperty.all<Color>(Colors.black),
                  shape: WidgetStateProperty.all<RoundedRectangleBorder>(
                    RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                  ),
                  fixedSize: WidgetStateProperty.all<Size>(
                    const Size(260, 50), // Set your desired width and height here
                  ),
                ),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => AlertLabelListScreen(),
                    ),
                  );
                },
                child: const Align(
                  alignment: Alignment.center, // Adjust alignment as needed
                  child: Text(
                    "Manage Alert Label",
                    style: TextStyle(color: Colors.white, fontSize: 20),
                  ),
                ),
              ),
              const SizedBox(
                height: 18,
              ),
              ElevatedButton(
                style: ButtonStyle(
                  backgroundColor: WidgetStateProperty.all<Color>(Colors.black),
                  shape: WidgetStateProperty.all<RoundedRectangleBorder>(
                    RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                  ),
                  fixedSize: WidgetStateProperty.all<Size>(
                    const Size(260, 50), // Set your desired width and height here
                  ),
                ),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => MainDisplayScreen(),
                    ),
                  );
                },
                child: const Align(
                  alignment: Alignment.center, // Adjust alignment as needed
                  child: Text(
                    "Manage Coupon",
                    style: TextStyle(color: Colors.white, fontSize: 20),
                  ),
                ),
              ),
              const SizedBox(
                height: 18,
              ),
              ElevatedButton(
                style: ButtonStyle(
                  backgroundColor: WidgetStateProperty.all<Color>(Colors.black),
                  shape: WidgetStateProperty.all<RoundedRectangleBorder>(
                    RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                  ),
                  fixedSize: WidgetStateProperty.all<Size>(
                    const Size(260, 50), // Set your desired width and height here
                  ),
                ),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ConstantsListScreen(),
                    ),
                  );
                },
                child: const Align(
                  alignment: Alignment.center, // Adjust alignment as needed
                  child: Text(
                    "Manage Constants",
                    style: TextStyle(color: Colors.white, fontSize: 20),
                  ),
                ),
              ),
              const SizedBox(
                height: 18,
              ),
              ElevatedButton(
                style: ButtonStyle(
                  backgroundColor: WidgetStateProperty.all<Color>(Colors.black),
                  shape: WidgetStateProperty.all<RoundedRectangleBorder>(
                    RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                  ),
                  fixedSize: WidgetStateProperty.all<Size>(
                    const Size(260, 50), // Set your desired width and height here
                  ),
                ),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const ManageDeliveredShopScreen(),
                    ),
                  );
                },
                child: const Align(
                  alignment: Alignment.center, // Adjust alignment as needed
                  child: Text(
                    "See ShopNames",
                    style: TextStyle(color: Colors.white, fontSize: 20),
                  ),
                ),
              ),
              const SizedBox(
                height: 18,
              ),
              //first part
            ],
          ),
        ),
      ),
    );
  }
}
