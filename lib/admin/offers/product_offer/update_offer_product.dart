import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class UpdateOfferProduct extends StatefulWidget {
  final Map<String, dynamic> data;

  const UpdateOfferProduct({super.key, required this.data});

  @override
  State<UpdateOfferProduct> createState() => _UpdateOfferProductState();
}

class _UpdateOfferProductState extends State<UpdateOfferProduct> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _nameController;
  late TextEditingController _priceController;
  late TextEditingController _mrpController;
  late TextEditingController _stockController;
  late TextEditingController _unitController;
  late int _status;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.data['name']);
    _priceController = TextEditingController(text: widget.data['price'].toString());
    _mrpController = TextEditingController(text: widget.data['mrp'].toString());
    _stockController = TextEditingController(text: widget.data['stock'].toString());
    _unitController = TextEditingController(text: widget.data['unit']);
    _status = widget.data['status'] ?? 0;
  }

  Future<void> _updateProduct() async {
    if (_formKey.currentState?.validate() ?? false) {
      final updatedProduct = {
        'name': _nameController.text,
        'price': double.tryParse(_priceController.text) ?? 0.0,
        'mrp': double.tryParse(_mrpController.text) ?? 0.0,
        'stock': int.tryParse(_stockController.text) ?? 0,
        'unit': _unitController.text,
        'status': _status,
      };

      try {
        // Query for the document
        final querySnapshot = await FirebaseFirestore.instance.collection('offerProduct').where('id', isEqualTo: widget.data['id']).get();

        if (querySnapshot.docs.isEmpty) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('No product found with the given ID')),
          );
          return;
        }

        // Assuming there is only one document with this ID
        final documentId = querySnapshot.docs.first.id;

        // Update the document
        await FirebaseFirestore.instance.collection('offerProduct').doc(documentId).update(updatedProduct);

        Navigator.pop(context, true);
      } catch (e) {
        // Handle any errors here
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to update product: $e')),
        );
      }
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _priceController.dispose();
    _mrpController.dispose();
    _stockController.dispose();
    _unitController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Update Offer Product'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(
                controller: _nameController,
                decoration: const InputDecoration(labelText: 'Name'),
                validator: (value) => value?.isEmpty ?? true ? 'Please enter a name' : null,
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
                controller: _stockController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(labelText: 'Stock'),
                validator: (value) => int.tryParse(value ?? '') == null ? 'Invalid stock' : null,
              ),
              TextFormField(
                controller: _unitController,
                decoration: const InputDecoration(labelText: 'Unit'),
                validator: (value) => value?.isEmpty ?? true ? 'Please enter a unit' : null,
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
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: _updateProduct,
                child: const Text('Update Product'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
