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
  final TextEditingController nameController = TextEditingController();
  final TextEditingController priorityController = TextEditingController();
  int? dropdownValue = 1;
  List<Map<String, dynamic>> catData = [];
  bool isLoading = false;

  Future<void> addCategory(BuildContext context) async {
    try {
      // Fetch existing categories to determine the new category ID
      final snapshot = await FirebaseFirestore.instance.collection('category').get();
      catData = snapshot.docs.map((doc) => doc.data()).toList();
      notifyListeners();

      // Check if category already exists
      final querySnapshot = await FirebaseFirestore.instance.collection('category').where('category_name', isEqualTo: nameController.text).get();

      if (querySnapshot.docs.isNotEmpty) {
        showMessage("Category already exists");
        log("Category already exists");
        return;
      }

      // Calculate the new category ID
      int newCategoryId = catData.length + 1;

      // Check if the ID is already used
      bool isIdUsed = true;
      while (isIdUsed) {
        final idCheckSnapshot = await FirebaseFirestore.instance.collection('category').where('category_id', isEqualTo: newCategoryId).get();

        if (idCheckSnapshot.docs.isEmpty) {
          isIdUsed = false;
        } else {
          newCategoryId += 1;
        }
      }

      // Add new category to Firestore
      await FirebaseFirestore.instance.collection('category').doc(newCategoryId.toString()).set({
        'category_id': newCategoryId,
        'category_name': nameController.text,
        'status': dropdownValue,
        'priority': int.parse(priorityController.text),
      });

      showMessage("Category added successfully");
      log("Category added successfully");
    } catch (e) {
      showMessage("Error adding category: $e");
      log("Error adding category: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Add new category"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(15.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Name
            SizedBox(
              width: 250,
              child: TextFormField(
                controller: nameController,
                cursorColor: Colors.black,
                decoration: InputDecoration(
                  hintText: 'Enter Category',
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

            // Priority
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

            // Add Button
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

                  await addCategory(context);

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