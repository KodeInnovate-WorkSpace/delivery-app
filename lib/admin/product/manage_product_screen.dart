// import 'package:flutter/material.dart';
// import 'package:speedy_delivery/admin/product/edit_product.dart';
// import 'package:speedy_delivery/admin/product/update_product.dart';
// import '../admin_model.dart';
//
// class ManageProductScreen extends StatefulWidget {
//   const ManageProductScreen({super.key});
//
//   @override
//   State<ManageProductScreen> createState() => _ManageProductScreenState();
// }
//
// class _ManageProductScreenState extends State<ManageProductScreen> {
//   late TableData src;
//
//   @override
//   void initState() {
//     super.initState();
//     src = TableData(context);
//     src.addListener(() {
//       setState(() {});
//     });
//   }
//
//   @override
//   void dispose() {
//     src.removeListener(() {});
//     src.dispose();
//     super.dispose();
//   }
//
//   Future<void> _refreshPage() async {
//     await src._loadProductData();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Colors.white,
//       appBar: AppBar(
//         title: const Text('Manage Products'),
//       ),
//       body: Stack(
//         children: [
//           RefreshIndicator(
//             onRefresh: _refreshPage,
//             child: ListView(children: [
//               PaginatedDataTable(
//                 columns: const [
//                   DataColumn(
//                     label: Text('ID'),
//                   ),
//                   DataColumn(
//                     label: Text('Sub-Cat'),
//                   ),
//                   DataColumn(label: Text('Image')),
//                   DataColumn(label: Text('Name')),
//                   DataColumn(label: Text('Unit')),
//                   DataColumn(label: Text('Price')),
//                   DataColumn(label: Text('Stock')),
//                   DataColumn(label: Text('Status')),
//                   DataColumn(label: Text('')),
//                   DataColumn(label: Text('')),
//                 ],
//                 source: src,
//                 columnSpacing: 15,
//                 rowsPerPage: 5,
//               ),
//             ]),
//           ),
//           Positioned(
//             bottom: 25,
//             right: 20,
//             child: FloatingActionButton(
//               hoverColor: Colors.transparent,
//               elevation: 2,
//               onPressed: () async {
//                 final result = await Navigator.push(
//                     context,
//                     MaterialPageRoute(
//                         builder: (context) => const EditProduct()));
//
//                 if (result != null && result as bool) {
//                   // Sub-category added successfully, refresh the list
//                   src._refreshProductList();
//                 }
//               },
//               backgroundColor: Colors.black,
//               child: const Icon(
//                 Icons.add,
//                 color: Colors.white,
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }
//
// class TableData extends DataTableSource {
//   final BuildContext context;
//
//   ProductModel productObj = ProductModel();
//   CatModel category = CatModel();
//   List<int> statusOptions = [0, 1]; // 0 for active, 1 for inactive
//
//   // Storing sub-category data in a list
//   List<Map<String, dynamic>> productData = [];
//   Map<int, String> categoryData =
//       {}; // Map to store category_id to category_name
//
//   TableData(this.context) {
//     _loadProductData();
//   }
//
//   Future<void> _loadProductData() async {
//     // Getting data from manageSubCategories() which is in productObj class
//     await _loadCategoryData();
//     productData = await productObj.manageProducts();
//     notifyListeners(); // Notify the listeners that data has changed
//   }
//
//   Future<void> _loadCategoryData() async {
//     final categories = await category.manageCategories();
//     categoryData = {
//       for (var cat in categories) cat['category_id']: cat['category_name']
//     };
//     notifyListeners();
//   }
//
//   Future<void> _updateProduct(String field, dynamic newValue,
//       {String? categoryField, dynamic categoryValue}) async {
//     await productObj.updateProduct(field, newValue,
//         categoryField: categoryField, categoryValue: categoryValue);
//     _loadProductData(); // Reload data after update
//   }
//
//   Future<void> _deleteProduct(dynamic categoryValue) async {
//     await productObj.deleteProduct(categoryValue);
//     _loadProductData(); // Reload data after deletion
//   }
//
//   void _refreshProductList() async {
//     // Clear existing data
//     productData.clear();
//
//     // Reload data from the server (or local storage)
//     await _loadProductData();
//
//     notifyListeners();
//   }
//
//   @override
//   DataRow? getRow(int index) {
//     if (index >= productData.length) return null; // Check index bounds
//
//     // Storing each index of productData list in data variable to iterate over each list
//     final data = productData[index];
//     // final sub = categoryData[data['sub_category_id']] ?? 'Deleted';
//
//     return DataRow(cells: [
//       // id
//       DataCell(Text(data['id'].toString())),
//       // subcat id
//       // DataCell(Text(sub)),
//       DataCell(Text(data['sub_category_id'].toString())),
//       // image
//       DataCell(
//         SizedBox(
//           width: 35,
//           child: Image.network(data['image'] ?? ''),
//         ),
//       ),
//       // name
//       DataCell(Text(data['name'] ?? 'N/A')),
//       // unit
//       DataCell(Text(data['unit'].toString())),
//       // price
//       DataCell(Text(data['price'].toString())),
//       // stock
//       DataCell(Text(data['stock'].toString())),
//       // status
//       DataCell(DropdownButton<int>(
//         value: data['status'], // Use the status value from data
//         onChanged: (int? newValue) {
//           _updateProduct(
//             'status',
//             newValue,
//             categoryField: 'sub_category_id',
//             categoryValue: data['sub_category_id'],
//           );
//         },
//         items: statusOptions.map<DropdownMenuItem<int>>((int status) {
//           return DropdownMenuItem<int>(
//             value: status,
//             child: Text(status == 0
//                 ? 'Inactive'
//                 : 'Active'), // Display 'Active' or 'Inactive'
//           );
//         }).toList(),
//       )),
//       // delete
//       DataCell(
//         IconButton(
//           icon: const Icon(Icons.delete),
//           onPressed: () {
//             _deleteProduct(data['id']);
//           },
//         ),
//       ),
//       // edit
//       DataCell(
//         IconButton(
//           icon: const Icon(Icons.edit),
//           onPressed: () async {
//             final result = await Navigator.push(
//               context,
//               MaterialPageRoute(
//                 builder: (context) => UpdateProduct(data: data),
//               ),
//             );
//
//             // Check if result is true (indicating update)
//             if (result != null && result as bool) {
//               _refreshProductList(); // Call refresh function here
//             }
//           },
//         ),
//       ),
//     ]);
//   }
//
//   @override
//   bool get isRowCountApproximate => false;
//
//   @override
//   int get rowCount => productData.length;
//
//   @override
//   int get selectedRowCount => 0;
// }

