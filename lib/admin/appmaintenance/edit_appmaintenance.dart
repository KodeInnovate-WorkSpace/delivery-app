import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class EditAppMaintenanceScreen extends StatefulWidget {
  final String docId;
  final int currentStatus;

  EditAppMaintenanceScreen({required this.docId, required this.currentStatus});

  @override
  _EditAppMaintenanceScreenState createState() => _EditAppMaintenanceScreenState();
}

class _EditAppMaintenanceScreenState extends State<EditAppMaintenanceScreen> {
  final CollectionReference collection = FirebaseFirestore.instance.collection('AppMaintenance');
  late int _isAppEnabled;
  final List<int> statusOptions = [0, 1];

  @override
  void initState() {
    super.initState();
    _isAppEnabled = widget.currentStatus;
  }

  void _updateStatus() async {
    try {
      await collection.doc(widget.docId).update({'isAppEnabled': _isAppEnabled});
      Navigator.pop(context, true);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to update: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Edit App Maintenance')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Text('ID: ${widget.docId}'),
            const SizedBox(height: 16.0),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text("Status: "),
                DropdownButton<int>(
                  value: _isAppEnabled,
                  onChanged: (int? newValue) {
                    setState(() {
                      _isAppEnabled = newValue!;
                    });
                  },
                  items: statusOptions.map<DropdownMenuItem<int>>((int status) {
                    return DropdownMenuItem<int>(
                      value: status,
                      child: Text(status == 0 ? 'Inactive' : 'Active'),
                    );
                  }).toList(),
                ),
              ],
            ),
            const SizedBox(height: 20.0),
            Center(
              child: ElevatedButton(
                onPressed: _updateStatus,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.black,
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                  textStyle: const TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                ),
                child: const Text(
                  "Update",
                  style: TextStyle(
                    color: Colors.white,
                    fontFamily: 'Gilroy-Bold',
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
