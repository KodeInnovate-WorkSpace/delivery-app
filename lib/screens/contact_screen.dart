import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class ContactScreen extends StatelessWidget {
  const ContactScreen({super.key});

  // Function to launch URLs
  void _launchURL(String url) async {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Contact Us", style: TextStyle(color: Color(0xff666666), fontFamily: 'Gilroy-Bold')),
        backgroundColor: const Color(0xfff7f7f7),
        elevation: 0,
      ),
      backgroundColor: const Color(0xfff7f7f7),
      body: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Info
            const Text(
              ''' You can get in touch with us through below platforms. Our Team will react out to you as soon as it would be possible
         ''',
              textAlign: TextAlign.justify,
              style: TextStyle(fontSize: 12, color: Color(0xff666666)),
            ),

            // Contact Info
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
                      "Customer Support",
                      style: TextStyle(color: Color(0xff666666), fontFamily: 'Gilroy-SemiBold'),
                    ),
                  ),

                  // Email
                  ListTile(
                    leading: Container(
                        decoration: BoxDecoration(
                          color: const Color(0xffc9cace),
                          borderRadius: BorderRadius.circular(50), // Adjust the radius as needed
                        ),
                        child: const Padding(
                          padding: EdgeInsets.all(6.0),
                          child: Icon(
                            Icons.email,
                            color: Colors.white,
                            size: 15,
                          ),
                        )),
                    title: const Text("info@kodeinnovate.in", style: TextStyle(color: Color(0xff666666))),
                    onTap: () async {
                      Uri email = Uri(scheme: 'mailto', path: "info@kodeinnovate.in");
                      await launchUrl(email);
                    },
                  ),

                  // Phone
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
                    title: const Text("+91 9326500602", style: TextStyle(color: Color(0xff666666))),
                    onTap: () async {
                      Uri dialNumber = Uri(scheme: 'tel', path: "9326500602");
                      await launchUrl(dialNumber);
                    },
                  ),

                  // Kodeinnovate website
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
                    title: const Text("kodeinnovate.in", style: TextStyle(color: Color(0xff666666))),
                    onTap: () {
                      _launchURL('https://kodeinnovate.in/');
                    },
                  ),

                  // Delivo Website
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
                    title: const Text("delivoapp.com", style: TextStyle(color: Color(0xff666666))),
                    onTap: () {
                      _launchURL('https://www.delivoapp.com/');
                    },
                  ),
                ],
              ),
            ),

            const SizedBox(height: 20),

            // Social Medias
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
                      "Social Media",
                      style: TextStyle(color: Color(0xff666666), fontFamily: 'Gilroy-SemiBold'),
                    ),
                  ),

                  // Delivo Instagram
                  ListTile(
                    leading: Image.asset(
                      "assets/images/instagram.png",
                      height: 30,
                    ),
                    title: const Text("Delivo Instagram", style: TextStyle(color: Color(0xff666666))),
                    onTap: () {
                      _launchURL('https://www.instagram.com/delivo.app');
                    },
                  ),

                  // Kodeinnovate Instagram
                  ListTile(
                    leading: Image.asset(
                      "assets/images/instagram.png",
                      height: 30,
                    ),
                    title: const Text("Kodeinnovate Instagram", style: TextStyle(color: Color(0xff666666))),
                    onTap: () {
                      _launchURL('https://www.instagram.com/kodeinnovate');
                    },
                  ),

                  // Kodeinnovate Facebook
                  ListTile(
                    leading: Image.asset(
                      "assets/images/facebook.png",
                      height: 28,
                    ),
                    title: const Text("Kodeinnovate Facebook", style: TextStyle(color: Color(0xff666666))),
                    onTap: () {
                      _launchURL('https://www.facebook.com/people/Kodeinnovate-solutions/61552635723546/');
                    },
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
