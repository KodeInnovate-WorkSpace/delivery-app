import 'dart:developer';
import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import '../../models/category_model.dart';
import '../../shared/show_msg.dart';
import '../admin_model.dart';

class EditSubCategory extends StatefulWidget {
  const EditSubCategory({super.key});

  @override
  State<EditSubCategory> createState() => _EditSubCategoryState();
}

class _EditSubCategoryState extends State<EditSubCategory> with ChangeNotifier {
  int? dropdownValue = 1;
  final List<int> categories = [];
  int? selectedCategory;
  final TextEditingController nameController = TextEditingController();
  final TextEditingController imageController = TextEditingController();
  File? _image;

  SubCatModel subcat = SubCatModel();
  List<Map<String, dynamic>> subData = [];

  @override
  void initState() {
    super.initState();
    fetchCategory();
  }

  Future<void> fetchCategory() async {
    try {
      final snapshot =
          await FirebaseFirestore.instance.collection("category").get();

      if (snapshot.docs.isNotEmpty) {
        setState(() {
          categories.clear();
          for (var doc in snapshot.docs) {
            final data = doc.data();
            final category = Category(
              id: data['category_id'],
              name: data['category_name'],
              status: data['status'],
            );

            if (category.status == 1) {
              categories.add(category.id);
            }
          }

          if (categories.isNotEmpty) {
            selectedCategory = categories.first;
          }
        });
      } else {
        log("No Category Document Found!");
      }
    } catch (e) {
      log("Error fetching category: $e");
    }
  }

  Future<void> addNewSubCategory(BuildContext context) async {
    try {
      // Fetch subData from Firestore
      subData = await subcat.manageSubCategories();
      notifyListeners();

      // Check if sub-category already exists
      final querySnapshot = await FirebaseFirestore.instance
          .collection('sub_category')
          .where('sub_category_name', isEqualTo: nameController.text)
          .get();

      if (querySnapshot.docs.isNotEmpty) {
        showMessage("Sub-Category already exists");
        log("Sub-category already exists");
        return;
      }

      // Upload image and add sub-category to Firestore
      String imageUrl = await uploadImage(_image!);
      final subCategoryDoc =
          FirebaseFirestore.instance.collection('sub_category').doc();

      await subCategoryDoc.set({
        'sub_category_id': subData.length + 1,
        'sub_category_name': nameController.text,
        'sub_category_img': imageUrl,
        'category_id': selectedCategory,
        'status': dropdownValue,
      });

      showMessage("Sub-Category added to database");
      log("Sub-category added successfully");
    } catch (e) {
      showMessage("Error adding sub-category: $e");
      log("Error adding sub-category: $e");
    }
  }

  Future<String> uploadImage(File image) async {
    try {
      final storageRef = FirebaseStorage.instance.ref().child(
          'sub_category_images/${DateTime.now().millisecondsSinceEpoch}');
      final uploadTask = storageRef.putFile(image);
      final snapshot = await uploadTask;
      final downloadUrl = await snapshot.ref.getDownloadURL();
      showMessage("Image Uploaded");
      return downloadUrl;
    } catch (e) {
      log("Error uploading image: $e");
      rethrow;
    }
  }

  Future<void> pickImage() async {
    final pickedFile =
        await ImagePicker().pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _image = File(pickedFile.path);
      });
    }
  }

  Future<void> openCamera() async {
    final pickedFile =
        await ImagePicker().pickImage(source: ImageSource.camera);
    if (pickedFile != null) {
      setState(() {
        _image = File(pickedFile.path);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(15.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(
              width: 250,
              child: TextFormField(
                controller: nameController,
                cursorColor: Colors.black,
                decoration: InputDecoration(
                  hintText: 'Enter Name',
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
                  prefixIcon: const Icon(Icons.category),
                ),
              ),
            ),
            const SizedBox(height: 20),

            // select image from camera
            ElevatedButton(
              onPressed: openCamera,
              child: const Text("Open Camera"),
            ),
            const SizedBox(height: 20),
            // select image from gallery
            ElevatedButton(
              onPressed: pickImage,
              child: const Text("Pick Image"),
            ),
            _image != null
                ? Image.file(_image!, height: 100, width: 100)
                : const Text("No image selected"),
            const SizedBox(height: 20),
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
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text("Category: "),
                DropdownButton<int>(
                  value: selectedCategory,
                  onChanged: (int? newValue) {
                    setState(() {
                      selectedCategory = newValue!;
                    });
                  },
                  items: categories.map<DropdownMenuItem<int>>((int category) {
                    return DropdownMenuItem<int>(
                      value: category,
                      child: Text(category.toString()),
                    );
                  }).toList(),
                  hint: const Text("Select a category"),
                )
              ],
            ),
            const SizedBox(height: 20),
            Center(
              child: ElevatedButton(
                onPressed: () async {
                  if (nameController.text.isEmpty ||
                      _image == null ||
                      selectedCategory == null) {
                    showMessage("Please fill necessary details");
                    log("Please fill all the fields");
                    return;
                  }

                  await addNewSubCategory(context);
                  log("Sub-Category Length: ${subData.length}");
                },
                style: ButtonStyle(
                  shape: WidgetStateProperty.all<RoundedRectangleBorder>(
                    RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14.0),
                    ),
                  ),
                  backgroundColor: WidgetStateProperty.resolveWith<Color>(
                    (Set<WidgetState> states) {
                      return Colors.black;
                    },
                  ),
                ),
                child: const SizedBox(
                  width: 200,
                  height: 58,
                  child: Center(
                    child: Text(
                      "Add",
                      style: TextStyle(
                        color: Colors.white,
                        fontFamily: 'Gilroy-Black',
                        fontSize: 16.0,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
