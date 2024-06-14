import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:speedy_delivery/providers/check_user_provider.dart';
import 'package:speedy_delivery/widget/input_box.dart';
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
      // _phoneController.text = authProvider.textController.text;
      _phoneController.text = authProvider.textController.text.substring(3);
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
                // Flat No
                SizedBox(
                  width: MediaQuery.of(context).size.width,
                  child: InputBox(
                      hintText: ("Flat No"),
                      myIcon: Icons.home,
                      myController: _flatController),
                ),
                const SizedBox(height: 20),

                // Floor
                SizedBox(
                  width: MediaQuery.of(context).size.width,
                  child: InputBox(
                      hintText: ("Floor"),
                      myIcon: Icons.chalet,
                      myController: _floorController),
                ),
                const SizedBox(height: 20),

                // Building Name
                SizedBox(
                  width: MediaQuery.of(context).size.width,
                  child: InputBox(
                      hintText: ("Building Name"),
                      myIcon: Icons.apartment,
                      myController: _buildingController),
                ),
                const SizedBox(height: 20),

                // Landmark
                SizedBox(
                  width: MediaQuery.of(context).size.width,
                  child: InputBox(
                      hintText: ("Landmark"),
                      myIcon: Icons.landscape,
                      myController: _landmarkController),
                ),
                const SizedBox(height: 20),
                // Name
                SizedBox(
                  width: MediaQuery.of(context).size.width,
                  child: InputBox(
                      hintText: ("Name"),
                      myIcon: Icons.person,
                      myController: _nameController),
                ),
                const SizedBox(height: 20),
                // Phone No
                SizedBox(
                  width: MediaQuery.of(context).size.width,
                  child: TextFormField(
                    controller: _phoneController,
                    maxLength: 10,
                    keyboardType: TextInputType.phone,
                    cursorColor: Colors.black,
                    decoration: InputDecoration(
                      hintText: "Phone",
                      hintStyle: const TextStyle(
                          color: Colors.black, fontWeight: FontWeight.normal),
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

                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      _saveAddress();
                      // userProvider.storeDetail(context, 'name', _nameController.text);
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
