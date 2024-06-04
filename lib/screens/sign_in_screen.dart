// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
// import 'package:provider/provider.dart';
// import 'package:speedy_delivery/providers/auth_provider.dart';
// import 'package:speedy_delivery/services/store_user.dart';
// import '../widget/terms_privacy_line.dart';
//
// class SigninScreen extends StatefulWidget {
//   const SigninScreen({super.key});
//
//   @override
//   State<SigninScreen> createState() => _SigninScreenState();
// }
//
// class _SigninScreenState extends State<SigninScreen> {
//   @override
//   Widget build(BuildContext context) {
//     final authProvider = Provider.of<MyAuthProvider>(context);
//
//     return Scaffold(
//         body: Container(
//       decoration: const BoxDecoration(
//         color: Colors.amberAccent,
//       ),
//       child: Column(
//         mainAxisAlignment: MainAxisAlignment.end,
//         children: [
//           splashWidget(),
//           const SizedBox(
//             height: 50,
//           ),
//           const SizedBox(
//             height: 50,
//           ),
//           Container(
//             width: MediaQuery.of(context).size.width,
//             height: MediaQuery.of(context).size.height / 3.5,
//             decoration: const BoxDecoration(
//               color: Colors.white,
//               borderRadius: BorderRadius.only(
//                 topLeft: Radius.circular(30.0),
//                 topRight: Radius.circular(30.0),
//               ),
//             ),
//             child: Column(
//               mainAxisAlignment: MainAxisAlignment.spaceAround,
//               crossAxisAlignment: CrossAxisAlignment.center,
//               children: [
//                 const SizedBox(
//                   height: 8,
//                 ),
//                 const Text(
//                   "Log in or sign up",
//                   style: TextStyle(fontFamily: "Gilroy-Bold", fontSize: 20),
//                 ),
//                 Padding(
//                   padding: const EdgeInsets.symmetric(horizontal: 30),
//                   child: TextField(
//                     controller: authProvider.textController,
//                     maxLength: 10,
//                     autofocus: true,
//                     keyboardType: TextInputType.phone,
//                     decoration: InputDecoration(
//                       hintText: "Enter Mobile Number",
//                       hintStyle: TextStyle(
//                           color: Colors.grey[400],
//                           fontFamily: 'Gilroy-SemiBold'),
//                       prefixIcon: const Padding(
//                         padding: EdgeInsets.all(18.0),
//                         child: Text(
//                           "+91",
//                           style: TextStyle(
//                               fontWeight: FontWeight.bold,
//                               fontFamily: 'Gilroy-SemiBold'),
//                         ),
//                       ),
//                       prefixIconConstraints:
//                           const BoxConstraints(minWidth: 0, minHeight: 0),
//                       contentPadding: const EdgeInsets.symmetric(
//                           vertical: 15, horizontal: 20),
//                       border: OutlineInputBorder(
//                         borderRadius: BorderRadius.circular(14.0),
//                         borderSide: BorderSide(color: Colors.grey.shade50),
//                       ),
//                       enabledBorder: OutlineInputBorder(
//                         borderRadius: BorderRadius.circular(14.0),
//                         borderSide: BorderSide(color: Colors.grey.shade100),
//                       ),
//                       focusedBorder: OutlineInputBorder(
//                         borderRadius: BorderRadius.circular(14.0),
//                         borderSide:
//                             const BorderSide(color: Colors.grey, width: 1.0),
//                       ),
//                     ),
//                   ),
//                 ),
//                 ElevatedButton(
//                   onPressed: authProvider.isButtonEnabled
//                       ? () async {
//                           HapticFeedback.selectionClick();
//
//                           await StoreUser().storeUserData(context);
//                           authProvider.verifyPhoneNumber(
//                               context, authProvider.textController.text);
//                         }
//                       : null,
//                   style: ButtonStyle(
//                     shape: WidgetStateProperty.all<RoundedRectangleBorder>(
//                       RoundedRectangleBorder(
//                         borderRadius: BorderRadius.circular(14.0),
//                       ),
//                     ),
//                     backgroundColor: WidgetStateProperty.resolveWith<Color>(
//                       (Set<WidgetState> states) {
//                         if (states.contains(WidgetState.disabled)) {
//                           return Colors.black.withOpacity(0.3);
//                         }
//                         return Colors.black;
//                       },
//                     ),
//                   ),
//                   child: authProvider.isLoading
//                       ? const SizedBox(
//                           width: 250,
//                           height: 50.0,
//                           child: Center(
//                             child: CircularProgressIndicator(
//                               color: Colors.white, // Adjust color as needed
//                             ),
//                           ),
//                         )
//                       : const SizedBox(
//                           width: 250,
//                           height: 50.0,
//                           child: Center(
//                             child: Text(
//                               "Continue",
//                               style: TextStyle(
//                                 color: Colors.white,
//                                 fontSize: 16.0,
//                               ),
//                             ),
//                           ),
//                         ),
//                 ),
//                 termsPrivacyLine(),
//                 const Row(
//                   mainAxisAlignment: MainAxisAlignment.center,
//                   children: [
//                     Text(
//                       "Developed by Kodeinnovate Solutions",
//                       style: TextStyle(fontSize: 10),
//                     ),
//                   ],
//                 )
//               ],
//             ),
//           )
//         ],
//       ),
//     ));
//   }
// }
//
// Widget splashWidget() {
//   return Column(
//     mainAxisAlignment: MainAxisAlignment.center,
//     children: [
//       Column(
//         children: [
//           Row(
//             mainAxisAlignment: MainAxisAlignment.center,
//             children: [
//               Text(
//                 "Delivery",
//                 style: TextStyle(
//                     fontFamily: 'Gilroy-Bold',
//                     fontWeight: FontWeight.w900,
//                     fontSize: 50.0,
//                     color: Colors.brown.shade900),
//               ),
//               Text(
//                 'App',
//                 style: TextStyle(
//                     fontFamily: 'Gilroy-Bold',
//                     fontWeight: FontWeight.w900,
//                     fontSize: 50.0,
//                     color: Colors.green[600]),
//               )
//             ],
//           ),
//           const Text(
//             'Mumbra\'s Last Minute App',
//             style: TextStyle(
//                 fontFamily: 'Gilroy-Regular',
//                 fontWeight: FontWeight.w600,
//                 fontSize: 15.0,
//                 color: Colors.black),
//           ),
//         ],
//       ),
//       const SizedBox(
//         height: 30,
//       ),
//     ],
//   );
// }
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:speedy_delivery/providers/auth_provider.dart';
import 'package:speedy_delivery/services/store_user.dart';
import 'package:speedy_delivery/widget/terms_privacy_line.dart';
import 'package:speedy_delivery/widget/network_handler.dart';

