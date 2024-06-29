import 'package:flutter/material.dart';
import '../admin_model.dart';
import 'edit_banner.dart';

class ManageBannerScreen extends StatefulWidget {
  const ManageBannerScreen({super.key});

  @override
  State<ManageBannerScreen> createState() => _ManageBannerScreenState();
}

class _ManageBannerScreenState extends State<ManageBannerScreen> {
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
        title: const Text('Manage Banner'),
      ),
      body: Stack(
        children: [
          RefreshIndicator(
            onRefresh: src._refreshBannerList,
            child: ListView(
              children: [
                PaginatedDataTable(
                  columns: const [
                    DataColumn(label: Text('Image')),
                    DataColumn(label: Text('Status')),
                    DataColumn(label: Text('Priority')),
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
                    builder: (context) => const EditBanner(),
                  ),
                );

                if (result != null && result as bool) {
                  src._refreshBannerList();
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
    __loadBannerData();
  }

  Future<void> __loadBannerData() async {
    catData = await category.manageCategories();
    // Sort categories by priority (ascending)
    catData.sort((a, b) => (a['priority'] as int).compareTo(b['priority'] as int));
    notifyListeners(); // Notify the listeners that data has changed
  }

  Future<void> _refreshBannerList() async {
    await __loadBannerData();
    notifyListeners();
  }

  @override
  DataRow? getRow(int index) {
    if (index >= catData.length) return null; // Check index bounds
    final data = catData[index];
    return DataRow(cells: [
      DataCell(Text(data['image'].toString())),
      DataCell(
        DropdownButton<int>(
          value: data['status'], // Use the status value from data
          onChanged: (int? newValue) {
            category
                .updateCategory(
                  'status',
                  newValue,
                  categoryField: 'image',
                  categoryValue: data['image'],
                )
                .then((_) => __loadBannerData());
          },
          items: statusOptions.map<DropdownMenuItem<int>>((int status) {
            return DropdownMenuItem<int>(
              value: status,
              child: Text(status == 0 ? 'Inactive' : 'Active'),
            );
          }).toList(),
        ),
      ),
      DataCell(Text(data['priority'].toString())), // Display priority
    ]);
  }

  @override
  bool get isRowCountApproximate => false;

  @override
  int get rowCount => catData.length;

  @override
  int get selectedRowCount => 0;
}
