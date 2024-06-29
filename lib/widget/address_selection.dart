import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/address_provider.dart';
import '../screens/address_input.dart';
import '../shared/show_msg.dart';

class AddressSelection extends StatefulWidget {
  const AddressSelection({super.key});

  @override
  State<AddressSelection> createState() => _AddressSelectionState();
}

class _AddressSelectionState extends State<AddressSelection> {
  String _defaultAdd = "No address available";
  String _newAdd = '';

  @override
  Widget build(BuildContext context) {
    final addressProvider = Provider.of<AddressProvider>(context);

    if (addressProvider.address.isNotEmpty) {
      _defaultAdd =
          "${addressProvider.address[0].flat}, ${addressProvider.address[0].building}, ${addressProvider.address[0].mylandmark}";
    }

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        addressProvider.loadAddresses();
      }
    });
    return GestureDetector(
      onTap: () {
        // Address selection sheet
        showModalBottomSheet(
          context: context,
          backgroundColor: Colors.white,
          builder: (BuildContext context) {
            return StatefulBuilder(
              builder: (BuildContext context, StateSetter setModalState) {
                return Container(
                  decoration: const BoxDecoration(
                    color: Colors.white70,
                    borderRadius:
                        BorderRadius.vertical(top: Radius.circular(10.0)),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 25.0, vertical: 10),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Title
                        const Text(
                          "Select address",
                          style: TextStyle(
                              fontSize: 20, fontFamily: 'Gilroy-Bold'),
                        ),
                        const SizedBox(height: 20),
                        // Add new address row
                        Container(
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius:
                                const BorderRadius.all(Radius.circular(10.0)),
                            border: Border.all(color: Colors.grey.shade200),
                          ),
                          child: ListTile(
                            minLeadingWidth: 50,
                            leading: const Icon(Icons.add,
                                color: Colors.green, size: 18),
                            title: const Text(
                              "Add new address",
                              style: TextStyle(
                                  color: Colors.green,
                                  fontFamily: 'Gilroy-SemiBold'),
                            ),
                            trailing: const Icon(Icons.chevron_right),
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) =>
                                        const AddressInputForm()),
                              ).then((value) {
                                // Refresh the modal state when returning from address input
                                setModalState(() {});
                                setState(() {}); // Refresh the main state
                              });
                            },
                          ),
                        ),
                        const SizedBox(height: 35),
                        // Saved addresses
                        Text(
                          "Your saved addresses",
                          style:
                              TextStyle(fontSize: 13, color: Colors.grey[600]),
                        ),
                        if (addressProvider.address.isNotEmpty)
                          SizedBox(
                            height: 250,
                            child: ListView.builder(
                              shrinkWrap: true,
                              itemCount: addressProvider.address.length,
                              itemBuilder: (context, index) {
                                final address = addressProvider.address[index];
                                return Column(
                                  children: [
                                    GestureDetector(
                                      onTap: () {
                                        _newAdd =
                                            "${address.flat}, ${address.building}, ${address.mylandmark}";
                                        setState(() {
                                          _defaultAdd = _newAdd;
                                        });
                                        addressProvider.setSelectedAddress(
                                            _newAdd); // Set the selected address in the provider
                                        Navigator.pop(context,
                                            true); // Close the bottom modal
                                        showMessage("Address Changed!");
                                      },
                                      child: ListTile(
                                        title: Text(
                                            '${address.flat}, ${address.floor}, ${address.building}'),
                                        subtitle: Text(address.mylandmark),
                                        trailing: IconButton(
                                          onPressed: () {
                                            addressProvider
                                                .removeAddress(address);
                                            showMessage("Address Deleted!");
                                            setModalState(
                                                () {}); // Refresh the modal state
                                            setState(() {
                                              if (_defaultAdd == _newAdd) {
                                                _defaultAdd = "";
                                                _newAdd = "";
                                              }
                                            });
                                          },
                                          icon: const Icon(Icons.delete),
                                        ),
                                      ),
                                    ),
                                  ],
                                );
                              },
                            ),
                          ),
                      ],
                    ),
                  ),
                );
              },
            );
          },
        ).then((value) {
          setState(() {}); // Refresh the main state after the modal is closed
        });
      },
      child: Container(
        color: Colors.transparent,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
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
                      const Text(
                        "Delivering to",
                        style: TextStyle(fontFamily: 'Gilroy-SemiBold'),
                      ),
                      Text(
                        addressProvider.selectedAddress.isEmpty
                            ? "Please select an address"
                            : addressProvider.selectedAddress,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                            color: Colors.grey[500],
                            fontFamily: 'Gilroy-Medium',
                            fontSize: 12),
                      ),
                    ],
                  ),
                ],
              ),
              // Change address button
              const Text(
                "Change",
                style: TextStyle(
                    color: Colors.green, fontFamily: 'Gilroy-SemiBold'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
