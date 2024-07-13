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
        title: const Text('Alert Label Management'),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const AddAlertLabelScreen()),
              );
            },
          ),
        ],
      ),
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
                title: Text('ID: ${data['id']}'),
                subtitle: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Message: ${data['message']}'),
                    Text('Status: ${data['status']}'),
                    Text('Color: ${data['color']}'),
                    Text('Text Color: ${data['textcolor']}'),
                  ],
                ),
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(
                      icon: const Icon(Icons.edit),
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
                      icon: const Icon(Icons.delete),
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
