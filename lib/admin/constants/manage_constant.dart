import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../../shared/show_msg.dart';

class ConstantsListScreen extends StatelessWidget {
  final CollectionReference collection =
      FirebaseFirestore.instance.collection('constants');

  ConstantsListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Constants Management',
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
                  'App Version: ${data['app_version']}',
                  style: const TextStyle(color: Color(0xffb3b3b3)),
                ),
                subtitle: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Delivery Charge: ₹${data['deliveryCharge']}',
                      style: const TextStyle(color: Color(0xffb3b3b3)),
                    ),
                    Text(
                      'Delivery Time: ${data['deliveryTime']} minutes',
                      style: const TextStyle(color: Color(0xffb3b3b3)),
                    ),
                    Text(
                      'Is Delivery Free: ${data['isDeliveryFree'] ? 'Yes' : 'No'}',
                      style: const TextStyle(color: Color(0xffb3b3b3)),
                    ),
                    Text(
                      'Max Total for Coupon: ${data['maxTotalForCoupon']}',
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
                            builder: (context) => EditConstantScreen(
                              docId: docs[index].id,
                              currentAppVersion: data['app_version'],
                              currentDeliveryCharge: data['deliveryCharge'],
                              currentMaxTotalForCoupon:
                                  data['maxTotalForCoupon'],
                              currentDeliveryTime: data['deliveryTime'],
                              currentIsDeliveryFree: data['isDeliveryFree'],
                            ),
                          ),
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
        backgroundColor: Colors.black,
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) =>
                    AddConstantScreen(collection: collection)),
          );
        },
        child: const Icon(
          Icons.add,
          color: Color(0xffb3b3b3),
        ),
      ),
    );
  }
}

class EditConstantScreen extends StatefulWidget {
  final String docId;
  final String currentAppVersion;
  final num currentDeliveryCharge;
  final num currentMaxTotalForCoupon;
  final num currentDeliveryTime;
  final bool currentIsDeliveryFree;

  const EditConstantScreen({
    super.key,
    required this.docId,
    required this.currentAppVersion,
    required this.currentDeliveryCharge,
    required this.currentMaxTotalForCoupon,
    required this.currentDeliveryTime,
    required this.currentIsDeliveryFree,
  });

  @override
  State<EditConstantScreen> createState() => _EditConstantScreenState();
}

class _EditConstantScreenState extends State<EditConstantScreen> {
  late TextEditingController appVersionController;
  late TextEditingController deliveryChargeController;
  late TextEditingController maxTotalForCouponController;
  late TextEditingController deliveryTimeController;
  late bool isDeliveryFree;

  @override
  void initState() {
    super.initState();
    appVersionController =
        TextEditingController(text: widget.currentAppVersion);
    deliveryChargeController =
        TextEditingController(text: widget.currentDeliveryCharge.toString());
    maxTotalForCouponController =
        TextEditingController(text: widget.currentMaxTotalForCoupon.toString());
    deliveryTimeController =
        TextEditingController(text: widget.currentDeliveryTime.toString());
    isDeliveryFree = widget.currentIsDeliveryFree;
  }

  @override
  void dispose() {
    appVersionController.dispose();
    deliveryChargeController.dispose();
    maxTotalForCouponController.dispose();
    deliveryTimeController.dispose();
    super.dispose();
  }

