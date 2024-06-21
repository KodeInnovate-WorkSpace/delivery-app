import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:speedy_delivery/admin/admin_screen.dart';
import 'package:speedy_delivery/deliveryPartner/screen/delivery_home.dart';
import 'package:speedy_delivery/providers/auth_provider.dart';
import 'package:speedy_delivery/screens/notification_screen.dart';
import 'package:speedy_delivery/screens/sign_in_screen.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:share_plus/share_plus.dart';
import '../shared/constants.dart';
import 'about_us_screen.dart';
import 'address_screen.dart';
import 'orders_screen.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<MyAuthProvider>(context, listen: false);

    List<String> selectedPhone = [
      // "+917977542667",
      "9136307745",
      "9326500602",
      "9876543210"
    ];

    List<String> deliveryPhone = ["9876543210"];

    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: [
            const Text(
              'My Account',
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),

            Text(
              authProvider.phone.isEmpty
                  ? "Please Login"
                  : "+91 ${authProvider.textController.text}",
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey[700],
              ),
            ),
            const SizedBox(height: 50),
            Text(
              'YOUR INFORMATION',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.grey[600],
              ),
            ),
            ListTile(
              leading: const Icon(Icons.receipt_long),
              title: const Text('Your orders'),
              trailing: const Icon(Icons.arrow_forward_ios),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const OrderHistoryScreen()),
                );
              },
            ),
            ListTile(
              leading: const Icon(Icons.home_work),
              title: const Text('Your address'),
              trailing: const Icon(Icons.arrow_forward_ios),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const AddressScreen()),
                );
              },
            ),
            const Divider(),
            Text(
              'OTHER INFORMATION',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.grey[600],
              ),
            ),

            ListTile(
              leading: const Icon(Icons.share),
              title: const Text('Share the app'),
              trailing: const Icon(Icons.arrow_forward_ios),
              onTap: () {
                _shareApp();
              },
            ),

            //display admin tile
            if (selectedPhone.contains(authProvider.phone))
              ListTile(
                leading: const Icon(Icons.settings),
                title: const Text('Admin Screen'),
                trailing: const Icon(Icons.arrow_forward_ios),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const AdminScreen()),
                  );
                  // Navigator.pushNamed(context, '/admin');
                },
              )
            else
              const SizedBox(),

            //display delivery tile
            if (deliveryPhone.contains(authProvider.phone))
              ListTile(
                leading: const Icon(Icons.two_wheeler),
                title: const Text('Delivery Partner'),
                trailing: const Icon(Icons.arrow_forward_ios),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) =>  const DeliveryHomeScreen()),
                  );
                  // Navigator.pushNamed(context, '/admin');
                },
              )
            else
              const SizedBox(),

            ListTile(
              leading: const Icon(Icons.info),
              title: const Text('About us'),
              trailing: const Icon(Icons.arrow_forward_ios),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const AboutUsPage()),
                );
              },
            ),
            ListTile(
              leading: const Icon(Icons.star),
              title: const Text('Rate us on the Play Store'),
              trailing: const Icon(Icons.arrow_forward_ios),
              onTap: () {
                _launchPlayStore();
              },
            ),
            ListTile(
              leading: const Icon(Icons.notifications_sharp),
              title: const Text('Notification Preferences'),
              trailing: const Icon(Icons.arrow_forward_ios),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const NotificationSettingsPage()),
                );
              },
            ),
            ListTile(
              leading: const Icon(Icons.logout),
              title: const Text('Log out'),
              trailing: const Icon(Icons.arrow_forward_ios),
              onTap: () async {
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
            ),
            const SizedBox(height: 40), // Add space below "Log out"
            Center(
              child: Column(
                children: [
                  Text(
                    'Delivo',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.grey[600],
                    ),
                  ),
                  Text(
                    appVer,
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.grey[600],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

void _shareApp() {
  Share.share(
      'Check out this amazing delivery app : https://play.google.com/store/apps');
}

void _launchPlayStore() async {
  final Uri url = Uri.parse('https://play.google.com/store/apps');
  if (!await launchUrl(url)) {
    throw Exception('Could not launch $url');
  }
}
