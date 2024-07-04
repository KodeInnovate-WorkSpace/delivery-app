import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:speedy_delivery/screens/home_screen.dart';
import 'package:speedy_delivery/screens/not_in_location_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ManualLocationScreen extends StatefulWidget {
  const ManualLocationScreen({super.key});

  @override
  State<ManualLocationScreen> createState() => _ManualLocationScreenState();
}

class _ManualLocationScreenState extends State<ManualLocationScreen> {
  final TextEditingController _locationController = TextEditingController();
  late SharedPreferences _prefs;

  @override
  void initState() {
    super.initState();
    _initPrefs();
  }

  Future<void> _initPrefs() async {
    _prefs = await SharedPreferences.getInstance();
  }

  Future<void> _checkManualLocation() async {
    String location = _locationController.text.trim();
    try {
      QuerySnapshot querySnapshot = await FirebaseFirestore.instance.collection('location').where('postal_code', isEqualTo: int.parse(location)).where('status', isEqualTo: 1).get();

      if (querySnapshot.docs.isNotEmpty) {
        _prefs.setBool('manualLocationSet', true);
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (context) => const HomeScreen(temporaryAccess: true)),
          (route) => false,
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Location not supported')),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $e')),
      );
    }
  }

  void navigateToManualLocation() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const NotInLocationScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Location Manually'),
        backgroundColor: Colors.green,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Enter your postal code to check if we deliver to your location:',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 20),
            TextField(
              controller: _locationController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                labelText: 'Enter Postal Code',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ),
            const SizedBox(height: 20),
            Row(
              children: [
                Expanded(
                  child: ElevatedButton(
                    onPressed: _checkManualLocation,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green,
                      padding: const EdgeInsets.symmetric(vertical: 16.0),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14.0),
                      ),
                    ),
                    child: const Text(
                      'Check Location',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16.0,
                      ),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            Row(
              children: [
                Expanded(
                  child: ElevatedButton(
                    onPressed: navigateToManualLocation,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green,
                      padding: const EdgeInsets.symmetric(vertical: 16.0),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14.0),
                      ),
                    ),
                    child: const Text(
                      'Get Current Location',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16.0,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

// import 'package:flutter/material.dart';
// import 'package:shared_preferences/shared_preferences.dart';
// import 'package:speedy_delivery/screens/home_screen.dart';
// import 'package:speedy_delivery/screens/not_in_location_screen.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
//
// class ManualLocationScreen extends StatefulWidget {
//   const ManualLocationScreen({super.key});
//
//   @override
//   State<ManualLocationScreen> createState() => _ManualLocationScreenState();
// }
//
// class _ManualLocationScreenState extends State<ManualLocationScreen> {
//   final TextEditingController _locationController = TextEditingController();
//   late SharedPreferences _prefs;
//   List<int> _postalCodes = [];
//   int? _selectedPostalCode;
//
//   @override
//   void initState() {
//     super.initState();
//     _initPrefs();
//     _fetchPostalCodes();
//   }
//
//   Future<void> _initPrefs() async {
//     _prefs = await SharedPreferences.getInstance();
//   }
//
//   Future<void> _fetchPostalCodes() async {
//     try {
//       QuerySnapshot querySnapshot = await FirebaseFirestore.instance.collection('location').where('status', isEqualTo: 1).get();
//       setState(() {
//         _postalCodes = querySnapshot.docs.map((doc) => doc['postal_code'] as int).toList();
//       });
//     } catch (e) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(content: Text('Error fetching postal codes: $e')),
//       );
//     }
//   }
//
//   void _checkManualLocation() {
//     if (_selectedPostalCode != null) {
//       _prefs.setBool('manualLocationSet', true);
//       Navigator.pushAndRemoveUntil(
//         context,
//         MaterialPageRoute(builder: (context) => const HomeScreen(temporaryAccess: true)),
//         (route) => false,
//       );
//     } else {
//       ScaffoldMessenger.of(context).showSnackBar(
//         const SnackBar(content: Text('Please select a location')),
//       );
//     }
//   }
//
//   void navigateToManualLocation() {
//     Navigator.push(
//       context,
//       MaterialPageRoute(builder: (context) => const NotInLocationScreen()),
//     );
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('Add Location Manually'),
//         //  backgroundColor: Colors.green,
//       ),
//       body: SingleChildScrollView(
//         padding: const EdgeInsets.all(16.0),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             const Text(
//               'Select Your Location',
//               style: TextStyle(
//                 fontSize: 20,
//                 fontWeight: FontWeight.bold,
//                 color: Colors.green,
//               ),
//             ),
//             const SizedBox(height: 20),
//             DropdownButtonFormField<int>(
//               value: _selectedPostalCode,
//               hint: const Text('Select Postal Code'),
//               decoration: InputDecoration(
//                 border: OutlineInputBorder(
//                   borderRadius: BorderRadius.circular(14.0),
//                 ),
//                 contentPadding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 15.0),
//               ),
//               onChanged: (int? newValue) {
//                 setState(() {
//                   _selectedPostalCode = newValue;
//                 });
//               },
//               items: _postalCodes.map<DropdownMenuItem<int>>((int value) {
//                 return DropdownMenuItem<int>(
//                   value: value,
//                   child: Text(value.toString()),
//                 );
//               }).toList(),
//             ),
//             const SizedBox(height: 20),
//             ElevatedButton(
//               onPressed: _checkManualLocation,
//               style: ElevatedButton.styleFrom(
//                 backgroundColor: Colors.green,
//                 shape: RoundedRectangleBorder(
//                   borderRadius: BorderRadius.circular(14.0),
//                 ),
//                 padding: const EdgeInsets.symmetric(vertical: 15.0),
//               ),
//               child: const SizedBox(
//                 width: double.infinity,
//                 child: Center(
//                   child: Text(
//                     'Check Location',
//                     style: TextStyle(
//                       color: Colors.white,
//                       fontSize: 16.0,
//                     ),
//                   ),
//                 ),
//               ),
//             ),
//             const SizedBox(height: 20),
//             ElevatedButton(
//               onPressed: navigateToManualLocation,
//               style: ElevatedButton.styleFrom(
//                 backgroundColor: Colors.green,
//                 shape: RoundedRectangleBorder(
//                   borderRadius: BorderRadius.circular(14.0),
//                 ),
//                 padding: const EdgeInsets.symmetric(vertical: 15.0),
//               ),
//               child: const SizedBox(
//                 width: double.infinity,
//                 child: Center(
//                   child: Text(
//                     'Get Current Location',
//                     style: TextStyle(
//                       color: Colors.white,
//                       fontSize: 16.0,
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
