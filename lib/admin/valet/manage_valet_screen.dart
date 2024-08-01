import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../admin_model.dart';
import '../order_details.dart';

class ManageValetScreen extends StatefulWidget {
  const ManageValetScreen({super.key});

  @override
  State<ManageValetScreen> createState() => _ManageValetScreenState();
}

class _ManageValetScreenState extends State<ManageValetScreen> {
  late TableData src;

  String? selectedValet;
  String? selectedPaymentMethod;
  int? selectedStatus;
  DateTime? selectedDate;

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

  void _filterData() {
    setState(() {
      // No need to do anything here, as we're using the selected filters in the build method
    });
  }

  void _resetFilters() {
    setState(() {
      selectedValet = null;
      selectedPaymentMethod = null;
      selectedStatus = null;
      selectedDate = null;
      _filterData();
    });
  }

  @override
  Widget build(BuildContext context) {
    List<Map<String, dynamic>> filteredData = src.orderData.where((order) {
      if (selectedValet != null && order['valetPhone'] != selectedValet) {
        return false;
      }
      if (selectedPaymentMethod != null && selectedPaymentMethod != 'Both' && order['paymentMode'] != selectedPaymentMethod) {
        return false;
      }
      if (selectedStatus != null && order['status'] != selectedStatus) {
        return false;
      }
      if (selectedDate != null) {
        DateTime orderDate = DateTime.parse(order['timestamp']);
        if (orderDate.year != selectedDate!.year ||
            orderDate.month != selectedDate!.month ||
            orderDate.day != selectedDate!.day) {
          return false;
        }
      }
      return true;
    }).toList();

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
                    'Total Orders: ${filteredData.length}',
                    style: const TextStyle(
                        fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                ),
                _buildFilters(),
                Expanded(
                  child: ListView.builder(
                    itemCount: filteredData.length,
                    itemBuilder: (context, index) {
                      final data = filteredData[index];
                      return GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                                  OrderDetailsScreen(orderId: data['orderId']),
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

  Widget _buildFilters() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                child: DropdownButton<String>(
                  hint: const Text('Select Valet'),
                  value: selectedValet,
                  onChanged: (String? newValue) {
                    setState(() {
                      selectedValet = newValue;
                      _filterData();
                    });
                  },
                  items: src.valetData.map<DropdownMenuItem<String>>((valet) {
                    return DropdownMenuItem<String>(
                      value: valet['phone'],
                      child: Text(valet['name']),
                    );
                  }).toList(),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8.0),
          Row(
            children: [
              Expanded(
                child: DropdownButton<String>(
                  hint: const Text('Payment Method'),
                  value: selectedPaymentMethod,
                  onChanged: (String? newValue) {
                    setState(() {
                      selectedPaymentMethod = newValue;
                      _filterData();
                    });
                  },
                  items: <String>['Both', 'Online', 'Cash on delivery']
                      .map<DropdownMenuItem<String>>((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value),
                    );
                  }).toList(),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8.0),
          Row(
            children: [
              Expanded(
                child: DropdownButton<int>(
                  hint: const Text('Select Status'),
                  value: selectedStatus,
                  onChanged: (int? newValue) {
                    setState(() {
                      selectedStatus = newValue;
                      _filterData();
                    });
                  },
                  items: src.statusOptions.map<DropdownMenuItem<int>>((int value) {
                    return DropdownMenuItem<int>(
                      value: value,
                      child: Text(src.statusMessages[value] ?? 'Unknown'),
                    );
                  }).toList(),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8.0),
          Row(
            children: [
              Expanded(
                child: GestureDetector(
                  onTap: () async {
                    DateTime? picked = await showDatePicker(
                      context: context,
                      initialDate: DateTime.now(),
                      firstDate: DateTime(2000),
                      lastDate: DateTime(2101),
                    );
                    if (picked != null) {
                      setState(() {
                        selectedDate = picked;
                        _filterData();
                      });
                    }
                  },
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey),
                      borderRadius: BorderRadius.circular(5.0),
                    ),
                    child: Text(
                      selectedDate == null
                          ? 'Select Date'
                          : DateFormat('dd MMM yyyy').format(selectedDate!),
                    ),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8.0),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              ElevatedButton(
                onPressed: _resetFilters,
                child: const Text('Reset Filters'),
              ),
            ],
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
    super.key,
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
            Text('Date: ${_formatTimestamp(data['timestamp'])}'),
            Text('Address: ${data['address']}'),
            Text('Payment Mode: ${data['paymentMode']}'),
            Text('Overall Total:${data['overallTotal']}'),
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

  String _formatTimestamp(String timestamp) {
    DateTime dateTime = DateTime.parse(timestamp);
    return DateFormat('dd MMM yyyy, hh:mm a').format(dateTime);
  }
}

class TableData extends ChangeNotifier {
  ValetModel valetObj = ValetModel();

  List<int> statusOptions = [0, 1, 2, 3, 4, 5, 6, 7, 8];
  Map<int, String> statusMessages = {
    0: 'Received',
    1: 'Confirmed',
    2: 'In Process',
    3: 'Picked Up',
    4: 'Delivered',
    5: 'Failed',
    6: 'Cancelled',
    7: 'New order in process',
    8: 'Order Generated',
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
    orderData = await _fetchOrders();
    valetData = await valetObj.manageValet();
    isLoading = false; // Data loaded
    notifyListeners();
  }

  Future<List<Map<String, dynamic>>> _fetchOrders() async {
    QuerySnapshot querySnapshot = await FirebaseFirestore.instance
        .collection('OrderHistory')
        .orderBy('timestamp', descending: true)
        .get();

    return querySnapshot.docs.map((doc) {
      Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
      data['orderId'] = doc.id;
      return data;
    }).toList();
  }

  int get rowCount => orderData.length; // Total number of orders
}