// old code
import 'package:flutter/material.dart';
import '../admin_model.dart';
import 'edit_product.dart';

class ManageProductScreen extends StatefulWidget {
  const ManageProductScreen({super.key});

  @override
  State<ManageProductScreen> createState() => _ManageProductScreenState();
}

class _ManageProductScreenState extends State<ManageProductScreen> {
  late TableData src;

  @override
  void initState() {
    super.initState();
    src = TableData();
    src.addListener(() {
      setState(() {});
    });
  }

  @override
  void dispose() {
    src.removeListener(() {});
    src.dispose();
    super.dispose();
  }

  void _refreshProductList() async {
    // Clear existing data
    src.productData.clear();
    // Reload data from the server (or local storage)
    await src.loadProductData();

    // Notify listeners about the change (important!)
    setState(() {});
  }

  Future<void> _refreshPage() async {
    await src.loadProductData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('Manage Products'),
      ),
      body: Stack(
        children: [
          RefreshIndicator(
            onRefresh: _refreshPage,
            child: ListView(children: [
              PaginatedDataTable(
                columns: const [
                  DataColumn(label: Text('Product Id')),
                  DataColumn(label: Text('Image')),
                  DataColumn(label: Text('Name')),
                  DataColumn(label: Text('Price')),
                  DataColumn(label: Text('Status')),
                  DataColumn(label: Text('Unit')),
                  DataColumn(label: Text('Sub-Cat')),
                  DataColumn(label: Text('')),
                ],
                source: src,
                columnSpacing: 15,
                rowsPerPage: 5,
              ),
            ]),
          ),
          Positioned(
            bottom: 25,
            right: 20,
            child: FloatingActionButton(
              hoverColor: Colors.transparent,
              elevation: 2,
              onPressed: () async {
                final result = await Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const EditProduct()));

                if (result != null && result as bool) {
                  // Sub-category added successfully, refresh the list
                  _refreshProductList();
                }
                // Navigator.push(
                //   context,
                //   MaterialPageRoute(builder: (context) => const EditProduct()),
                // );
              },
              backgroundColor: Colors.black,
              child: const Icon(
                Icons.add,
                color: Colors.white,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class TableData extends DataTableSource {
  final ProductModel productObj = ProductModel();
  final List<int> statusOptions = [0, 1]; // 0 for active, 1 for inactive

  List<Map<String, dynamic>> productData = [];

  // get sub-category in dropdown
  SubCatModel subCatObj = SubCatModel();
  Map<int, String> subCatData = {}; // Map to store category_id to category_name

  TableData() {
    loadProductData();
  }

  Future<void> loadProductData() async {
    await _loadCategoryData();
    productData = await productObj.manageProducts();
    debugPrint('Product Data: $productData');
    notifyListeners(); // Notify the listeners that data has changed
  }

  Future<void> _loadCategoryData() async {
    final categories = await subCatObj.manageSubCategories();
    subCatData = {
      for (var cat in categories)
        cat['sub_category_id']: cat['sub_category_name']
    };
    notifyListeners();
  }

  Future<void> _updateProduct(String field, dynamic newValue,
      {String? categoryField, dynamic categoryValue}) async {
    await productObj.updateProduct(field, newValue,
        categoryField: categoryField, categoryValue: categoryValue);
    loadProductData(); // Reload data after update
  }

  Future<void> _deleteProduct(dynamic categoryValue) async {
    await productObj.deleteProduct(categoryValue);
    loadProductData(); // Reload data after deletion
    // _updateProduct;
  }

  @override
  DataRow? getRow(int index) {
    if (index >= productData.length) return null; // Check index bounds

    final data = productData[index];
    final subCatName = subCatData[data['sub_category_id']] ?? 'Unknown';

    return DataRow(cells: [
      // id column
      DataCell(Text(data['id']?.toString() ?? 'N/A')),
      // image column
      DataCell(
        SizedBox(
          width: 35,
          child:
              Image.network(data['image'] ?? 'https://via.placeholder.com/35'),
        ),
      ),
      // name column
      // DataCell((Text(data['name']))),

      DataCell(
        TextFormField(
          initialValue: data['name'] ?? '',
          onFieldSubmitted: (newValue) {
            _updateProduct(
              'name',
              newValue,
              categoryField: 'id',
              categoryValue: data['id'],
            );
          },
        ),
      ),
      // price column
      // DataCell((Text(data['price'].toString()))),
      DataCell(
        TextFormField(
          initialValue: data['price'].toString(),
          onFieldSubmitted: (newValue) {
            _updateProduct(
              'price',
              newValue,
              categoryField: 'id',
              categoryValue: data['id'],
            );
          },
        ),
      ),
      // status column
      DataCell(DropdownButton<int>(
        value: data['status'] ?? 0,
        onChanged: (int? newValue) {
          _updateProduct(
            'status',
            newValue,
            categoryField: 'id',
            categoryValue: data['id'],
          );
        },
        items: statusOptions.map<DropdownMenuItem<int>>((int status) {
          return DropdownMenuItem<int>(
            value: status,
            child: Text(status == 0 ? 'Inactive' : 'Active'),
          );
        }).toList(),
      )),
      // unit column

      DataCell(
        TextFormField(
          initialValue: data['unit'] ?? '',
          onFieldSubmitted: (newValue) {
            _updateProduct(
              'unit',
              newValue,
              categoryField: 'id',
              categoryValue: data['id'],
            );
          },
        ),
      ),

      // sub-category name column
      DataCell(DropdownButton<String>(
        value: subCatName,
        onChanged: (String? newValue) {
          final newSubCatId = subCatData.entries
              .firstWhere((entry) => entry.value == newValue)
              .key;
          _updateProduct(
            'sub_category_id',
            newSubCatId,
            categoryField: 'id',
            categoryValue: data['id'],
          );
        },
        items: subCatData.entries.map<DropdownMenuItem<String>>((entry) {
          return DropdownMenuItem<String>(
            value: entry.value,
            child: Text(entry.value),
          );
        }).toList(),
      )),

      // Delete column
      DataCell(
        IconButton(
          icon: const Icon(Icons.delete),
          onPressed: () {
            _deleteProduct(data['sub_category_id']);
          },
        ),
      ),
    ]);
  }

  @override
  bool get isRowCountApproximate => false;

  @override
  int get rowCount => productData.length;

  @override
  int get selectedRowCount => 0;
}
