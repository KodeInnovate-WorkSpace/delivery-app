import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'dart:developer';

import 'admin_model.dart';

class ManageSubCategoryScreen extends StatelessWidget {
  const ManageSubCategoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    Admin admin = Admin();
    return Scaffold(
      appBar: AppBar(
        title: const Text('Manage Users'),
      ),
      body: FutureBuilder<List<Map<String, dynamic>>>(
        future: admin.manageSubCategories(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('No users found.'));
          } else {
            final users = snapshot.data!;
            return Center(
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: DataTable(
                  columns: const [
                    DataColumn(label: Text('Category Id')),
                    DataColumn(label: Text('Sub-Category Id')),
                    DataColumn(label: Text('Name')),
                    // Add more columns as needed
                  ],
                  rows: users.map((user) {
                    return DataRow(cells: [
                      DataCell(Text(user['sub_category_id'].toString())),
                      DataCell(Text(user['category_id'].toString())),
                      DataCell(Text(user['sub_category_name'] ?? 'N/A')),
                      // Add more cells as needed
                    ]);
                  }).toList(),
                ),
              ),
            );
          }
        },
      ),
    );
  }
}
