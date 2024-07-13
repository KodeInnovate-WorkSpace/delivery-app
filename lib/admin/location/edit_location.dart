import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../../shared/show_msg.dart';

class EditLocationScreen extends StatefulWidget {
  final String docId;
  final int currentStatus;
  final int currentPostalCode;

  const EditLocationScreen({
    super.key,
    required this.docId,
    required this.currentStatus,
    required this.currentPostalCode,
  });

  @override
  State<EditLocationScreen> createState() => _EditLocationScreenState();
}

class _EditLocationScreenState extends State<EditLocationScreen> {
  final CollectionReference collection = FirebaseFirestore.instance.collection('location');
  late int _status;
  late int _postalCode;
  final List<int> statusOptions = [0, 1]; // 0 for inactive, 1 for active
  final TextEditingController postalCodeController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _status = widget.currentStatus;
    _postalCode = widget.currentPostalCode;
    postalCodeController.text = _postalCode.toString();
  }

  void _updateLocation() async {
    try {
      await collection.doc(widget.docId).update({
        'status': _status,
        'postal_code': int.parse(postalCodeController.text),
      });
      showMessage('Location updated successfully.');
      Navigator.pop(context, true);
    } catch (e) {
      showMessage('Failed to update location: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Edit Location')),
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
                  value: _status,
                  onChanged: (int? newValue) {
                    setState(() {
                      _status = newValue!;
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
            TextField(
              controller: postalCodeController,
              decoration: const InputDecoration(
                labelText: 'Postal Code',
                border: OutlineInputBorder(),
              ),
              keyboardType: TextInputType.number,
            ),
            const SizedBox(height: 20.0),
            Center(
              child: ElevatedButton(
                onPressed: _updateLocation,
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
