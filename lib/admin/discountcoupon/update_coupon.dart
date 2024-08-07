import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'dart:io';
import '../../shared/show_msg.dart';

class AddOfferScreen extends StatefulWidget {
  const AddOfferScreen({super.key});

  @override
  State<AddOfferScreen> createState() => _AddOfferScreenState();
}

class _AddOfferScreenState extends State<AddOfferScreen> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseStorage _storage = FirebaseStorage.instance;
  final ImagePicker _picker = ImagePicker();

  final TextEditingController _offerNameController = TextEditingController();
  final TextEditingController _offerIdController = TextEditingController();
  final TextEditingController _discountController = TextEditingController();
  final TextEditingController _statusController = TextEditingController();

  XFile? _image;

  Future<void> _pickImage() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.gallery);
    setState(() {
      _image = pickedFile;
    });
  }

  Future<void> _uploadImage(String docId) async {
    if (_image != null) {
      String fileName = 'offers/$docId.png';
      await _storage.ref(fileName).putFile(File(_image!.path));
      String imageUrl = await _storage.ref(fileName).getDownloadURL();
      await _firestore.collection('offers').doc(docId).update({'image': imageUrl});
    }
  }

  Future<void> _createOffer() async {
    try {
      String docId = _firestore.collection('offers').doc().id;
      await _firestore.collection('offers').doc(docId).set({
        'offerId': int.parse(_offerIdController.text),
        'offerName': _offerNameController.text,
        'discount': int.parse(_discountController.text),
        'status': int.parse(_statusController.text),
      });
      await _uploadImage(docId);
      showMessage('Offer created successfully');
      Navigator.pop(context);
    } catch (e) {
      showMessage('Failed to create offer: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Add Offer',
          style: TextStyle(color: Color(0xffb3b3b3)),
        ),
        elevation: 0,
        backgroundColor: const Color(0xff1a1a1c),
        surfaceTintColor: Colors.transparent,
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: const Icon(
            Icons.keyboard_backspace,
            color: Color(0xffb3b3b3),
          ),
        ),
      ),
      backgroundColor: const Color(0xff1a1a1c),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            children: [
              TextField(
                controller: _offerIdController,
                keyboardType: TextInputType.number,
                style: const TextStyle(color: Color(0xffb3b3b3)),
                decoration: const InputDecoration(
                  labelText: 'Offer ID',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(
                height: 25,
              ),
              TextField(
                controller: _offerNameController,
                style: const TextStyle(color: Color(0xffb3b3b3)),
                decoration: const InputDecoration(
                  labelText: 'Offer Name',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(
                height: 25,
              ),
              TextField(
                controller: _discountController,
                keyboardType: TextInputType.number,
                style: const TextStyle(color: Color(0xffb3b3b3)),
                decoration: const InputDecoration(
                  labelText: 'Discount',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(
                height: 25,
              ),
              TextField(
                controller: _statusController,
                keyboardType: TextInputType.number,
                style: const TextStyle(color: Color(0xffb3b3b3)),
                decoration: const InputDecoration(
                  labelText: 'Status',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(
                height: 25,
              ),
              const SizedBox(height: 16.0),
              _image != null ? Image.file(File(_image!.path), height: 150) : Container(),
              ElevatedButton(
                onPressed: _pickImage,
                style: ButtonStyle(backgroundColor: WidgetStateProperty.all(Colors.black)),
                child: const Text(
                  'Pick Image',
                  style: TextStyle(color: Color(0xffb3b3b3), fontFamily: "Gilroy-SemiBold"),
                ),
              ),
              const SizedBox(height: 16.0),
              ElevatedButton(
                onPressed: _createOffer,
                style: ButtonStyle(backgroundColor: WidgetStateProperty.all(Colors.black)),
                child: const Text(
                  'Create Offer',
                  style: TextStyle(color: Color(0xffb3b3b3), fontFamily: "Gilroy-SemiBold"),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}