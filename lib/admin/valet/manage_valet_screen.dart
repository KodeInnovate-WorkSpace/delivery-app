import 'package:flutter/material.dart';
import '../admin_model.dart';

class ManageValetScreen extends StatefulWidget {
  const ManageValetScreen({super.key});

  @override
  State<ManageValetScreen> createState() => _ManageValetScreenState();
}

class _ManageValetScreenState extends State<ManageValetScreen> {
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
        title: const Text('Assign Valet'),
      ),
      body: Stack(
        children: [
          RefreshIndicator(
            onRefresh: _refreshPage,
            child: ListView(children: [
              PaginatedDataTable(
                dataRowHeight: 100,
                showEmptyRows: false,
                columns: const [
                  DataColumn(label: Text('Order ID')),
                  DataColumn(label: Text('Cust Phone')),
                  DataColumn(label: Text('Date')),
                  DataColumn(label: Text('Address')),
                  DataColumn(label: Text('Assign')),
                  DataColumn(label: Text('Status')), // New Status column
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
  ValetModel valetObj = ValetModel();

  List<int> statusOptions = [0, 1, 2, 3, 4, 5, 6];

  List<Map<String, dynamic>> orderData = [];
  List<Map<String, dynamic>> valetData = [];

  TableData() {
    _loadData();
  }

  Future<void> _loadData() async {
    orderData = await valetObj.manageOrder();
    valetData = await valetObj.manageValet();
    notifyListeners();
  }

  @override
  DataRow? getRow(int index) {
    if (index >= orderData.length) return null; // Check index bounds
    final data = orderData[index];

    return DataRow(cells: [
      DataCell(SizedBox(
        width: 100,
        child: Text(
          data['orderId'].toString(),
          softWrap: true,
          overflow: TextOverflow.visible,
        ),
      )),
      DataCell(Text(data['phone'].toString())),
      DataCell(SizedBox(
        width: 100,
        child: Text(
          data['timestamp'],
          softWrap: true,
          overflow: TextOverflow.visible,
        ),
      )),
      DataCell(SizedBox(
        width: 100,
        child: Text(
          data['address'].toString(),
          softWrap: true,
          overflow: TextOverflow.visible,
        ),
      )),

      //Phone Number
      DataCell(DropdownButton<String>(
        value: data['user'],
        onChanged: (String? newValue) async {
          await valetObj.assignValet(data['orderId'].toString(), newValue!);
          await _loadData();
        },
        items: valetData.map<DropdownMenuItem<String>>((valet) {
          return DropdownMenuItem<String>(
            value: valet['phone'],
            child: Text(valet['phone'].toString()),
          );
        }).toList(),
      )),

      //Status
      DataCell(DropdownButton<int>(
        value: data['status'],
        onChanged: (int? newValue) async {
          await valetObj.updateStatus(data['orderId'].toString(), newValue!);
          await _loadData(); // Reload data after updating
        },
        items: statusOptions.map<DropdownMenuItem<int>>((status) {
          return DropdownMenuItem<int>(
            value: status,
            child: Text(status.toString()), // Display status
          );
        }).toList(),
      )),
    ]);
  }

  @override
  bool get isRowCountApproximate => false;

  @override
  int get rowCount => orderData.length;

  @override
  int get selectedRowCount => 0;
}