import 'package:accordion/accordion.dart';
import 'package:flutter/material.dart';
import 'package:speedy_delivery/screens/policy_screen.dart';
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
              Accordion(
                children: [
                  AccordionSection(
                    isOpen: false,
                    header: const Text('Delivo App'),
                    contentHorizontalPadding: 10,
                    contentVerticalPadding: 20,
                    headerBackgroundColor: Colors.grey[200],
                    headerPadding: const EdgeInsets.all(14.0),
                    rightIcon: const Icon(Icons.arrow_downward, color: Color(0xff666666), size: 12),
                    content: const Text(
                      '''Delivo revolutionizes the way you shop for groceries by offering a seamless, user-friendly app that delivers everything you need right to your doorstep. With an extensive range of fresh produce, pantry staples, household essentials, and specialty items, Delivo ensures that you have access to high-quality products without the hassle of visiting a store.
The app features an intuitive interface that makes browsing, selecting, and purchasing groceries quick and easy. Whether you're planning your weekly shop or need a last-minute ingredient, Delivo's same-day delivery service ensures your groceries arrive promptly and in perfect condition.
Customize your orders, track your delivery in real-time, and enjoy the convenience of contactless payment options. Delivo also offers personalized recommendations based on your shopping habits, making your grocery shopping experience tailored to your preferences. Experience the future of grocery shopping with Delivo, where quality, convenience, and customer satisfaction are our top priorities.''',
                      style: TextStyle(fontSize: 16),
                    ),
                  ),
                ],
              ),

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
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const PolicyScreen(policyTitle: "Privacy Policy", content: '''This Privacy Policy describes Our policies and procedures on the collection, use and disclosure of Your information when You use the Service and tells You about Your privacy rights and how the law protects You.

We use Your Personal data to provide and improve the Service. By using the Service, You agree to the collection and use of information in accordance with this Privacy Policy. This Privacy Policy has been created with the help of the Free Privacy Policy Generator.

Interpretation and Definitions
Interpretation
The words of which the initial letter is capitalized have meanings defined under the following conditions. The following definitions shall have the same meaning regardless of whether they appear in singular or in plural.

Definitions
For the purposes of this Privacy Policy:

Account means a unique account created for You to access our Service or parts of our Service.

Affiliate means an entity that controls, is controlled by or is under common control with a party, where "control" means ownership of 50% or more of the shares, equity interest or other securities entitled to vote for election of directors or other managing authority.

Application refers to Delivo App, the software program provided by the Company.

Company (referred to as either "the Company", "We", "Us" or "Our" in this Agreement) refers to Kodeinnovate Solutions Private Limited, Mumbra, Thane 400612.

Country refers to: Maharashtra, India

Device means any device that can access the Service such as a computer, a cellphone or a digital tablet.

Personal Data is any information that relates to an identified or identifiable individual.

Service refers to the Application.

Service Provider means any natural or legal person who processes the data on behalf of the Company. It refers to third-party companies or individuals employed by the Company to facilitate the Service, to provide the Service on behalf of the Company, to perform services related to the Service or to assist the Company in analyzing how the Service is used.

Usage Data refers to data collected automatically, either generated by the use of the Service or from the Service infrastructure itself (for example, the duration of a page visit).

You means the individual accessing or using the Service, or the company, or other legal entity on behalf of which such individual is accessing or using the Service, as applicable.

Collecting and Using Your Personal Data
Types of Data Collected
Personal Data
While using Our Service, We may ask You to provide Us with certain personally identifiable information that can be used to contact or identify You. Personally identifiable information may include, but is not limited to:

First name and last name

Phone number

Address, State, Province, ZIP/Postal code, City

Usage Data

Usage Data
Usage Data is collected automatically when using the Service.

Usage Data may include information such as Your Device's Internet Protocol address (e.g. IP address), browser type, browser version, the pages of our Service that You visit, the time and date of Your visit, the time spent on those pages, unique device identifiers and other diagnostic data.

When You access the Service by or through a mobile device, We may collect certain information automatically, including, but not limited to, the type of mobile device You use, Your mobile device unique ID, the IP address of Your mobile device, Your mobile operating system, the type of mobile Internet browser You use, unique device identifiers and other diagnostic data.

We may also collect information that Your browser sends whenever You visit our Service or when You access the Service by or through a mobile device.

Information Collected while Using the Application
While using Our Application, in order to provide features of Our Application, We may collect, with Your prior permission:

Information regarding your location

Pictures and other information from your Device's camera and photo library

We use this information to provide features of Our Service, to improve and customize Our Service. The information may be uploaded to the Company's servers and/or a Service Provider's server or it may be simply stored on Your device.

You can enable or disable access to this information at any time, through Your Device settings.

Use of Your Personal Data
The Company may use Personal Data for the following purposes:

To provide and maintain our Service, including to monitor the usage of our Service.

To manage Your Account: to manage Your registration as a user of the Service. The Personal Data You provide can give You access to different functionalities of the Service that are available to You as a registered user.

For the performance of a contract: the development, compliance and undertaking of the purchase contract for the products, items or services You have purchased or of any other contract with Us through the Service.

To contact You: To contact You by email, telephone calls, SMS, or other equivalent forms of electronic communication, such as a mobile application's push notifications regarding updates or informative communications related to the functionalities, products or contracted services, including the security updates, when necessary or reasonable for their implementation.

To provide You with news, special offers and general information about other goods, services and events which we offer that are similar to those that you have already purchased or enquired about unless You have opted not to receive such information.

To manage Your requests: To attend and manage Your requests to Us.

For business transfers: We may use Your information to evaluate or conduct a merger, divestiture, restructuring, reorganization, dissolution, or other sale or transfer of some or all of Our assets, whether as a going concern or as part of bankruptcy, liquidation, or similar proceeding, in which Personal Data held by Us about our Service users is among the assets transferred.

For other purposes: We may use Your information for other purposes, such as data analysis, identifying usage trends, determining the effectiveness of our promotional campaigns and to evaluate and improve our Service, products, services, marketing and your experience.

We may share Your personal information in the following situations:

With Service Providers: We may share Your personal information with Service Providers to monitor and analyze the use of our Service, to contact You.
For business transfers: We may share or transfer Your personal information in connection with, or during negotiations of, any merger, sale of Company assets, financing, or acquisition of all or a portion of Our business to another company.
With Affiliates: We may share Your information with Our affiliates, in which case we will require those affiliates to honor this Privacy Policy. Affiliates include Our parent company and any other subsidiaries, joint venture partners or other companies that We control or that are under common control with Us.
With business partners: We may share Your information with Our business partners to offer You certain products, services or promotions.
With other users: when You share personal information or otherwise interact in the public areas with other users, such information may be viewed by all users and may be publicly distributed outside.
With Your consent: We may disclose Your personal information for any other purpose with Your consent.
Retention of Your Personal Data
The Company will retain Your Personal Data only for as long as is necessary for the purposes set out in this Privacy Policy. We will retain and use Your Personal Data to the extent necessary to comply with our legal obligations (for example, if we are required to retain your data to comply with applicable laws), resolve disputes, and enforce our legal agreements and policies.

The Company will also retain Usage Data for internal analysis purposes. Usage Data is generally retained for a shorter period of time, except when this data is used to strengthen the security or to improve the functionality of Our Service, or We are legally obligated to retain this data for longer time periods.

Transfer of Your Personal Data
Your information, including Personal Data, is processed at the Company's operating offices and in any other places where the parties involved in the processing are located. It means that this information may be transferred to — and maintained on — computers located outside of Your state, province, country or other governmental jurisdiction where the data protection laws may differ than those from Your jurisdiction.

Your consent to this Privacy Policy followed by Your submission of such information represents Your agreement to that transfer.

The Company will take all steps reasonably necessary to ensure that Your data is treated securely and in accordance with this Privacy Policy and no transfer of Your Personal Data will take place to an organization or a country unless there are adequate controls in place including the security of Your data and other personal information.

Delete Your Personal Data
You have the right to delete or request that We assist in deleting the Personal Data that We have collected about You.

Our Service may give You the ability to delete certain information about You from within the Service.

You may update, amend, or delete Your information at any time by signing in to Your Account, if you have one, and visiting the account settings section that allows you to manage Your personal information. You may also contact Us to request access to, correct, or delete any personal information that You have provided to Us.

Please note, however, that We may need to retain certain information when we have a legal obligation or lawful basis to do so.

Disclosure of Your Personal Data
Business Transactions
If the Company is involved in a merger, acquisition or asset sale, Your Personal Data may be transferred. We will provide notice before Your Personal Data is transferred and becomes subject to a different Privacy Policy.

Law enforcement
Under certain circumstances, the Company may be required to disclose Your Personal Data if required to do so by law or in response to valid requests by public authorities (e.g. a court or a government agency).

Other legal requirements
The Company may disclose Your Personal Data in the good faith belief that such action is necessary to:

Comply with a legal obligation
Protect and defend the rights or property of the Company
Prevent or investigate possible wrongdoing in connection with the Service
Protect the personal safety of Users of the Service or the public
Protect against legal liability
Security of Your Personal Data
The security of Your Personal Data is important to Us, but remember that no method of transmission over the Internet, or method of electronic storage is 100% secure. While We strive to use commercially acceptable means to protect Your Personal Data, We cannot guarantee its absolute security.

Children's Privacy
Our Service does not address anyone under the age of 13. We do not knowingly collect personally identifiable information from anyone under the age of 13. If You are a parent or guardian and You are aware that Your child has provided Us with Personal Data, please contact Us. If We become aware that We have collected Personal Data from anyone under the age of 13 without verification of parental consent, We take steps to remove that information from Our servers.

If We need to rely on consent as a legal basis for processing Your information and Your country requires consent from a parent, We may require Your parent's consent before We collect and use that information.

Links to Other Websites
Our Service may contain links to other websites that are not operated by Us. If You click on a third party link, You will be directed to that third party's site. We strongly advise You to review the Privacy Policy of every site You visit.

We have no control over and assume no responsibility for the content, privacy policies or practices of any third party sites or services.

Changes to this Privacy Policy
We may update Our Privacy Policy from time to time. We will notify You of any changes by posting the new Privacy Policy on this page.

We will let You know via email and/or a prominent notice on Our Service, prior to the change becoming effective and update the "Last updated" date at the top of this Privacy Policy.

You are advised to review this Privacy Policy periodically for any changes. Changes to this Privacy Policy are effective when they are posted on this page.

Contact Us
If you have any questions about this Privacy Policy, You can contact us:

By phone number: 9326500602''')),
                  );
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
                  Navigator.push(context, MaterialPageRoute(builder: (context) => const PolicyScreen(policyTitle: "Terms & Conditions", content: '''
Terms and Conditions

Thank you for accessing/shopping at https://play.google.com/store/apps/details?id=com.delivoapp.app. This site is owned by Kodeinnovate Solutions Private Limited (hereinafter referred to as “Delivo App”). By accessing or shopping on this site, you indicate your unconditional acceptance of these terms and conditions. We reserve the right, at our sole discretion, to update or revise these terms and conditions. Continued use of the site following the posting of any changes constitutes your acceptance of those changes. At “Delivo App”, we strive to create a space where you can explore and shop for all your favorite things in a safe and secure environment. All products and information displayed on “Delivo App” constitutes an "invitation to offer". “Delivo App” reserves the right to accept or reject your offer. Your order for purchase constitutes your "offer" which shall be subject to the terms and conditions as listed below.

1. *Eligibility to Use Our Site*
   Use of the Site is available only to persons who can legally enter into contracts under applicable laws. Persons who are "incompetent to contract", within the meaning of the Indian Contract Act, 1872 including un-discharged insolvents etc., are not eligible to use the Site. “Delivo App” reserves the right to terminate your access to the Site if it discovers that you are under the age of 18 years or suffer from any other disability, as recognized under the Indian Contract Act, 1872.

2. *Membership*
   Although it's not essential to have an account to shop with “Delivo App”, you can shop as a guest. As a member, you agree to provide true, accurate, current, and complete information about yourself as prompted by the site's registration form. Registration where prohibited under any law shall be void. “Delivo App” reserves the right to revoke or terminate your registration for any reason at any time, without notice.

3. *Electronic Communications*
   When you use the site or send emails or other data, information, or communication to us, you agree and understand that you are communicating with us electronically and give your consent to receive communications electronically from us periodically, when required.

4. *Reviews, Feedback, Submissions*
   All reviews, comments, feedback, postcards, suggestions, ideas, and other submissions disclosed, submitted, or offered to “Delivo App” directly or otherwise disclosed, submitted, or offered in connection with your use of this Site (collectively referred to "Comments") will remain “Delivo App” property. Such disclosure, submission, or offer of any comments shall constitute an assignment to “Delivo App” of all worldwide rights, titles, and interests in all copyrights and other intellectual properties in the comments. Thus, it exclusively owns all such rights, titles, and interests and shall not be limited in any way in its use, commercial or otherwise. “Delivo App” will be entitled to use, reproduce, disclose, modify, adapt, create derivative works from, publish, display, and distribute any comments you submit for any purpose whatsoever, without restriction and without compensating you in any way. “Delivo App” is and shall be under no obligation (1) to maintain any Comments in confidence; or (2) to pay you any compensation for any Comments; or (3) to respond to any Comments. You agree that any comments submitted by you to the Site will not violate this policy or any right of any third party, including copyright, trademark, privacy, or other personal or proprietary right(s), and will not cause injury to any person or entity. You further agree that no comments submitted by you to the site will be libelous or otherwise unlawful, threatening, abusive, or obscene material, or contain software viruses, political campaigning, commercial solicitation, chain letters, mass mailings or any form of "spam".
“Delivo App” does not regularly review posted comments, but does reserve the right (but not the obligation) to monitor and edit or remove any comment submitted to the Site. You grant “Delivo App” the right to use the name that you submit in connection with any of the posted comments. You agree not to use a false email address, impersonate any person or entity, or otherwise mislead as to the origin of any Comments you submit. You are and shall remain solely responsible for the content of any comments you make and you agree to indemnify “Delivo App” and its affiliates for all claims resulting from any Comments you submit. We take no responsibility and assume no liability for any comments submitted by you or any third party.

5. *Accuracy of Content/Information of Products on the Web Site*
   While “Delivo App” strives to provide accurate product and pricing information, typographical errors may occur. In the event that a product is listed at an incorrect price or with incorrect information due to an error in pricing or product information, “Delivo App” shall have the right, on our sole discretion, to modify the price of the products, or information of the products or to refuse or cancel any orders placed for that product, unless the product has already been dispatched.

6. *Limitation of Liability*
   Kodeinnovate Solutions Private Limited is not liable for any indirect, incidental, or consequential damages arising from the use of the app.

7. *Governing Law*
   These terms are governed by the laws of India.

8. *Changes to Terms*
   We may update these terms from time to time. Changes will be posted on our website and app.

For any queries, please contact us at info@kodeinnovate.in  ''')));//terms and conditions
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
                  Navigator.push(context, MaterialPageRoute(builder: (context) => const PolicyScreen(content: '''Delivo App Delivery Policy
1. Delivery Areas
Service Area: 400613
2. Delivery Hours
7 AM - 12 PM
3. Delivery Fees
Fees may vary
4. Delivery Time
Maximum 20 minutes''', policyTitle: "Delivery Policy")));
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
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const PolicyScreen(policyTitle: "Cancellation Policy for Delivo App", content: '''
1. No Order Cancellation Policy
Once an order has been placed on the Delivo App, it cannot be canceled. This policy is in place to ensure a seamless and efficient delivery process for all our users.

2. Company Information
Company Name: Kodeinnovate Solutions Pvt Ltd
Contact Number: +91-9326500602

3. Exceptions
In exceptional cases, if an order must be canceled due to unavoidable circumstances, please contact our customer service team immediately at the provided contact number. Requests will be reviewed on a case-by-case basis.''')),
                  );
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
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const PolicyScreen(policyTitle: "Refund Policy", content: '''Refund Policy

At Delivo App, we strive to provide excellent service. If you are not satisfied with your purchase, please review our refund policy below.

1. Refund Eligibility
   - Refunds are only applicable for incorrect or damaged items.
   - To be eligible for a refund, you must contact our support team within 3 working days of delivery.

2. Refund Process
   - Contact our support team at support@kodeinnovate.in with your order details and reason for the refund request.
   - Our team will review your request and, if approved, process the refund within 3 working days.
   - Refunds will be credited to the original payment method.

3. Non-Refundable Items
   - Perishable goods
   - Gift cards
   - Items purchased on sale

4. Support Contact
   - Email: support@kodeinnovate.in
   - Phone: 9326500602

Please note that order cancellations are not allowed once an order is placed.
''')),
                  );
                },//refund policy
              ),
            ],
          ),
        ),
      ),
    );
  }
}