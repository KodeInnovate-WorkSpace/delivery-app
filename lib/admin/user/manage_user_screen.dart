import 'package:flutter/material.dart';
import '../admin_model.dart';

class ManageUserScreen extends StatefulWidget {
  const ManageUserScreen({super.key});

  @override
  State<ManageUserScreen> createState() => _ManageUserScreenState();
}

class _ManageUserScreenState extends State<ManageUserScreen> {
  late TableData src;
  final TextEditingController _searchController = TextEditingController();

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
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _refreshPage() async {
    await src._loadData();
  }

  void _searchUser(String phone) {
    src.searchUserByPhone(phone);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Manage Users',
          style: TextStyle(color: Color(0xffb3b3b3)),
        ),
        elevation: 0,
        backgroundColor: const Color(0xff1a1a1c),
        surfaceTintColor: Colors.transparent,
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: const Icon(
            Icons.keyboard_backspace,
            color: Color(0xffb3b3b3),
          ),
        ),
      ),
      backgroundColor: const Color(0xff1a1a1c),
      body: Stack(
        children: [
          RefreshIndicator(
            onRefresh: _refreshPage,
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextField(
                    controller: _searchController,
                    decoration: InputDecoration(
                      labelText: 'Search by phone number',
                      border: const OutlineInputBorder(),
                      suffixIcon: IconButton(
                        icon: const Icon(Icons.clear),
                        onPressed: () {
                          _searchController.clear();
                          _searchUser('');
                        },
                      ),
                    ),
                    style: const TextStyle(color:Colors.white),
                    keyboardType: TextInputType.number,
                    onChanged: _searchUser,
                  ),
                ),
                Expanded(
                  child: ListView(
                    children: [
                      PaginatedDataTable(
                        dataRowHeight: 100,
                        showEmptyRows: false,
                        columns: const [
                          DataColumn(label: Text('No.')),
                          DataColumn(label: Text('ID')),
                          DataColumn(label: Text('Name')),
                          DataColumn(label: Text('Phone')),
                          DataColumn(label: Text('Date \n (DD-MM-YYYY)')),
                          DataColumn(label: Text('Status')),
                          DataColumn(label: Text('Type')),
                          DataColumn(label: Text('')),
                        ],
                        source: src,
                        columnSpacing: 15,
                        rowsPerPage: 5,
                        showFirstLastButtons: true,
                        arrowHeadColor: const Color(0xff1a1a1c),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class TableData extends DataTableSource {
  UserModel userModel = UserModel();

  List<int> statusOptions = [0, 1]; // 0 for active, 1 for inactive
  List<int> typeOptions = [0, 1, 2]; // Different user types

  List<Map<String, dynamic>> userData = [];
  List<Map<String, dynamic>> filteredData = [];

  TableData() {
    _loadData();
  }

  Future<void> _loadData() async {
    userData = await userModel.manageUsers();
    filteredData = userData;
    notifyListeners();
  }

  void searchUserByPhone(String phone) {
    if (phone.isEmpty) {
      filteredData = userData;
    } else {
      filteredData = userData.where((user) => user['phone'].contains(phone)).toList();
    }
    notifyListeners();
  }

  Future<void> _updateUser(String field, dynamic newValue, {String? userField, dynamic userFieldValue}) async {
    await userModel.updateUser(field, newValue, userField: userField, fieldValue: userFieldValue);
    _loadData(); // Reload data after update
  }

  Future<void> _deleteUser(dynamic userFieldValue) async {
    await userModel.deleteUser(userFieldValue);
    _loadData(); // Reload data after deletion
  }

  @override
  DataRow? getRow(int index) {
    if (index >= filteredData.length) return null; // Check index bounds

    final data = filteredData[index];

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
      DataCell(DropdownButton<int>(
        value: data['status'],
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
            child: Text(status == 0 ? 'Inactive' : 'Active'),
          );
        }).toList(),
      )),
      DataCell(DropdownButton<int>(
        value: data['type'],
        onChanged: (int? newValue) {
          _updateUser(
            'type',
            newValue,
            userField: 'id',
            userFieldValue: data['id'],
          );
        },
        items: typeOptions.map<DropdownMenuItem<int>>((int type) {
          return DropdownMenuItem<int>(
            value: type,
            child: Text(type.toString()),
          );
        }).toList(),
      )),
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
  int get rowCount => filteredData.length;

  @override
  int get selectedRowCount => 0;
}