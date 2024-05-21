import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class DemoPage extends StatefulWidget {
  const DemoPage({super.key});

  @override
  State<DemoPage> createState() => _DemoPageState();
}

class _DemoPageState extends State<DemoPage> {
  final supabase = Supabase.instance.client;
  // List<String> categories = [];
  bool isLoading = false;
  String errorMessage = '';
String data = '';
  Future<void> _fetchData() async {
    setState(() {
      isLoading = true;
      errorMessage = '';
    });

    try {
      // final response = await supabase.from('category').select('name').execute();

      final response = await supabase
          .from('category')
          .select('name')
          .contains('name', "Grocery & Kitchen");

      final data = response.first;

      setState(() {
        data = data;
      });
    } catch (error) {
      setState(() {
        errorMessage = error.toString();
      });
    } finally {
      setState(() {
        isLoading = false;
      });
    }

    log("Category Data = $data");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Demo Page'),
      ),
      body: Center(
        child: isLoading
            ? const CircularProgressIndicator()
            : errorMessage.isNotEmpty
                ? Text('Error: $errorMessage')
                : ListView.builder(
                    itemCount: categories.length,
                    itemBuilder: (context, index) {
                      return ListTile(
                        title: Text(categories[index]),
                      );
                    },
                  ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _fetchData,
        child: const Icon(Icons.refresh),
      ),
    );
  }
}
