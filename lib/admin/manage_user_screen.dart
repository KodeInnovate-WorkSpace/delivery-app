import 'package:flutter/material.dart';

import 'admin_model.dart';

class ManageUserScreen extends StatelessWidget {
  const ManageUserScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final DataTableSource src = TableData();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Manage Users'),
      ),
      body: PaginatedDataTable(
        columns: const [
          DataColumn(label: Text('ID')),
          DataColumn(label: Text('Phone')),
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
    subData = await admin.manageUsers();
    notifyListeners(); // Notify the listeners that data has changed
  }

  @override
  DataRow? getRow(int index) {
    if (index >= subData.length) return null; // Check index bounds
    final data = subData[index];
    return DataRow(cells: [
      DataCell(Text(data['id'].toString())),
      DataCell(Text(data['phone'] ?? 'N/A')),
    ]);
  }

  @override
  bool get isRowCountApproximate => false;

  @override
  int get rowCount => subData.length;

  @override
  int get selectedRowCount => 0;
}