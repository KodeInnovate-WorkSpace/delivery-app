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
        title: const Text('Profile', style: TextStyle(color: Color(0xff1c1c1c), fontFamily: 'Gilroy-Bold')),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        backgroundColor: const Color(0xfff7f7f7),
        elevation: 0,
      ),
      backgroundColor: const Color(0xfff7f7f7),
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
                  // User Info
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(10), // Adjust the radius as needed
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.1), // Shadow color
                          spreadRadius: 2, // Spread radius
                          blurRadius: 5, // Blur radius
                          offset: const Offset(0, 2), // Shadow offset (x, y)
                        ),
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Padding(
                          padding: EdgeInsets.only(top: 15.0, left: 18.0),
                          child: Text(
                            "My Account",
                            style: TextStyle(color: Color(0xff666666), fontFamily: 'Gilroy-SemiBold'),
                          ),
                        ),

                        /*//Phone Number
                  Text(
                    authProvider.phone.isEmpty ? "Please Login" : "+91 ${authProvider.textController.text}",
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.grey[700],
                    ),
                  ),*/

                        // Phone Number
                        ListTile(
                          leading: Container(
                              decoration: BoxDecoration(
                                color: const Color(0xffc9cace),
                                borderRadius: BorderRadius.circular(50), // Adjust the radius as needed
                              ),
                              child: const Padding(
                                padding: EdgeInsets.all(6.0),
                                child: Icon(
                                  Icons.phone,
                                  color: Colors.white,
                                  size: 15,
                                ),
                              )),
                          title: Text(authProvider.phone.isEmpty ? "Please Login" : "+91 ${authProvider.textController.text}", style: const TextStyle(color: Color(0xff1c1c1c))),
                        ),

                        // Your Orders
                        ListTile(
                          leading: Container(
                              decoration: BoxDecoration(
                                color: const Color(0xffc9cace),
                                borderRadius: BorderRadius.circular(50), // Adjust the radius as needed
                              ),
                              child: const Padding(
                                padding: EdgeInsets.all(6.0),
                                child: Icon(
                                  Icons.receipt_long,
                                  color: Colors.white,
                                  size: 15,
                                ),
                              )),
                          title: const Text("Orders", style: TextStyle(color: Color(0xff1c1c1c))),
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) => const OrderHistoryScreen()),
                            );
                          },
                        ),

                        // Address
                        ListTile(
                          leading: Container(
                              decoration: BoxDecoration(
                                color: const Color(0xffc9cace),
                                borderRadius: BorderRadius.circular(50), // Adjust the radius as needed
                              ),
                              child: const Padding(
                                padding: EdgeInsets.all(6.0),
                                child: Icon(
                                  Icons.language,
                                  color: Colors.white,
                                  size: 15,
                                ),
                              )),
                          title: const Text("Adderss", style: TextStyle(color: Color(0xff1c1c1c))),
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) => const AddressScreen()),
                            );
                          },
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(
                    height: 20,
                  ),
                  // Other information
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(10), // Adjust the radius as needed
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.1), // Shadow color
                          spreadRadius: 2, // Spread radius
                          blurRadius: 5, // Blur radius
                          offset: const Offset(0, 2), // Shadow offset (x, y)
                        ),
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Padding(
                          padding: EdgeInsets.only(top: 15.0, left: 18.0),
                          child: Text(
                            "Other Information",
                            style: TextStyle(color: Color(0xff666666), fontFamily: 'Gilroy-SemiBold'),
                          ),
                        ),

                        // Admin screen
                        if (userProvider.userType == 1)
                          ListTile(
                            leading: Container(
                                decoration: BoxDecoration(
                                  color: const Color(0xffc9cace),
                                  borderRadius: BorderRadius.circular(50), // Adjust the radius as needed
                                ),
                                child: const Padding(
                                  padding: EdgeInsets.all(6.0),
                                  child: Icon(
                                    Icons.settings,
                                    color: Colors.white,
                                    size: 15,
                                  ),
                                )),
                            title: const Text("Admin Screen", style: TextStyle(color: Color(0xff1c1c1c))),
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
                            leading: Container(
                                decoration: BoxDecoration(
                                  color: const Color(0xffc9cace),
                                  borderRadius: BorderRadius.circular(50), // Adjust the radius as needed
                                ),
                                child: const Padding(
                                  padding: EdgeInsets.all(6.0),
                                  child: Icon(
                                    Icons.motorcycle,
                                    color: Colors.white,
                                    size: 15,
                                  ),
                                )),
                            title: const Text("Delivery Partner", style: TextStyle(color: Color(0xff1c1c1c))),
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(builder: (context) => const DeliveryHomeScreen()),
                              );
                            },
                          ),

                        // Share the app
                        ListTile(
                          leading: Container(
                              decoration: BoxDecoration(
                                color: const Color(0xffc9cace),
                                borderRadius: BorderRadius.circular(50), // Adjust the radius as needed
                              ),
                              child: const Padding(
                                padding: EdgeInsets.all(6.0),
                                child: Icon(
                                  Icons.share,
                                  color: Colors.white,
                                  size: 15,
                                ),
                              )),
                          title: const Text("Share the app", style: TextStyle(color: Color(0xff1c1c1c))),
                          onTap: () {
                            _shareApp();
                          },
                        ),

                        // About us
                        ListTile(
                          leading: Container(
                              decoration: BoxDecoration(
                                color: const Color(0xffc9cace),
                                borderRadius: BorderRadius.circular(50), // Adjust the radius as needed
                              ),
                              child: const Padding(
                                padding: EdgeInsets.all(6.0),
                                child: Icon(
                                  Icons.info,
                                  color: Colors.white,
                                  size: 15,
                                ),
                              )),
                          title: const Text("About Us", style: TextStyle(color: Color(0xff1c1c1c))),
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) => const AboutUsPage()),
                            );
                          },
                        ),

                        // Rate us
                        ListTile(
                          leading: Container(
                              decoration: BoxDecoration(
                                color: const Color(0xffc9cace),
                                borderRadius: BorderRadius.circular(50), // Adjust the radius as needed
                              ),
                              child: const Padding(
                                padding: EdgeInsets.all(6.0),
                                child: Icon(
                                  Icons.info,
                                  color: Colors.white,
                                  size: 15,
                                ),
                              )),
                          title: const Text("Rate Us on Play Store", style: TextStyle(color: Color(0xff1c1c1c))),
                          onTap: () {
                            _launchPlayStore();
                          },
                        ),

                        // Notification
                        ListTile(
                          leading: Container(
                              decoration: BoxDecoration(
                                color: const Color(0xffc9cace),
                                borderRadius: BorderRadius.circular(50), // Adjust the radius as needed
                              ),
                              child: const Padding(
                                padding: EdgeInsets.all(6.0),
                                child: Icon(
                                  Icons.notifications_sharp,
                                  color: Colors.white,
                                  size: 15,
                                ),
                              )),
                          title: const Text("Notification", style: TextStyle(color: Color(0xff1c1c1c))),
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) => const NotificationSettingsPage()),
                            );
                          },
                        ),

                        // Contact Us
                        ListTile(
                          leading: Container(
                              decoration: BoxDecoration(
                                color: const Color(0xffc9cace),
                                borderRadius: BorderRadius.circular(50), // Adjust the radius as needed
                              ),
                              child: const Padding(
                                padding: EdgeInsets.all(6.0),
                                child: Icon(
                                  Icons.support_agent,
                                  color: Colors.white,
                                  size: 15,
                                ),
                              )),
                          title: const Text("Contact Us", style: TextStyle(color: Color(0xff1c1c1c))),
                          onTap: () {
                            Navigator.push(context, MaterialPageRoute(builder: (context) => const ContactScreen()));
                          },
                        ),
                      ],
                    ),
                  ),

                  //About us
                  // ListTile(
                  //   leading: const Icon(Icons.info),
                  //   title: const Text('About us'),
                  //   trailing: const Icon(Icons.arrow_forward_ios),
                  //   onTap: () {
                  //     Navigator.push(
                  //       context,
                  //       MaterialPageRoute(builder: (context) => const AboutUsPage()),
                  //     );
                  //   },
                  // ),
                  // Rate on playstore
                  // ListTile(
                  //   leading: const Icon(Icons.star),
                  //   title: const Text('Rate us on the Play Store'),
                  //   trailing: const Icon(Icons.arrow_forward_ios),
                  //   onTap: () {
                  //     _launchPlayStore();
                  //   },
                  // ),
                  //Notification
                  // ListTile(
                  //   leading: const Icon(Icons.notifications_sharp),
                  //   title: const Text('Notification Preferences'),
                  //   trailing: const Icon(Icons.arrow_forward_ios),
                  //   onTap: () {
                  //     Navigator.push(
                  //       context,
                  //       MaterialPageRoute(builder: (context) => const NotificationSettingsPage()),
                  //     );
                  //   },
                  // ),
                  //Contact Us
                  // ListTile(
                  //   leading: const Icon(Icons.support_agent),
                  //   title: const Text('Contact Us'),
                  //   trailing: const Icon(Icons.arrow_forward_ios),
                  //   onTap: () {
                  //     Navigator.push(context, MaterialPageRoute(builder: (context) => const ContactScreen()));
                  //   },
                  // ),
                  //Logout
                  const SizedBox(
                    height: 20,
                  ),
                  //Logout
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(10), // Adjust the radius as needed
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.1), // Shadow color
                          spreadRadius: 2, // Spread radius
                          blurRadius: 5, // Blur radius
                          offset: const Offset(0, 2), // Shadow offset (x, y)
                        ),
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        ListTile(
                          leading: Container(
                              decoration: BoxDecoration(
                                color: const Color(0xffEF4B4B),

                                borderRadius: BorderRadius.circular(50), // Adjust the radius as needed
                              ),
                              child: const Padding(
                                padding: EdgeInsets.all(6.0),
                                child: Icon(
                                  Icons.logout,
                                  color: Colors.white,
                                  size: 15,
                                ),
                              )),
                          title: const Text("Logout", style: TextStyle(color: Color(0xff1c1c1c))),
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
                      ],
                    ),
                  ),

                  const SizedBox(height: 20),
                  Center(
                    child: Column(
                      children: [
                        const Text(
                          'Delivo',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Color(0xff666666),
                          ),
                        ),
                        Text(
                          "${appVer!.isEmpty ? "v0.1.0" : appVer}",
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Color(0xff666666),
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
