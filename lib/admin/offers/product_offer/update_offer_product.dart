import 'dart:developer';
import 'package:flutter/material.dart';
import '../../../widget/input_box.dart';
import '../offer_model.dart';

class UpdateOfferProduct extends StatefulWidget {
  final Map<String, dynamic> data;

  const UpdateOfferProduct({super.key, required this.data});

  @override
  State<UpdateOfferProduct> createState() => _UpdateOfferProductState();
}

class _UpdateOfferProductState extends State<UpdateOfferProduct> with ChangeNotifier {
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
  final OfferProductModel offerProductObj = OfferProductModel();

  // sub-cat variables
  final OfferCatModel offerCatObj = OfferCatModel();

  List<Map<String, dynamic>> offerCatOptions = [];

  String? selectedOfferCategoryName;
  late int selectedOfferCategoryId; // Default value

  Map<String, int> offerCategoryMap = {};

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
    offerCatOptions = await offerCatObj.manageOfferCategories();

    // Populate the categoryNames and categoryMap
    for (var cat in offerCatOptions) {
      offerCategoryMap[cat['categoryId']] = cat['categoryId'];
    }

    // Set the initial selected category if available
    if (widget.data['id'] != null) {
      try {
        selectedOfferCategoryId = widget.data['categoryId'];
        if (offerCategoryMap.isNotEmpty) {
          selectedOfferCategoryName = offerCategoryMap.entries.firstWhere((entry) => entry.value == selectedOfferCategoryId, orElse: () => offerCategoryMap.entries.first).key;
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
        title: const Text('Update Offer Product'),
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
                    await offerCatObj.updateOfferCategory('name', nameController.text);
                    log("Name = ${nameController.text}");

                    // Update mrp
                    await offerCatObj.updateOfferCategory(
                      'mrp',
                      int.parse(mrpController.text),
                    );
                    log("Mrp = ${mrpController.text}");

                    // Update price
                    await offerCatObj.updateOfferCategory(
                      'price',
                      int.parse(priceController.text),
                    );
                    log("Price = ${priceController.text}");

                    // Update stock
                    await offerCatObj.updateOfferCategory(
                      'stock',
                      int.parse(stockController.text),
                    );
                    log("Stock = ${stockController.text}");

                    // Update unit
                    await offerCatObj.updateOfferCategory(
                      'unit',
                      unitController.text,
                    );
                    log("Unit = ${unitController.text}");

                    // Update isVeg
                    await offerCatObj.updateOfferCategory(
                      'isVeg',
                      isVeg,
                    );
                    log("isVeg = $isVeg");

                    // Update sub-category (if selected)
                    if (selectedOfferCategoryId != -1) {
                      await offerCatObj.updateOfferCategory(
                        'categoryId',
                        selectedOfferCategoryId,
                      );
                      log("Category ID = $selectedOfferCategoryId");
                    }

                    // Update status
                    await offerProductObj.updateOfferProduct('status', dropdownValue, productField: 'id', productValue: widget.data['id']);
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
