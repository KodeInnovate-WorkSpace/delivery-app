import 'dart:developer';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import '../../models/category_model.dart';
import '../../shared/show_msg.dart';
import '../admin_model.dart';

class EditCategory extends StatefulWidget {
  const EditCategory({super.key});

  @override
  State<EditCategory> createState() => _EditCategoryState();
}

class _EditCategoryState extends State<EditCategory> with ChangeNotifier {
  int? dropdownValue = 1;
  final List<int> categories = [];
  int? selectedCategory;
  final TextEditingController nameController = TextEditingController();
  final TextEditingController priorityController = TextEditingController();

  CatModel category = CatModel();

  // list to store fetched categories
  List<Map<String, dynamic>> catData = [];
  bool isLoading = false;

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
          categories.clear();
          for (var doc in snapshot.docs) {
            final data = doc.data();
            final category = Category(
              id: data['category_id'],
              name: data['category_name'],
              status: data['status'],
              priority: data['priority'], // Added priority field
            );

            if (category.status == 1) {
              categories.add(category.id);
            }
          }

          if (categories.isNotEmpty) {
            selectedCategory = categories.first;
            fetchCategoryDetails(selectedCategory!);
          }
        });
      } else {
        log("No Category Document Found!");
      }
    } catch (e) {
      log("Error fetching category: $e");
    }
  }

  Future<void> fetchCategoryDetails(int categoryId) async {
    try {
      final doc = await FirebaseFirestore.instance.collection("category").doc(categoryId.toString()).get();
      if (doc.exists) {
        final data = doc.data();
        setState(() {
          nameController.text = data!['category_name'];
          priorityController.text = data['priority'].toString();
          dropdownValue = data['status'];
        });
      } else {
        log("Category details not found for ID: $categoryId");
      }
    } catch (e) {
      log("Error fetching category details: $e");
    }
  }

  Future<void> addOrUpdateCategory(BuildContext context) async {
    try {
      // Fetch catData from Firestore
      catData = await category.manageCategories();
      notifyListeners();

      // Check if category already exists
      final querySnapshot = await FirebaseFirestore.instance.collection('category').where('category_name', isEqualTo: nameController.text).get();

      if (querySnapshot.docs.isNotEmpty && querySnapshot.docs.first.id != selectedCategory.toString()) {
        showMessage("Category already exists");
        log("Category already exists");
        return;
      }

      // Update existing category in Firestore
      final catDoc = FirebaseFirestore.instance.collection('category').doc();
      await catDoc.set({
        'category_id': catData.length + 1,
        'category_name': nameController.text,
        'status': dropdownValue,
        'priority': int.parse(priorityController.text),
      });

      showMessage("Category updated successfully");
      log("Category updated successfully");
    } catch (e) {
      showMessage("Error updating category: $e");
      log("Error updating category: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xff1a1a1c),
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

            //Priority
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

            //Status
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text(
                  "Status: ",
                  style: TextStyle(color: Color(0xffb3b3b3)),
                ),
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
                    DropdownMenuItem(
                        value: 1,
                        child: Text(
                          "Enable",
                          style: TextStyle(color: Color(0xffb3b3b3)),
                        )),
                    DropdownMenuItem(
                        value: 0,
                        child: Text(
                          "Disable",
                          style: TextStyle(color: Color(0xffb3b3b3)),
                        )),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 20),

            //Add Button
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

                        await addOrUpdateCategory(context);

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
                          color: Color(0xffb3b3b3),
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
