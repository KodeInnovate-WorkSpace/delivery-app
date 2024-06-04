import 'package:flutter/material.dart';
import 'package:speedy_delivery/admin/subcategory/update_subcategory.dart';
import '../admin_model.dart';
import 'edit_sub_category.dart';

class ManageSubCategoryScreen extends StatefulWidget {
  const ManageSubCategoryScreen({super.key});

  @override
  State<ManageSubCategoryScreen> createState() =>
      _ManageSubCategoryScreenState();
}

class _ManageSubCategoryScreenState extends State<ManageSubCategoryScreen> {
  late TableData src;

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
      ),
      body: Stack(
        children: [
          RefreshIndicator(
            onRefresh: _refreshPage,
            child: ListView(children: [
              PaginatedDataTable(
                columns: const [
                  DataColumn(
                      label: Text('Category'),
                      tooltip:
                          "Name of the category this sub-category belongs to"),
                  DataColumn(
                      label: Text('Sub-Cat Id'), tooltip: "Sub-Categoy ID"),
                  DataColumn(label: Text('Image')),
                  DataColumn(label: Text('Name')),
                  DataColumn(label: Text('Status')),
                  DataColumn(label: Text('')),
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
                        builder: (context) => const EditSubCategory()));

                if (result != null && result as bool) {
                  // Sub-category added successfully, refresh the list
                  src._refreshSubCategoryList();
                }
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
  final BuildContext context;

  SubCatModel subcat = SubCatModel();
  CatModel category = CatModel();
  List<int> statusOptions = [0, 1]; // 0 for active, 1 for inactive

  // Storing sub-category data in a list
  List<Map<String, dynamic>> subData = [];
  Map<int, String> categoryData =
      {}; // Map to store category_id to category_name

  TableData(this.context) {
    _loadSubData();
  }

  Future<void> _loadSubData() async {
    // Getting data from manageSubCategories() which is in subcat class
    await _loadCategoryData();
    subData = await subcat.manageSubCategories();
    notifyListeners(); // Notify the listeners that data has changed
  }

  Future<void> _loadCategoryData() async {
    final categories = await category.manageCategories();
    categoryData = {
      for (var cat in categories) cat['category_id']: cat['category_name']
    };
    notifyListeners();
  }

  Future<void> _updateSubCategory(String field, dynamic newValue,
      {String? categoryField, dynamic categoryValue}) async {
    await subcat.updateSubCategory(field, newValue,
        categoryField: categoryField, categoryValue: categoryValue);
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

  @override
  DataRow? getRow(int index) {
    if (index >= subData.length) return null; // Check index bounds

    // Storing each index of subData list in data variable to iterate over each list
    final data = subData[index];
    final categoryName = categoryData[data['category_id']] ?? 'Deleted';

    return DataRow(cells: [
      DataCell(Text(categoryName)),
      DataCell(Text(data['sub_category_id'].toString())),
      DataCell(
        SizedBox(
          width: 35,
          child: Image.network(data['sub_category_img'] ?? ''),
        ),
      ),
      DataCell(Text(data['sub_category_name'] ?? '')),
      DataCell(DropdownButton<int>(
        value: data['status'], // Use the status value from data
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
            child: Text(status == 0
                ? 'Inactive'
                : 'Active'), // Display 'Active' or 'Inactive'
          );
        }).toList(),
      )),
      DataCell(
        IconButton(
          icon: const Icon(Icons.delete),
          onPressed: () {
            _deleteSubCategory(data['sub_category_id']);
          },
        ),
      ),
      DataCell(
        IconButton(
          icon: const Icon(Icons.edit),
          onPressed: () async {
            // Navigator.push(
            //   context,
            //   MaterialPageRoute(
            //     builder: (context) => UpdateSubCategory(data: data),
            //   ),
            // );

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
  int get rowCount => subData.length;

  @override
  int get selectedRowCount => 0;
}
