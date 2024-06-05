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

  // void _refreshUserList() async {
  //   // Clear existing data
  //   src.userData.clear();
  //
  //   // Reload data from the server (or local storage)
  //   await src._loaduserData();
  //
  //   // Notify listeners about the change (important!)
  //   setState(() {});
  // }

  Future<void> _refreshPage() async {
    await src._loaduserData();
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
                  DataColumn(label: Text('ID')),
                  DataColumn(label: Text('Name')),
                  DataColumn(label: Text('Phone')),
                  DataColumn(label: Text('Date')),
                  DataColumn(label: Text('Status')),
                  DataColumn(label: Text('')),
                ],
                source: src,
                columnSpacing: 15,
                rowsPerPage: 5,
              ),
            ]),
          ),
          // Positioned(
          //   bottom: 25,
          //   right: 20,
          //   child: FloatingActionButton(
          //     hoverColor: Colors.transparent,
          //     elevation: 2,
          //     onPressed: () async {
          //       final result = await Navigator.push(context,
          //           MaterialPageRoute(builder: (context) => const EditUser()));
          //
          //       if (result != null && result as bool) {
          //         // Sub-category added successfully, refresh the list
          //         _refreshUserList();
          //       }
          //     },
          //     backgroundColor: Colors.black,
          //     child: const Icon(
          //       Icons.add,
          //       color: Colors.white,
          //     ),
          //   ),
          // ),
        ],
      ),
    );
  }
}

class TableData extends DataTableSource {
  UserModel userModel = UserModel();
  CatModel category = CatModel();
  List<int> statusOptions = [0, 1]; // 0 for active, 1 for inactive

  // storing sub-category data in a list
  List<Map<String, dynamic>> userData = [];
  Map<int, String> categoryData =
      {}; // map to store category_id to category_name

  TableData() {
    _loaduserData();
  }

  Future<void> _loaduserData() async {
    // getting data from manageSubCategories() which is in userModel class
    _loadCategoryData();
    userData = await userModel.manageUsers();
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
    await userModel.updateUser(field, newValue,
        categoryField: categoryField, categoryValue: categoryValue);
    _loaduserData(); // Reload data after update
  }

  // Delete a row of data from firebase
  Future<void> _deleteSubCategory(dynamic categoryValue) async {
    await userModel.deleteUser(categoryValue);
    _loaduserData(); // Reload data after deletion
  }

  @override
  DataRow? getRow(int index) {
    if (index >= userData.length) return null; // Check index bounds

    // storing each index of userData list in data variable to iterate over each list
    final data = userData[index];
    // final categoryName = categoryData[data['category_id']] ?? 'Unknown';

    return DataRow(cells: [
      // DataCell(Text(data['category_id'].toString())),
      DataCell(Text(data['id'].toString())),
      DataCell(Text(data['name'].toString())),
      DataCell(Text(data['phone'].toString())),
      DataCell(Text(data['date'].toString())),
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
  int get rowCount => userData.length;

  @override
  int get selectedRowCount => 0;
}
