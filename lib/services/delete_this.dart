import 'package:flutter/material.dart';

class CartScreen extends StatefulWidget {
  const CartScreen({super.key});

  @override
  _CartScreenState createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Padding(
      padding: const EdgeInsets.all(10.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisSize: MainAxisSize.max,
            children: [




              Align(
                alignment: Alignment.centerRight,
                child: InkWell(
                  onTap: () {},
                  child: Container(
                    height: 35,
                    width: 100,
                    decoration: BoxDecoration(
                        color: Colors.green,
                        borderRadius: BorderRadius.circular(5)),
                    child: Padding(
                      padding: const EdgeInsets.all(4.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          InkWell(
                              onTap: () {
                                // Placeholder decrement action
                              },
                              child: const Icon(
                                Icons.remove,
                                color: Colors.white,
                                size: 15,
                              )),
                          const Text("Add", // Placeholder data
                              style: TextStyle(color: Colors.white)),
                          InkWell(
                              onTap: () {
                                // Placeholder increment action
                              },
                              child: const Icon(
                                Icons.add,
                                color: Colors.white,
                                size: 15,
                              )),
                        ],
                      ),
                    ),
                  ),
                ),
              )
            ],
          )
        ],
      ),
    ));
  }
}
