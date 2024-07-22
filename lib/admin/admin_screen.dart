import 'dart:developer';
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
import '../screens/sign_in_screen.dart';
import 'category/manage_category_screen.dart';

class AdminScreen extends StatelessWidget {
  const AdminScreen({super.key});

  @override
  Widget build(BuildContext context) {
    List<String> pages = ["Users", "Categories", "Sub-Categories", "Products", "Banner", "App Status", "Location", "Alert", "Coupon", "Constants", "Shop Name"];
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Admin Panel",
          style: TextStyle(color: Color(0xffb3b3b3)),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10.0),
            child: IconButton(
              onPressed: () async {
                showDialog(
                    context: context,
                    builder: (context) => AlertDialog(
                          backgroundColor: const Color(0xff1a1a1c),
                          title: const Text(
                            "Logout",
                            style: TextStyle(fontFamily: 'Gilroy-ExtraBold', color: Color(0xffb3b3b3)),
                          ),
                          content: const Text(
                            "Are you sure you want to logout?",
                            style: TextStyle(color: Color(0xffb3b3b3)),
                          ),
                          actions: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                TextButton(
                                    onPressed: () => Navigator.of(context).pop(),
                                    style: ButtonStyle(
                                      overlayColor: WidgetStateProperty.all(Colors.red[900]),
                                    ),
                                    child: const Text(
                                      "No",
                                      style: TextStyle(color: Color(0xffEF4B4B), fontFamily: "Gilroy-Black"),
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
                                    style: ButtonStyle(
                                      overlayColor: WidgetStateProperty.all(Colors.grey[700]),
                                    ),
                                    child: const Text(
                                      "Yes",
                                      style: TextStyle(color: Color(0xffb3b3b3), fontFamily: "Gilroy-Black"),
                                    )),
                              ],
                            )
                          ],
                        ));
              },
              // style: ButtonStyle(
              //   shape: WidgetStateProperty.all<RoundedRectangleBorder>(
              //     RoundedRectangleBorder(
              //       // borderRadius: BorderRadius.circular(20.0),
              //       borderRadius: BorderRadius.circular(2.0),
              //     ),
              //   ),
              //   backgroundColor: WidgetStateProperty.resolveWith<Color>(
              //     (Set<WidgetState> states) {
              //       if (states.contains(WidgetState.disabled)) {
              //         return Colors.black.withOpacity(0.3);
              //       }
              //       return const Color(0xffEF4B4B);
              //     },
              //   ),
              // ),
              icon: const Icon(
                Icons.logout,
                color: Color(0xffEF4B4B),
                size: 18,
              ),
            ),
          ),
        ],
        elevation: 0,
        backgroundColor: const Color(0xff1a1a1c),
        surfaceTintColor: Colors.transparent,
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: const Icon(
            Icons.keyboard_backspace,
            color: Color(0xffb3b3b3),
          ),
        ),
      ),
      backgroundColor: const Color(0xff1a1a1c),
      body: GridView.builder(
        itemCount: pages.length,
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2),
        itemBuilder: (context, index) => Padding(
          padding: const EdgeInsets.all(8.0),
          child: customContainer(context, "Manage ${pages[index]}", "p${index + 1}"),
        ),
      ),
    );
  }

  Widget customContainer(BuildContext context, String pageName, String routeName) {
    final Map<String, WidgetBuilder> pageRoutes = {
      'p1': (context) => const ManageUserScreen(),
      'p2': (context) => const ManageCategoryScreen(),
      'p3': (context) => const ManageSubCategoryScreen(),
      'p4': (context) => const ManageProduct(),
      'p5': (context) => const ManageBannerScreen(),
      'p6': (context) => AppMaintenanceListScreen(),
      'p7': (context) => LocationListScreen(),
      'p8': (context) => AlertLabelListScreen(),
      'p9': (context) => MainDisplayScreen(),
      'p10': (context) => ConstantsListScreen(),
      'p11': (context) => const ManageDeliveredShopScreen(),
    };

    return GestureDetector(
      onTap: () {
        log("Route Name: $routeName");
        if (pageRoutes.containsKey(routeName)) {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => pageRoutes[routeName]!(context),
            ),
          );
        } else {
          // Handle the case where the page name is not found
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Page not found: $pageName')),
          );
        }
      },
      child: Container(
        width: 150,
        height: 160,
        decoration: BoxDecoration(
          color: Colors.grey[850],
          borderRadius: const BorderRadius.all(Radius.circular(10)),
        ),
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              pageName,
              textAlign: TextAlign.center,
              style: const TextStyle(color: Color(0xffb3b3b3), fontFamily: 'Gilroy-Black', fontSize: 22),
            ),
          ),
        ),
      ),
    );
  }
}
