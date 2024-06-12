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
  int? dropdownValue = 1;
  final List<int> categories = [];
  final List<String> subcategories = [];
  Map<String, int> subcategoriesMap = {};
  int? selectedCategory;
  String? selectedSubCategory;
  final TextEditingController nameController = TextEditingController();
  final TextEditingController priceController = TextEditingController();
  final TextEditingController stockController = TextEditingController();
  final TextEditingController imageController = TextEditingController();
  final TextEditingController unitController = TextEditingController();
  File? _image;

  ProductModel product = ProductModel();
  List<Map<String, dynamic>> productData = [];

  @override
  void initState() {
    super.initState();
    fetchSubCategory();
  }

  Future<void> fetchSubCategory() async {
    try {
      final snapshot =
          await FirebaseFirestore.instance.collection("sub_category").get();

      if (snapshot.docs.isNotEmpty) {
        setState(() {
          subcategories.clear();
          subcategoriesMap.clear();
          for (var doc in snapshot.docs) {
            final data = doc.data();
            final sub = Category(
              id: data['sub_category_id'],
              name: data['sub_category_name'],
              status: data['status'],
            );

            if (sub.status == 1) {
              subcategories.add(sub.name);
              subcategoriesMap[sub.name] = sub.id;
            }
          }

          if (subcategories.isNotEmpty) {
            selectedSubCategory = subcategories.first;
            selectedCategory = subcategoriesMap[selectedSubCategory!];
          }
        });
      } else {
        log("No Sub-Category Document Found!");
      }
    } catch (e) {
      log("Error fetching Sub-Category: $e");
    }
  }

  Future<void> addNewProduct(BuildContext context) async {
    try {
      // Fetch productData from Firestore
      productData = await product.manageProducts();
      notifyListeners();

      // Check if sub-category already exists
      final querySnapshot = await FirebaseFirestore.instance
          .collection('products')
          .where('name', isEqualTo: nameController.text)
          .get();

      if (querySnapshot.docs.isNotEmpty) {
        showMessage("Product already exists");
        log("Product already exists");
        return;
      }

      // Upload image and add sub-category to Firestore
      String imageUrl = await uploadImage(_image!);
      final productDoc =
          FirebaseFirestore.instance.collection('products').doc();

      await productDoc.set({
        'id': productData.length + 1,
        'image': imageUrl,
        'name': nameController.text,
        'price': int.parse(priceController.text),
        'status': dropdownValue,
        'stock': int.parse(stockController.text),
        'sub_category_id': selectedCategory,
        'unit': unitController.text,
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
      final storageRef = FirebaseStorage.instance
          .ref()
          .child('image/${DateTime.now().millisecondsSinceEpoch}');
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
    // bool isButtonDisabled = false;
    return Scaffold(
      appBar: AppBar(
        title: const Text("Add new product"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(15.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Enter name of product
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
                  prefixIcon: const Icon(Icons.drive_file_rename_outline),
                ),
              ),
            ),
            const SizedBox(height: 20),

            // Enter Price
            SizedBox(
              width: 250,
              child: TextFormField(
                keyboardType: TextInputType.number,
                controller: priceController,
                cursorColor: Colors.black,
                decoration: InputDecoration(
                  hintText: 'Enter product price',
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
                  prefixIcon: const Icon(Icons.currency_rupee),
                ),
              ),
            ),
            const SizedBox(height: 20),

            // Enter available stock
            SizedBox(
              width: 250,
              child: TextFormField(
                keyboardType: TextInputType.number,
                controller: stockController,
                cursorColor: Colors.black,
                decoration: InputDecoration(
                  hintText: 'Enter Available Stock',
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
                  prefixIcon: const Icon(Icons.warehouse),
                ),
              ),
            ),
            const SizedBox(height: 20),

            // Enter unit of a product
            SizedBox(
              width: 250,
              child: TextFormField(
                controller: unitController,
                cursorColor: Colors.black,
                decoration: InputDecoration(
                  hintText: 'Enter Unit Eg: 100g, 5 L',
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
                  prefixIcon: const Icon(Icons.production_quantity_limits),
                ),
              ),
            ),
            const SizedBox(height: 20),

            // Select Image
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
                    style: TextStyle(
                        color: Colors.white, fontFamily: 'Gilroy-Bold'),
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
                    style: TextStyle(
                        color: Colors.white, fontFamily: 'Gilroy-Bold'),
                  ),
                ),
              ],
            ),

            _image != null
                ? Image.file(_image!, height: 100, width: 100)
                : const Text("No image selected"),
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
            // Select Category
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text("Sub-Category: "),
                DropdownButton<String>(
                  value: selectedSubCategory,
                  onChanged: (String? newValue) {
                    setState(() {
                      selectedSubCategory = newValue!;
                      selectedCategory = subcategoriesMap[selectedSubCategory!];
                    });
                  },
                  items: subcategories
                      .map<DropdownMenuItem<String>>((String subcat) {
                    return DropdownMenuItem<String>(
                      value: subcat,
                      child: Text(subcat),
                    );
                  }).toList(),
                  hint: const Text("Select a sub-category"),
                )
              ],
            ),

            const SizedBox(height: 20),

            // Add button

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

                  await addNewProduct(context);
                  Navigator.pop(context, true);
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

            const SizedBox(
              height: 10,
            ),
            const Center(
                child: Text(
              "Adding product takes time. Please wait before adding new product, otherwise same product will be added again",
              style: TextStyle(
                fontStyle: FontStyle.italic,
                fontSize: 12,
              ),
              textAlign: TextAlign.center,
            )),
          ],
        ),
      ),
    );
  }
}
