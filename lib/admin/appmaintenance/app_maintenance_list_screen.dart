import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'edit_appmaintenance.dart';

class AppMaintenanceListScreen extends StatelessWidget {
  final CollectionReference collection = FirebaseFirestore.instance.collection('AppMaintenance');

  AppMaintenanceListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('App Maintenance')),
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
                subtitle: Text('isAppEnabled: ${data['isAppEnabled']}'),
                trailing: IconButton(
                  icon: const Icon(Icons.edit),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => EditAppMaintenanceScreen(
                          docId: docs[index].id,
                          currentStatus: data['isAppEnabled'],
                        ),
                      ),
                    );
                  },
                ),
              );
            },
          );
        },
      ),
    );
  }
}
