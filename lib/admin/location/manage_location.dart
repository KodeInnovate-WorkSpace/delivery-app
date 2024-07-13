import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'edit_location.dart';
import 'add_location.dart';

class LocationListScreen extends StatelessWidget {
  final CollectionReference collection = FirebaseFirestore.instance.collection('location');

  LocationListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Location Management')),
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
                    Text('Status: ${data['status']}'),
                    Text('Postal Code: ${data['postal_code']}'),
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
                            builder: (context) => EditLocationScreen(
                              docId: docs[index].id,
                              currentStatus: data['status'],
                              currentPostalCode: data['postal_code'],
                            ),
                          ),
                        );
                      },
                    ),
                    IconButton(
                      icon: const Icon(Icons.delete),
                      onPressed: () {
                        showDialog(
                          context: context,
                          builder: (context) {
                            return AlertDialog(
                              title: const Text('Delete Location'),
                              content: const Text('Are you sure you want to delete this location?'),
                              actions: [
                                TextButton(
                                  onPressed: () {
                                    Navigator.of(context).pop();
                                  },
                                  child: const Text('Cancel'),
                                ),
                                TextButton(
                                  onPressed: () {
                                    collection.doc(docs[index].id).delete();
                                    Navigator.of(context).pop();
                                  },
                                  child: const Text('Delete'),
                                ),
                              ],
                            );
                          },
                        );
                      },
                    ),
                  ],
                ),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => AddLocationScreen()),
          );
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
