import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'edit_appmaintenance.dart';

class AppMaintenanceListScreen extends StatelessWidget {
  final CollectionReference collection = FirebaseFirestore.instance.collection('AppMaintenance');

  AppMaintenanceListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'App Maintenance',
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
                subtitle: Text(
                  'isAppEnabled: ${data['isAppEnabled']}',
                  style: const TextStyle(color: Color(0xffb3b3b3)),
                ),
                trailing: IconButton(
                  icon: const Icon(
                    Icons.edit,
                    color: Color(0xffb3b3b3),
                  ),
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