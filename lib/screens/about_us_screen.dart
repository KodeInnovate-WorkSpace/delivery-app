import 'package:flutter/material.dart';

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
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 16),
              const Text(
                '''Speedy is Mumbra's most beloved online grocery shopping platform. Our app is changing the way customers approach their daily essentials. You can now shop online for groceries, fresh fruits and vegetables procured daily, dairy & bakery, beauty & wellness, personal care, household care, diapers & baby care, pet care, meats and seafood as well as the latest products from leading brands like Cadbury, ITC, Colgate-Palmolive, PepsiCo, Aashirvaad, Saffola, Fortune, Nestle, Amul, Dabur, and many more.

Imagine if you could get anything delivered to you in minutes. Milk for your morning chai. The perfect shade of lipstick for tonight's party. Even an iPhone.

Our superfast delivery service aims to help consumers in Mumbra save time and fulfill their needs in a way that is frictionless. We will make healthy, high-quality and life-improving products available to everyone instantly so that people can have time for the things that matter to them.

'Speedy' is owned & managed by 'KodeInnovate Solutions PVT LTD' and is not related, linked or interconnected in whatsoever manner or nature other third party''',
                style: TextStyle(fontSize: 16),
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