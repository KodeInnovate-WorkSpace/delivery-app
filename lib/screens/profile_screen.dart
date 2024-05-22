import 'package:flutter/material.dart';
import 'package:speedy_delivery/screens/sign_in_screen.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:share_plus/share_plus.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
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
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              '9136307745',
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
                      builder: (context) => const YourOrdersPage()),
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
              leading: const Icon(Icons.logout),
              title: const Text('Log out'),
              trailing: const Icon(Icons.arrow_forward_ios),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => SigninScreen()),
                );
              },
            ),
            const SizedBox(height: 40), // Add space below "Log out"
            Center(
              child: Column(
                children: [
                  Text(
                    'Speedy',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.grey[600],
                    ),
                  ),
                  Text(
                    'v15.113.0',
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

class YourOrdersPage extends StatelessWidget {
  const YourOrdersPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Your orders'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              'assets/images/dog.png', // Ensure you have added this image to your assets
              height: 200,
            ),
            const SizedBox(height: 20),
            Text(
              'Oops, you haven’t placed an order yet',
              style: TextStyle(
                fontSize: 18,
                color: Colors.grey[600],
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
  const url = 'https://play.google.com/store/apps';
  // const url = 'https://play.google.com/store/apps/details?id=com.example.yourapp';// Replace com.example.yourapp with your app's package name
  if (await canLaunch(url)) {
    await launch(url);
  } else {
    throw 'Could not launch $url';
  }
}

class AboutUsPage extends StatelessWidget {
  const AboutUsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('About Us'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'About Us v15.113.0',
                style: TextStyle(
                  fontSize: 20,
                ),
              ),
              const SizedBox(height: 16),
              const Text(
                textAlign: TextAlign.justify,
                '''Speedy is Mumbra's most beloved online grocery shopping platform. Our app is changing the way customers approach their daily essentials. You can now shop online for groceries, fresh fruits and vegetables procured daily, dairy & bakery, beauty & wellness, personal care, household care, diapers & baby care, pet care, meats and seafood as well as the latest products from leading brands like Cadbury, ITC, Colgate-Palmolive, PepsiCo, Aashirvaad, Saffola, Fortune, Nestle, Amul, Dabur, and many more.

Imagine if you could get anything delivered to you in minutes. Milk for your morning chai. The perfect shade of lipstick for tonight's party. Even an iPhone.

Our superfast delivery service aims to help consumers in Mumbra save time and fulfill their needs in a way that is frictionless. We will make healthy, high-quality and life-improving products available to everyone instantly so that people can have time for the things that matter to them.

'Speedy' is owned & managed by 'KodeInnovate Solutions PVT LTD' and is not related, linked or interconnected in whatsoever manner or nature other third party''',
                style: TextStyle(fontSize: 14),
              ),
              const SizedBox(height: 24),
              const Divider(),
              ListTile(
                title: const Text(
                  'Privacy Policy',
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.black,
                  ),
                ),
                onTap: () {
                  // Handle Privacy Policy tap
                },
              ),
              ListTile(
                title: const Text(
                  'Terms & Conditions',
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.black,
                  ),
                ),
                onTap: () {
                  // Handle Terms & Conditions tap
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
