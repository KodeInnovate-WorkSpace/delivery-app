import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:speedy_delivery/admin/banner/update_banner.dart';
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
        title: const Text(
          'Manage Banner',
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
            onRefresh: src._refreshBannerList,
            child: ListView(
              children: [
                PaginatedDataTable(
                  columns: const [
                    DataColumn(label: Text('Image')),
                    DataColumn(label: Text('Status')),
                    DataColumn(label: Text('Priority')),
                    DataColumn(label: Text('Update')),
                    DataColumn(label: Text('Delete')),
                  ],
                  source: src,
                  columnSpacing: 20,
                  rowsPerPage: 8,
                  showFirstLastButtons: true,
                  arrowHeadColor: const Color(0xff1a1a1c),
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

  BannerModel banner = BannerModel();
  List<Map<String, dynamic>> bannerData = [];
  List<int> statusOptions = [0, 1]; // 0 for inactive, 1 for active

  TableData(this.context) {
    __loadBannerData();
  }

  Future<void> __loadBannerData() async {
    bannerData = await banner.manageBanner();
    // Sort categories by priority (ascending)
    bannerData.sort((a, b) => (a['priority'] as int).compareTo(b['priority'] as int));
    notifyListeners(); // Notify the listeners that data has changed
  }

  Future<void> _deleteBanner(dynamic bannerValue) async {
    await banner.deleteBanner(bannerValue);
    __loadBannerData(); // Reload data after deletion
  }

  Future<void> _refreshBannerList() async {
    await __loadBannerData();
    notifyListeners();
  }

  @override
  DataRow? getRow(int index) {
    if (index >= bannerData.length) return null; // Check index bounds
    final data = bannerData[index];
    return DataRow(cells: [
      // DataCell(Text(data['image'].toString())),

      //Image
      DataCell(
        SizedBox(
          width: 35,
          child: CachedNetworkImage(
            imageUrl: data['image'] ?? 'No Image',
          ),
        ),
      ),

      //Status
      DataCell(
        DropdownButton<int>(
          value: data['status'], // Use the status value from data
          onChanged: (int? newValue) {
            banner
                .updateBanner(
                  'status',
                  newValue,
                  bannerField: 'image',
                  bannerValue: data['image'],
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

      //Priority
      DataCell(Text(data['priority'].toString())),

      //Edit
      DataCell(
        IconButton(
          icon: const Icon(Icons.edit),
          onPressed: () async {
            final result = await Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => UpdateBanner(data: data),
              ),
            );

            // Check if result is true (indicating update)
            if (result != null && result as bool) {
              _refreshBannerList(); // Call refresh function here
            }
          },
        ),
      ),

      //Delete
      DataCell(
        IconButton(
          icon: const Icon(Icons.delete),
          onPressed: () {
            _deleteBanner(data['id']);
          },
        ),
      ),
    ]);
  }

  @override
  bool get isRowCountApproximate => false;

  @override
  int get rowCount => bannerData.length;

  @override
  int get selectedRowCount => 0;
}
