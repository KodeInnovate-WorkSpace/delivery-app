import 'package:flutter/material.dart';
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
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('Manage Sub-Categories'),
      ),
      body: Stack(
        children: [
          PaginatedDataTable(
            columns: const [
              DataColumn(label: Text('Category')),
              DataColumn(label: Text('Sub-Cat Id')),
              DataColumn(label: Text('Image')),
              DataColumn(label: Text('Name')),
              DataColumn(label: Text('Status')),
              DataColumn(label: Text('')),
            ],
            source: src,
            columnSpacing: 15,
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
                        builder: (context) => const EditSubCategory()));
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
  SubCatModel subcat = SubCatModel();
  CatModel category = CatModel();
  List<int> statusOptions = [0, 1]; // 0 for active, 1 for inactive

  // storing sub-category data in a list
  List<Map<String, dynamic>> subData = [];
  Map<int, String> categoryData ={}; // map to store category_id to category_name

  TableData() {
    _loadSubData();
  }

  Future<void> _loadSubData() async {
    // getting data from manageSubCategories() which is in subcat class
    _loadCategoryData();
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

  // function to update the values of sub-category name
  // () takes name of field, New value to replace the old one, category field and category value
  Future<void> _updateSubCategory(String field, dynamic newValue,
      {String? categoryField, dynamic categoryValue}) async {
    await subcat.updateSubCategory(field, newValue,
        categoryField: categoryField, categoryValue: categoryValue);
    _loadSubData(); // Reload data after update
  }

  // Delete a row of data from firebase
  Future<void> _deleteSubCategory(dynamic categoryValue) async {
    await subcat.deleteSubCategory(categoryValue);
    _loadSubData(); // Reload data after deletion
  }

  @override
  DataRow? getRow(int index) {
    if (index >= subData.length) return null; // Check index bounds

    // storing each index of subData list in data variable to iterate over each list
    final data = subData[index];
    final categoryName = categoryData[data['category_id']] ?? 'Unknown';

    return DataRow(cells: [
      // DataCell(Text(data['category_id'].toString())),
      DataCell(Text(categoryName)),
      DataCell(Text(data['sub_category_id'].toString())),
      DataCell(
        SizedBox(
          width: 35,
          child: Image.network(data['sub_category_img']),
        ),
      ),
      DataCell(
        TextFormField(
          initialValue: data['sub_category_name'],
          onFieldSubmitted: (newValue) {
            _updateSubCategory(
              'sub_category_name',
              newValue,
              categoryField: 'sub_category_id',
              categoryValue: data['sub_category_id'],
            );
          },
        ),
      ),

      // status column
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

      // delete column
      DataCell(
        IconButton(
          icon: const Icon(Icons.delete),
          onPressed: () {
            _deleteSubCategory(data['sub_category_id']);
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
