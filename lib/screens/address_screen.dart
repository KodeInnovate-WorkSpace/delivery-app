import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
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
      body: Center(
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
                    return ListTile(
                      title: Text(
                          'Flat No.${address.flat}, Floor: ${address.floor}'),
                      subtitle: Text("Landmark: ${address.mylandmark}"),
                      trailing: IconButton(
                          onPressed: () {
                            addressProvider.removeAddress(address);
                          },
                          icon: const Icon(Icons.delete)),
                    );
                  },
                ),
              )
            else
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
    );
  }
}
