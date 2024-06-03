import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:speedy_delivery/admin/manage_user_screen.dart';
import 'package:speedy_delivery/admin/subcategory/manage_sub_category_screen.dart';

import '../screens/sign_in_screen.dart';
import 'category/manage_category_screen.dart';
import 'manage_product_screen.dart';

class AdminScreen extends StatelessWidget {
  const AdminScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Admin"),
      ),
      body: SizedBox(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const Text(
              "Hello, Admin",
              style: TextStyle(fontSize: 30, fontFamily: 'Gilroy-ExtraBold'),
            ),
            ElevatedButton(
              style: ButtonStyle(
                backgroundColor: WidgetStateProperty.all<Color>(Colors.black),
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
            ElevatedButton(
              style: ButtonStyle(
                backgroundColor: WidgetStateProperty.all<Color>(Colors.black),
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
            ElevatedButton(
              style: ButtonStyle(
                backgroundColor: WidgetStateProperty.all<Color>(Colors.black),
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
                style: TextStyle(color: Colors.white, fontSize: 20),
              ),
            ),
            ElevatedButton(
              style: ButtonStyle(
                backgroundColor: WidgetStateProperty.all<Color>(Colors.black),
              ),
              onPressed: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const ManageProductScreen(),
                    ));
              },
              child: const Text(
                "Manage Products",
                style: TextStyle(color: Colors.white, fontSize: 20),
              ),
            ),
            ElevatedButton(
              style: ButtonStyle(
                backgroundColor: WidgetStateProperty.all<Color>(Colors.black),
              ),
              onPressed: null,
              child: const Text(
                "Manage Notification",
                style: TextStyle(color: Colors.white, fontSize: 20),
              ),
            ),
            TextButton(
              onPressed: () async {
                showDialog(
                    context: context,
                    builder: (context) => AlertDialog(
                          backgroundColor: Colors.white,
                          title: const Text(
                            "Logout",
                            style: TextStyle(fontFamily: 'Gilroy-ExtraBold'),
                          ),
                          content:
                              const Text("Are you sure you want to logout?"),
                          actions: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                TextButton(
                                    onPressed: () =>
                                        Navigator.of(context).pop(),
                                    child: const Text(
                                      "No",
                                      style: TextStyle(color: Colors.red),
                                    )),
                                TextButton(
                                    onPressed: () async {
                                      await FirebaseAuth.instance.signOut();
                                      SharedPreferences prefs =
                                          await SharedPreferences.getInstance();
                                      await prefs.remove('isLoggedIn');
                                      Navigator.pushAndRemoveUntil(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                const SigninScreen()),
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
              child: const Text(
                "Log out",
                style: TextStyle(
                    color: Colors.red,
                    fontFamily: 'Gilroy-SemiBold',
                    fontSize: 20),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