class SigninScreen extends StatefulWidget {
  const SigninScreen({Key? key}) : super(key: key);

  @override
  State<SigninScreen> createState() => _SigninScreenState();
}

class _SigninScreenState extends State<SigninScreen> {
  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<MyAuthProvider>(context);

    return Scaffold(
      resizeToAvoidBottomInset: true, // This will adjust the layout when the keyboard is shown
      body: NetworkHandler(
        child: Container(
          decoration: const BoxDecoration(
            color: Colors.amberAccent,
          ),
          child: SingleChildScrollView( // Added SingleChildScrollView
            child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                splashWidget(),
                const SizedBox(height: 50),
                const SizedBox(height: 50),
                Container(
                  width: MediaQuery.of(context).size.width,
                  height: MediaQuery.of(context).size.height / 3.5,
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(30.0),
                      topRight: Radius.circular(30.0),
                    ),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      const SizedBox(height: 8),
                      const Text(
                        "Log in or sign up",
                        style: TextStyle(fontFamily: "Gilroy-Bold", fontSize: 20),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 30),
                        child: TextField(
                          controller: authProvider.textController,
                          maxLength: 10,
                          autofocus: true,
                          keyboardType: TextInputType.phone,
                          decoration: InputDecoration(
                            hintText: "Enter Mobile Number",
                            hintStyle: TextStyle(
                                color: Colors.grey[400],
                                fontFamily: 'Gilroy-SemiBold'),
                            prefixIcon: const Padding(
                              padding: EdgeInsets.all(18.0),
                              child: Text(
                                "+91",
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontFamily: 'Gilroy-SemiBold'),
                              ),
                            ),
                            prefixIconConstraints:
                            const BoxConstraints(minWidth: 0, minHeight: 0),
                            contentPadding: const EdgeInsets.symmetric(
                                vertical: 15, horizontal: 20),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(14.0),
                              borderSide: BorderSide(color: Colors.grey.shade50),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(14.0),
                              borderSide: BorderSide(color: Colors.grey.shade100),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(14.0),
                              borderSide:
                              const BorderSide(color: Colors.grey, width: 1.0),
                            ),
                          ),
                        ),
                      ),
                      ElevatedButton(
                        onPressed: authProvider.isButtonEnabled
                            ? () async {
                          HapticFeedback.selectionClick();

                          await StoreUser().storeUserData(context);
                          authProvider.verifyPhoneNumber(
                              context, authProvider.textController.text);
                        }
                            : null,
                        style: ButtonStyle(
                          shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                            RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(14.0),
                            ),
                          ),
                          backgroundColor: MaterialStateProperty.resolveWith<Color>(
                                (Set<MaterialState> states) {
                              if (states.contains(MaterialState.disabled)) {
                                return Colors.black.withOpacity(0.3);
                              }
                              return Colors.black;
                            },
                          ),
                        ),
                        child: authProvider.isLoading
                            ? const SizedBox(
                          width: 250,
                          height: 50.0,
                          child: Center(
                            child: CircularProgressIndicator(
                              color: Colors.white, // Adjust color as needed
                            ),
                          ),
                        )
                            : const SizedBox(
                          width: 250,
                          height: 50.0,
                          child: Center(
                            child: Text(
                              "Continue",
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 16.0,
                              ),
                            ),
                          ),
                        ),
                      ),
                      termsPrivacyLine(),
                      const Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            "Developed by Kodeinnovate Solutions",
                            style: TextStyle(fontSize: 10),
                          ),
                        ],
                      )
                    ],
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}

Widget splashWidget() {
  return Column(
    mainAxisAlignment: MainAxisAlignment.center,
    children: [
      Image.asset("assets/images/speedy.png"),
    ],
  );
}