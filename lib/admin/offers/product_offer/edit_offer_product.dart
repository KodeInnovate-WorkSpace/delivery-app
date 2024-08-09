import 'dart:io';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';

class EditOfferProduct extends StatefulWidget {
  const EditOfferProduct({super.key});

  @override
  State<EditOfferProduct> createState() => _EditOfferProductState();
}

class _EditOfferProductState extends State<EditOfferProduct> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _categoryIdController = TextEditingController();
  final _priceController = TextEditingController();
  final _mrpController = TextEditingController();
  final _unitController = TextEditingController();
  final _stockController = TextEditingController();
  int _status = 1;
  bool _isVeg = false;
  bool _isFood = false;
  File? _imageFile;
  final ImagePicker _picker = ImagePicker();

  Future<void> _pickImage() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      setState(() {
        _imageFile = File(pickedFile.path);
      });
    }
  }

  Future<String?> _uploadImage(File image) async {
    try {
      final storageRef = FirebaseStorage.instance.ref().child('offerProductImg').child('${DateTime.now().millisecondsSinceEpoch}.jpg');

      final uploadTask = storageRef.putFile(image);
      final snapshot = await uploadTask.whenComplete(() {});
      final downloadUrl = await snapshot.ref.getDownloadURL();

      return downloadUrl;
    } catch (e) {
      // Handle errors
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to upload image: $e')),
      );
      return null;
    }
  }

  Future<void> _addProduct() async {
    if (_formKey.currentState?.validate() ?? false) {
      String? imageUrl;
      if (_imageFile != null) {
        imageUrl = await _uploadImage(_imageFile!);
        if (imageUrl == null) return; // Abort if image upload fails
      }

      final newId = await _generateUniqueId();

      final newProduct = {
        'id': newId,
        'name': _nameController.text,
        'image': imageUrl ?? '',
        'categoryId': int.parse(_categoryIdController.text),
        'price': int.parse(_priceController.text),
        'mrp': int.parse(_mrpController.text),
        'unit': _unitController.text,
        'status': _status,
        'isVeg': _isVeg,
        'isFood': _isFood,
        'isOfferProduct': true,
        'stock': int.parse(_stockController.text),
      };

      try {
        await FirebaseFirestore.instance.collection('offerProduct').add(newProduct);
        Navigator.pop(context, true);
      } catch (e) {
        // Handle any errors here
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to add product: $e')),
        );
      }
    }
  }

  Future<int> _generateUniqueId() async {
    final querySnapshot = await FirebaseFirestore.instance.collection('offerProduct').orderBy('id', descending: true).limit(1).get();

    if (querySnapshot.docs.isEmpty) {
      return 1; // Start with ID 1 if no documents exist
    }

    final highestId = querySnapshot.docs.first.data()['id'] as int;
    return highestId + 1; // Increment the highest ID
  }

  @override
  void dispose() {
    _nameController.dispose();
    _categoryIdController.dispose();
    _priceController.dispose();
    _mrpController.dispose();
    _unitController.dispose();
    _stockController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add New Offer Product'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              GestureDetector(
                onTap: _pickImage,
                child: Container(
                  height: 200,
                  color: Colors.grey[300],
                  child: _imageFile == null ? const Center(child: Text('Pick an Image')) : Image.file(_imageFile!, fit: BoxFit.cover),
                ),
              ),
              TextFormField(
                controller: _nameController,
                decoration: const InputDecoration(labelText: 'Name'),
                validator: (value) => value?.isEmpty ?? true ? 'Please enter a name' : null,
              ),
              TextFormField(
                controller: _categoryIdController,
                decoration: const InputDecoration(labelText: 'Category ID'),
                validator: (value) => value?.isEmpty ?? true ? 'Please enter a category ID' : null,
              ),
              TextFormField(
                controller: _priceController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(labelText: 'Price'),
                validator: (value) => double.tryParse(value ?? '') == null ? 'Invalid price' : null,
              ),
              TextFormField(
                controller: _mrpController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(labelText: 'MRP'),
                validator: (value) => double.tryParse(value ?? '') == null ? 'Invalid MRP' : null,
              ),
              TextFormField(
                controller: _unitController,
                decoration: const InputDecoration(labelText: 'Unit'),
                validator: (value) => value?.isEmpty ?? true ? 'Please enter a unit' : null,
              ),
              TextFormField(
                controller: _stockController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(labelText: 'Stock'),
                validator: (value) => int.tryParse(value ?? '') == null ? 'Invalid stock' : null,
              ),
              DropdownButtonFormField<int>(
                value: _status,
                decoration: const InputDecoration(labelText: 'Status'),
                items: const [
                  DropdownMenuItem(value: 0, child: Text('Inactive')),
                  DropdownMenuItem(value: 1, child: Text('Active')),
                ],
                onChanged: (value) => setState(() => _status = value ?? 0),
                validator: (value) => value == null ? 'Please select a status' : null,
              ),
              CheckboxListTile(
                title: const Text('Is Veg'),
                value: _isVeg,
                onChanged: (value) => setState(() => _isVeg = value ?? false),
              ),
              CheckboxListTile(
                title: const Text('Is Food'),
                value: _isFood,
                onChanged: (value) => setState(() => _isFood = value ?? false),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: _addProduct,
                child: const Text('Add Product'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
