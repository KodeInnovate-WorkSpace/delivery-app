import 'package:flutter/material.dart';

class Admin extends ChangeNotifier {
  Future<Widget> manageUser() async {
    return const Text("Manage User");
  }

  Future<Widget> manageCategories() async {
    return const Text("Manage Categories");
  }

  Future<Widget> manageSubCategories() async {
    return const Text("Manage Sub-Categories");
  }

  Future<Widget> manageProducts() async {
    return const Text("Manage Products");
  }

  Future<Widget> manageNotification() async {
    return const Text("Manage Notification");
  }
}
