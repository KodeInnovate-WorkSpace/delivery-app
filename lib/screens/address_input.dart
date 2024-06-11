// import 'dart:developer';
//
// import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';
// import 'package:speedy_delivery/providers/check_user_provider.dart';
// import '../models/address_model.dart';
// import '../providers/address_provider.dart';
// import '../providers/auth_provider.dart';
//
// class AddressInputForm extends StatefulWidget {
//   const AddressInputForm({super.key});
//
//   @override
//   State<AddressInputForm> createState() => _AddressInputFormState();
// }
//
// class _AddressInputFormState extends State<AddressInputForm> {
//   final _formKey = GlobalKey<FormState>();
//   final _flatController = TextEditingController();
//   final _floorController = TextEditingController();
//   final _buildingController = TextEditingController();
//   final _landmarkController = TextEditingController();
//   final _nameController = TextEditingController();
//   final _phoneController = TextEditingController();
//
//   @override
//   void initState() {
//     super.initState();
//     final authProvider = Provider.of<MyAuthProvider>(context, listen: false);
//     if (authProvider.textController.text.isNotEmpty) {
//       _phoneController.text = authProvider.textController.text;
//     }
//   }
//
//   @override
//   void dispose() {
//     _flatController.dispose();
//     _floorController.dispose();
//     _buildingController.dispose();
//     _landmarkController.dispose();
//     _phoneController.dispose();
//     super.dispose();
//   }
//
//   void _saveAddress() {
//     if (_formKey.currentState!.validate()) {
//       try {
//         final address = Address(
//           flat: _flatController.text,
//           floor: _floorController.text,
//           building: _buildingController.text,
//           mylandmark: _landmarkController.text,
//         );
//
//         Provider.of<AddressProvider>(context, listen: false)
//             .addAddress(address);
//         Navigator.of(context).pop();
//       } catch (e) {
//         log("Error saving address (address_input.dart): $e");
//       }
//     }
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     // final authProvider = Provider.of<MyAuthProvider>(context);
//     final userProvider = Provider.of<CheckUserProvider>(context);
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text("Enter Address"),
//       ),
//       body: SingleChildScrollView(
//         child: Padding(
//           padding: const EdgeInsets.all(16.0),
//           child: Form(
//             key: _formKey,
//             child: Column(
//               mainAxisAlignment: MainAxisAlignment.center,
//               children: [
//                 // Flat No
//                 SizedBox(
//                   width: MediaQuery.of(context).size.width,
//                   // width: 250,
//                   child: TextFormField(
//                     controller: _flatController,
//                     cursorColor: Colors.black,
//                     decoration: InputDecoration(
//                       hintText: "Flat No.",
//                       hintStyle: const TextStyle(
//                           color: Colors.black, fontWeight: FontWeight.normal),
//                       border: OutlineInputBorder(
//                         borderRadius: BorderRadius.circular(14.0),
//                         borderSide: const BorderSide(color: Colors.black),
//                       ),
//                       enabledBorder: OutlineInputBorder(
//                         borderRadius: BorderRadius.circular(14.0),
//                         borderSide: const BorderSide(color: Colors.black),
//                       ),
//                       focusedBorder: OutlineInputBorder(
//                         borderRadius: BorderRadius.circular(14.0),
//                         borderSide: const BorderSide(color: Colors.black),
//                       ),
//                       filled: true,
//                       fillColor: Colors.white,
//                       prefixIcon: const Icon(Icons.home),
//                     ),
//                     validator: (value) {
//                       if (value!.isEmpty) {
//                         return "Please enter Flat No";
//                       }
//                       return null;
//                     },
//                   ),
//                 ),
//                 const SizedBox(
//                   height: 20,
//                 ),
//                 // floor
//                 SizedBox(
//                   width: MediaQuery.of(context).size.width,
//                   // width: 250,
//                   child: TextFormField(
//                     controller: _floorController,
//                     cursorColor: Colors.black,
//                     decoration: InputDecoration(
//                       hintText: "Floor",
//                       hintStyle: const TextStyle(
//                           color: Colors.black, fontWeight: FontWeight.normal),
//                       border: OutlineInputBorder(
//                         borderRadius: BorderRadius.circular(14.0),
//                         borderSide: const BorderSide(color: Colors.black),
//                       ),
//                       enabledBorder: OutlineInputBorder(
//                         borderRadius: BorderRadius.circular(14.0),
//                         borderSide: const BorderSide(color: Colors.black),
//                       ),
//                       focusedBorder: OutlineInputBorder(
//                         borderRadius: BorderRadius.circular(14.0),
//                         borderSide: const BorderSide(color: Colors.black),
//                       ),
//                       filled: true,
//                       fillColor: Colors.white,
//                       prefixIcon: const Icon(Icons.chalet),
//                     ),
//                     validator: (value) {
//                       if (value!.isEmpty) {
//                         return "Please enter FLoor";
//                       }
//                       return null;
//                     },
//                   ),
//                 ),
//                 const SizedBox(
//                   height: 20,
//                 ),
//                 //building
//                 SizedBox(
//                   width: MediaQuery.of(context).size.width,
//                   // width: 250,
//                   child: TextFormField(
//                     controller: _buildingController,
//                     cursorColor: Colors.black,
//                     decoration: InputDecoration(
//                       hintText: "Building name",
//                       hintStyle: const TextStyle(
//                           color: Colors.black, fontWeight: FontWeight.normal),
//                       border: OutlineInputBorder(
//                         borderRadius: BorderRadius.circular(14.0),
//                         borderSide: const BorderSide(color: Colors.black),
//                       ),
//                       enabledBorder: OutlineInputBorder(
//                         borderRadius: BorderRadius.circular(14.0),
//                         borderSide: const BorderSide(color: Colors.black),
//                       ),
//                       focusedBorder: OutlineInputBorder(
//                         borderRadius: BorderRadius.circular(14.0),
//                         borderSide: const BorderSide(color: Colors.black),
//                       ),
//                       filled: true,
//                       fillColor: Colors.white,
//                       prefixIcon: const Icon(Icons.apartment),
//                     ),
//                     validator: (value) {
//                       if (value!.isEmpty) {
//                         return "Please enter Building";
//                       }
//                       return null;
//                     },
//                   ),
//                 ),
//                 const SizedBox(
//                   height: 20,
//                 ),
//
//                 // landmark
//                 SizedBox(
//                   width: MediaQuery.of(context).size.width,
//                   // width: 250,
//                   child: TextFormField(
//                     controller: _landmarkController,
//                     cursorColor: Colors.black,
//                     decoration: InputDecoration(
//                       hintText: "Landmark",
//                       hintStyle: const TextStyle(
//                           color: Colors.black, fontWeight: FontWeight.normal),
//                       border: OutlineInputBorder(
//                         borderRadius: BorderRadius.circular(14.0),
//                         borderSide: const BorderSide(color: Colors.black),
//                       ),
//                       enabledBorder: OutlineInputBorder(
//                         borderRadius: BorderRadius.circular(14.0),
//                         borderSide: const BorderSide(color: Colors.black),
//                       ),
//                       focusedBorder: OutlineInputBorder(
//                         borderRadius: BorderRadius.circular(14.0),
//                         borderSide: const BorderSide(color: Colors.black),
//                       ),
//                       filled: true,
//                       fillColor: Colors.white,
//                       prefixIcon: const Icon(Icons.landscape),
//                     ),
//                     validator: (value) {
//                       if (value!.isEmpty) {
//                         return "Please enter Landmark";
//                       }
//                       return null;
//                     },
//                   ),
//                 ),
//                 const SizedBox(
//                   height: 20,
//                 ),
//                 // name
//                 SizedBox(
//                   width: MediaQuery.of(context).size.width,
//                   // width: 250,
//                   child: TextFormField(
//                     controller: _nameController,
//                     cursorColor: Colors.black,
//                     decoration: InputDecoration(
//                       hintText: "Name",
//                       hintStyle: const TextStyle(
//                           color: Colors.black, fontWeight: FontWeight.normal),
//                       border: OutlineInputBorder(
//                         borderRadius: BorderRadius.circular(14.0),
//                         borderSide: const BorderSide(color: Colors.black),
//                       ),
//                       enabledBorder: OutlineInputBorder(
//                         borderRadius: BorderRadius.circular(14.0),
//                         borderSide: const BorderSide(color: Colors.black),
//                       ),
//                       focusedBorder: OutlineInputBorder(
//                         borderRadius: BorderRadius.circular(14.0),
//                         borderSide: const BorderSide(color: Colors.black),
//                       ),
//                       filled: true,
//                       fillColor: Colors.white,
//                       prefixIcon: const Icon(Icons.person),
//                     ),
//                     validator: (value) {
//                       if (value!.isEmpty) {
//                         return "Please enter Name";
//                       }
//                       return null;
//                     },
//                   ),
//                 ),
//                 const SizedBox(
//                   height: 20,
//                 ),
//                 // phone number
//                 SizedBox(
//                   width: MediaQuery.of(context).size.width,
//                   // width: 250,
//                   child: TextFormField(
//                     controller: _phoneController,
//                     keyboardType: TextInputType.number,
//                     cursorColor: Colors.black,
//                     decoration: InputDecoration(
//                       hintText: "Phone",
//                       hintStyle: const TextStyle(
//                           color: Colors.black, fontWeight: FontWeight.normal),
//                       border: OutlineInputBorder(
//                         borderRadius: BorderRadius.circular(14.0),
//                         borderSide: const BorderSide(color: Colors.black),
//                       ),
//                       enabledBorder: OutlineInputBorder(
//                         borderRadius: BorderRadius.circular(14.0),
//                         borderSide: const BorderSide(color: Colors.black),
//                       ),
//                       focusedBorder: OutlineInputBorder(
//                         borderRadius: BorderRadius.circular(14.0),
//                         borderSide: const BorderSide(color: Colors.black),
//                       ),
//                       filled: true,
//                       fillColor: Colors.white,
//                       prefixIcon: const Icon(Icons.phone),
//                     ),
//                     validator: (value) {
//                       if (value!.isEmpty) {
//                         return "Please enter Phone";
//                       }
//                       return null;
//                     },
//                   ),
//                 ),
//                 const SizedBox(
//                   height: 20,
//                 ),
//
//                 const SizedBox(height: 20),
//                 ElevatedButton(
//                   onPressed: () {
//                     _saveAddress();
//                     // store username in firebase
//                     userProvider.storeDetail(
//                         context, 'name', _nameController.text);
//                     Navigator.pop(context, true); // Close the bottom modal
//                   },
//                   style: ElevatedButton.styleFrom(
//                     fixedSize: const Size(
//                         250, 50), // Set your desired width and height
//                     shape: RoundedRectangleBorder(
//                       borderRadius: BorderRadius.circular(10.0),
//                     ),
//                     backgroundColor: Colors.black,
//                   ),
//                   child: const Row(
//                     mainAxisAlignment: MainAxisAlignment.center,
//                     children: [
//                       Icon(
//                         Icons.add,
//                         color: Colors.white,
//                       ),
//                       SizedBox(),
//                       Text(
//                         "Save address",
//                         style: TextStyle(color: Colors.white),
//                       ),
//                     ],
//                   ),
//                 ),
//
//                 // add address button
//               ],
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }

