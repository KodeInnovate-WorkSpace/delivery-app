import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class EditAlertLabelScreen extends StatefulWidget {
  final String docId;
  final String currentColor;
  final String currentMessage;
  final int currentStatus;
  final String currentTextColor;

  const EditAlertLabelScreen({super.key, 
    required this.docId,
    required this.currentColor,
    required this.currentMessage,
    required this.currentStatus,
    required this.currentTextColor,
  });

  @override
  _EditAlertLabelScreenState createState() => _EditAlertLabelScreenState();
}

class _EditAlertLabelScreenState extends State<EditAlertLabelScreen> {
  final CollectionReference collection = FirebaseFirestore.instance.collection('AlertLabel');
  late String _color;
  late String _message;
  late int _status;
  late String _textColor;
  final List<int> statusOptions = [0, 1]; // 0 for inactive, 1 for active
  final TextEditingController colorController = TextEditingController();
  final TextEditingController messageController = TextEditingController();
  final TextEditingController textColorController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _color = widget.currentColor;
    _message = widget.currentMessage;
    _status = widget.currentStatus;
    _textColor = widget.currentTextColor;
    colorController.text = _color;
    messageController.text = _message;
    textColorController.text = _textColor;
  }

  void _updateAlertLabel() async {
    try {
      await collection.doc(widget.docId).update({
        'color': colorController.text,
        'message': messageController.text,
        'status': _status,
        'textcolor': textColorController.text,
      });
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
      appBar: AppBar(title: const Text('Edit Alert Label')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Text('ID: ${widget.docId}'),
            const SizedBox(height: 16.0),
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
                onPressed: _updateAlertLabel,
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
