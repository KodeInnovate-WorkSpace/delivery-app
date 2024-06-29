import 'package:flutter/material.dart';
import 'package:speedy_delivery/admin/banner/update_banner.dart';
import 'package:speedy_delivery/widget/input_box.dart';

import '../admin_model.dart';

class UpdateBanner extends StatefulWidget {
  final Map<String, dynamic> data;

  const UpdateBanner({super.key, required this.data});

  @override
  State<UpdateBanner> createState() => _UpdateBannerState();
}

class _UpdateBannerState extends State<UpdateBanner> {
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
        title: const Text('Update Category'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            InputBox(
              hintText: "Update Category name",
              myIcon: Icons.category,
              myController: categoryController,
            ),
            const SizedBox(height: 20),
            InputBox(
              hintText: "Update Priority",
              myIcon: Icons.sort,
              myController: priorityController,
            ),
            const SizedBox(height: 20),
            // Row(
            //   mainAxisAlignment: MainAxisAlignment.center,
            //   children: [
            //     const Text("Status: "),
            //     DropdownButton<int>(
            //       value: dropdownValue, // Use the status value from data
            //       onChanged: (int? newValue) {
            //         setState(() {
            //           dropdownValue = newValue;
            //         });
            //         categoryModel.UpdateBanner(
            //           'status',
            //           newValue,
            //           categoryField: 'category_id',
            //           categoryValue: widget.data['category_id'],
            //         ).then((_) => categoryModel.manageCategories());
            //       },
            //       items: statusOptions.map<DropdownMenuItem<int>>((int status) {
            //         return DropdownMenuItem<int>(
            //           value: status,
            //           child: Text(status == 0 ? 'Inactive' : 'Active'),
            //         );
            //       }).toList(),
            //     ),
            //   ],
            // ),
            const SizedBox(height: 20),
            // Container(
            //   width: 280,
            //   height: 50,
            //   decoration: BoxDecoration(
            //     color: Colors.black,
            //     borderRadius: BorderRadius.circular(20),
            //   ),
            //   child: TextButton(
            //     onPressed: () {
            //       categoryModel
            //           .newUpdateBanner(
            //         'category_name',
            //         categoryController.text,
            //         categoryId: widget.data['category_id'].toString(),
            //       )
            //           .then((_) {
            //         categoryModel.newUpdateBanner(
            //           'priority',
            //           int.parse(priorityController.text),
            //           categoryId: widget.data['category_id'].toString(),
            //         );
            //         Navigator.pop(context, true);
            //       });
            //       log("Data of index: ${widget.data}");
            //     },
            //     child: const Center(
            //       child: Text(
            //         "UPDATE CATEGORY",
            //         style: TextStyle(
            //           color: Colors.white,
            //           fontFamily: 'Gilroy-Black',
            //           fontSize: 16.0,
            //         ),
            //       ),
            //     ),
            //   ),
            // ),
          ],
        ),
      ),
    );
  }
}
