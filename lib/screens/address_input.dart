import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:speedy_delivery/widget/input_box.dart';
import '../models/address_model.dart';
import '../providers/address_provider.dart';
import '../providers/auth_provider.dart';

class AddressInputForm extends StatefulWidget {
  @override
  State<AddressInputForm> createState() => _AddressInputFormState();
}

class _AddressInputFormState extends State<AddressInputForm> {
  final _formKey = GlobalKey<FormState>();
  final _flatController = TextEditingController();
  final _floorController = TextEditingController();
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
    _landmarkController.dispose();
    _phoneController.dispose();
    super.dispose();
  }

  // @override
  // void dispose() {
  //   _flatController.dispose();
  //   _floorController.dispose();
  //   _landmarkController.dispose();
  //   super.dispose();
  // }

  void _saveAddress() {
    if (_formKey.currentState!.validate()) {
      final address = Address(
        flat: _flatController.text,
        floor: _floorController.text,
        mylandmark: _landmarkController.text,
      );

      Provider.of<AddressProvider>(context, listen: false).addAddress(address);
      Navigator.of(context).pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<MyAuthProvider>(context);
    return Scaffold(
      appBar: AppBar(
        title: const Text("Enter Address"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              InputBox(
                  hintText: "Flat No.",
                  myIcon: Icons.home_filled,
                  myController: _flatController),
              const SizedBox(
                height: 20,
              ),
              InputBox(
                  hintText: "Floor",
                  myIcon: Icons.chalet,
                  myController: _floorController),
              const SizedBox(
                height: 20,
              ),
              InputBox(
                  hintText: "Landmark",
                  myIcon: Icons.landscape,
                  myController: _landmarkController),
              const SizedBox(
                height: 20,
              ),
              InputBox(
                  hintText: "Name",
                  myIcon: Icons.person,
                  myController: _nameController),
              const SizedBox(
                height: 20,
              ),
              InputBox(
                  hintText: "Test",
                  myIcon: Icons.phone,
                  myController: _phoneController),
              const SizedBox(
                height: 20,
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: _saveAddress,
                child: const Text("Save Address"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
