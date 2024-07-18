//updated_order_screen
import 'package:flutter/material.dart';
import '../order_details.dart';
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
        title: const Text('Manage Orders'),
      ),
      body: Stack(
        children: [
          RefreshIndicator(
            onRefresh: _refreshPage,
            child: src.isLoading
                ? const Center(child: CircularProgressIndicator())
                : Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    'Total Orders: ${src.rowCount}',
                    style: const TextStyle(
                        fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                ),
                Expanded(
                  child: ListView.builder(
                    itemCount: src.orderData.length,
                    itemBuilder: (context, index) {
                      final data = src.orderData[index];
                      return GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => OrderDetailsScreen(orderId: data['orderId']),
                            ),
                          );
                        },
                        child: OrderDataRow(
                          data: data,
                          valetData: src.valetData,
                          statusMessages: src.statusMessages,
                          statusOptions: src.statusOptions,
                          valetObj: src.valetObj,
                          refreshCallback: _refreshPage,
                        ),
                      );
                    },
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

class OrderDataRow extends StatelessWidget {
  final Map<String, dynamic> data;
  final List<Map<String, dynamic>> valetData;
  final Map<int, String> statusMessages;
  final List<int> statusOptions;
  final ValetModel valetObj;
  final Future<void> Function() refreshCallback;

  const OrderDataRow({
    required this.data,
    required this.valetData,
    required this.statusMessages,
    required this.statusOptions,
    required this.valetObj,
    required this.refreshCallback,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.all(8.0),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Order ID: ${data['orderId']}'),
            Text('Cust Phone: ${data['phone']}'),
            Text('Date: ${data['timestamp']}'),
            Text('Address: ${data['address']}'),
            DropdownButton<String>(
              value: data['valetPhone'],
              onChanged: (String? newValue) async {
                await valetObj.assignValet(data['orderId'].toString(), newValue!);
                await refreshCallback();
              },
              items: valetData.map<DropdownMenuItem<String>>((valet) {
                return DropdownMenuItem<String>(
                  value: valet['phone'],
                  child: Text(valet['name']),
                );
              }).toList(),
            ),
            DropdownButton<int>(
              value: data['status'],
              onChanged: (int? newValue) async {
                await valetObj.updateStatus(data['orderId'].toString(), newValue!);
                await refreshCallback(); // Reload data after updating
              },
              items: statusOptions.map<DropdownMenuItem<int>>((status) {
                return DropdownMenuItem<int>(
                  value: status,
                  child: Text(statusMessages[status] ?? 'Unknown'),
                );
              }).toList(),
            ),
          ],
        ),
      ),
    );
  }
}

class TableData extends ChangeNotifier {
  ValetModel valetObj = ValetModel();

  List<int> statusOptions = [0, 1, 2, 3, 4, 5, 6];
  Map<int, String> statusMessages = {
    0: 'Received',
    1: 'Confirmed',
    2: 'In Process',
    3: 'Picked Up',
    4: 'Delivered',
    5: 'Failed',
    6: 'Cancelled',
  };

  List<Map<String, dynamic>> orderData = [];
  List<Map<String, dynamic>> valetData = [];
  bool isLoading = true;

  TableData() {
    _loadData();
  }

  Future<void> _loadData() async {
    isLoading = true; // Set loading state
    notifyListeners();
    orderData = await valetObj.manageOrder();
    valetData = await valetObj.manageValet();
    isLoading = false; // Data loaded
    notifyListeners();
  }

  int get rowCount => orderData.length; // Total number of orders
}