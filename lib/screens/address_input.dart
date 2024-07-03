import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:speedy_delivery/providers/check_user_provider.dart';
import 'package:speedy_delivery/widget/input_box.dart';
import '../models/address_model.dart';
import '../providers/address_provider.dart';
import '../providers/auth_provider.dart';
import '../shared/show_msg.dart';

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
  final _pincodeController = TextEditingController();

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
    _pincodeController.dispose();
    super.dispose();
  }

  Future<bool> _isValidPincode(String pincode) async {
    try {
      final int pincodeInt = int.parse(pincode);
      const int status = 1; // Ensure status is also an integer
      final querySnapshot = await FirebaseFirestore.instance.collection('location').where('postal_code', isEqualTo: pincodeInt).where('status', isEqualTo: status).get();

      log("Pincode check: ${querySnapshot.docs.length} documents found for pincode $pincode with status $status");

      for (var doc in querySnapshot.docs) {
        log("Document data: ${doc.data()}");
      }

      return querySnapshot.docs.isNotEmpty;
    } catch (e) {
      log("Error checking pincode: $e");
      return false;
    }
  }

  void _saveAddress() async {
    if (_formKey.currentState!.validate()) {
      try {
        final pincode = _pincodeController.text;
        final isValid = await _isValidPincode(pincode);

        if (!isValid) {
          showMessage("Invalid pincode or delivery not available in this area.");
          return;
        }

        final address = Address(
          flat: _flatController.text,
          floor: _floorController.text,
          building: _buildingController.text,
          mylandmark: _landmarkController.text,
          phoneNumber: _phoneController.text,
          pincode: int.parse(pincode),
        );

        Provider.of<AddressProvider>(context, listen: false).addAddress(address);
        log("Address saved successfully: $address");
        Navigator.of(context).pop();
      } catch (e) {
        log("Error saving address (address_input.dart): $e");
        showMessage("Error saving address. Please try again.");
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
                  child: InputBox(
                    hintText: "Flat No",
                    myIcon: Icons.home,
                    myController: _flatController,
                    keyboardType: TextInputType.text,
                  ),
                ),
                const SizedBox(height: 20),
                SizedBox(
                  width: MediaQuery.of(context).size.width,
                  child: InputBox(
                    hintText: "Floor",
                    myIcon: Icons.chalet,
                    myController: _floorController,
                    keyboardType: TextInputType.text,
                  ),
                ),
                const SizedBox(height: 20),
                SizedBox(
                  width: MediaQuery.of(context).size.width,
                  child: InputBox(
                    hintText: "Building Name",
                    myIcon: Icons.apartment,
                    myController: _buildingController,
                    keyboardType: TextInputType.text,
                  ),
                ),
                const SizedBox(height: 20),
                SizedBox(
                  width: MediaQuery.of(context).size.width,
                  child: InputBox(
                    hintText: "Landmark",
                    myIcon: Icons.landscape,
                    myController: _landmarkController,
                    keyboardType: TextInputType.text,
                  ),
                ),
                const SizedBox(height: 20),
                SizedBox(
                  width: MediaQuery.of(context).size.width,
                  child: TextFormField(
                    controller: _pincodeController,
                    keyboardType: TextInputType.number,
                    cursorColor: Colors.black,
                    decoration: InputDecoration(
                      hintText: "Pincode",
                      hintStyle: const TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.normal,
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(14.0),
                        borderSide: const BorderSide(color: Colors.black),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(14.0),
                        borderSide: const BorderSide(color: Colors.black),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(14.0),
                        borderSide: const BorderSide(color: Colors.black),
                      ),
                      filled: true,
                      fillColor: Colors.white,
                      prefixIcon: const Icon(Icons.location_on),
                    ),
                    validator: (value) {
                      if (value!.isEmpty) {
                        return "Please enter Pincode";
                      } else if (!RegExp(r'^[0-9]{6}$').hasMatch(value)) {
                        return "Please enter a valid 6 digit pincode";
                      }
                      return null;
                    },
                  ),
                ),
                const SizedBox(height: 20),
                SizedBox(
                  width: MediaQuery.of(context).size.width,
                  child: InputBox(
                    hintText: "Name",
                    myIcon: Icons.person,
                    myController: _nameController,
                    keyboardType: TextInputType.name,
                  ),
                ),
                const SizedBox(height: 20),
                SizedBox(
                  width: MediaQuery.of(context).size.width,
                  child: TextFormField(
                    controller: _phoneController,
                    keyboardType: TextInputType.phone,
                    cursorColor: Colors.black,
                    autofocus: true,
                    readOnly: true, // Make the field uneditable
                    decoration: InputDecoration(
                      hintText: "Phone",
                      hintStyle: const TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.normal,
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(14.0),
                        borderSide: const BorderSide(color: Colors.black),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(14.0),
                        borderSide: const BorderSide(color: Colors.black),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(14.0),
                        borderSide: const BorderSide(color: Colors.black),
                      ),
                      filled: true,
                      fillColor: Colors.white,
                      prefixIcon: const Icon(Icons.phone),
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
                      userProvider.storeDetail(context, 'name', _nameController.text);
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
