import 'dart:developer';
import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:speedy_delivery/admin/offers/offer_model.dart';
import 'package:speedy_delivery/widget/input_box.dart';

import '../../../shared/show_msg.dart';

class UpdateOfferCategory extends StatefulWidget {
  final Map<String, dynamic> data;

  const UpdateOfferCategory({super.key, required this.data});

  @override
  State<UpdateOfferCategory> createState() => _UpdateCategoryState();
}

class _UpdateCategoryState extends State<UpdateOfferCategory> {
  int? dropdownValue = 1;
  final List<int> categories = [];
  int? selectedCategory;
  final TextEditingController categoryController = TextEditingController();
  final TextEditingController priorityController = TextEditingController();
  final OfferCatModel categoryModel = OfferCatModel();
  List<int> statusOptions = [0, 1]; // 0 for inactive, 1 for active
  File? _image; // To store the selected image
  final ImagePicker _picker = ImagePicker();
  bool isLogoEnabled = false;

  @override
  void initState() {
    super.initState();
    categoryController.text = widget.data['name'];
    priorityController.text = widget.data['priority'].toString();
     dropdownValue = widget.data['status'];
    // if (widget.data['logo_url'] != null) {
    //   setState(() {
    //     isLogoEnabled = true;
    //   });
    // }
  }

  //
  // Future<void> _pickImage() async {
  //   final pickedFile = await _picker.pickImage(source: ImageSource.gallery);
  //   if (pickedFile != null) {
  //     setState(() {
  //       _image = File(pickedFile.path);
  //     });
  //   }
  // }
  //
  // Future<void> _captureImage() async {
  //   final pickedFile = await _picker.pickImage(source: ImageSource.camera);
  //   if (pickedFile != null) {
  //     setState(() {
  //       _image = File(pickedFile.path);
  //     });
  //   }
  // }
  //
  // Future<String?> _uploadImage(String categoryId) async {
  //   try {
  //     final ref = FirebaseStorage.instance.ref().child('category_logos').child('$categoryId.jpg');
  //     await ref.putFile(_image!);
  //     return await ref.getDownloadURL();
  //   } catch (e) {
  //     log("Error uploading image: $e");
  //     showMessage("Error uploading image: $e");
  //     return null;
  //   }
  // }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Update Category'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              InputBox(
                hintText: "Update Category name",
                myIcon: Icons.category,
                myController: categoryController,
                keyboardType: TextInputType.text,
              ),
              const SizedBox(height: 20),
              InputBox(
                hintText: "Update Priority",
                myIcon: Icons.sort,
                myController: priorityController,
                keyboardType: TextInputType.number,
              ),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text("Status: "),
                  DropdownButton<int>(
                    value: dropdownValue, // Use the status value from data
                    onChanged: (int? newValue) {
                      setState(() {
                        dropdownValue = newValue;
                      });
                      categoryModel
                          .updateCategory(
                        'status',
                        newValue,
                        categoryField: 'id',
                        categoryValue: widget.data['id'],
                      )
                          .then((_) => categoryModel.manageCategories());
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
              // const SizedBox(height: 20),
              // Row(
              //   mainAxisAlignment: MainAxisAlignment.center,
              //   children: [
              //     const Text("Update Logo: "),
              //     Switch(
              //       value: isLogoEnabled,
              //       onChanged: (value) {
              //         setState(() {
              //           isLogoEnabled = value;
              //         });
              //       },
              //     ),
              //   ],
              // ),
              // if (widget.data['logo_url'] != null)
              //   Padding(
              //     padding: const EdgeInsets.symmetric(vertical: 10),
              //     child: Image.network(
              //       widget.data['logo_url'],
              //       width: 100,
              //       height: 100,
              //       fit: BoxFit.cover,
              //     ),
              //   ),
              // if (isLogoEnabled) ...[
              //   const SizedBox(height: 10),
              //   Row(
              //     mainAxisAlignment: MainAxisAlignment.center,
              //     children: [
              //       ElevatedButton.icon(
              //         onPressed: _pickImage,
              //         icon: const Icon(Icons.image),
              //         label: const Text("Select Image"),
              //       ),
              //       const SizedBox(width: 10),
              //       ElevatedButton.icon(
              //         onPressed: _captureImage,
              //         icon: const Icon(Icons.camera_alt),
              //         label: const Text("Capture Image"),
              //       ),
              //     ],
              //   ),
              //   if (_image != null)
              //     Padding(
              //       padding: const EdgeInsets.symmetric(vertical: 10),
              //       child: Image.file(
              //         _image!,
              //         width: 100,
              //         height: 100,
              //         fit: BoxFit.cover,
              //       ),
              //     ),
              // ],
              const SizedBox(height: 20),
              Container(
                width: 280,
                height: 50,
                decoration: BoxDecoration(
                  color: Colors.black,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: TextButton(
                  onPressed: () async {
                    // String? imageUrl;
                    // if (isLogoEnabled && _image != null) {
                    //   imageUrl = await _uploadImage(widget.data['id'].toString());
                    // }

                    categoryModel
                        .newupdateCategory(
                      'name',
                      categoryController.text,
                      id: widget.data['id'].toString(),
                    )
                        .then((_) {
                      categoryModel.newupdateCategory(
                        'priority',
                        int.parse(priorityController.text),
                        id: widget.data['id'].toString(),
                      );
                      // if (imageUrl != null) {
                      //   categoryModel.newupdateCategory(
                      //     'logo_url',
                      //     imageUrl,
                      //     id: widget.data['id'].toString(),
                      //   );
                      // }
                      Navigator.pop(context, true);
                    });
                    log("Data of index: ${widget.data}");
                  },
                  child: const Center(
                    child: Text(
                      "UPDATE CATEGORY",
                      style: TextStyle(
                        color: Colors.white,
                        fontFamily: 'Gilroy-Black',
                        fontSize: 16.0,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}