import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../../shared/show_msg.dart';

class ConstantsListScreen extends StatelessWidget {
  final CollectionReference collection = FirebaseFirestore.instance.collection('constants');

  ConstantsListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Constants Management')),
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
                title: Text('App Version: ${data['app_version']}'),
                subtitle: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Delivery Charge: \$${data['deliveryCharge']}'),
                    Text('Delivery Time: ${data['deliveryTime']} minutes'),
                    Text('Is Delivery Free: ${data['isDeliveryFree'] ? 'Yes' : 'No'}'),
                    Text('Max Total for Coupon: ${data['maxTotalForCoupon']}'),
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
                            builder: (context) => EditConstantScreen(
                              docId: docs[index].id,
                              currentAppVersion: data['app_version'],
                              currentDeliveryCharge: data['deliveryCharge'],
                              currentMaxTotalForCoupon: data['maxTotalForCoupon'],
                              currentDeliveryTime: data['deliveryTime'],
                              currentIsDeliveryFree: data['isDeliveryFree'],
                            ),
                          ),
                        );
                      },
                    ),
                    // IconButton(
                    //   icon: const Icon(Icons.delete),
                    //   onPressed: () {
                    //     showDialog(
                    //       context: context,
                    //       builder: (context) {
                    //         return AlertDialog(
                    //           title: const Text('Delete Constant'),
                    //           content: const Text('Are you sure you want to delete this constant?'),
                    //           actions: [
                    //             TextButton(
                    //               onPressed: () {
                    //                 Navigator.of(context).pop();
                    //               },
                    //               child: const Text('Cancel'),
                    //             ),
                    //             TextButton(
                    //               onPressed: () {
                    //                 collection.doc(docs[index].id).delete();
                    //                 Navigator.of(context).pop();
                    //               },
                    //               child: const Text('Delete'),
                    //             ),
                    //           ],
                    //         );
                    //       },
                    //     );
                    //   },
                    // ),
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
            MaterialPageRoute(builder: (context) => AddConstantScreen(collection: collection)),
          );
        },
        child: const Icon(Icons.add),
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

  const EditConstantScreen({super.key,
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
    appVersionController = TextEditingController(text: widget.currentAppVersion);
    deliveryChargeController = TextEditingController(text: widget.currentDeliveryCharge.toString());
    maxTotalForCouponController = TextEditingController(text: widget.currentMaxTotalForCoupon.toString());
    deliveryTimeController = TextEditingController(text: widget.currentDeliveryTime.toString());
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
      await FirebaseFirestore.instance.collection('constants').doc(widget.docId).update({
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
      appBar: AppBar(title: const Text('Edit Constant')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: appVersionController,
              decoration: const InputDecoration(labelText: 'App Version'),
            ),
            TextField(
              controller: deliveryChargeController,
              decoration: const InputDecoration(labelText: 'Delivery Charge'),
              keyboardType: TextInputType.number,
            ),
            TextField(
              controller: maxTotalForCouponController,
              decoration: const InputDecoration(labelText: 'Max Total For Coupon'),
              keyboardType: TextInputType.number,
            ),
            TextField(
              controller: deliveryTimeController,
              decoration: const InputDecoration(labelText: 'Delivery Time'),
              keyboardType: TextInputType.number,
            ),
            SwitchListTile(
              title: const Text('Is Delivery Free'),
              value: isDeliveryFree,
              onChanged: (value) {
                setState(() {
                  isDeliveryFree = value;
                });
              },
            ),
            ElevatedButton(
              onPressed: _updateConstant,
              child: const Text('Save'),
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
      appBar: AppBar(title: const Text('Add Constant')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: appVersionController,
              decoration: const InputDecoration(labelText: 'App Version'),
            ),
            TextField(
              controller: deliveryChargeController,
              decoration: const InputDecoration(labelText: 'Delivery Charge'),
              keyboardType: TextInputType.number,
            ),
            TextField(
              controller: maxTotalForCouponController,
              decoration: const InputDecoration(labelText: 'Max Total for Coupon'),
              keyboardType: TextInputType.number,
            ),

            TextField(
              controller: deliveryTimeController,
              decoration: const InputDecoration(labelText: 'Delivery Time'),
              keyboardType: TextInputType.number,
            ),
            SwitchListTile(
              title: const Text('Is Delivery Free'),
              value: isDeliveryFree,
              onChanged: (value) {
                isDeliveryFree = value;
              },
            ),
            ElevatedButton(
              onPressed: addConstant,
              child: const Text('Add'),
            ),
          ],
        ),
      ),
    );
  }
}
