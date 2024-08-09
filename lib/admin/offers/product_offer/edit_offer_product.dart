import 'dart:developer';
import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import '../../../models/category_model.dart';
import '../../../shared/show_msg.dart';
import '../offer_model.dart';

class EditOfferProduct extends StatefulWidget {
  const EditOfferProduct({super.key});

  @override
  State<EditOfferProduct> createState() => _EditOfferProductState();
}

class _EditOfferProductState extends State<EditOfferProduct> with ChangeNotifier {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController priceController = TextEditingController();
  final TextEditingController mrpController = TextEditingController();
  final TextEditingController stockController = TextEditingController();
  final TextEditingController unitController = TextEditingController();
  File? _image;
  bool isVeg = false;
  bool isFood = false;

  int? dropdownValue = 1;
  final List<String> offerCategoryNames = [];
  final Map<String, int> offerCategoryMap = {};
  String? selectedOfferCatName;
  int? selectedOfferCatId;

  OfferProductModel offerProductObj = OfferProductModel();
  List<Map<String, dynamic>> offerProductData = [];

  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    fetchOfferCategory();
  }

  Future<void> fetchOfferCategory() async {
    try {
      final snapshot = await FirebaseFirestore.instance.collection("offerCategory").get();

      if (snapshot.docs.isNotEmpty) {
        setState(() {
          offerCategoryNames.clear();
          offerCategoryMap.clear();
          for (var doc in snapshot.docs) {
            final data = doc.data();
            final category = Category(
              id: data['id'],
              name: data['name'],
              status: data['status'],
              priority: data['priority'],
              isOffer: data['isOffer'],
            );

            if (category.status == 1) {
              offerCategoryNames.add(category.name);
              offerCategoryMap[category.name] = category.id;
            }
          }

          if (offerCategoryNames.isNotEmpty) {
            selectedOfferCatName = offerCategoryNames.first;
            selectedOfferCatId = offerCategoryMap[selectedOfferCatName!];
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
      // Fetch offerProductData from Firestore
      offerProductData = await offerProductObj.manageOfferProducts();
      notifyListeners();

      // Check if offerProductObj already exists
      final querySnapshot = await FirebaseFirestore.instance.collection('offerProduct').where('name', isEqualTo: nameController.text).get();

      if (querySnapshot.docs.isNotEmpty) {
        showMessage("Product already exists");
        log("Product already exists");
        return;
      }

      // Calculate the new offerProductObj ID
      int newProductId = offerProductData.length + 1;

      // Check if the ID is already used
      bool isIdUsed = true;
      while (isIdUsed) {
        final idCheckSnapshot = await FirebaseFirestore.instance.collection('offerProduct').where('id', isEqualTo: newProductId).get();

        if (idCheckSnapshot.docs.isEmpty) {
          isIdUsed = false;
        } else {
          newProductId += 1;
        }
      }

      // Upload image and add offerProductObj to Firestore
      String imageUrl = '';
      // if (!isFood) {
      imageUrl = await uploadImage(_image!);
      // }

      final offerProductObjDoc = FirebaseFirestore.instance.collection('offerProduct').doc();

      await offerProductObjDoc.set({
        'id': newProductId,
        'image': imageUrl,
        'name': nameController.text,
        'price': int.parse(priceController.text),
        'mrp': int.parse(mrpController.text),
        'status': dropdownValue,
        'stock': int.parse(stockController.text),
        'categoryId': selectedOfferCatId,
        'unit': unitController.text,
        'isVeg': isVeg, // New field
        'isFood': isFood, // New field
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
      final storageRef = FirebaseStorage.instance.ref().child('offerImage/${DateTime.now().millisecondsSinceEpoch}');
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Add new Offer offerProductObj"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(15.0),
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Enter name of offerProductObj
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
                    prefixIcon: const Icon(Icons.currency_rupee),
                  ),
                ),
              ),
              const SizedBox(height: 20),

              // Enter MRP
              SizedBox(
                width: 250,
                child: TextFormField(
                  keyboardType: TextInputType.number,
                  controller: mrpController,
                  cursorColor: Colors.black,
                  decoration: InputDecoration(
                    hintText: 'Enter product MRP',
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
                    prefixIcon: const Icon(Icons.price_change),
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
                    prefixIcon: const Icon(Icons.inventory),
                  ),
                ),
              ),
              const SizedBox(height: 20),

              // Enter unit of a offerProductObj
              SizedBox(
                width: 250,
                child: TextFormField(
                  controller: unitController,
                  cursorColor: Colors.black,
                  decoration: InputDecoration(
                    hintText: 'Enter Unit Eg: 100g, 5 L',
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
                    prefixIcon: const Icon(Icons.production_quantity_limits),
                  ),
                ),
              ),
              const SizedBox(height: 20),

              // Select Image
              // if (!isFood)
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
              // if (!isFood)
              _image != null ? Image.file(_image!, height: 100, width: 100) : const Text("No image selected"),
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

              // Select Sub-Category
              const Text("Sub-Category: "),
              DropdownButton<String>(
                value: selectedOfferCatName,
                onChanged: (String? newValue) {
                  setState(() {
                    selectedOfferCatName = newValue!;
                    selectedOfferCatId = offerCategoryMap[selectedOfferCatName]!;
                  });
                },
                items: offerCategoryNames.map<DropdownMenuItem<String>>((String subcat) {
                  return DropdownMenuItem<String>(
                    value: subcat,
                    child: Text(subcat.toString()),
                  );
                }).toList(),
                hint: const Text("Select a sub-category"),
              ),
              const SizedBox(height: 20),

              // Is Veg Slider
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text("Is Veg: "),
                  Switch(
                    value: isVeg,
                    onChanged: (value) {
                      setState(() {
                        isVeg = value;
                      });
                    },
                    activeColor: Colors.green,
                    inactiveThumbColor: Colors.red,
                  ),
                ],
              ),
              const SizedBox(height: 20),

              // Is Food Slider
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text("Is Food: "),
                  Switch(
                    value: isFood,
                    onChanged: (value) {
                      setState(() {
                        isFood = value;
                        // if (isFood) {
                        //   _image = null;
                        // }
                      });
                    },
                    activeColor: Colors.green,
                    inactiveThumbColor: Colors.red,
                  ),
                ],
              ),
              const SizedBox(height: 20),

              Center(
                child: ElevatedButton(
                  onPressed: isLoading
                      ? null
                      : () async {
                          if (nameController.text.isEmpty || (!isFood && _image == null) || selectedOfferCatName == null) {
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

                          await addNewProduct(context);

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
              ),
            ],
          ),
        ),
      ),
    );
  }
}
