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

  Future<void> addNewCategory(BuildContext context) async {
    try {
      // Fetch all categories from Firestore
      final snapshot =
          await FirebaseFirestore.instance.collection('category').get();

      // Find the maximum category_id in the existing documents
      int maxId = 0;
      if (snapshot.docs.isNotEmpty) {
        for (var doc in snapshot.docs) {
          final data = doc.data();
          final categoryId = data['category_id'] as int;
          if (categoryId > maxId) {
            maxId = categoryId;
          }
        }
      }

      // Check if category already exists
      final querySnapshot = await FirebaseFirestore.instance
          .collection('category')
          .where('category_name', isEqualTo: nameController.text)
          .get();

      if (querySnapshot.docs.isNotEmpty) {
        showMessage("Category already exists");
        log("Category already exists");
        return;
      }

      // Add new category to Firestore with the correct category_id
      final catDoc = FirebaseFirestore.instance.collection('category').doc();
      await catDoc.set({
        'category_id': maxId + 1,
        'category_name': nameController.text,
        'status': dropdownValue,
      });

      showMessage("Category added to database");
      log("Category added successfully");
    } catch (e) {
      showMessage("Error adding category: $e");
      log("Error adding category: $e");
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
            // Select Category

            Center(
              child: ElevatedButton(
                onPressed: isLoading
                    ? null
                    : () async {
                        if (nameController.text.isEmpty) {
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

                        await addNewCategory(context);

                        setState(() {
                          isLoading = false;
                        });

                        Navigator.pop(context, true);
                      },
                style: ElevatedButton.styleFrom(
                  backgroundColor: isLoading
                      ? Colors.black.withOpacity(0.3)
                      : Colors.black, // Set the color directly
                  padding:
                      const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
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
