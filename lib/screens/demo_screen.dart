import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/product_provider.dart';
import '../services/delete_this.dart';

class DemoPage extends StatelessWidget {
  const DemoPage({super.key});

  @override
  Widget build(BuildContext context) {
    final productProvider =
        Provider.of<ProductProvider>(context, listen: false);
    return Scaffold(
      appBar: AppBar(
        title: const Text("Products"),
      ),
      body: const CartScreen(),
      // body: Column(
      //   mainAxisAlignment: MainAxisAlignment.center,
      //   children: [
      //     const Center(child: Text("Products")),
      //     Consumer<ProductProvider>(
      //       builder: (ctx, provider, child) {
      //         if (provider.isLoading) {
      //           return const CircularProgressIndicator();
      //         } else if (provider.products.isEmpty) {
      //           return const Text("No products found");
      //         } else {
      //           return ListView.builder(
      //             shrinkWrap: true,
      //             itemCount: provider.products.length,
      //             itemBuilder: (ctx, index) {
      //               return ListTile(
      //                 title: Text(provider.products[index].name),
      //               );
      //             },
      //           );
      //         }
      //       },
      //     ),
      //   ],
      // ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          productProvider.fetchProducts(context);
        },
        child: const Icon(Icons.refresh),
      ),
    );
  }
}
