import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../../shared/show_msg.dart';

class AddAlertLabelScreen extends StatefulWidget {
  const AddAlertLabelScreen({super.key});

  @override
  State<AddAlertLabelScreen> createState() => _AddAlertLabelScreenState();
}

class _AddAlertLabelScreenState extends State<AddAlertLabelScreen> {
  final CollectionReference collection = FirebaseFirestore.instance.collection('AlertLabel');
  final List<int> statusOptions = [0, 1]; // 0 for inactive, 1 for active
  final TextEditingController idController = TextEditingController(); // Controller for ID
  final TextEditingController colorController = TextEditingController();
  final TextEditingController messageController = TextEditingController();
  final TextEditingController textColorController = TextEditingController();
  int _status = 0;

  void _addAlertLabel() async {
    try {
      int id = int.parse(idController.text); // Parsing ID as an integer
      await collection.add({
        'id': id, // Adding ID to Firestore document
        'color': colorController.text,
        'message': messageController.text,
        'status': _status,
        'textcolor': textColorController.text,
      });
      showMessage('Alert label added successfully');
      Navigator.pop(context, true);
    } catch (e) {
      showMessage('Failed to add alert label: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Add Alert Label')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            const SizedBox(height: 16.0),
            TextField(
              controller: idController,
              decoration: const InputDecoration(
                labelText: 'ID',
                border: OutlineInputBorder(),
              ),
              keyboardType: TextInputType.number,
            ),
            const SizedBox(height: 20.0),
            TextField(
              controller: colorController,
              decoration: const InputDecoration(
                labelText: 'Color',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 20.0),
            TextField(
              controller: messageController,
              decoration: const InputDecoration(
                labelText: 'Message',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 20.0),
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
              controller: textColorController,
              decoration: const InputDecoration(
                labelText: 'Text Color',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 20.0),
            Center(
              child: ElevatedButton(
                onPressed: _addAlertLabel,
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
                  "Add",
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
