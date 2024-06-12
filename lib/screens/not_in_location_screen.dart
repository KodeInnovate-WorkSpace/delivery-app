import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:speedy_delivery/screens/home_screen.dart';

class NotInLocationScreen extends StatelessWidget {
  const NotInLocationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvoked: (bool didPop) async {
        if (didPop) {
          return;
        }
      },
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Location Check'),
          automaticallyImplyLeading: false, // Removes the back button
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              const Icon(
                Icons.location_off,
                size: 100,
                // color: Colors.red,
              ),
              const SizedBox(height: 20),
              const Text(
                'Sorry, We Are Currently Not in This Location',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 20),
              ),
              const SizedBox(height: 20),
              Center(
                child: ElevatedButton(
                  onPressed: () {
                    HapticFeedback.heavyImpact();
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const HomeScreen()),
                    );
                  },
                  style: ButtonStyle(
                    shape: WidgetStateProperty.all<RoundedRectangleBorder>(
                      RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14.0),
                      ),
                    ),
                    backgroundColor: WidgetStateProperty.resolveWith<Color>(
                      (Set<WidgetState> states) {
                        return Colors.black;
                      },
                    ),
                  ),
                  child: const SizedBox(
                    width: 200,
                    height: 58,
                    child: Center(
                      child: Text(
                        "Try changing location",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 16.0,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// Usage example to check the state and navigate accordingly when the app starts
// void main() async {
//   WidgetsFlutterBinding.ensureInitialized();
//
//   SharedPreferences prefs = await SharedPreferences.getInstance();
//   bool? notInLocation = prefs.getBool('notInLocation');
//
//   runApp(MyApp(notInLocation: notInLocation ?? false));
// }

// class MyApp extends StatelessWidget {
//   final bool notInLocation;
//
//   const MyApp({super.key, required this.notInLocation});
//
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       title: 'Flutter Demo',
//       theme: ThemeData(
//         primarySwatch: Colors.blue,
//       ),
//       home: notInLocation ? const NotInLocationScreen() : const HomeScreen(),
//     );
//   }
// }
//
// // Dummy HomeScreen for illustration
// class HomeScreen extends StatelessWidget {
//   const HomeScreen({super.key});
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('Home'),
//       ),
//       body: const Center(
//         child: Text('Home Screen'),
//       ),
//     );
//   }
// }
//
// // Dummy DemoPage for illustration
// class DemoPage extends StatelessWidget {
//   const DemoPage({super.key});
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('Change location'),
//       ),
//       body: Center(
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             const Text('Change your location manually here'),
//             const SizedBox(height: 16),
//             // Building detail
//             SizedBox(
//               width: 300,
//               child: TextFormField(
//                 cursorColor: Colors.black,
//                 decoration: InputDecoration(
//                   hintText: 'Building',
//                   hintStyle: const TextStyle(
//                       color: Colors.black, fontWeight: FontWeight.normal),
//                   border: OutlineInputBorder(
//                     borderRadius: BorderRadius.circular(14.0),
//                     borderSide: const BorderSide(
//                         color: Colors.black), // Set the border color to red
//                   ),
//                   enabledBorder: OutlineInputBorder(
//                     borderRadius: BorderRadius.circular(14.0),
//                     borderSide: const BorderSide(
//                         color: Colors.black), // Set the border color to red
//                   ),
//                   focusedBorder: OutlineInputBorder(
//                     borderRadius: BorderRadius.circular(14.0),
//                     borderSide: const BorderSide(
//                         color: Colors.black), // Set the border color to red
//                   ),
//                   filled: true,
//                   fillColor: Colors.white,
//                   prefixIcon: const Icon(Icons
//                       .apartment), // Optional: icon color to match the border
//                 ),
//               ),
//             ),
//             const SizedBox(
//               height: 20,
//             ),
//
// // street detail
//             SizedBox(
//               width: 300,
//               child: TextFormField(
//                 cursorColor: Colors.black,
//                 decoration: InputDecoration(
//                   hintText: 'Street',
//                   hintStyle: const TextStyle(
//                       color: Colors.black, fontWeight: FontWeight.normal),
//                   border: OutlineInputBorder(
//                     borderRadius: BorderRadius.circular(14.0),
//                     borderSide: const BorderSide(
//                         color: Colors.black), // Set the border color to red
//                   ),
//                   enabledBorder: OutlineInputBorder(
//                     borderRadius: BorderRadius.circular(14.0),
//                     borderSide: const BorderSide(
//                         color: Colors.black), // Set the border color to red
//                   ),
//                   focusedBorder: OutlineInputBorder(
//                     borderRadius: BorderRadius.circular(14.0),
//                     borderSide: const BorderSide(
//                         color: Colors.black), // Set the border color to red
//                   ),
//                   filled: true,
//                   fillColor: Colors.white,
//                   prefixIcon: const Icon(Icons
//                       .signpost), // Optional: icon color to match the border
//                 ),
//               ),
//             ),
//             const SizedBox(
//               height: 20,
//             ),
//             // landmark
//             SizedBox(
//               width: 300,
//               child: TextFormField(
//                 cursorColor: Colors.black,
//                 decoration: InputDecoration(
//                   hintText: 'Landmark',
//                   hintStyle: const TextStyle(
//                       color: Colors.black, fontWeight: FontWeight.normal),
//                   border: OutlineInputBorder(
//                     borderRadius: BorderRadius.circular(14.0),
//                     borderSide: const BorderSide(
//                         color: Colors.black), // Set the border color to red
//                   ),
//                   enabledBorder: OutlineInputBorder(
//                     borderRadius: BorderRadius.circular(14.0),
//                     borderSide: const BorderSide(
//                         color: Colors.black), // Set the border color to red
//                   ),
//                   focusedBorder: OutlineInputBorder(
//                     borderRadius: BorderRadius.circular(14.0),
//                     borderSide: const BorderSide(
//                         color: Colors.black), // Set the border color to red
//                   ),
//                   filled: true,
//                   fillColor: Colors.white,
//                   prefixIcon: const Icon(
//                       Icons.place), // Optional: icon color to match the border
//                 ),
//               ),
//             ),
//             const SizedBox(
//               height: 20,
//             ),
//             Center(
//               child: ElevatedButton(
//                 onPressed: () => HapticFeedback.heavyImpact(),
//                 style: ButtonStyle(
//                   shape: WidgetStateProperty.all<RoundedRectangleBorder>(
//                     RoundedRectangleBorder(
//                       borderRadius: BorderRadius.circular(14.0),
//                     ),
//                   ),
//                   backgroundColor: WidgetStateProperty.resolveWith<Color>(
//                     (Set<WidgetState> states) {
//                       return Colors.black;
//                     },
//                   ),
//                 ),
//                 child: const SizedBox(
//                   width: 250,
//                   height: 58,
//                   child: Center(
//                     child: Text(
//                       "Continue",
//                       style: TextStyle(
//                         color: Colors.white,
//                         fontSize: 16.0,
//                       ),
//                     ),
//                   ),
//                 ),
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
