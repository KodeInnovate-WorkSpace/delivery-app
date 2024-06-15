import 'package:flutter/material.dart';
import '../admin_model.dart';

class ManageUserScreen extends StatefulWidget {
  const ManageUserScreen({super.key});

  @override
  State<ManageUserScreen> createState() => _ManageUserScreenState();
}

class _ManageUserScreenState extends State<ManageUserScreen> {
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

  Future<void> _refreshPage() async {
    await src._loadData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('Manage Users'),
      ),
      body: Stack(
        children: [
          RefreshIndicator(
            onRefresh: _refreshPage,
            child: ListView(children: [
              PaginatedDataTable(
                dataRowHeight: 65,
                showEmptyRows: false,
                columns: const [
                  DataColumn(label: Text('No.')),
                  DataColumn(label: Text('ID')),
                  DataColumn(label: Text('Name')),
                  DataColumn(label: Text('Phone')),
                  DataColumn(label: Text('Date \n (DD-MM-YYYY)')),
                  DataColumn(label: Text('Status')),
                  DataColumn(label: Text('')),
                ],
                source: src,
                columnSpacing: 15,
                rowsPerPage: 5,
              ),
            ]),
          ),
        ],
      ),
    );
  }
}

class TableData extends DataTableSource {
  UserModel userModel = UserModel();

  List<int> statusOptions = [0, 1]; // 0 for active, 1 for inactive

  List<Map<String, dynamic>> userData = [];
  TableData() {
    _loadData();
  }

  Future<void> _loadData() async {
    // getting data from manageSubCategories() which is in userModel class
    _loadUserData();
    userData = await userModel.manageUsers();
    notifyListeners(); // Notify the listeners that data has changed
  }

  Future<void> _loadUserData() async {
    final user = await userModel.manageUsers();
    notifyListeners();
  }

  // function to update the values of sub-category name
  // () takes name of field, New value to replace the old one, category field and category value
  Future<void> _updateUser(String field, dynamic newValue,
      {String? userField, dynamic userFieldValue}) async {
    await userModel.updateUser(field, newValue,
        userField: userField, fieldValue: userFieldValue);
    _loadData(); // Reload data after update
  }

  // Delete a row of data from firebase
  Future<void> _deleteUser(dynamic userFieldValue) async {
    await userModel.deleteUser(userFieldValue);
    _loadData(); // Reload data after deletion
  }

  @override
  DataRow? getRow(int index) {
    if (index >= userData.length) return null; // Check index bounds

    // storing each index of userData list in data variable to iterate over each list
    final data = userData[index];

    return DataRow(cells: [
      DataCell(Text((index + 1).toString())),
      DataCell(SizedBox(
        width: 100,
        child: Text(
          data['id'].toString(),
          softWrap: true,
          overflow: TextOverflow.visible,
        ),
      )),
      DataCell(Text(data['name'].toString())),
      DataCell(Text(data['phone'].toString())),
      DataCell(Text(data['date'].toString())),
      // status column
      DataCell(DropdownButton<int>(
        value: data['status'], // Use the status value from data
        onChanged: (int? newValue) {
          _updateUser(
            'status',
            newValue,
            userField: 'id',
            userFieldValue: data['id'],
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
            _deleteUser(data['id']);
          },
        ),
      ),
    ]);
  }

  @override
  bool get isRowCountApproximate => false;

  @override
  int get rowCount => userData.length;

  @override
  int get selectedRowCount => 0;
}
