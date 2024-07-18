import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'dart:io';

import '../../shared/show_msg.dart';

class UpdateOfferScreen extends StatefulWidget {
  final String offerId;

  const UpdateOfferScreen({super.key, required this.offerId});

  @override
  State<UpdateOfferScreen> createState() => _UpdateOfferScreenState();
}

class _UpdateOfferScreenState extends State<UpdateOfferScreen> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseStorage _storage = FirebaseStorage.instance;
  final ImagePicker _picker = ImagePicker();

  final TextEditingController _offerNameController = TextEditingController();
  final TextEditingController _offerIdController = TextEditingController();
  final TextEditingController _discountController = TextEditingController();
  final TextEditingController _statusController = TextEditingController();

  XFile? _image;

  @override
  void initState() {
    super.initState();
    _loadOfferData();
  }

  Future<void> _loadOfferData() async {
    try {
      var offer = await _firestore.collection('offers').doc(widget.offerId).get();
      setState(() {
        _offerIdController.text = offer['offerId'].toString();
        _offerNameController.text = offer['offerName'];
        _discountController.text = offer['discount'].toString();
        _statusController.text = offer['status'].toString();
      });
    } catch (e) {
      showMessage('Failed to load offer data.');
    }
  }

  Future<void> _pickImage() async {
    try {
      final pickedFile = await _picker.pickImage(source: ImageSource.gallery);
      setState(() {
        _image = pickedFile;
      });
      if (_image != null) {
        showMessage('Image selected successfully.');
      } else {
        showMessage('No image selected.');
      }
    } catch (e) {
      showMessage('Failed to pick image.');
    }
  }

  Future<void> _uploadImage() async {
    try {
      if (_image != null) {
        String fileName = 'offers/${widget.offerId}.png';
        await _storage.ref(fileName).putFile(File(_image!.path));
        String imageUrl = await _storage.ref(fileName).getDownloadURL();
        await _firestore.collection('offers').doc(widget.offerId).update({'image': imageUrl});
        showMessage('Image uploaded successfully.');
      }
    } catch (e) {
      showMessage('Failed to upload image.');
    }
  }

  Future<void> _updateOffer() async {
    try {
      await _firestore.collection('offers').doc(widget.offerId).update({
        'offerId': int.parse(_offerIdController.text),
        'offerName': _offerNameController.text,
        'discount': int.parse(_discountController.text),
        'status': int.parse(_statusController.text),
      });
      await _uploadImage();
      showMessage('Offer updated successfully.');
      Navigator.pop(context);
    } catch (e) {
      showMessage('Failed to update offer.');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Update Offer'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            children: [
              TextField(
                controller: _offerIdController,
                decoration: const InputDecoration(labelText: 'Offer ID'),
                keyboardType: TextInputType.number,
              ),
              TextField(
                controller: _offerNameController,
                decoration: const InputDecoration(labelText: 'Offer Name'),
              ),
              TextField(
                controller: _discountController,
                decoration: const InputDecoration(labelText: 'Discount'),
                keyboardType: TextInputType.number,
              ),
              TextField(
                controller: _statusController,
                decoration: const InputDecoration(labelText: 'Status'),
                keyboardType: TextInputType.number,
              ),
             const SizedBox(height: 16.0),
              _image != null ? Image.file(File(_image!.path), height: 150) : Container(),
              ElevatedButton(
                onPressed: _pickImage,
                child: const Text('Pick Image'),
              ),
             const  SizedBox(height: 16.0),
              ElevatedButton(
                onPressed: _updateOffer,
                child: const Text('Update Offer'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
