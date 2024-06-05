import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/address_model.dart';
import '../providers/address_provider.dart';

class AddressInputForm extends StatefulWidget {
  @override
  _AddressInputFormState createState() => _AddressInputFormState();
}

class _AddressInputFormState extends State<AddressInputForm> {
  final _formKey = GlobalKey<FormState>();
  final _flatController = TextEditingController();
  final _floorController = TextEditingController();
  final _landmarkController = TextEditingController();

  @override
  void dispose() {
    _flatController.dispose();
    _floorController.dispose();
    _landmarkController.dispose();
    super.dispose();
  }

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
              TextFormField(
                controller: _flatController,
                decoration: const InputDecoration(labelText: "Flat Number"),
                validator: (value) {
                  if (value!.isEmpty) {
                    return "Please enter your flat number";
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _floorController,
                decoration: const InputDecoration(labelText: "Floor"),
                validator: (value) {
                  if (value!.isEmpty) {
                    return "Please enter your floor";
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _landmarkController,
                decoration: const InputDecoration(labelText: "Landmark"),
                validator: (value) {
                  if (value!.isEmpty) {
                    return "Please enter your landmark";
                  }
                  return null;
                },
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
