import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'edit_alert_label.dart';
import 'add_alert_label.dart';

class AlertLabelListScreen extends StatelessWidget {
  final CollectionReference collection = FirebaseFirestore.instance.collection('AlertLabel');

  AlertLabelListScreen({super.key});

  void _deleteLabel(String docId) async {
    try {
      await collection.doc(docId).delete();
    } catch (e) {
      // Handle error
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Alert Label Management',
          style: TextStyle(color: Color(0xffb3b3b3)),
        ),
        actions: [
          IconButton(
            icon: const Icon(
              Icons.add,
              color: Color(0xffb3b3b3),
            ),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const AddAlertLabelScreen()),
              );
            },
          ),
        ],
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
      body: StreamBuilder(
        stream: collection.snapshots(),
        builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }
          var docs = snapshot.data!.docs;
          return ListView.builder(
            itemCount: docs.length,
            itemBuilder: (context, index) {
              var data = docs[index].data() as Map<String, dynamic>;
              return ListTile(
                title: Text(
                  'ID: ${data['id']}',
                  style: const TextStyle(color: Color(0xffb3b3b3)),
                ),
                subtitle: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Message: ${data['message']}',
                      style: const TextStyle(color: Color(0xffb3b3b3)),
                    ),
                    Text(
                      'Status: ${data['status']}',
                      style: const TextStyle(color: Color(0xffb3b3b3)),
                    ),
                    Text(
                      'Color: ${data['color']}',
                      style: const TextStyle(color: Color(0xffb3b3b3)),
                    ),
                    Text(
                      'Text Color: ${data['textcolor']}',
                      style: const TextStyle(color: Color(0xffb3b3b3)),
                    ),
                  ],
                ),
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(
                      icon: const Icon(
                        Icons.edit,
                        color: Color(0xffb3b3b3),
                      ),
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => EditAlertLabelScreen(
                              docId: docs[index].id,
                              currentColor: data['color'],
                              currentMessage: data['message'],
                              currentStatus: data['status'],
                              currentTextColor: data['textcolor'],
                            ),
                          ),
                        );
                      },
                    ),
                    IconButton(
                      icon: const Icon(
                        Icons.delete,
                        color: Color(0xffb3b3b3),
                      ),
                      onPressed: () {
                        _deleteLabel(docs[index].id);
                      },
                    ),
                  ],
                ),
              );
            },
          );
        },
      ),
    );
  }
}