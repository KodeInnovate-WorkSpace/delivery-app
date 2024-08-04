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
    setState(() {});
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
        if (orderDate.year != selectedDate!.year || orderDate.month != selectedDate!.month || orderDate.day != selectedDate!.day) {
          return false;
        }
      }
      return true;
    }).toList();

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Manage Orders',
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
            child: src.isLoading
                ? const Center(
                    child: CircularProgressIndicator(
                    color: Colors.black,
                  ))
                : Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          'Total Orders: ${filteredData.length}',
                          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Color(0xffb3b3b3)),
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

  // Widget _buildFilters() {
  //   return Padding(
  //     padding: const EdgeInsets.all(8.0),
  //     child: Column(
  //       children: [
  //         //Select Valet
  //         Row(
  //           children: [
  //             Expanded(
  //               child: DropdownButton<String>(
  //                 hint: Text(
  //                   'Select Valet',
  //                   style: TextStyle(color: Color(0xffb3b3b3)),
  //                 ),
  //                 value: selectedValet,
  //                 onChanged: (String? newValue) {
  //                   setState(() {
  //                     selectedValet = newValue;
  //                     _filterData();
  //                   });
  //                 },
  //                 items: src.valetData.map<DropdownMenuItem<String>>((valet) {
  //                   return DropdownMenuItem<String>(
  //                     value: valet['phone'],
  //                     child: Text(
  //                       valet['name'],
  //                       style: const TextStyle(color: Color(0xffb3b3b3)),
  //                     ),
  //                   );
  //                 }).toList(),
  //               ),
  //             ),
  //           ],
  //         ),
  //         const SizedBox(height: 8.0),
  //         //Payment Method
  //         Row(
  //           children: [
  //             Expanded(
  //               child: DropdownButton<String>(
  //                 hint: Text(
  //                   'Payment Method',
  //                   style: TextStyle(color: Color(0xffb3b3b3)),
  //                 ),
  //                 value: selectedPaymentMethod,
  //                 onChanged: (String? newValue) {
  //                   setState(() {
  //                     selectedPaymentMethod = newValue;
  //                     _filterData();
  //                   });
  //                 },
  //                 items: <String>['Both', 'Online', 'Cash on delivery'].map<DropdownMenuItem<String>>((String value) {
  //                   return DropdownMenuItem<String>(
  //                     value: value,
  //                     child: Text(
  //                       value,
  //                       style: const TextStyle(color: Color(0xffb3b3b3)),
  //                     ),
  //                   );
  //                 }).toList(),
  //               ),
  //             ),
  //           ],
  //         ),
  //         const SizedBox(height: 8.0),
  //         // Order Status
  //         Row(
  //           children: [
  //             Expanded(
  //               child: DropdownButton<int>(
  //                 hint: Text(
  //                   'Select Status',
  //                   style: TextStyle(color: Color(0xffb3b3b3)),
  //                 ),
  //                 value: selectedStatus,
  //                 onChanged: (int? newValue) {
  //                   setState(() {
  //                     selectedStatus = newValue;
  //                     _filterData();
  //                   });
  //                 },
  //                 items: src.statusOptions.map<DropdownMenuItem<int>>((int value) {
  //                   return DropdownMenuItem<int>(
  //                     value: value,
  //                     child: Text(
  //                       src.statusMessages[value] ?? 'Unknown',
  //                       style: const TextStyle(color: Color(0xffb3b3b3)),
  //                     ),
  //                   );
  //                 }).toList(),
  //               ),
  //             ),
  //           ],
  //         ),
  //         const SizedBox(height: 8.0),
  //         //Date
  //         Row(
  //           children: [
  //             Expanded(
  //               child: GestureDetector(
  //                 onTap: () async {
  //                   DateTime? picked = await showDatePicker(
  //                     context: context,
  //                     initialDate: DateTime.now(),
  //                     firstDate: DateTime(2000),
  //                     lastDate: DateTime(2101),
  //                   );
  //                   if (picked != null) {
  //                     setState(() {
  //                       selectedDate = picked;
  //                       _filterData();
  //                     });
  //                   }
  //                 },
  //                 child: Container(
  //                   padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
  //                   decoration: BoxDecoration(
  //                     border: Border.all(color: Colors.grey),
  //                     borderRadius: BorderRadius.circular(5.0),
  //                   ),
  //                   child: Text(
  //                     selectedDate == null ? 'Select Date' : DateFormat('dd MMM yyyy').format(selectedDate!),
  //                     style: TextStyle(color: Color(0xffb3b3b3)),
  //                   ),
  //                 ),
  //               ),
  //             ),
  //           ],
  //         ),
  //         const SizedBox(height: 8.0),
  //         //Reset button
  //         Row(
  //           mainAxisAlignment: MainAxisAlignment.end,
  //           children: [
  //             ElevatedButton(
  //               onPressed: _resetFilters,
  //               style: ButtonStyle(
  //                 backgroundColor: WidgetStateProperty.all(Colors.black),
  //               ),
  //               child: Text(
  //                 'Reset Filters',
  //                 style: TextStyle(color: Color(0xffb3b3b3)),
  //               ),
  //             ),
  //           ],
  //         ),
  //       ],
  //     ),
  //   );
  // }
  Widget _buildFilters() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          children: [
            // Select Valet
            Chip(
              label: DropdownButton<String>(
                dropdownColor: const Color(0xff1a1a1c),
                hint: const Text(
                  'Select Valet',
                  style: TextStyle(color: Color(0xffb3b3b3)),
                ),
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
                    child: Text(
                      valet['name'],
                      style: const TextStyle(color: Color(0xffb3b3b3)),
                    ),
                  );
                }).toList(),
              ),
              backgroundColor: const Color(0xff1a1a1c),
            ),
            const SizedBox(width: 8.0),
            // Payment Method
            Chip(
              label: DropdownButton<String>(
                dropdownColor: const Color(0xff1a1a1c),
                hint: const Text(
                  'Payment Method',
                  style: TextStyle(color: Color(0xffb3b3b3)),
                ),
                value: selectedPaymentMethod,
                onChanged: (String? newValue) {
                  setState(() {
                    selectedPaymentMethod = newValue;
                    _filterData();
                  });
                },
                items: <String>['Both', 'Online', 'Cash on delivery'].map<DropdownMenuItem<String>>((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(
                      value,
                      style: const TextStyle(color: Color(0xffb3b3b3)),
                    ),
                  );
                }).toList(),
              ),
              backgroundColor: const Color(0xff1a1a1c),
            ),
            const SizedBox(width: 8.0),
            // Order Status
            Chip(
              label: DropdownButton<int>(
                dropdownColor: const Color(0xff1a1a1c),
                hint: const Text(
                  'Select Status',
                  style: TextStyle(color: Color(0xffb3b3b3)),
                ),
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
                    child: Text(
                      src.statusMessages[value] ?? 'Unknown',
                      style: const TextStyle(color: Color(0xffb3b3b3)),
                    ),
                  );
                }).toList(),
              ),
              backgroundColor: const Color(0xff1a1a1c),
            ),
            const SizedBox(width: 8.0),
            // Date
            GestureDetector(
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
                  selectedDate == null ? 'Select Date' : DateFormat('dd MMM yyyy').format(selectedDate!),
                  style: const TextStyle(color: Color(0xffb3b3b3)),
                ),
              ),
            ),
            const SizedBox(width: 8.0),
            // Reset button
            ElevatedButton(
              onPressed: _resetFilters,
              style: ButtonStyle(
                backgroundColor: WidgetStateProperty.all(Colors.black),
              ),
              child: const Text(
                'Reset Filters',
                style: TextStyle(fontSize: 15, color: Color(0xffb3b3b3)),
              ),
            ),
          ],
        ),
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
      color: Colors.grey[850],
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Order ID: ${data['orderId']}',
              style: const TextStyle(color: Color(0xffb3b3b3)),
            ),
            Text(
              'Cust Phone: ${data['phone']}',
              style: const TextStyle(color: Color(0xffb3b3b3)),
            ),
            Text(
              'Date: ${_formatTimestamp(data['timestamp'])}',
              style: const TextStyle(color: Color(0xffb3b3b3)),
            ),
            Text(
              'Address: ${data['address']}',
              style: const TextStyle(color: Color(0xffb3b3b3)),
            ),
            Text(
              'Payment Mode: ${data['paymentMode']}',
              style: const TextStyle(color: Color(0xffb3b3b3)),
            ),
            DropdownButton<String>(
              value: data['valetPhone'],
              onChanged: (String? newValue) async {
                await valetObj.assignValet(data['orderId'].toString(), newValue!);
                await refreshCallback();
              },
              items: valetData.map<DropdownMenuItem<String>>((valet) {
                return DropdownMenuItem<String>(
                  value: valet['phone'],
                  child: Text(
                    valet['name'],
                    style: const TextStyle(color: Color(0xffb3b3b3)),
                  ),
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
                  child: Text(
                    statusMessages[status] ?? 'Unknown',
                    style: const TextStyle(color: Color(0xffb3b3b3)),
                  ),
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
    QuerySnapshot querySnapshot = await FirebaseFirestore.instance.collection('OrderHistory').orderBy('timestamp', descending: true).get();

    return querySnapshot.docs.map((doc) {
      Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
      data['orderId'] = doc.id;
      return data;
    }).toList();
  }

  int get rowCount => orderData.length; // Total number of orders
}
