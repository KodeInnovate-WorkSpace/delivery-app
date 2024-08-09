import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:speedy_delivery/admin/offers/product_offer/update_offer_product.dart';
import 'package:speedy_delivery/admin/product/update_product.dart';
import '../offer_model.dart';
import 'edit_offer_product.dart';

class ManageOfferProduct extends StatefulWidget {
  const ManageOfferProduct({super.key});

  @override
  State<ManageOfferProduct> createState() => _ManageOfferProductState();
}

class _ManageOfferProductState extends State<ManageOfferProduct> {
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
      appBar: AppBar(
        title: const Text(
          'Manage Offer Products',
          style: TextStyle(color: Color(0xffb3b3b3)),
        ),
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
                final result = await Navigator.push(context, MaterialPageRoute(builder: (context) => const EditOfferProduct()));

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
                    border: const OutlineInputBorder(),
                    prefixIcon: const Icon(Icons.search),
                    suffixIcon: IconButton(
                      icon: const Icon(Icons.clear),
                      onPressed: () {
                        searchController.clear();
                        src.filterProducts('');
                      },
                    ),
                  ),
                  style: const TextStyle(color: Color(0xffb3b3b3)),
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
                          DataColumn(label: Text('IsVeg')),
                          DataColumn(label: Text('Status')),
                          DataColumn(label: Text('Price')),
                          DataColumn(label: Text('MRP')),
                          DataColumn(label: Text('Stock')),
                          DataColumn(label: Text('Unit')),
                          DataColumn(label: Text('Category')),
                          DataColumn(label: Text('')),
                          DataColumn(label: Text('')),
                        ],
                        source: src,
                        columnSpacing: 10,
                        rowsPerPage: 8,
                        showFirstLastButtons: true,
                        arrowHeadColor: const Color(0xff1a1a1c),
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

  final OfferProductModel productObj = OfferProductModel();
  List<int> statusOptions = [0, 1];
  // Storing product data in a list
  List<Map<String, dynamic>> productData = [];
  List<Map<String, dynamic>> filteredProductData = [];

  OfferCatModel offerCatObj = OfferCatModel();
  Map<int, String> offerCatData = {};

  TableData(this.context) {
    _loadProductData();
  }

  Future<void> _loadProductData() async {
    await _loadOfferCategoryData();
    productData = await productObj.manageOfferProducts();
    debugPrint('Product Data: $productData');

    productData.sort((a, b) => a['id'].compareTo(b['id']));
    filteredProductData = List.from(productData);

    notifyListeners(); // Notify the listeners that data has changed
  }

  Future<void> _loadOfferCategoryData() async {
    final categories = await offerCatObj.manageOfferCategories();
    // offerCatData = {for (var cat in categories) cat['id']: cat['id']};
    notifyListeners();
  }

  Future<void> _updateProduct(String field, dynamic newValue, {String? categoryField, dynamic categoryValue}) async {
    await productObj.updateOfferProduct(field, newValue, productField: categoryField, productValue: categoryValue);
    _loadProductData(); // Reload data after update
  }

  Future<void> _deleteProduct(dynamic categoryValue) async {
    await productObj.deleteOfferProduct(categoryValue);
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

    final data = filteredProductData[index];
    final subCatName = offerCatData[data['id']] ?? 'Unknown';

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
        width: 100,
        child: Text(
          data['name'],
          softWrap: true,
          overflow: TextOverflow.visible,
        ),
      )),

      // isVeg
      //isVeg
      DataCell(
        Text(data['isVeg'] == true ? 'Yes' : ''),
      ),

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
            child: Text(status == 0 ? 'Inactive' : 'Active'),
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

      // Category Id
      DataCell(Text(data['categoryId']?.toString() ?? 'N/A')),

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
                builder: (context) => UpdateOfferProduct(data: data),
              ),
            );

            if (result != null && result as bool) {
              _refreshProductList();
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
