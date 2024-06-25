import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:speedy_delivery/admin/product/manage_product_screen.dart';
import 'package:speedy_delivery/admin/subcategory/manage_sub_category_screen.dart';
import 'package:speedy_delivery/admin/user/manage_user_screen.dart';
import '../screens/sign_in_screen.dart';
import 'category/manage_category_screen.dart';

class AdminScreen extends StatelessWidget {
  const AdminScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Admin"),
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
                                      style: TextStyle(color: Colors.redAccent),
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
              style: ButtonStyle(
                shape: WidgetStateProperty.all<RoundedRectangleBorder>(
                  RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14.0),
                  ),
                ),
                backgroundColor: WidgetStateProperty.resolveWith<Color>(
                  (Set<WidgetState> states) {
                    if (states.contains(WidgetState.disabled)) {
                      return Colors.black.withOpacity(0.3);
                    }
                    return Colors.redAccent;
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
          ],
        ),
      ),
    );
  }
}
