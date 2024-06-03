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

  @override
  Widget build(BuildContext context) {
    final DataTableSource src = TableData();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Manage Category'),
      ),
      body: Stack(
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
          Positioned(
            bottom: 25,
            right: 20,
            child: FloatingActionButton(
              hoverColor: Colors.transparent,
              elevation: 2,
              onPressed: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const EditCategory()));
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

  TableData() {
    _loadSubData();
  }

  Future<void> _loadSubData() async {
    catData = await category.manageCategories();
    notifyListeners(); // Notify the listeners that data has changed
  }

  // function to update the values of sub-category name
  // () takes name of field, New value to replace the old one, category field and category value
  Future<void> _updateSubCategory(String field, dynamic newValue,
      {String? categoryField, dynamic categoryValue}) async {
    await category.updateCategory(field, newValue,
        categoryField: categoryField, categoryValue: categoryValue);
    _loadSubData(); // Reload data after update
  }

  // Delete a row of data from firebase
  Future<void> _deleteCategory(dynamic categoryValue) async {
    await category.deleteCategory(categoryValue);
    _loadSubData(); // Reload data after deletion
  }

  @override
  DataRow? getRow(int index) {
    if (index >= catData.length) return null; // Check index bounds
    final data = catData[index];
    return DataRow(cells: [
      // id column
      DataCell(Text(data['category_id'].toString())),
      // category name column

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

      // DataCell(Text(data['category_name'] ?? 'N/A')),
      // status column
      DataCell(Text(data['status'].toString())),

      // delete column
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