  void _updateConstant() async {
    try {
      await FirebaseFirestore.instance
          .collection('constants')
          .doc(widget.docId)
          .update({
        'app_version': appVersionController.text,
        'deliveryCharge': num.parse(deliveryChargeController.text),
        'maxTotalForCoupon': num.parse(maxTotalForCouponController.text),
        'deliveryTime': num.parse(deliveryTimeController.text),
        'isDeliveryFree': isDeliveryFree,
      });
      showMessage('Constant updated successfully');
      Navigator.of(context).pop();
    } catch (e) {
      showMessage('Failed to update constant: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Edit Constant',
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
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: appVersionController,
              style: const TextStyle(color: Color(0xffb3b3b3)),
              decoration: const InputDecoration(
                labelText: 'App Version',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(
              height: 25,
            ),
            TextField(
              controller: deliveryChargeController,
              keyboardType: TextInputType.number,
              style: const TextStyle(color: Color(0xffb3b3b3)),
              decoration: const InputDecoration(
                labelText: 'Delivery Charge',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(
              height: 25,
            ),
            TextField(
              controller: maxTotalForCouponController,
              keyboardType: TextInputType.number,
              style: const TextStyle(color: Color(0xffb3b3b3)),
              decoration: const InputDecoration(
                labelText: 'Max Total For Coupon',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(
              height: 25,
            ),
            TextField(
              controller: deliveryTimeController,
              keyboardType: TextInputType.number,
              style: const TextStyle(color: Color(0xffb3b3b3)),
              decoration: const InputDecoration(
                labelText: 'Delivery Time',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(
              height: 25,
            ),
            SwitchListTile(
              title: const Text(
                'Is Delivery Free',
                style: TextStyle(color: Color(0xffb3b3b3)),
              ),
              value: isDeliveryFree,
              onChanged: (value) {
                setState(() {
                  isDeliveryFree = value;
                });
              },
            ),
            const SizedBox(
              height: 25,
            ),
            ElevatedButton(
              onPressed: _updateConstant,
              style: ButtonStyle(
                backgroundColor: WidgetStateProperty.all(Colors.black),
              ),
              child: const Text(
                'Save',
                style: TextStyle(
                    color: Color(0xffb3b3b3),
                    fontFamily: "Gilroy-Bold",
                    fontSize: 16),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class AddConstantScreen extends StatelessWidget {
  final CollectionReference collection;

  const AddConstantScreen({super.key, required this.collection});

  @override
  Widget build(BuildContext context) {
    final appVersionController = TextEditingController();
    final deliveryChargeController = TextEditingController();
    final maxTotalForCouponController = TextEditingController();
    final deliveryTimeController = TextEditingController();
    bool isDeliveryFree = false;

    void addConstant() async {
      try {
        await collection.add({
          'app_version': appVersionController.text,
          'deliveryCharge': num.parse(deliveryChargeController.text),
          'maxTotalForCoupon': num.parse(maxTotalForCouponController.text),
          'deliveryTime': num.parse(deliveryTimeController.text),
          'isDeliveryFree': isDeliveryFree,
        });
        showMessage('Constant added successfully');
        Navigator.of(context).pop();
      } catch (e) {
        showMessage('Failed to add constant: $e');
      }
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Add Constant',
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
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: appVersionController,
              // decoration: const InputDecoration(labelText: 'App Version'),
              style: const TextStyle(color: Color(0xffb3b3b3)),
              decoration: const InputDecoration(
                labelText: 'App Version',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(
              height: 25,
            ),
            TextField(
              controller: deliveryChargeController,
              keyboardType: TextInputType.number,
              // decoration: const InputDecoration(labelText: 'Delivery Charge'),
              style: const TextStyle(color: Color(0xffb3b3b3)),
              decoration: const InputDecoration(
                labelText: 'Delivery Charge',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(
              height: 25,
            ),
            TextField(
              controller: maxTotalForCouponController,
              keyboardType: TextInputType.number,
              // decoration: const InputDecoration(labelText: 'Max Total for Coupon'),
              style: const TextStyle(color: Color(0xffb3b3b3)),
              decoration: const InputDecoration(
                labelText: 'Max Total for Coupon',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(
              height: 25,
            ),
            TextField(
              controller: deliveryTimeController,
              keyboardType: TextInputType.number,
              // decoration: const InputDecoration(labelText: 'Delivery Time'),
              style: const TextStyle(color: Color(0xffb3b3b3)),
              decoration: const InputDecoration(
                labelText: 'Delivery Time',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(
              height: 25,
            ),
            SwitchListTile(
              title: const Text(
                'Is Delivery Free',
                style: TextStyle(color: Color(0xffb3b3b3)),
              ),
              value: isDeliveryFree,
              onChanged: (value) {
                isDeliveryFree = value;
              },
            ),
            ElevatedButton(
              style: ButtonStyle(
                  backgroundColor: WidgetStateProperty.all(Colors.black)),
              onPressed: addConstant,
              child: const Text(
                'Add',
                style: TextStyle(color: Color(0xffb3b3b3)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
