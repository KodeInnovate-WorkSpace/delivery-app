import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:speedy_delivery/admin/subcategory/update_subcategory.dart';
import '../admin_model.dart';
import 'edit_sub_category.dart';

class ManageSubCategoryScreen extends StatefulWidget {
  const ManageSubCategoryScreen({super.key});

  @override
  State<ManageSubCategoryScreen> createState() => _ManageSubCategoryScreenState();
}

class _ManageSubCategoryScreenState extends State<ManageSubCategoryScreen> {
  late TableData src;
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';

  @override
  void initState() {
    super.initState();
    src = TableData(context);
    src.addListener(() {
      setState(() {});
    });
    _searchController.addListener(() {
      setState(() {
        _searchQuery = _searchController.text;
        src.filterData(_searchQuery);
      });
    });
  }

  @override
  void dispose() {
    src.removeListener(() {});
    src.dispose();
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _refreshPage() async {
    await src._loadSubData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('Manage Sub-Categories'),
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
                final result = await Navigator.push(context, MaterialPageRoute(builder: (context) => const EditSubCategory()));

                if (result != null && result as bool) {
                  // Sub-category added successfully, refresh the list
                  src._refreshSubCategoryList();
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
                  controller: _searchController,
                  decoration: InputDecoration(
                    labelText: 'Search Sub-Categories',
                    border: const OutlineInputBorder(),
                    prefixIcon: const Icon(Icons.search),
                    suffixIcon: _searchController.text.isNotEmpty
                        ? IconButton(
                            icon: const Icon(Icons.clear),
                            onPressed: () {
                              _searchController.clear();
                              src.filterData('');
                            },
                          )
                        : null,
                  ),
                ),
              ),
              Expanded(
                child: RefreshIndicator(
                  onRefresh: _refreshPage,
                  child: ListView(
                    children: [
                      PaginatedDataTable(
                        dataRowHeight: 80,
                        columns: const [
                          DataColumn(label: Text('Id'), tooltip: "Sub-Categoy ID"),
                          DataColumn(label: Text('Category'), tooltip: "Name of the category this sub-category belongs to"),
                          DataColumn(label: Text('Image')),
                          DataColumn(label: Text('Name')),
                          DataColumn(label: Text('Status')),
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

  SubCatModel subcat = SubCatModel();
  CatModel category = CatModel();
  List<int> statusOptions = [0, 1]; // 0 for active, 1 for inactive

  // Storing sub-category data in a list
  List<Map<String, dynamic>> subData = [];
  List<Map<String, dynamic>> filteredData = [];
  Map<int, String> categoryData = {}; // Map to store category_id to category_name

  TableData(this.context) {
    _loadSubData();
  }

  Future<void> _loadSubData() async {
    await _loadCategoryData();
    subData = await subcat.manageSubCategories();

    // Sort subData by sub_category_id
    subData.sort((a, b) => a['sub_category_id'].compareTo(b['sub_category_id']));
    filteredData = subData;
    notifyListeners();
  }

  Future<void> _loadCategoryData() async {
    final categories = await category.manageCategories();
    categoryData = {for (var cat in categories) cat['category_id']: cat['category_name']};
    notifyListeners();
  }

  Future<void> _updateSubCategory(String field, dynamic newValue, {String? categoryField, dynamic categoryValue}) async {
    await subcat.updateSubCategory(field, newValue, categoryField: categoryField, categoryValue: categoryValue);
    _loadSubData(); // Reload data after update
  }

  Future<void> _deleteSubCategory(dynamic categoryValue) async {
    await subcat.deleteSubCategory(categoryValue);
    _loadSubData(); // Reload data after deletion
  }

  void _refreshSubCategoryList() async {
    // Clear existing data
    subData.clear();

    // Reload data from the server (or local storage)
    await _loadSubData();

    notifyListeners();
  }

  void filterData(String query) {
    if (query.isEmpty) {
      filteredData = subData;
    } else {
      filteredData = subData.where((subcategory) => subcategory['sub_category_name'].toString().toLowerCase().contains(query.toLowerCase())).toList();
    }
    notifyListeners();
  }

  @override
  DataRow? getRow(int index) {
    if (index >= filteredData.length) return null;

    final data = filteredData[index];
    final categoryName = categoryData[data['category_id']] ?? 'Deleted';

    return DataRow(cells: [
      DataCell(Text(data['sub_category_id'].toString())),
      DataCell(Text(categoryName)),

      DataCell(
        SizedBox(
          width: 35,
          child: CachedNetworkImage(
            imageUrl: data['sub_category_img'] ?? 'No Image',
          ),
        ),
      ),
      DataCell(SizedBox(
        width: 150,
        child: Text(
          data['sub_category_name'],
          softWrap: true,
          overflow: TextOverflow.visible,
        ),
      )),
      DataCell(DropdownButton<int>(
        value: data['status'],
        onChanged: (int? newValue) {
          _updateSubCategory(
            'status',
            newValue,
            categoryField: 'sub_category_id',
            categoryValue: data['sub_category_id'],
          );
        },
        items: statusOptions.map<DropdownMenuItem<int>>((int status) {
          return DropdownMenuItem<int>(
            value: status,
            child: Text(status == 0 ? 'Inactive' : 'Active'), // Display 'Active' or 'Inactive'
          );
        }).toList(),
      )),

      //Delete
      DataCell(
        IconButton(
          icon: const Icon(Icons.delete),
          onPressed: () {
            _deleteSubCategory(data['sub_category_id']);
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
                builder: (context) => UpdateSubCategory(data: data),
              ),
            );

            // Check if result is true (indicating update)
            if (result != null && result as bool) {
              _refreshSubCategoryList(); // Call refresh function here
            }
          },
        ),
      ),
    ]);
  }

  @override
  bool get isRowCountApproximate => false;

  @override
  int get rowCount => filteredData.length;

  @override
  int get selectedRowCount => 0;
}
