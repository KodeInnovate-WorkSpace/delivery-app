import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:speedy_delivery/admin/admin_model.dart';
import 'package:speedy_delivery/widget/input_box.dart';

class UpdateProduct extends StatefulWidget {
  final Map<String, dynamic> data;

  const UpdateProduct({super.key, required this.data});

  @override
  State<UpdateProduct> createState() => _UpdateProductState();
}

class _UpdateProductState extends State<UpdateProduct> with ChangeNotifier {
  // text controllers
  TextEditingController nameController = TextEditingController();
  final TextEditingController priceController = TextEditingController();
  final TextEditingController stockController = TextEditingController();
  final TextEditingController imageController = TextEditingController();
  final TextEditingController unitController = TextEditingController();

  // status variables
  int? dropdownValue = 1;
  List<int> statusOptions = [0, 1]; // 0 for inactive, 1 for active

  // product model object
  final ProductModel productObj = ProductModel();

  // sub-cat variables
  final SubCatModel subcatObj = SubCatModel();

  List<Map<String, dynamic>> subcatOptions = [];

  String? selectedSubCategoryName;
  late int selectedSubCategoryId; // Default value

  Map<String, int> subcategoryMap = {};

  @override
  void initState() {
    super.initState();
    _loadSubCatData().then((_) {
      notifyListeners();
    });
    nameController.text = widget.data['name'];

    priceController.text = widget.data['price'].toString();
    stockController.text = widget.data['stock'].toString();
    // imageController.text = widget.data[''];
    unitController.text = widget.data['unit'];
  }

  Future<void> _loadSubCatData() async {
    subcatOptions = await subcatObj.manageSubCategories();

    // Populate the categoryNames and categoryMap
    for (var cat in subcatOptions) {
      subcategoryMap[cat['sub_category_name']] = cat['sub_category_id'];
    }

    // Set the initial selected category if available
    if (widget.data['id'] != null) {
      try {
        selectedSubCategoryId = widget.data['sub_category_id'];
        if (subcategoryMap.isNotEmpty) {
          selectedSubCategoryName = subcategoryMap.entries.firstWhere((entry) => entry.value == selectedSubCategoryId, orElse: () => subcategoryMap.entries.first).key;
        }
      } catch (e) {
        log("Error setting selected sub-category: $e");
      }
    }

    notifyListeners();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Update Product'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // name

            InputBox(
              hintText: "Update product name",
              myIcon: Icons.shopping_bag,
              myController: nameController,
              keyboardType: TextInputType.text,
            ),
            const SizedBox(height: 20),

            // price
            InputBox(
              hintText: "Update product price",
              myIcon: Icons.currency_rupee,
              myController: priceController,
              keyboardType: TextInputType.number,
            ),
            const SizedBox(height: 20),
            // stock
            InputBox(
              hintText: "Update product stock",
              myIcon: Icons.warehouse,
              myController: stockController,
              keyboardType: TextInputType.number,
            ),
            const SizedBox(height: 20),
            // unit
            InputBox(
              hintText: "Update product unit",
              myIcon: Icons.production_quantity_limits,
              myController: unitController,
              keyboardType: TextInputType.text,
            ),
            const SizedBox(height: 20),

            // sub-category dropdown
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text("Change Sub-Category: "),
                DropdownButton<String>(
                  value: selectedSubCategoryName ?? subcategoryMap.keys.first,
                  onChanged: (String? newValue) {
                    try {
                      setState(() {
                        selectedSubCategoryName = newValue!;
                        selectedSubCategoryId = subcategoryMap[selectedSubCategoryName]!;
                      });
                    } catch (e) {
                      log("Error getting sub-categories: $e");
                    }
                  },
                  items: subcategoryMap.keys.map<DropdownMenuItem<String>>((String sub) {
                    return DropdownMenuItem<String>(
                      value: sub,
                      child: Text(sub),
                    );
                  }).toList(),
                  hint: const Text("Select a sub-category"),
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
                    productObj
                        .updateProduct(
                          'status',
                          newValue,
                          categoryField: 'sub_category_id',
                          categoryValue: widget.data['sub_category_id'],
                        )
                        .then((_) => productObj.manageProducts());
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
                  try {
                    await productObj.updateProduct('name', nameController.text, categoryField: 'id', categoryValue: widget.data['id']);
                    log("Name = ${nameController.text}");
// Update price
                    await productObj.updateProduct('price', int.parse(priceController.text), categoryField: 'id', categoryValue: widget.data['id']);
                    log("Price = ${priceController.text}");

// Update stock
                    await productObj.updateProduct('stock', int.parse(stockController.text), categoryField: 'id', categoryValue: widget.data['id']);
                    log("Stock = ${stockController.text}");

// Update unit
                    await productObj.updateProduct('unit', unitController.text, categoryField: 'id', categoryValue: widget.data['id']);

// Update sub-category (if selected)
                    if (selectedSubCategoryId != -1) {
                      await productObj.updateProduct('name', selectedSubCategoryId, categoryField: 'id', categoryValue: widget.data['id']);
                    }

// Update status
                    await productObj.updateProduct('status', dropdownValue, categoryField: 'id', categoryValue: widget.data['id']);

// After successful updates
                    Navigator.pop(context, true);
                  } catch (e) {
                    log("Error: $e");
                  }
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
