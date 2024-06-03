import 'package:flutter/material.dart';
import 'package:speedy_delivery/admin/subcategory/edit_sub_category.dart';
import '../admin_model.dart';

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
              DataColumn(label: Text('Cat Id')),
              DataColumn(label: Text('Sub-Cat Id')),
              DataColumn(label: Text('Image')),
              DataColumn(label: Text('Name')),
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
  Admin admin = Admin();
  List<Map<String, dynamic>> subData = [];

  TableData() {
    _loadSubData();
  }

  Future<void> _loadSubData() async {
    subData = await admin.manageSubCategories();
    notifyListeners(); // Notify the listeners that data has changed
  }

  Future<void> _updateSubCategory(String field, dynamic newValue,
      {String? categoryField, dynamic categoryValue}) async {
    await admin.updateSubCategory(field, newValue,
        categoryField: categoryField, categoryValue: categoryValue);
    _loadSubData(); // Reload data after update
  }

  @override
  DataRow? getRow(int index) {
    if (index >= subData.length) return null; // Check index bounds
    final data = subData[index];
    return DataRow(cells: [
      DataCell(Text(data['category_id'].toString())),
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
    ]);
  }

  @override
  bool get isRowCountApproximate => false;

  @override
  int get rowCount => subData.length;

  @override
  int get selectedRowCount => 0;
}
