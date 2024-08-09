import 'dart:developer';
import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import '../../../shared/show_msg.dart';

class EditOfferCategory extends StatefulWidget {
  const EditOfferCategory({super.key});

  @override
  State<EditOfferCategory> createState() => _EditOfferCategoryState();
}

class _EditOfferCategoryState extends State<EditOfferCategory> {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController priorityController = TextEditingController();
  final TextEditingController textColorController = TextEditingController();
  final TextEditingController buttonColorController = TextEditingController();
  int? dropdownValue = 1;
  List<Map<String, dynamic>> catData = [];
  bool isLoading = false;

  File? _image; // To store the selected image
  final ImagePicker _picker = ImagePicker();

  Future<void> addCategory(BuildContext context) async {
    try {
      // Fetch existing categories to determine the new category ID
      final snapshot = await FirebaseFirestore.instance.collection('offerCategory').get();
      catData = snapshot.docs.map((doc) => doc.data()).toList();

      // Check if category already exists
      final querySnapshot = await FirebaseFirestore.instance.collection('offerCategory').where('name', isEqualTo: nameController.text).get();

      if (querySnapshot.docs.isNotEmpty) {
        showMessage("Category already exists");
        log("Category already exists");
        return;
      }

      // Calculate the new category ID
      int newCategoryId = catData.length + 1;

      // Check if the ID is already used
      bool isIdUsed = true;
      while (isIdUsed) {
        final idCheckSnapshot = await FirebaseFirestore.instance.collection('offerCategory').where('id', isEqualTo: newCategoryId).get();

        if (idCheckSnapshot.docs.isEmpty) {
          isIdUsed = false;
        } else {
          newCategoryId += 1;
        }
      }

      // // Upload logo if it is enabled and an image is selected
      String? imageUrl;
      if (_image != null) {
        imageUrl = await _uploadImage(newCategoryId.toString());
      }

      // Add new category to Firestore
      Map<String, dynamic> categoryData = {
        'id': newCategoryId,
        'name': nameController.text,
        'buttonColor': buttonColorController.text,
        'textColor': textColorController.text,
        'status': dropdownValue,
        'priority': int.parse(priorityController.text),
      };

      // Add the logo URL if available
      if (imageUrl != null) {
        categoryData['categoryImage'] = imageUrl;
      }

      await FirebaseFirestore.instance.collection('offerCategory').doc(newCategoryId.toString()).set(categoryData);

      showMessage("Category added successfully");
      log("Category added successfully");
    } catch (e) {
      showMessage("Error adding category: $e");
      log("Error adding category: $e");
    }
  }

  Future<String?> _uploadImage(String categoryId) async {
    try {
      final ref = FirebaseStorage.instance.ref().child('offerCategoryImages').child('$categoryId.jpg');
      await ref.putFile(_image!);
      return await ref.getDownloadURL();
    } catch (e) {
      log("Error uploading image: $e");
      showMessage("Error uploading image: $e");
      return null;
    }
  }

  Future<void> _pickImage() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _image = File(pickedFile.path);
      });
    }
  }

  Future<void> _captureImage() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.camera);
    if (pickedFile != null) {
      setState(() {
        _image = File(pickedFile.path);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Add new category"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(15.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Name
            SizedBox(
              width: 250,
              child: TextFormField(
                controller: nameController,
                cursorColor: Colors.black,
                decoration: InputDecoration(
                  hintText: 'Enter Category',
                  hintStyle: const TextStyle(color: Colors.black, fontWeight: FontWeight.normal),
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
                  prefixIcon: const Icon(Icons.category),
                ),
              ),
            ),
            const SizedBox(height: 20),

            // Priority
            SizedBox(
              width: 250,
              child: TextFormField(
                controller: priorityController,
                cursorColor: Colors.black,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  hintText: 'Enter Priority',
                  hintStyle: const TextStyle(color: Colors.black, fontWeight: FontWeight.normal),
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
                  prefixIcon: const Icon(Icons.sort),
                ),
              ),
            ),
            const SizedBox(height: 20),

            // Text Color
            SizedBox(
              width: 250,
              child: TextFormField(
                controller: textColorController,
                cursorColor: Colors.black,
                decoration: InputDecoration(
                  hintText: 'Enter Text Color',
                  hintStyle: const TextStyle(color: Colors.black, fontWeight: FontWeight.normal),
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
                  prefixIcon: const Icon(Icons.color_lens_outlined),
                ),
              ),
            ),
            const SizedBox(height: 20),

            // Button Color
            SizedBox(
              width: 250,
              child: TextFormField(
                controller: buttonColorController,
                cursorColor: Colors.black,
                decoration: InputDecoration(
                  hintText: 'Enter Button Color',
                  hintStyle: const TextStyle(color: Colors.black, fontWeight: FontWeight.normal),
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
                  prefixIcon: const Icon(Icons.color_lens_rounded),
                ),
              ),
            ),
            const SizedBox(height: 20),

            // Status
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text("Status: "),
                DropdownButton<int>(
                  value: dropdownValue,
                  onChanged: (int? value) {
                    setState(() {
                      dropdownValue = value;
                    });

                    log("Status: ${value.toString()}");
                    value == 1 ? log("Enabled") : log("Disabled");
                  },
                  items: const [
                    DropdownMenuItem(value: 1, child: Text("Enable")),
                    DropdownMenuItem(value: 0, child: Text("Disable")),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 20),

            // Image Picker Buttons

            const SizedBox(height: 10),
            ElevatedButton.icon(
              onPressed: _pickImage,
              icon: const Icon(Icons.image),
              label: const Text("Select Image"),
            ),
            const SizedBox(width: 10),
            ElevatedButton.icon(
              onPressed: _captureImage,
              icon: const Icon(Icons.camera_alt),
              label: const Text("Capture Image"),
            ),
            if (_image != null)
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 10),
                child: Image.file(
                  _image!,
                  width: 100,
                  height: 100,
                  fit: BoxFit.cover,
                ),
              ),

            const SizedBox(height: 20),

            // Add Button
            Center(
              child: ElevatedButton(
                onPressed: isLoading
                    ? null
                    : () async {
                        if (nameController.text.isEmpty || priorityController.text.isEmpty) {
                          showMessage("Please fill necessary details");
                          log("Please fill all the fields");

                          setState(() {
                            isLoading = false;
                          });

                          return;
                        }

                        setState(() {
                          isLoading = true;
                        });

                        await addCategory(context);

                        setState(() {
                          isLoading = false;
                        });

                        Navigator.pop(context, true);
                      },
                style: ElevatedButton.styleFrom(
                  backgroundColor: isLoading ? Colors.black.withOpacity(0.3) : Colors.black, // Set the color directly
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                  textStyle: const TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                ),
                child: isLoading
                    ? const CircularProgressIndicator(
                        color: Colors.white,
                        strokeWidth: 2,
                      )
                    : const Text(
                        "Save",
                        style: TextStyle(
                          color: Colors.white,
                          fontFamily: 'Gilroy-Bold',
                        ),
                      ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
