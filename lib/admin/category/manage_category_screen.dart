import 'package:flutter/material.dart';
import '../admin_model.dart';
import 'edit_category.dart';

class ManageCategoryScreen extends StatefulWidget {
  const ManageCategoryScreen({super.key});

  @override
  State<ManageCategoryScreen> createState() => _ManageCategoryScreenState();
}

class _ManageCategoryScreenState extends State<ManageCategoryScreen> {
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

  Future<void> _refreshCategoryList() async {
    await src._loadCatData();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Manage Category'),
      ),
      body: Stack(
        children: [
          RefreshIndicator(
            onRefresh: _refreshCategoryList,
            child: ListView(
              children: [
                PaginatedDataTable(
                  columns: const [
                    DataColumn(label: Text('ID')),
                    DataColumn(label: Text('Category')),
                    DataColumn(label: Text('Status')),
                    DataColumn(label: Text('')),
                  ],
                  source: src,
                  columnSpacing: 20,
                  rowsPerPage: 5,
                ),
              ],
            ),
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
                    builder: (context) => const EditCategory(),
                  ),
                );

                if (result != null && result as bool) {
                  _refreshCategoryList();
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
  CatModel category = CatModel();
  List<Map<String, dynamic>> catData = [];
  List<int> statusOptions = [0, 1]; // 0 for inactive, 1 for active

  TableData() {
    _loadCatData();
  }

  Future<void> _loadCatData() async {
    catData = await category.manageCategories();
    notifyListeners(); // Notify the listeners that data has changed
  }

  Future<void> _updateSubCategory(String field, dynamic newValue,
      {String? categoryField, dynamic categoryValue}) async {
    await category.updateCategory(field, newValue,
        categoryField: categoryField, categoryValue: categoryValue);
    _loadCatData(); // Reload data after update
  }

  Future<void> _deleteCategory(dynamic categoryValue) async {
    await category.deleteCategory(categoryValue);
    _loadCatData(); // Reload data after deletion
  }

  @override
  DataRow? getRow(int index) {
    if (index >= catData.length) return null; // Check index bounds
    final data = catData[index];
    return DataRow(cells: [
      DataCell(Text(data['category_id'].toString())),
      DataCell(
        TextFormField(
          initialValue: data['category_name'],
          onFieldSubmitted: (newValue) {
            _updateSubCategory(
              'category_name',
              newValue,
              categoryField: 'category_id',
              categoryValue: data['category_id'],
            );
          },
        ),
      ),
      DataCell(DropdownButton<int>(
        value: data['status'], // Use the status value from data
        onChanged: (int? newValue) {
          _updateSubCategory(
            'status',
            newValue,
            categoryField: 'category_id',
            categoryValue: data['category_id'],
          );
        },
        items: statusOptions.map<DropdownMenuItem<int>>((int status) {
          return DropdownMenuItem<int>(
            value: status,
            child: Text(status == 0 ? 'Inactive' : 'Active'),
          );
        }).toList(),
      )),
      DataCell(
        IconButton(
          icon: const Icon(Icons.delete),
          onPressed: () {
            _deleteCategory(data['category_id']);
          },
        ),
      ),
    ]);
  }

  @override
  bool get isRowCountApproximate => false;

  @override
  int get rowCount => catData.length;

  @override
  int get selectedRowCount => 0;
}
