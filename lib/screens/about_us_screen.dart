import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class AboutUsPage extends StatelessWidget {
  const AboutUsPage({super.key});

  @override
  Widget build(BuildContext context) {
    void launchURL(String url) async {
      if (await canLaunch(url)) {
        await launch(url);
      } else {
        throw 'Could not launch $url';
      }
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('About Us'),
        elevation: 0,
        backgroundColor: const Color(0xfff7f7f7),
        surfaceTintColor: Colors.transparent,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Kodeinnovate Solutions Private Limited',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 16),
              const Text(
                '''Kodeinnovate Solutions Private Limited
Kodeinnovate solutions where digital dreams become reality. we're your go-to team for crafting cutting-edge mobile apps and captivating websites. Innovation is our language, quality our guarantee, and collaboration our ethos. At Kodeinnovate Solutions, we are your trusted partner in the ever-evolving digital landscape. We are a dynamic and forward-thinking software development company specializing in Mobile Application Development and Website Development. Our vision is to empower businesses, both large and small, with innovative digital solutions that transform their ideas into reality. We believe that technology is the cornerstone of modern success and strive to be at the forefront of technological innovation.
''',
                style: TextStyle(fontSize: 16),
              ),
              const SizedBox(height: 24),
              const Divider(),
              const Text("Our product"),
              ListTile(
                title: const Text(
                  'About Delivo App',
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.black,
                  ),
                ),
                onTap: () {
                  launchURL("https://kodeinnovate-workspace.github.io/delivo-policy/delivo_about.html");
                },
              ),
//               Accordion(
//                 children: [
//                   AccordionSection(
//                     isOpen: false,
//                     header: const Text('Delivo App'),
//                     contentHorizontalPadding: 10,
//                     contentVerticalPadding: 20,
//                     headerBackgroundColor: Colors.grey[200],
//                     headerPadding: const EdgeInsets.all(14.0),
//                     rightIcon: const Icon(Icons.arrow_downward, color: Color(0xff666666), size: 12),
//                     content: const Text(
//                       '''Delivo revolutionizes the way you shop for groceries by offering a seamless, user-friendly app that delivers everything you need right to your doorstep. With an extensive range of fresh produce, pantry staples, household essentials, and specialty items, Delivo ensures that you have access to high-quality products without the hassle of visiting a store.
// The app features an intuitive interface that makes browsing, selecting, and purchasing groceries quick and easy. Whether you're planning your weekly shop or need a last-minute ingredient, Delivo's same-day delivery service ensures your groceries arrive promptly and in perfect condition.
// Customize your orders, track your delivery in real-time, and enjoy the convenience of contactless payment options. Delivo also offers personalized recommendations based on your shopping habits, making your grocery shopping experience tailored to your preferences. Experience the future of grocery shopping with Delivo, where quality, convenience, and customer satisfaction are our top priorities.''',
//                       style: TextStyle(fontSize: 16),
//                     ),
//                   ),
//                 ],
//               ),

              // Privacy
              ListTile(
                title: const Text(
                  'Privacy Policy',
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.black,
                  ),
                ),
                onTap: () {
                  launchURL("https://kodeinnovate-workspace.github.io/delivo-policy/delivo_app_privacy_policy.html");
                },
              ),

              //Terms
              ListTile(
                title: const Text(
                  'Terms & Conditions',
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.black,
                  ),
                ),
                onTap: () {
                  launchURL("https://kodeinnovate-workspace.github.io/delivo-policy/delivo_app_terms_and_conditions.html");

                },
              ),

              //Delivery
              ListTile(
                title: const Text(
                  'Delivery Policy',
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.black,
                  ),
                ),
                onTap: () {
                  launchURL("https://kodeinnovate-workspace.github.io/delivo-policy/Delivery_Policy.html");
                },
              ),
              //Cancellation
              ListTile(
                title: const Text(
                  'Cancellation Policy',
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.black,
                  ),
                ),
                onTap: () {
                  launchURL("https://kodeinnovate-workspace.github.io/delivo-policy/Cancellation_Policy.html");
                },
              ),

              //Refund
              ListTile(
                title: const Text(
                  'Refund Policy',
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.black,
                  ),
                ),
                onTap: () {
                  launchURL("https://kodeinnovate-workspace.github.io/delivo-policy/Refund_Policy.html");
                },//refund policy
              ),
            ],
          ),
        ),
      ),
    );
  }
}