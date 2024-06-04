import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:speedy_delivery/widget/input_box.dart';

import '../admin_model.dart';

class UpdateSubCategory extends StatefulWidget {
  final Map<String, dynamic> data;

  const UpdateSubCategory({super.key, required this.data});

  @override
  State<UpdateSubCategory> createState() => _UpdateSubCategoryState();
}

class _UpdateSubCategoryState extends State<UpdateSubCategory>
    with ChangeNotifier {
  int? dropdownValue = 1;
  List<int> statusOptions = [0, 1]; // 0 for inactive, 1 for active
  final TextEditingController categoryController = TextEditingController();

  final SubCatModel subcatObj = SubCatModel();

  CatModel catObj = CatModel();
  List<Map<String, dynamic>> catOptions = [];

  String? selectedCategoryName;
  int selectedCategoryId = -1; // Default value

  Map<String, int> categoryMap = {}; // Map to store category names and IDs

  @override
  void initState() {
    super.initState();
    _loadCatData().then((_) {
      notifyListeners();
    });
    categoryController.text = widget.data['sub_category_name'];
    dropdownValue = widget.data['status'];
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
      selectedCategoryName = categoryMap.entries
          .firstWhere((entry) => entry.value == selectedCategoryId)
          .key;
    }

    notifyListeners();
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
            InputBox(
                hintText: "Update Sub-Category name",
                myIcon: Icons.category,
                myController: categoryController),
            const SizedBox(height: 20),

            // category dropdown
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text("Change Category: "),
                DropdownButton<String>(
                  value: selectedCategoryName,
                  onChanged: (String? newValue) {
                    setState(() {
                      selectedCategoryName = newValue!;
                      selectedCategoryId = categoryMap[selectedCategoryName]!;
                    });
                  },
                  items: categoryMap.keys
                      .map<DropdownMenuItem<String>>((String category) {
                    return DropdownMenuItem<String>(
                      value: category,
                      child: Text(category),
                    );
                  }).toList(),
                  hint: const Text("Select a category"),
                )
              ],
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
            Container(
              width: 200,
              height: 50,
              decoration: BoxDecoration(
                color: Colors.black,
                borderRadius: BorderRadius.circular(20),
              ),
              child: TextButton(
                onPressed: () async {
                  // Update name
                  await subcatObj.updateSubCategory(
                      'sub_category_name', categoryController.text,
                      categoryField: 'sub_category_id',
                      categoryValue: widget.data['sub_category_id']);

                  // Update category (if selected)
                  if (selectedCategoryId != -1) {
                    await subcatObj.updateSubCategory(
                        'category_id', selectedCategoryId,
                        categoryField: 'sub_category_id',
                        categoryValue: widget.data['sub_category_id']);
                  }

                  // Update status
                  await subcatObj.updateSubCategory('status', dropdownValue,
                      categoryField: 'sub_category_id',
                      categoryValue: widget.data['sub_category_id']);

                  // After successful updates
                  Navigator.pop(context, true);
                },
                child: const Center(
                  child: Text(
                    "UPDATE",
                    style: TextStyle(
                      color: Colors.white,
                      fontFamily: 'Gilroy-ExtraBold',
                      fontSize: 16.0,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
