import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:speedy_delivery/screens/address_input.dart';
import '../providers/address_provider.dart';

class AddressScreen extends StatelessWidget {
  const AddressScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final addressProvider = Provider.of<AddressProvider>(context);
    addressProvider.loadAddresses();
    return Scaffold(
      appBar: AppBar(
        title: const Text("Your Addresses", style: TextStyle(color: Color(0xff666666), fontFamily: 'Gilroy-Bold')),
        iconTheme: const IconThemeData(color: Color(0xff666666)),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        backgroundColor: const Color(0xfff7f7f7),
        elevation: 0,
      ),
      backgroundColor: const Color(0xfff7f7f7),
      body: Padding(
        padding: const EdgeInsets.only(left: 10, right: 10, bottom: 20.0),
        // padding: const EdgeInsets.all(10.0),
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
                          Container(
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(10), // Adjust the radius as needed
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.grey.withOpacity(0.1), // Shadow color
                                  spreadRadius: 2, // Spread radius
                                  blurRadius: 5, // Blur radius
                                  offset: const Offset(0, 2), // Shadow offset (x, y)
                                ),
                              ],
                            ),
                            child: ListTile(
                              title: Text('Flat No.${address.flat}, Floor: ${address.floor}, Building: ${address.building}'),
                              // title: Text('${address.flat}, ${address.floor}, ${address.building}'),
                              // subtitle: Text('${address.mylandmark}, ${address.pincode}'),
                              subtitle: Text('Landmark: ${address.mylandmark}, Pincode: ${address.pincode}'),
                              trailing: IconButton(
                                onPressed: () {
                                  addressProvider.removeAddress(address);
                                },
                                icon: const Icon(Icons.delete, color: Color(0xff666666)),
                              ),
                            ),
                          ),
                          const SizedBox(
                            height: 10,
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
              ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const AddressInputForm(),
                    ),
                  );
                },
                style: ElevatedButton.styleFrom(
                  fixedSize: const Size(250, 50),
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
                    SizedBox(
                      width: 10,
                    ),
                    Text(
                      "Add Address",
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