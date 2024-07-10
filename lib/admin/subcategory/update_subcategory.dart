import 'dart:developer';
import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:speedy_delivery/widget/input_box.dart';

import '../../shared/show_msg.dart';
import '../admin_model.dart';

class UpdateSubCategory extends StatefulWidget {
  final Map<String, dynamic> data;

  const UpdateSubCategory({super.key, required this.data});

  @override
  State<UpdateSubCategory> createState() => _UpdateSubCategoryState();
}

class _UpdateSubCategoryState extends State<UpdateSubCategory> with ChangeNotifier {
  int? dropdownValue = 1;
  List<int> statusOptions = [0, 1]; // 0 for inactive, 1 for active
  final TextEditingController categoryController = TextEditingController();

  final SubCatModel subcatObj = SubCatModel();

  CatModel catObj = CatModel();
  List<Map<String, dynamic>> catOptions = [];

  String? selectedCategoryName;
  int selectedCategoryId = 0; // Default value

  Map<String, int> categoryMap = {}; // Map to store category names and IDs

  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    _loadCatData().then((_) {
      notifyListeners();
    });
    categoryController.text = widget.data['sub_category_name'];
    dropdownValue = widget.data['status'];
    notifyListeners();
  }

  Future<void> _loadCatData() async {
    catOptions = await catObj.manageCategories();

    // Populate the categoryNames and categoryMap
    for (var cat in catOptions) {
      categoryMap[cat['category_name']] = cat['category_id'];
    }

    // Set the initial selected category if available
    if (widget.data['category_id'] != null) {
      selectedCategoryId = widget.data['category_id'];
      selectedCategoryName = categoryMap.entries.firstWhere((entry) => entry.value == selectedCategoryId).key;
    }
    setState(() {});
    notifyListeners();
  }

  // Update Image
  File? _image;
  final TextEditingController imageController = TextEditingController();

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
        title: const Text('Update Sub-Category'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Image
            _image != null ? Image.file(_image!, height: 100, width: 100) : const Text("No image selected"),

            // Open Camera
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
            const SizedBox(height: 20),

            InputBox(
              hintText: "Update Sub-Category name",
              myIcon: Icons.category,
              myController: categoryController,
              keyboardType: TextInputType.text,
            ),
            const SizedBox(height: 40),

            // category dropdown
            const Text("Change Category: "),
            DropdownButton<String>(
              value: selectedCategoryName,
              onChanged: (String? newValue) {
                setState(() {
                  selectedCategoryName = newValue!;
                  selectedCategoryId = categoryMap[selectedCategoryName]!;
                });
              },
              items: categoryMap.keys.map<DropdownMenuItem<String>>((String category) {
                return DropdownMenuItem<String>(
                  value: category,
                  child: Text(category),
                );
              }).toList(),
              hint: const Text("Select a category"),
            ),
            const SizedBox(height: 20),

            // status dropdown
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text("Status: "),
                DropdownButton<int>(
                  value: dropdownValue, // Use the state variable here
                  onChanged: (int? newValue) {
                    setState(() {
                      dropdownValue = newValue!; // Update state on change
                    });
                    subcatObj
                        .updateSubCategory(
                          'status',
                          newValue,
                          categoryField: 'sub_category_id',
                          categoryValue: widget.data['sub_category_id'],
                        )
                        .then((_) => subcatObj.manageSubCategories());
                  },
                  items: statusOptions.map<DropdownMenuItem<int>>((int status) {
                    return DropdownMenuItem<int>(
                      value: status,
                      child: Text(status == 0 ? 'Inactive' : 'Active'),
                    );
                  }).toList(),
                ),
              ],
            ),
            const SizedBox(height: 20),

            // Update button
            Center(
              child: ElevatedButton(
                onPressed: isLoading
                    ? null
                    : () async {
                        // If an image is selected, upload it and get the URL
                        String? imageUrl;
                        if (_image != null) {
                          imageUrl = await uploadImage(_image!);
                          // Update Image
                          await subcatObj.updateSubCategory('sub_category_img', imageUrl, categoryField: 'sub_category_id', categoryValue: widget.data['sub_category_id']);
                        }

                        // Update name
                        await subcatObj.updateSubCategory('sub_category_name', categoryController.text, categoryField: 'sub_category_id', categoryValue: widget.data['sub_category_id']);

                        // Update category (if selected)
                        if (selectedCategoryId != -1) {
                          await subcatObj.updateSubCategory('category_id', selectedCategoryId, categoryField: 'sub_category_id', categoryValue: widget.data['sub_category_id']);
                        }

                        // Update status
                        await subcatObj.updateSubCategory('status', dropdownValue, categoryField: 'sub_category_id', categoryValue: widget.data['sub_category_id']);

                        // After successful updates
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
                        "Update",
                        style: TextStyle(
                          color: Colors.white,
                          fontFamily: 'Gilroy-Bold',
                        ),
                      ),
              ),
            ),

            // Container(
            //   width: 200,
            //   height: 50,
            //   decoration: BoxDecoration(
            //     color: Colors.black,
            //     borderRadius: BorderRadius.circular(20),
            //   ),
            //   child: TextButton(
            //     onPressed: () async {
            //       // Update name
            //       await subcatObj.updateSubCategory('sub_category_name', categoryController.text, categoryField: 'sub_category_id', categoryValue: widget.data['sub_category_id']);
            //
            //       // Update category (if selected)
            //       if (selectedCategoryId != -1) {
            //         await subcatObj.updateSubCategory('category_id', selectedCategoryId, categoryField: 'sub_category_id', categoryValue: widget.data['sub_category_id']);
            //       }
            //
            //       // Update status
            //       await subcatObj.updateSubCategory('status', dropdownValue, categoryField: 'sub_category_id', categoryValue: widget.data['sub_category_id']);
            //
            //       // After successful updates
            //       Navigator.pop(context, true);
            //     },
            //     child: const Center(
            //       child: Text(
            //         "UPDATE",
            //         style: TextStyle(
            //           color: Colors.white,
            //           fontFamily: 'Gilroy-ExtraBold',
            //           fontSize: 16.0,
            //         ),
            //       ),
            //     ),
            //   ),
            // ),
          ],
        ),
      ),
    );
  }
}
