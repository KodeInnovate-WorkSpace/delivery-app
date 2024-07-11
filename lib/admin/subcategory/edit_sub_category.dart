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
  final TextEditingController nameController = TextEditingController();
  final TextEditingController imageController = TextEditingController();
  File? _image;

  int? dropdownValue = 1;
  final List<String> categoryNames = [];
  final Map<String, int> categoryMap = {};
  String? selectedCategoryName;
  int? selectedCategoryId;

  bool isLoading = false;

  SubCatModel subcat = SubCatModel();
  List<Map<String, dynamic>> subData = [];

  @override
  void initState() {
    super.initState();
    fetchCategory();
  }

  Future<void> fetchCategory() async {
    try {
      final snapshot = await FirebaseFirestore.instance.collection("category").get();

      if (snapshot.docs.isNotEmpty) {
        setState(() {
          categoryNames.clear();
          categoryMap.clear();
          for (var doc in snapshot.docs) {
            final data = doc.data();
            final category = Category(
              id: data['category_id'],
              name: data['category_name'],
              status: data['status'],
              priority: data['priority'],
            );

            if (category.status == 1) {
              categoryNames.add(category.name);
              categoryMap[category.name] = category.id;
            }
          }

          if (categoryNames.isNotEmpty) {
            selectedCategoryName = categoryNames.first;
            selectedCategoryId = categoryMap[selectedCategoryName!];
          }
        });
      } else {
        log("No Category Document Found!");
      }
    } catch (e) {
      log("Error fetching category: $e");
    }
  }

  // Future<void> addNewSubCategory(BuildContext context) async {
  //   try {
  //     // Fetch subData from Firestore
  //     subData = await subcat.manageSubCategories();
  //     notifyListeners();
  //
  //     // Check if sub-category already exists
  //     final querySnapshot = await FirebaseFirestore.instance.collection('sub_category').where('sub_category_name', isEqualTo: nameController.text).get();
  //
  //     if (querySnapshot.docs.isNotEmpty) {
  //       showMessage("Sub-Category already exists");
  //       log("Sub-category already exists");
  //       return;
  //     }
  //
  //     // Upload image and add sub-category to Firestore
  //     String imageUrl = await uploadImage(_image!);
  //     final subCategoryDoc = FirebaseFirestore.instance.collection('sub_category').doc();
  //
  //     await subCategoryDoc.set({
  //       'sub_category_id': subData.length + 1,
  //       'sub_category_name': nameController.text,
  //       'sub_category_img': imageUrl,
  //       'category_id': selectedCategoryId,
  //       'status': dropdownValue,
  //     });
  //
  //     showMessage("Sub-Category added to database");
  //     log("Sub-category added successfully");
  //   } catch (e) {
  //     showMessage("Error adding sub-category: $e");
  //     log("Error adding sub-category: $e");
  //   }
  // }

  Future<void> addNewSubCategory(BuildContext context) async {
    try {
      // Fetch subData from Firestore
      subData = await subcat.manageSubCategories();
      notifyListeners();

      // Check if sub-category already exists
      final querySnapshot = await FirebaseFirestore.instance.collection('sub_category').where('sub_category_name', isEqualTo: nameController.text).get();

      if (querySnapshot.docs.isNotEmpty) {
        showMessage("Sub-Category already exists");
        log("Sub-category already exists");
        return;
      }

      // Calculate the new sub-category ID
      int newSubCategoryId = subData.length + 1;

      // Check if the ID is already used
      bool isIdUsed = true;
      while (isIdUsed) {
        final idCheckSnapshot = await FirebaseFirestore.instance.collection('sub_category').where('sub_category_id', isEqualTo: newSubCategoryId).get();

        if (idCheckSnapshot.docs.isEmpty) {
          isIdUsed = false;
        } else {
          newSubCategoryId += 1;
        }
      }

      // Upload image and add sub-category to Firestore
      String imageUrl = await uploadImage(_image!);
      final subCategoryDoc = FirebaseFirestore.instance.collection('sub_category').doc();

      await subCategoryDoc.set({
        'sub_category_id': newSubCategoryId,
        'sub_category_name': nameController.text,
        'sub_category_img': imageUrl,
        'category_id': selectedCategoryId,
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
      final storageRef = FirebaseStorage.instance.ref().child('sub_category_images/${DateTime.now().millisecondsSinceEpoch}');
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
    final pickedFile = await ImagePicker().pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _image = File(pickedFile.path);
      });
    }
  }

  Future<void> openCamera() async {
    final pickedFile = await ImagePicker().pickImage(source: ImageSource.camera);
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
        title: const Text("Add new sub-category"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(15.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            //Name
            SizedBox(
              width: 250,
              child: TextFormField(
                controller: nameController,
                cursorColor: Colors.black,
                decoration: InputDecoration(
                  hintText: 'Enter Name',
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

            // Camera
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // select image from camera
                ElevatedButton(
                  onPressed: openCamera,
                  style: ButtonStyle(
                    shape: WidgetStateProperty.all<RoundedRectangleBorder>(
                      RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                    ),
                    backgroundColor: WidgetStateProperty.resolveWith<Color>(
                      (Set<WidgetState> states) {
                        return Colors.black;
                      },
                    ),
                  ),
                  child: const Text(
                    "Open Camera",
                    style: TextStyle(color: Colors.white, fontFamily: 'Gilroy-Bold'),
                  ),
                ),
                const SizedBox(width: 10),
                // select image from gallery
                ElevatedButton(
                  onPressed: pickImage,
                  style: ButtonStyle(
                    shape: WidgetStateProperty.all<RoundedRectangleBorder>(
                      RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                    ),
                    backgroundColor: WidgetStateProperty.resolveWith<Color>(
                      (Set<WidgetState> states) {
                        return Colors.black;
                      },
                    ),
                  ),
                  child: const Text(
                    "Pick Image",
                    style: TextStyle(color: Colors.white, fontFamily: 'Gilroy-Bold'),
                  ),
                ),
              ],
            ),

            _image != null ? Image.file(_image!, height: 100, width: 100) : const Text("No image selected"),
            const SizedBox(height: 20),

            //Status Dropdown
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
            // Select Category Dropdown
            const Text("Category: "),
            DropdownButton<String>(
              value: selectedCategoryName,
              onChanged: (String? newValue) {
                setState(() {
                  selectedCategoryName = newValue!;
                  selectedCategoryId = categoryMap[selectedCategoryName]!;
                });
              },
              items: categoryNames.map<DropdownMenuItem<String>>((String category) {
                return DropdownMenuItem<String>(
                  value: category,
                  child: Text(category.toString()),
                );
              }).toList(),
              hint: const Text("Select a category"),
            ),
            const SizedBox(height: 20),

            // Add button
            Center(
              child: ElevatedButton(
                onPressed: isLoading
                    ? null
                    : () async {
                        if (nameController.text.isEmpty || _image == null || selectedCategoryName == null) {
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

                        await addNewSubCategory(context);

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
                        "Add",
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
