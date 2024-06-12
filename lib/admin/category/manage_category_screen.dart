// manage_category_screen.dart
import 'package:flutter/material.dart';
import 'package:speedy_delivery/admin/category/edit_category.dart';
import 'package:speedy_delivery/admin/category/update_category.dart';

import '../admin_model.dart';

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




  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Manage Category'),
      ),
      body: Stack(
        children: [
          RefreshIndicator(
            onRefresh: src._refreshCategoryList,
            child: ListView(
              children: [
                PaginatedDataTable(
                  columns: const [
                    DataColumn(label: Text('ID')),
                    DataColumn(label: Text('Category')),
                    DataColumn(label: Text('Status')),
                    DataColumn(label: Text('')),
                    DataColumn(label: Text('')),
                  ],
                  source: src,
                  columnSpacing: 20,
                  rowsPerPage: 8,
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
                  src._refreshCategoryList();
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

  CatModel category = CatModel();
  List<Map<String, dynamic>> catData = [];
  List<int> statusOptions = [0, 1]; // 0 for inactive, 1 for active

  TableData(this.context) {
    _loadCatData();
  }

  Future<void> _loadCatData() async {
    catData = await category.manageCategories();
    notifyListeners(); // Notify the listeners that data has changed
  }
  Future<void> _refreshCategoryList() async {
    await _loadCatData();
    notifyListeners();
  }
  @override
  DataRow? getRow(int index) {
    if (index >= catData.length) return null; // Check index bounds
    final data = catData[index];
    return DataRow(cells: [
      DataCell(Text(data['category_id'].toString())),
      DataCell(Text(data['category_name'].toString())),

      DataCell(
        DropdownButton<int>(
          value: data['status'], // Use the status value from data
          onChanged: (int? newValue) {
            category.updateCategory(
              'status',
              newValue,
              categoryField: 'category_id',
              categoryValue: data['category_id'],
            ).then((_) => _loadCatData());
          },
          items: statusOptions.map<DropdownMenuItem<int>>((int status) {
            return DropdownMenuItem<int>(
              value: status,
              child: Text(status == 0 ? 'Inactive' : 'Active'),
            );
          }).toList(),
        ),
      ),
      DataCell(
        IconButton(
          icon: const Icon(Icons.delete),
          onPressed: () {
            category.deleteCategory(data['category_id']).then((_) => _loadCatData());
          },
        ),
      ),
      DataCell(
        IconButton(
          icon: const Icon(Icons.edit),
          onPressed: () async{
            final result = await Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) =>  UpdateCategory(data: data),
              ),
            );

            // Check if result is true (indicating update)
            if (result != null && result as bool) {
              _refreshCategoryList(); // Call refresh function here
            }

            // Navigator.push(context,
            //     MaterialPageRoute(builder: (context) =>  UpdateCategory(data: data)));

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
