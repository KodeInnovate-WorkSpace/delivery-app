import 'package:flutter/material.dart';

import 'admin_model.dart';

class ManageProductScreen extends StatelessWidget {
  const ManageProductScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final DataTableSource src = TableData();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Manage Products'),
      ),
      body: PaginatedDataTable(
        columns: const [
          DataColumn(label: Text('Id')),
          DataColumn(label: Text('Sub-Cat Id')),
          DataColumn(label: Text('Name')),
          DataColumn(label: Text('Price')),
        ],
        source: src,
        columnSpacing: 20,
        rowsPerPage: 5,
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
    subData = await admin.manageProducts();
    notifyListeners(); // Notify the listeners that data has changed
  }

  @override
  DataRow? getRow(int index) {
    if (index >= subData.length) return null; // Check index bounds
    final data = subData[index];
    return DataRow(cells: [
      DataCell(Text(data['id'].toString())),
      DataCell(Text(data['sub_category_id'].toString())),
      DataCell(Text(data['name'] ?? 'N/A')),
      DataCell(Text("Rs. ${data['price'] ?? 'N/A'}")),
    ]);
  }

  @override
  bool get isRowCountApproximate => false;

  @override
  int get rowCount => subData.length;

  @override
  int get selectedRowCount => 0;
}
