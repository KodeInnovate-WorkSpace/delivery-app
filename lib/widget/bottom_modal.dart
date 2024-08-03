import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:speedy_delivery/providers/address_provider.dart';

import '../models/address_model.dart';
import '../shared/show_msg.dart';

class BottomModal extends StatefulWidget {
  const BottomModal({super.key});

  @override
  State<BottomModal> createState() => _BottomModalState();
}

class _BottomModalState extends State<BottomModal> {
  String _defaultAdd = "No address available";

  @override
  Widget build(BuildContext context) {
    final addressProvider = Provider.of<AddressProvider>(context);

    // default address
    if (addressProvider.address.isNotEmpty) {
      _defaultAdd = "${addressProvider.address[0].flat}, ${addressProvider.address[0].building}, ${addressProvider.address[0].mylandmark}";
    }

    return Container(
      color: Colors.white,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            // location section
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    const Icon(Icons.place),
                    const SizedBox(width: 5),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text("Delivering to"),
                        Text(_defaultAdd),
                      ],
                    ),
                  ],
                ),

                // change address button
                TextButton(
                  onPressed: () async {
                    if (addressProvider.address.isEmpty) {
                      showMessage("Address book is empty");
                      return;
                    }

                    Address? newAddress = await _showAddressSelectionDialog(context, addressProvider.address);
                    if (newAddress != null) {
                      setState(() {
                        _defaultAdd = "${newAddress.flat}, ${newAddress.building}, ${newAddress.mylandmark}";
                      });
                    }
                  },
                  child: const Text(
                    "Change",
                    style: TextStyle(color: Colors.green),
                  ),
                ),
              ],
            ),

            // payment mode | place order
            const Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.payments,
                          size: 12,
                        ),
                        SizedBox(width: 10),
                        Text("Pay Using"),
                        SizedBox(width: 10),
                        Icon(
                          Icons.arrow_upward,
                          size: 10,
                        ),
                      ],
                    ),
                    Text("Bank Name")
                  ],
                ),
              ],
            )
          ],
        ),
      ),
    );
  }

  Future<Address?> _showAddressSelectionDialog(BuildContext context, List<Address> addresses) async {
    return showDialog<Address>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Select Address'),
          content: SingleChildScrollView(
            child: ListBody(
              children: addresses.map((Address address) {
                return GestureDetector(
                  onTap: () {
                    Navigator.of(context).pop(address);
                  },
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8.0),
                    child: Text("${address.flat}, ${address.floor}, ${address.mylandmark}"),
                  ),
                );
              }).toList(),
            ),
          ),
        );
      },
    );
  }
}
