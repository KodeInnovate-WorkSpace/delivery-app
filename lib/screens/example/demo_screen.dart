import 'package:flutter/material.dart';
import 'package:speedy_delivery/screens/example/prod_card.dart';
import 'package:speedy_delivery/screens/example/product_screen_grid.dart';

class DemoPage extends StatelessWidget {
  const DemoPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text("New Product Card"),
        ),
        body: CustomScrollView(
          shrinkWrap: true,
          physics: const BouncingScrollPhysics(),
          slivers: [
            SliverGrid(
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                mainAxisSpacing: 8.0,
                crossAxisSpacing: 8.0,
                childAspectRatio: 0.62,
              ),
              delegate: SliverChildBuilderDelegate(
                (BuildContext context, int index) {
                  if (index == 6) {
                    return const SizedBox(
                      height: 50,
                    );
                  }

                  return const ProductCard();
                },
                childCount: 6 + 1,
              ),
            )
          ],
        )
    );
  }
}
