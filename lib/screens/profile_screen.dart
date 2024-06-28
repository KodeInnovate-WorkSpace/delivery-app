import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:speedy_delivery/admin/admin_screen.dart';
import 'package:speedy_delivery/deliveryPartner/screen/delivery_home.dart';
import 'package:speedy_delivery/providers/auth_provider.dart';
import 'package:speedy_delivery/providers/check_user_provider.dart';
import 'package:speedy_delivery/screens/notification_screen.dart';
import 'package:speedy_delivery/screens/sign_in_screen.dart';
import 'package:speedy_delivery/screens/contact_screen.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:share_plus/share_plus.dart';
import '../shared/constants.dart';
import 'about_us_screen.dart';
import 'address_screen.dart';
import 'orders_screen.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  late Future<void> _checkUserTypeFuture;

  @override
  void initState() {
    super.initState();
    final authProvider = Provider.of<MyAuthProvider>(context, listen: false);
    final userProvider = Provider.of<CheckUserProvider>(context, listen: false);
    _checkUserTypeFuture = userProvider.checkUserType(authProvider.textController.text);
  }

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<MyAuthProvider>(context, listen: false);
    final userProvider = Provider.of<CheckUserProvider>(context, listen: false);

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
      body: FutureBuilder<void>(
        future: _checkUserTypeFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return const Center(child: Text('Error loading user data'));
          } else {
            return Padding(
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
                    authProvider.phone.isEmpty ? "Please Login" : "+91 ${authProvider.textController.text}",
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
                  // Your orders
                  ListTile(
                    leading: const Icon(Icons.receipt_long),
                    title: const Text('Your orders'),
                    trailing: const Icon(Icons.arrow_forward_ios),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => const OrderHistoryScreen()),
                      );
                    },
                  ),
                  // Addresses
                  ListTile(
                    leading: const Icon(Icons.home_work),
                    title: const Text('Your address'),
                    trailing: const Icon(Icons.arrow_forward_ios),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => const AddressScreen()),
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

                  // Admin Screen
                  if (userProvider.userType == 1)
                    ListTile(
                      leading: const Icon(Icons.settings),
                      title: const Text('Admin Screen'),
                      trailing: const Icon(Icons.arrow_forward_ios),
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => const AdminScreen()),
                        );
                      },
                    ),
                  // Delivery Partner Screen
                  if (userProvider.userType == 1 || userProvider.userType == 2)
                    ListTile(
                      leading: const Icon(Icons.motorcycle),
                      title: const Text('Delivery Partner'),
                      trailing: const Icon(Icons.arrow_forward_ios),
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => const DeliveryHomeScreen()),
                        );
                      },
                    ),
                  //Share the app
                  ListTile(
                    leading: const Icon(Icons.share),
                    title: const Text('Share the app'),
                    trailing: const Icon(Icons.arrow_forward_ios),
                    onTap: () {
                      _shareApp();
                    },
                  ),
                  //About us
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
                  // Rate on playstore
                  ListTile(
                    leading: const Icon(Icons.star),
                    title: const Text('Rate us on the Play Store'),
                    trailing: const Icon(Icons.arrow_forward_ios),
                    onTap: () {
                      _launchPlayStore();
                    },
                  ),
                  //Notification
                  ListTile(
                    leading: const Icon(Icons.notifications_sharp),
                    title: const Text('Notification Preferences'),
                    trailing: const Icon(Icons.arrow_forward_ios),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => const NotificationSettingsPage()),
                      );
                    },
                  ),
                  //Support
                  ListTile(
                    leading: const Icon(Icons.support_agent),
                    title: const Text('Contact Us'),
                    trailing: const Icon(Icons.arrow_forward_ios),
                    onTap: () {
                      Navigator.push(context, MaterialPageRoute(builder: (context) => const ContactScreen()));
                    },
                  ),
                  //Logout
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
                                content: const Text("Are you sure you want to logout?"),
                                actions: [
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                    children: [
                                      TextButton(
                                          onPressed: () => Navigator.of(context).pop(),
                                          child: const Text(
                                            "No",
                                            style: TextStyle(color: Colors.red),
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
                                  ),
                                ],
                              ));
                    },
                  ),
                  const SizedBox(height: 40),
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
                          "${appVer!.isEmpty ? "v0.1.0" : appVer}",
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Colors.grey[600],
                          ),
                        ),
                      ],
                    ),
                  )
                ],
              ),
            );
          }
        },
      ),
    );
  }
}

void _shareApp() {
  Share.share('Check out this amazing delivery app : https://play.google.com/store/apps');
}

void _launchPlayStore() async {
  final Uri url = Uri.parse('https://play.google.com/store/apps');
  if (!await launchUrl(url)) {
    throw Exception('Could not launch $url');
  }
}