import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:speedy_delivery/providers/check_user_provider.dart';
import '../models/address_model.dart';
import '../providers/address_provider.dart';
import '../providers/auth_provider.dart';

class AddressInputForm extends StatefulWidget {
  const AddressInputForm({super.key});

  @override
  State<AddressInputForm> createState() => _AddressInputFormState();
}

class _AddressInputFormState extends State<AddressInputForm> {
  final _formKey = GlobalKey<FormState>();
  final _flatController = TextEditingController();
  final _floorController = TextEditingController();
  final _buildingController = TextEditingController();
  final _landmarkController = TextEditingController();
  final _nameController = TextEditingController();
  final _phoneController = TextEditingController();

  @override
  void initState() {
    super.initState();
    final authProvider = Provider.of<MyAuthProvider>(context, listen: false);
    if (authProvider.textController.text.isNotEmpty) {
      _phoneController.text = authProvider.textController.text;
    }
  }

  @override
  void dispose() {
    _flatController.dispose();
    _floorController.dispose();
    _buildingController.dispose();
    _landmarkController.dispose();
    _phoneController.dispose();
    super.dispose();
  }

  void _saveAddress() {
    if (_formKey.currentState!.validate()) {
      try {
        final address = Address(
          flat: _flatController.text,
          floor: _floorController.text,
          building: _buildingController.text,
          mylandmark: _landmarkController.text,
        );

        Provider.of<AddressProvider>(context, listen: false)
            .addAddress(address);
        Navigator.of(context).pop();
      } catch (e) {
        log("Error saving address (address_input.dart): $e");
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final userProvider = Provider.of<CheckUserProvider>(context);
    return Scaffold(
      appBar: AppBar(
        title: const Text("Enter Address"),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(
                  width: MediaQuery.of(context).size.width,
                  child: TextFormField(
                    controller: _flatController,
                    cursorColor: Colors.black,
                    decoration: const InputDecoration(
                      hintText: "Flat No.",
                      prefixIcon: Icon(Icons.home),
                    ),
                    validator: (value) {
                      if (value!.isEmpty) {
                        return "Please enter Flat No";
                      }
                      return null;
                    },
                  ),
                ),
                const SizedBox(height: 20),
                SizedBox(
                  width: MediaQuery.of(context).size.width,
                  child: TextFormField(
                    controller: _floorController,
                    cursorColor: Colors.black,
                    decoration: const InputDecoration(
                      hintText: "Floor",
                      prefixIcon: Icon(Icons.chalet),
                    ),
                    validator: (value) {
                      if (value!.isEmpty) {
                        return "Please enter Floor";
                      }
                      return null;
                    },
                  ),
                ),
                const SizedBox(height: 20),
                SizedBox(
                  width: MediaQuery.of(context).size.width,
                  child: TextFormField(
                    controller: _buildingController,
                    cursorColor: Colors.black,
                    decoration: const InputDecoration(
                      hintText: "Building name",
                      prefixIcon: Icon(Icons.apartment),
                    ),
                    validator: (value) {
                      if (value!.isEmpty) {
                        return "Please enter Building";
                      }
                      return null;
                    },
                  ),
                ),
                const SizedBox(height: 20),
                SizedBox(
                  width: MediaQuery.of(context).size.width,
                  child: TextFormField(
                    controller: _landmarkController,
                    cursorColor: Colors.black,
                    decoration: const InputDecoration(
                      hintText: "Landmark",
                      prefixIcon: Icon(Icons.landscape),
                    ),
                    validator: (value) {
                      if (value!.isEmpty) {
                        return "Please enter Landmark";
                      }
                      return null;
                    },
                  ),
                ),
                const SizedBox(height: 20),
                SizedBox(
                  width: MediaQuery.of(context).size.width,
                  child: TextFormField(
                    controller: _nameController,
                    cursorColor: Colors.black,
                    decoration: const InputDecoration(
                      hintText: "Name",
                      prefixIcon: Icon(Icons.person),
                    ),
                    validator: (value) {
                      if (value!.isEmpty) {
                        return "Please enter Name";
                      }
                      return null;
                    },
                  ),
                ),
                const SizedBox(height: 20),
                SizedBox(
                  width: MediaQuery.of(context).size.width,
                  child: TextFormField(
                    controller: _phoneController,
                    keyboardType: TextInputType.phone,
                    cursorColor: Colors.black,
                    decoration: const InputDecoration(
                      hintText: "Phone",
                      prefixIcon: Icon(Icons.phone),
                    ),
                    validator: (value) {
                      if (value!.isEmpty) {
                        return "Please enter Phone";
                      } else if (!RegExp(r'^[0-9]{10}$').hasMatch(value)) {
                        return "Please enter a valid 10 digit phone number";
                      }
                      return null;
                    },
                  ),
                ),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      _saveAddress();
                      userProvider.storeDetail(
                          context, 'name', _nameController.text);
                      Navigator.pop(context, true);
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    fixedSize: const Size(250, 50),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                    backgroundColor: Colors.black,
                  ),
                  child: const Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.add,
                        color: Colors.white,
                      ),
                      SizedBox(),
                      Text(
                        "Save address",
                        style: TextStyle(color: Colors.white),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
