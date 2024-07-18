import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:speedy_delivery/admin/product/update_product.dart';
import '../admin_model.dart';
import 'edit_product.dart';

class ManageProduct extends StatefulWidget {
  const ManageProduct({super.key});

  @override
  State<ManageProduct> createState() => _ManageProductState();
}

class _ManageProductState extends State<ManageProduct> {
  late TableData src;
  TextEditingController searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    src = TableData(context);
    src.addListener(() {
      setState(() {});
    });
  }

  @override
  void dispose() {
    src.removeListener(() {});
    src.dispose();
    searchController.dispose();
    super.dispose();
  }

  Future<void> _refreshPage() async {
    await src._loadProductData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('Manage Products'),
        actions: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: ElevatedButton(
              style: ButtonStyle(
                backgroundColor: WidgetStateProperty.all<Color>(Colors.black),
                shape: WidgetStateProperty.all<RoundedRectangleBorder>(
                  RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                ),
              ),
              onPressed: () async {
                final result = await Navigator.push(context, MaterialPageRoute(builder: (context) => const EditProduct()));

                if (result != null && result as bool) {
                  // Product added successfully, refresh the list
                  src._refreshProductList();
                }
              },
              child: const Icon(
                Icons.add,
                color: Colors.white,
              ),
            ),
          )
        ],
      ),
      body: Stack(
        children: [
          Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextField(
                  controller: searchController,
                  decoration: InputDecoration(
                    labelText: 'Search',
                    hintText: 'Search by product name',
                    prefixIcon: const Icon(Icons.search),
                    suffixIcon: IconButton(
                      icon: const Icon(Icons.clear),
                      onPressed: () {
                        searchController.clear();
                        src.filterProducts('');
                      },
                    ),
                  ),
                  onChanged: (value) {
                    src.filterProducts(value);
                  },
                ),
              ),
              Expanded(
                child: RefreshIndicator(
                  onRefresh: _refreshPage,
                  child: ListView(
                    children: [
                      PaginatedDataTable(
                        dataRowHeight: 100,
                        columns: const [
                          DataColumn(label: Text('ID')),
                          DataColumn(label: Text('Image')),
                          DataColumn(label: Text('Name')),
                          DataColumn(label: Text('Status')),
                          DataColumn(label: Text('Price')),
                          DataColumn(label: Text('MRP')),
                          DataColumn(label: Text('Stock')),
                          DataColumn(label: Text('Unit')),
                          DataColumn(label: Text('Sub-Category')),
                          DataColumn(label: Text('')),
                          DataColumn(label: Text('')),
                        ],
                        source: src,
                        columnSpacing: 10,
                        rowsPerPage: 8,
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class TableData extends DataTableSource {
  final BuildContext context;

  final ProductModel productObj = ProductModel();
  List<int> statusOptions = [0, 1];
  // Storing product data in a list
  List<Map<String, dynamic>> productData = [];
  List<Map<String, dynamic>> filteredProductData = [];

  SubCatModel subCatObj = SubCatModel();
  Map<int, String> subCatData = {};

  TableData(this.context) {
    _loadProductData();
  }

  Future<void> _loadProductData() async {
    await _loadSubCategoryData();
    productData = await productObj.manageProducts();
    debugPrint('Product Data: $productData');

    productData.sort((a, b) => a['id'].compareTo(b['id']));
    filteredProductData = List.from(productData);

    notifyListeners(); // Notify the listeners that data has changed
  }

  Future<void> _loadSubCategoryData() async {
    final categories = await subCatObj.manageSubCategories();
    subCatData = {for (var cat in categories) cat['sub_category_id']: cat['sub_category_name']};
    notifyListeners();
  }

  Future<void> _updateProduct(String field, dynamic newValue, {String? categoryField, dynamic categoryValue}) async {
    await productObj.updateProduct(field, newValue, productField: categoryField, productValue: categoryValue);
    _loadProductData(); // Reload data after update
  }

  Future<void> _deleteProduct(dynamic categoryValue) async {
    await productObj.deleteProduct(categoryValue);
    await _loadProductData(); // Refresh data after deletion
  }

  void _refreshProductList() async {
    // Clear existing data
    productData.clear();
    // Reload data from the server (or local storage)
    await _loadProductData();
  }

  void filterProducts(String query) {
    if (query.isEmpty) {
      filteredProductData = List.from(productData);
    } else {
      filteredProductData = productData.where((product) {
        final name = product['name'].toString().toLowerCase();
        return name.contains(query.toLowerCase());
      }).toList();
    }
    notifyListeners();
  }

  @override
  DataRow? getRow(int index) {
    if (index >= filteredProductData.length) return null; // Check index bounds

    // Storing each index of productData list in data variable to iterate over each list
    final data = filteredProductData[index];
    final subCatName = subCatData[data['sub_category_id']] ?? 'Unknown';

    return DataRow(cells: [
      //id
      DataCell(Text(data['id']?.toString() ?? 'N/A')),

      //image
      DataCell(
        SizedBox(
          width: 35,
          child: CachedNetworkImage(
            imageUrl: data['image'] ?? 'No Image',
          ),
        ),
      ),

      //name
      DataCell(SizedBox(
        width: 130,
        child: Text(
          data['name'],
          softWrap: true,
          overflow: TextOverflow.visible,
        ),
      )),

      //status
      DataCell(DropdownButton<int>(
        value: data['status'], // Use the status value from data
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
            child: Text(status == 0 ? 'Inactive' : 'Active'), // Display 'Active' or 'Inactive'
          );
        }).toList(),
      )),

      //price
      DataCell(SizedBox(
        width: 40,
        child: Text(
          data['price'].toString(),
          softWrap: true,
          overflow: TextOverflow.visible,
        ),
      )),

      //mrp
      DataCell(SizedBox(
        width: 40,
        child: Text(
          data['mrp'].toString(),
          softWrap: true,
          overflow: TextOverflow.visible,
        ),
      )),

      //stock
      DataCell(SizedBox(
        width: 40,
        child: Text(
          data['stock'].toString(),
          softWrap: true,
          overflow: TextOverflow.visible,
        ),
      )),

      //Unit
      DataCell(SizedBox(
        width: 50,
        child: Text(
          data['unit'],
          softWrap: true,
          overflow: TextOverflow.visible,
        ),
      )),

      // sub-category name column
      DataCell(DropdownButton<String>(
        value: subCatName,
        onChanged: (String? newValue) {
          final newSubCatId = subCatData.entries.firstWhere((entry) => entry.value == newValue).key;
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

      //Delete
      DataCell(
        IconButton(
          icon: const Icon(Icons.delete),
          onPressed: () {
            _deleteProduct(data['id']);
          },
        ),
      ),

      //Edit
      DataCell(
        IconButton(
          icon: const Icon(Icons.edit),
          onPressed: () async {
            final result = await Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => UpdateProduct(data: data),
              ),
            );

            // Check if result is true (indicating update)
            if (result != null && result as bool) {
              _refreshProductList(); // Call refresh function here
            }
          },
        ),
      ),
    ]);
  }

  @override
  bool get isRowCountApproximate => false;

  @override
  int get rowCount => filteredProductData.length;

  @override
  int get selectedRowCount => 0;
}