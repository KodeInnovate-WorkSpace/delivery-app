import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:speedy_delivery/screens/address_input.dart';
import '../providers/address_provider.dart';

class AddressScreen extends StatelessWidget {
  const AddressScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final addressProvider = Provider.of<AddressProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Your Orders'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.only(bottom: 20.0),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const SizedBox(height: 20),
              if (addressProvider.address.isNotEmpty)
                Expanded(
                  child: ListView.builder(
                    itemCount: addressProvider.address.length,
                    itemBuilder: (context, index) {
                      final address = addressProvider.address[index];
                      return Column(
                        children: [
                          ListTile(
                            title: Text(
                                'Flat No.${address.flat}, Floor: ${address.floor}'),
                            subtitle: Text("Landmark: ${address.mylandmark}"),
                            trailing: IconButton(
                                onPressed: () {
                                  addressProvider.removeAddress(address);
                                },
                                icon: const Icon(Icons.delete)),
                          ),
                        ],
                      );
                    },
                  ),
                )
              else
                Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'No saved address',
                        style: TextStyle(
                          fontSize: 18,
                          color: Colors.grey[600],
                        ),
                      ),
                    ],
                  ),
                ),

              // add new address button
              ElevatedButton(
                onPressed: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const AddressInputForm()));
                },
                style: ElevatedButton.styleFrom(
                  fixedSize:
                      const Size(250, 50), // Set your desired width and height
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  backgroundColor: Colors.black,
                ),
                child: const Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.add,
                      color: Colors.white,
                    ),
                    SizedBox(),
                    Text(
                      "Add address",
                      style: TextStyle(color: Colors.white),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
