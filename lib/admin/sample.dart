import 'package:flutter/material.dart';
import 'admin_model.dart';

class SamplePage extends StatefulWidget {
  final String method;

  const SamplePage({required this.method, super.key});

  @override
  State<SamplePage> createState() => _SamplePageState();
}

class _SamplePageState extends State<SamplePage> {
  late Future<Widget> contentFuture;

  @override
  void initState() {
    super.initState();
    final admin = Admin();
    final methods = {
      'Manage Users': admin.manageUser(),
      'Manage Categories': admin.manageCategories(),
      'Manage SubCategories': admin.manageSubCategories(),
      'Manage Products': admin.manageProducts(),
      'Manage Notification': admin.manageNotification(),
    };

    contentFuture = methods[widget.method]!;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.method),
      ),
      body: Center(
        child: FutureBuilder<Widget>(
          future: contentFuture,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return CircularProgressIndicator();
            } else if (snapshot.hasError) {
              return Text('Error: ${snapshot.error}');
            } else if (snapshot.hasData) {
              return snapshot.data!;
            } else {
              return Text('No content available');
            }
          },
        ),
      ),
    );
  }
}
