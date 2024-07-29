import 'dart:developer';
import 'package:flutter/material.dart';
import '../../widget/input_box.dart';
import '../admin_model.dart';

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
  final TextEditingController mrpController = TextEditingController();
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

  // isVeg state
  bool isVeg = false;

  @override
  void initState() {
    super.initState();
    _loadSubCatData().then((_) {
      notifyListeners();
    });
    nameController.text = widget.data['name'];
    mrpController.text = widget.data['mrp'].toString();
    priceController.text = widget.data['price'].toString();
    stockController.text = widget.data['stock'].toString();
    unitController.text = widget.data['unit'];

    // Initialize isVeg state
    isVeg = widget.data['isVeg'] ?? false;
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

            // mrp
            InputBox(
              hintText: "Update product mrp",
              myIcon: Icons.currency_rupee,
              myController: mrpController,
              keyboardType: TextInputType.number,
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

            // isVeg checkbox
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text("Vegetarian: "),
                Checkbox(
                  value: isVeg,
                  onChanged: (bool? newValue) {
                    setState(() {
                      isVeg = newValue ?? false;
                    });
                  },
                ),
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
                  try {
                    // Update name
                    await productObj.updateProduct('name', nameController.text, productField: 'id', productValue: widget.data['id']);
                    log("Name = ${nameController.text}");

                    // Update mrp
                    await productObj.updateProduct('mrp', int.parse(mrpController.text), productField: 'id', productValue: widget.data['id']);
                    log("Mrp = ${mrpController.text}");

                    // Update price
                    await productObj.updateProduct('price', int.parse(priceController.text), productField: 'id', productValue: widget.data['id']);
                    log("Price = ${priceController.text}");

                    // Update stock
                    await productObj.updateProduct('stock', int.parse(stockController.text), productField: 'id', productValue: widget.data['id']);
                    log("Stock = ${stockController.text}");

                    // Update unit
                    await productObj.updateProduct('unit', unitController.text, productField: 'id', productValue: widget.data['id']);
                    log("Unit = ${unitController.text}");

                    // Update isVeg
                    await productObj.updateProduct('isVeg', isVeg, productField: 'id', productValue: widget.data['id']);
                    log("isVeg = $isVeg");

                    // Update sub-category (if selected)
                    if (selectedSubCategoryId != -1) {
                      await productObj.updateProduct('sub_category_id', selectedSubCategoryId, productField: 'id', productValue: widget.data['id']);
                      log("Sub-category ID = $selectedSubCategoryId");
                    }

                    // Update status
                    await productObj.updateProduct('status', dropdownValue, productField: 'id', productValue: widget.data['id']);
                    log("Status = $dropdownValue");

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
