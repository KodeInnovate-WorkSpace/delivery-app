import 'package:flutter/material.dart';

class PolicyScreen extends StatefulWidget {
  final String content;
  final String policyTitle;
  const PolicyScreen({super.key, required this.content, required this.policyTitle});

  @override
  State<PolicyScreen> createState() => _PolicyScreenState();
}

class _PolicyScreenState extends State<PolicyScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.policyTitle),
      ),
      body: SingleChildScrollView(child: Column(children: [Text(widget.content)],),),
    );
  }
}
