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
  List<Map<String, dynamic>> productDataList = [];

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
      // Validate customizable options if isCustomizable is true
      if (isCustomizable && !validateCustomizableOptions()) {
        showMessage("Please add at least one complete customizable option.");
        return;
      }

      // Fetch productData from Firestore
      productDataList = await product.manageProducts();
      notifyListeners();

      // Check if product already exists
      final querySnapshot = await FirebaseFirestore.instance.collection('product3').where('name', isEqualTo: nameController.text).get();

      if (querySnapshot.docs.isNotEmpty) {
        showMessage("Product already exists");
        log("Product already exists");
        return;
      }

      // Calculate the new product ID
      int newProductId = productDataList.length + 1;

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
      imageUrl = await uploadImage(_image!);

      final productDoc = FirebaseFirestore.instance.collection('product3').doc();

      final newProductData = {
        'id': newProductId,
        'image': imageUrl,
        'name': nameController.text,
        'status': dropdownValue,
        'stock': int.parse(stockController.text),
        'sub_category_id': selectedSubCategoryId,
        'isVeg': isVeg, // New field
        'isFood': isFood, // New field
        'isCustomizable': isCustomizable, // New field
        'customizableOptions': isCustomizable ? customizableOptions : [],
      };

      // Conditionally add price, mrp, and unit fields if not customizable
      if (!isCustomizable) {
        newProductData['price'] = int.parse(priceController.text);
        newProductData['mrp'] = int.parse(mrpController.text);
        newProductData['unit'] = unitController.text;
      }

      await productDoc.set(newProductData);

      showMessage("Product added to database");
      log("Product added successfully");
      Navigator.pop(context);
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
    customizableOptions.add({'price': 0, 'mrp': 0, 'unit': ''});
    setState(() {});
  }

  void removeCustomizableOption(int index) {
    customizableOptions.removeAt(index);
    setState(() {});
  }

  bool validateCustomizableOptions() {
    return customizableOptions.any((option) =>
    option['price'] != null && option['mrp'] != null && option['unit'] != '');
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
              if (!isCustomizable)
                buildTextFormField(priceController, "Enter product price", Icons.currency_rupee, TextInputType.number),
              const SizedBox(height: 20),
              if (!isCustomizable)
                buildTextFormField(mrpController, "Enter product mrp", Icons.currency_rupee, TextInputType.number),
              const SizedBox(height: 20),
              buildTextFormField(stockController, "Enter product stock", Icons.confirmation_number_outlined, TextInputType.number),
              const SizedBox(height: 20),
              if (!isCustomizable) buildTextFormField(unitController, "Enter Unit", Icons.ad_units_outlined, TextInputType.text),
              const SizedBox(height: 20),
              buildDropdownFormField(
                "Choose Status",
                dropdownValue,
                [DropdownMenuItem(value: 1, child: Text('Active')), DropdownMenuItem(value: 2, child: Text('Inactive'))],
                    (int? newValue) {
                  setState(() {
                    dropdownValue = newValue;
                  });
                },
              ),
              const SizedBox(height: 20),
              buildDropdownFormField(
                "Choose Sub-Category",
                selectedSubCategoryName,
                subCategoryNames.map<DropdownMenuItem<String>>((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
                    (String? newValue) {
                  setState(() {
                    selectedSubCategoryName = newValue;
                    selectedSubCategoryId = subCategoryMap[selectedSubCategoryName!]!;
                  });
                },
              ),
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
              if (isCustomizable) ...[
                ListView.builder(
                  shrinkWrap: true,
                  itemCount: customizableOptions.length,
                  itemBuilder: (context, index) {
                    return Column(
                      children: [
                        buildTextFormField(
                          TextEditingController(text: customizableOptions[index]['price'].toString()),
                          "Enter option price",
                          Icons.currency_rupee,
                          TextInputType.number,
                          onChanged: (value) {
                            customizableOptions[index]['price'] = int.tryParse(value) ?? 0;
                          },
                        ),
                        buildTextFormField(
                          TextEditingController(text: customizableOptions[index]['mrp'].toString()),
                          "Enter option MRP",
                          Icons.currency_rupee,
                          TextInputType.number,
                          onChanged: (value) {
                            customizableOptions[index]['mrp'] = int.tryParse(value) ?? 0;
                          },
                        ),
                        buildTextFormField(
                          TextEditingController(text: customizableOptions[index]['unit']),
                          "Enter option unit",
                          Icons.ad_units,
                          TextInputType.text,
                          onChanged: (value) {
                            customizableOptions[index]['unit'] = value;
                          },
                        ),
                        IconButton(
                          onPressed: () {
                            removeCustomizableOption(index);
                          },
                          icon: Icon(Icons.remove_circle, color: Colors.red),
                        ),
                      ],
                    );
                  },
                ),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: addCustomizableOption,
                  child: const Text('Add Customizable Option'),
                ),
              ],
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  addNewProduct(context);
                },
                child: const Text('Add New Product'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildTextFormField(
      TextEditingController controller,
      String hintText,
      IconData icon,
      TextInputType inputType, {
        ValueChanged<String>? onChanged,
      }) {
    return TextFormField(
      controller: controller,
      decoration: InputDecoration(
        hintText: hintText,
        prefixIcon: Icon(icon),
      ),
      keyboardType: inputType,
      onChanged: onChanged,
    );
  }

  Widget buildDropdownFormField<T>(
      String hintText,
      T? value,
      List<DropdownMenuItem<T>> items,
      ValueChanged<T?> onChanged,
      ) {
    return DropdownButtonFormField<T>(
      value: value,
      decoration: InputDecoration(
        hintText: hintText,
        prefixIcon: Icon(Icons.arrow_drop_down),
      ),
      items: items,
      onChanged: onChanged,
    );
  }

  Widget buildSwitchTile(
      String title,
      bool value,
      ValueChanged<bool> onChanged,
      ) {
    return SwitchListTile(
      title: Text(title),
      value: value,
      onChanged: onChanged,
    );
  }
}
