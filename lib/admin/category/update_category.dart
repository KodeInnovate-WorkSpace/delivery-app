import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:speedy_delivery/widget/input_box.dart';

import '../admin_model.dart';

class UpdateCategory extends StatefulWidget {
  final Map<String, dynamic> data;

  const UpdateCategory({super.key, required this.data});

  @override
  State<UpdateCategory> createState() => _UpdateCategoryState();
}

class _UpdateCategoryState extends State<UpdateCategory> {
  int? dropdownValue = 1;
  final List<int> categories = [];
  int? selectedCategory;
  final TextEditingController categoryController = TextEditingController();
  final TextEditingController priorityController = TextEditingController();
  final CatModel categoryModel = CatModel();
  List<int> statusOptions = [0, 1]; // 0 for inactive, 1 for active

  @override
  void initState() {
    super.initState();
    categoryController.text = widget.data['category_name'];
    priorityController.text = widget.data['priority'].toString();
    dropdownValue = widget.data['status'];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Update Category',
          style: TextStyle(color: Color(0xffb3b3b3)),
        ),
        elevation: 0,
        backgroundColor: const Color(0xff1a1a1c),
        surfaceTintColor: Colors.transparent,
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: const Icon(
            Icons.keyboard_backspace,
            color: Color(0xffb3b3b3),
          ),
        ),
      ),
      backgroundColor: const Color(0xff1a1a1c),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
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
                const Text("Status: ",
                  style:  TextStyle(color: Color(0xffb3b3b3)),
                ),
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
                      categoryField: 'category_id',
                      categoryValue: widget.data['category_id'],
                    )
                        .then((_) => categoryModel.manageCategories());
                  },
                  items: statusOptions.map<DropdownMenuItem<int>>((int status) {
                    return DropdownMenuItem<int>(
                      value: status,
                      child: Text(status == 0 ? 'Inactive' : 'Active',
                        style: const TextStyle(color: Color(0xffb3b3b3)),
                      ),
                    );
                  }).toList(),
                ),
              ],
            ),
            const SizedBox(height: 20),
            Container(
              width: 280,
              height: 50,
              decoration: BoxDecoration(
                color: Colors.black,
                borderRadius: BorderRadius.circular(20),
              ),
              child: TextButton(
                onPressed: () {
                  categoryModel
                      .newupdateCategory(
                    'category_name',
                    categoryController.text,
                    categoryId: widget.data['category_id'].toString(),
                  )
                      .then((_) {
                    categoryModel.newupdateCategory(
                      'priority',
                      int.parse(priorityController.text),
                      categoryId: widget.data['category_id'].toString(),
                    );
                    Navigator.pop(context, true);
                  });
                  log("Data of index: ${widget.data}");
                },
                child: const Center(
                  child: Text(
                    "UPDATE CATEGORY",
                    style: TextStyle(
                      color: Color(0xffb3b3b3),
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
    );
  }
}