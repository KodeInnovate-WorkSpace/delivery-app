import 'dart:developer';
import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import '../../models/category_model.dart';
import '../../shared/show_msg.dart';
import '../admin_model.dart';

class EditProduct extends StatefulWidget {
  const EditProduct({super.key});

  @override
  State<EditProduct> createState() => _EditProductState();
}

class _EditProductState extends State<EditProduct> with ChangeNotifier {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController priceController = TextEditingController();
  final TextEditingController mrpController = TextEditingController();
  final TextEditingController stockController = TextEditingController();
  final TextEditingController unitController = TextEditingController();
  List<Map<String, dynamic>> customizableOptions = [];
  File? _image;
  bool isVeg = false; // New field
  bool isFood = false; // New field
  bool isCustomizable = false; // New field

  int? dropdownValue = 1;
  final List<String> subCategoryNames = [];
  final Map<String, int> subCategoryMap = {};
  String? selectedSubCategoryName;
  int? selectedSubCategoryId;

  ProductModel product = ProductModel();
  List<Map<String, dynamic>> productData = [];

  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    fetchSubCategory();
  }

  Future<void> fetchSubCategory() async {
    try {
      final snapshot = await FirebaseFirestore.instance.collection("sub_category").get();

      if (snapshot.docs.isNotEmpty) {
        setState(() {
          subCategoryNames.clear();
          subCategoryMap.clear();
          for (var doc in snapshot.docs) {
            final data = doc.data();
            final category = SubCategory(
              id: data['sub_category_id'],
              name: data['sub_category_name'],
              status: data['status'],
              img: '',
              catId: data['category_id'],
            );

            if (category.status == 1) {
              subCategoryNames.add(category.name);
              subCategoryMap[category.name] = category.id;
            }
          }

          if (subCategoryNames.isNotEmpty) {
            selectedSubCategoryName = subCategoryNames.first;
            selectedSubCategoryId = subCategoryMap[selectedSubCategoryName!];
          }
        });
      } else {
        log("No Category Document Found!");
      }
    } catch (e) {
      log("Error fetching category: $e");
    }
  }

  Future<void> addNewProduct(BuildContext context) async {
    try {
      // Fetch productData from Firestore
      productData = await product.manageProducts();
      notifyListeners();

      // Check if product already exists
      final querySnapshot = await FirebaseFirestore.instance.collection('product3').where('name', isEqualTo: nameController.text).get();

      if (querySnapshot.docs.isNotEmpty) {
        showMessage("Product already exists");
        log("Product already exists");
        return;
      }

      // Calculate the new product ID
      int newProductId = productData.length + 1;

      // Check if the ID is already used
      bool isIdUsed = true;
      while (isIdUsed) {
        final idCheckSnapshot = await FirebaseFirestore.instance.collection('product3').where('id', isEqualTo: newProductId).get();

        if (idCheckSnapshot.docs.isEmpty) {
          isIdUsed = false;
        } else {
          newProductId += 1;
        }
      }

      // Upload image and add product to Firestore
      String imageUrl = '';
      // if (!isFood) {
      imageUrl = await uploadImage(_image!);
      // }

      final productDoc = FirebaseFirestore.instance.collection('product3').doc();

      await productDoc.set({
        'id': newProductId,
        'image': imageUrl,
        'name': nameController.text,
        'price': isCustomizable ? null : int.parse(priceController.text),
        'mrp': isCustomizable ? null : int.parse(mrpController.text),
        'status': dropdownValue,
        'stock': int.parse(stockController.text),
        'sub_category_id': selectedSubCategoryId,
        'unit': isCustomizable ? null : unitController.text,
        'isVeg': isVeg, // New field
        'isFood': isFood, // New field
        'isCustomizable': isCustomizable, // New field
        'customizableOptions': isCustomizable ? customizableOptions : [],
      });

      showMessage("Product added to database");
      log("Product added successfully");
    } catch (e) {
      showMessage("Error adding Product: $e");
      log("Error adding Product: $e");
    }
  }

  Future<String> uploadImage(File image) async {
    try {
      final storageRef = FirebaseStorage.instance.ref().child('image/${DateTime.now().millisecondsSinceEpoch}');
      final uploadTask = storageRef.putFile(image);
      final snapshot = await uploadTask;
      final downloadUrl = await snapshot.ref.getDownloadURL();

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

  void addCustomizableOption() {
    customizableOptions.add({'price': '', 'mrp': '', 'unit': ''});
    setState(() {});
  }

  void removeCustomizableOption(int index) {
    customizableOptions.removeAt(index);
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Add new product"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(15.0),
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              buildTextFormField(nameController, "Enter Name", Icons.drive_file_rename_outline, TextInputType.text),
              const SizedBox(height: 20),
              if (!isCustomizable) buildTextFormField(priceController, "Enter product price", Icons.currency_rupee, TextInputType.number),
              const SizedBox(height: 20),
              if (!isCustomizable) buildTextFormField(mrpController, "Enter product mrp", Icons.currency_rupee, TextInputType.number),
              const SizedBox(height: 20),
              buildTextFormField(stockController, "Enter product stock", Icons.confirmation_number_outlined, TextInputType.number),
              const SizedBox(height: 20),
              if (!isCustomizable) buildTextFormField(unitController, "Enter Unit", Icons.ad_units_outlined, TextInputType.text),
              const SizedBox(height: 20),
              buildDropdownFormField("Choose Status", dropdownValue, [DropdownMenuItem(value: 1, child: Text('Active')), DropdownMenuItem(value: 2, child: Text('Inactive'))], (int? newValue) {
                setState(() {
                  dropdownValue = newValue;
                });
              }),
              const SizedBox(height: 20),
              buildDropdownFormField("Choose Sub-Category", selectedSubCategoryName, subCategoryNames.map<DropdownMenuItem<String>>((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              }).toList(), (String? newValue) {
                setState(() {
                  selectedSubCategoryName = newValue;
                  selectedSubCategoryId = subCategoryMap[selectedSubCategoryName!]!;
                });
              }),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: pickImage,
                child: const Text('Add Image'),
              ),
              const SizedBox(height: 20),
              _image == null ? const Text('No image selected.') : Image.file(_image!, height: 200),
              const SizedBox(height: 20),
              buildSwitchTile("Is Veg?", isVeg, (bool value) {
                setState(() {
                  isVeg = value;
                });
              }),
              buildSwitchTile("Is Food?", isFood, (bool value) {
                setState(() {
                  isFood = value;
                });
              }),
              buildSwitchTile("Is Customizable?", isCustomizable, (bool value) {
                setState(() {
                  isCustomizable = value;
                });
              }),
              if (isCustomizable) buildCustomizableOptions(),
              if (isCustomizable) ElevatedButton(onPressed: addCustomizableOption, child: const Text('Add Customizable Option')),
              ElevatedButton(
                onPressed: () {
                  addNewProduct(context);
                },
                child: const Text('Add Product'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  TextFormField buildTextFormField(TextEditingController controller, String hintText, IconData icon, TextInputType keyboardType) {
    return TextFormField(
      controller: controller,
      cursorColor: Colors.black,
      keyboardType: keyboardType,
      decoration: InputDecoration(
        hintText: hintText,
        hintStyle: const TextStyle(color: Colors.black),
        prefixIcon: Icon(icon, color: Colors.black),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10.0),
          borderSide: const BorderSide(color: Colors.black),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10.0),
          borderSide: const BorderSide(color: Colors.black54),
        ),
      ),
    );
  }

  DropdownButtonFormField<T> buildDropdownFormField<T>(String hintText, T? value, List<DropdownMenuItem<T>> items, ValueChanged<T?> onChanged) {
    return DropdownButtonFormField<T>(
      value: value,
      decoration: InputDecoration(
        labelText: hintText,
        contentPadding: const EdgeInsets.symmetric(horizontal: 10),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10.0),
        ),
      ),
      items: items,
      onChanged: onChanged,
    );
  }

  SwitchListTile buildSwitchTile(String title, bool value, ValueChanged<bool> onChanged) {
    return SwitchListTile(
      title: Text(title),
      value: value,
      onChanged: onChanged,
    );
  }

  Column buildCustomizableOptions() {
    return Column(
      children: [
        for (int i = 0; i < customizableOptions.length; i++)
          Card(
            child: Padding(
              padding: const EdgeInsets.all(10.0),
              child: Column(
                children: [
                  buildTextFormFieldForCustomizableOption("Enter Customizable Price", Icons.currency_rupee, TextInputType.number, (value) {
                    customizableOptions[i]['price'] = value;
                  }),
                  buildTextFormFieldForCustomizableOption("Enter Customizable Mrp", Icons.currency_rupee, TextInputType.number, (value) {
                    customizableOptions[i]['mrp'] = value;
                  }),
                  buildTextFormFieldForCustomizableOption("Enter Customizable Unit", Icons.ad_units_outlined, TextInputType.text, (value) {
                    customizableOptions[i]['unit'] = value;
                  }),
                  ElevatedButton(onPressed: () => removeCustomizableOption(i), child: const Text('Remove Option')),
                ],
              ),
            ),
          ),
      ],
    );
  }

  TextFormField buildTextFormFieldForCustomizableOption(String hintText, IconData icon, TextInputType keyboardType, ValueChanged<String?> onChanged) {
    return TextFormField(
      cursorColor: Colors.black,
      keyboardType: keyboardType,
      decoration: InputDecoration(
        hintText: hintText,
        hintStyle: const TextStyle(color: Colors.black),
        prefixIcon: Icon(icon, color: Colors.black),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10.0),
          borderSide: const BorderSide(color: Colors.black),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10.0),
          borderSide: const BorderSide(color: Colors.black54),
        ),
      ),
      onChanged: onChanged,
    );
  }
}
