// import 'package:cached_network_image/cached_network_image.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
// import 'package:provider/provider.dart';
// import 'package:speedy_delivery/providers/cart_provider.dart';
//
// import '../widget/add_to_cart_button.dart';
//
// class CheckoutScreen extends StatefulWidget {
//   const CheckoutScreen({super.key});
//
//   @override
//   State<CheckoutScreen> createState() => _CheckoutScreenState();
// }
//
// class _CheckoutScreenState extends State<CheckoutScreen> with ChangeNotifier {
//   @override
//   Widget build(BuildContext context) {
//     final cartProvider = Provider.of<CartProvider>(context);
//
//     return Scaffold(
//       resizeToAvoidBottomInset:
//           true, // Enable auto-resizing when keyboard appears
//       appBar: AppBar(
//         title: const Text('Checkout'),
//       ),
//       body: Container(
//         color: Colors.grey[100], // Set the background color to grey
//         child: Padding(
//           padding: const EdgeInsets.all(8.0),
//           child: SingleChildScrollView(
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 // Delivery information
//                 const Card(
//                   elevation: 0,
//                   color: Colors.white, // Set the card color to white
//                   child: Padding(
//                     padding: EdgeInsets.all(18.0),
//                     child: Row(
//                       children: [
//                         Icon(Icons.timer),
//                         SizedBox(width: 12),
//                         Expanded(
//                           child: Column(
//                             crossAxisAlignment: CrossAxisAlignment.start,
//                             children: [
//                               Text(
//                                 'Delivery in 7 minutes',
//                                 style: TextStyle(
//                                     fontSize: 18,
//                                     fontFamily: 'Gilroy-ExtraBold'),
//                               ),
//                               Text(
//                                 'Shipment of 1 item',
//                                 style:
//                                     TextStyle(fontSize: 12, color: Colors.grey),
//                               ),
//                             ],
//                           ),
//                         ),
//                       ],
//                     ),
//                   ),
//                 ),
//                 // title end
//                 const SizedBox(height: 10),
//                 // Display cart items
//
//                 if (cartProvider.cart.isEmpty)
//                   Center(
//                     child: Column(children: [
//                       Image.asset("assets/images/empty.png"),
//                       const Text(
//                         "No item in cart",
//                         style: TextStyle(fontSize: 20),
//                       ),
//                     ]),
//                   ),
//
//                 if (cartProvider.cart.isNotEmpty)
//                   ...cartProvider.cart.map((item) {
//                     return Card(
//                       elevation: 0,
//                       color: Colors.white,
//                       child: Padding(
//                         padding: const EdgeInsets.all(8.0),
//                         child: Row(
//                           children: [
//                             CachedNetworkImage(
//                               imageUrl: item.itemImage,
//                               width: 50,
//                               height: 50,
//                             ),
//                             const SizedBox(width: 15),
//                             Expanded(
//                               child: Column(
//                                 crossAxisAlignment: CrossAxisAlignment.start,
//                                 children: [
//                                   // Item name
//                                   Text(
//                                     item.itemName,
//                                     style: const TextStyle(fontSize: 16),
//                                   ),
//                                   // Item Unit kg, g, L, etc
//                                   Text(
//                                     item.itemUnit.toString(),
//                                     style: const TextStyle(color: Colors.grey),
//                                   ),
//                                   const SizedBox(height: 4),
//                                   // Item price
//                                   Text(
//                                     'Total: ₹${item.itemPrice * item.qnt}',
//                                     style: const TextStyle(
//                                       fontSize: 14,
//                                       fontWeight: FontWeight.bold,
//                                     ),
//                                   ),
//                                 ],
//                               ),
//                             ),
//                             const SizedBox(width: 2),
//
//                             //add to Cart button
//                             Column(
//                               children: [
//                                 AddToCartButton(
//                                   productName: item.itemName,
//                                   productPrice: item.itemPrice,
//                                   productImage: item.itemImage,
//                                   productUnit: item
//                                       .itemUnit, // Set product unit to 0 since it's not used
//                                 ),
//
//                                 // Container(
//                                 //   height: 35,
//                                 //   decoration: BoxDecoration(
//                                 //     color: Colors.green,
//                                 //     borderRadius: BorderRadius.circular(5),
//                                 //   ),
//                                 //   child: Row(
//                                 //     mainAxisSize: MainAxisSize.min,
//                                 //     children: [
//                                 //       IconButton(
//                                 //         icon: const Icon(Icons.remove,
//                                 //             size: 15, color: Colors.white),
//                                 //         onPressed: () {
//                                 //           cartProvider.removeItem(item);
//                                 //           notifyListeners();
//                                 //         },
//                                 //       ),
//                                 //       // item count/quantity
//                                 //       Text(
//                                 //         '${item.qnt}',
//                                 //         style: const TextStyle(
//                                 //           color: Colors.white,
//                                 //           fontFamily: 'Gilroy-SemiBold',
//                                 //         ),
//                                 //       ),
//                                 //       IconButton(
//                                 //         icon: const Icon(Icons.add,
//                                 //             size: 15, color: Colors.white),
//                                 //         onPressed: () {
//                                 //           cartProvider.addItem(item);
//                                 //           notifyListeners();
//                                 //         },
//                                 //       ),
//                                 //     ],
//                                 //   ),
//                                 // ),
//                               ],
//                             ),
//                           ],
//                         ),
//                       ),
//                     );
//                   }),
//                 // spacing
//                 const SizedBox(height: 10),
//                 // Bill details
//                 const SizedBox(height: 10),
//                 Card(
//                   color: Colors.white, // Set the card color to white
//                   child: Padding(
//                     padding: const EdgeInsets.all(8.0),
//                     child: Column(
//                       crossAxisAlignment: CrossAxisAlignment.start,
//                       children: [
//                         const Text('Bill details',
//                             style: TextStyle(
//                                 fontSize: 18, fontFamily: 'Gilroy-Black')),
//                         // Row 1
//                         Row(
//                           mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                           children: [
//                             const Row(
//                               children: [
//                                 Icon(
//                                   Icons.receipt_long,
//                                   size: 14,
//                                 ),
//                                 SizedBox(width: 4),
//                                 Text('Item total',
//                                     style: TextStyle(fontSize: 14)),
//                               ],
//                             ),
//                             Align(
//                               alignment: Alignment.centerRight,
//                               child: Text(
//                                 '\u20B9 ${cartProvider.calculateTotalPrice()}',
//                                 style: const TextStyle(fontSize: 14),
//                               ),
//                             ),
//                           ],
//                         ),
//                         const SizedBox(height: 4),
//                         // Row 2
//                         Row(
//                           mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                           children: [
//                             const Row(
//                               children: [
//                                 Icon(
//                                   Icons.sports_motorsports,
//                                   size: 14,
//                                 ),
//                                 SizedBox(width: 4),
//                                 Text('Delivery Charge',
//                                     style: TextStyle(fontSize: 14)),
//                               ],
//                             ),
//                             Align(
//                               alignment: Alignment.centerRight,
//                               child: Text(
//                                   '\u20B9 ${cartProvider.deliveryCharge}',
//                                   style: const TextStyle(fontSize: 14)),
//                             ),
//                           ],
//                         ),
//                         const SizedBox(height: 4),
//                         // Row 3
//                         Row(
//                           mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                           children: [
//                             const Row(
//                               children: [
//                                 Icon(
//                                   Icons.shopping_bag,
//                                   size: 14,
//                                 ),
//                                 SizedBox(width: 4),
//                                 Text('Handling Charge',
//                                     style: TextStyle(fontSize: 14)),
//                               ],
//                             ),
//                             Align(
//                               alignment: Alignment.centerRight,
//                               child: Text(
//                                   '\u20B9 ${cartProvider.handlingCharge}',
//                                   style: const TextStyle(fontSize: 14)),
//                             ),
//                           ],
//                         ),
//                         const SizedBox(height: 4),
//                         // Row 4
//                         Row(
//                           mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                           children: [
//                             const Text('Grand total',
//                                 style: TextStyle(
//                                     fontSize: 16, fontFamily: 'Gilroy-Medium')),
//                             Text('\u20B9 ${cartProvider.calculateGrandTotal()}',
//                                 style: const TextStyle(
//                                     fontSize: 16, fontFamily: 'Gilroy-Medium')),
//                           ],
//                         ),
//                       ],
//                     ),
//                   ),
//                 ),
//                 const SizedBox(height: 50),
//
//                 Center(
//                   child: ElevatedButton(
//                     onPressed: () => HapticFeedback.heavyImpact(),
//                     style: ButtonStyle(
//                       shape: WidgetStateProperty.all<RoundedRectangleBorder>(
//                         RoundedRectangleBorder(
//                           borderRadius: BorderRadius.circular(14.0),
//                         ),
//                       ),
//                       backgroundColor: WidgetStateProperty.resolveWith<Color>(
//                         (Set<WidgetState> states) {
//                           return Colors.black;
//                         },
//                       ),
//                     ),
//                     child: const SizedBox(
//                       width: 250,
//                       height: 50.0,
//                       child: Center(
//                         child: Text(
//                           "Continue",
//                           style: TextStyle(
//                             color: Colors.white,
//                             fontSize: 16.0,
//                           ),
//                         ),
//                       ),
//                     ),
//                   ),
//                 ),
//               ],
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:speedy_delivery/providers/address_provider.dart';
import 'package:speedy_delivery/providers/cart_provider.dart';
import 'package:speedy_delivery/shared/show_msg.dart';
import '../widget/add_to_cart_button.dart';
import '../widget/network_handler.dart';
import 'address_input.dart'; // Make sure to import your NetworkHandler

class CheckoutScreen extends StatefulWidget {
  const CheckoutScreen({super.key});

  @override
  State<CheckoutScreen> createState() => _CheckoutScreenState();
}

class _CheckoutScreenState extends State<CheckoutScreen> {
  @override
  Widget build(BuildContext context) {
    final cartProvider = Provider.of<CartProvider>(context);
    final addressProvider = Provider.of<AddressProvider>(context);

    return NetworkHandler(
      child: Scaffold(
        resizeToAvoidBottomInset:
            true, // Enable auto-resizing when keyboard appears
        appBar: AppBar(
          title: const Text('Checkout'),
        ),
        body: Container(
          // height: MediaQuery.of(context).size.height, //covers the entire screen (responsive)
          // color: Colors.grey[100], // Set the background color to grey
          color: const Color(0xffeaf1fc), // Set the background color to grey
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Delivery information
                  const Card(
                    elevation: 0,
                    color: Colors.white, // Set the card color to white
                    child: Padding(
                      padding: EdgeInsets.all(18.0),
                      child: Row(
                        children: [
                          Icon(Icons.timer),
                          SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Delivery in 7 minutes',
                                  style: TextStyle(
                                      fontSize: 18,
                                      fontFamily: 'Gilroy-ExtraBold'),
                                ),
                                Text(
                                  'Shipment of 1 item',
                                  style: TextStyle(
                                      fontSize: 12, color: Colors.grey),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  // title end
                  const SizedBox(height: 10),
                  // Display cart items

                  if (cartProvider.cart.isEmpty)
                    Center(
                      child: Column(children: [
                        Image.asset("assets/images/empty.png"),
                        const Text(
                          "No item in cart",
                          style: TextStyle(fontSize: 20),
                        ),
                      ]),
                    ),

                  if (cartProvider.cart.isNotEmpty)
                    ...cartProvider.cart.map((item) {
                      return Card(
                        elevation: 0,
                        color: Colors.white,
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Row(
                            children: [
                              CachedNetworkImage(
                                imageUrl: item.itemImage,
                                width: 50,
                                height: 50,
                              ),
                              const SizedBox(width: 15),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    // Item name
                                    Text(
                                      item.itemName,
                                      style: const TextStyle(fontSize: 16),
                                    ),
                                    // Item Unit kg, g, L, etc
                                    Text(
                                      item.itemUnit.toString(),
                                      style:
                                          const TextStyle(color: Colors.grey),
                                    ),
                                    const SizedBox(height: 4),
                                    // Item price
                                    Text(
                                      'Total: ₹${item.itemPrice * item.qnt}',
                                      style: const TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(width: 2),

                              //add to Cart button
                              Column(
                                children: [
                                  AddToCartButton(
                                    productName: item.itemName,
                                    productPrice: item.itemPrice,
                                    productImage: item.itemImage,
                                    productUnit: item
                                        .itemUnit, // Set product unit to 0 since it's not used
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      );
                    }),
                  // spacing
                  const SizedBox(height: 10),
                  // Bill details
                  const SizedBox(height: 10),
                  Card(
                    color: Colors.white, // Set the card color to white
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text('Bill details',
                              style: TextStyle(
                                  fontSize: 18, fontFamily: 'Gilroy-Black')),
                          // Row 1
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Row(
                                children: [
                                  Icon(
                                    Icons.receipt_long,
                                    size: 14,
                                  ),
                                  SizedBox(width: 4),
                                  Text('Item total',
                                      style: TextStyle(fontSize: 14)),
                                ],
                              ),
                              Align(
                                alignment: Alignment.centerRight,
                                child: Text(
                                  '\u20B9 ${cartProvider.calculateTotalPrice()}',
                                  style: const TextStyle(fontSize: 14),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 4),
                          // Row 2
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Row(
                                children: [
                                  Icon(
                                    Icons.sports_motorsports,
                                    size: 14,
                                  ),
                                  SizedBox(width: 4),
                                  Text('Delivery Charge',
                                      style: TextStyle(fontSize: 14)),
                                ],
                              ),
                              Align(
                                alignment: Alignment.centerRight,
                                child: Text(
                                    '\u20B9 ${cartProvider.deliveryCharge}',
                                    style: const TextStyle(fontSize: 14)),
                              ),
                            ],
                          ),
                          const SizedBox(height: 4),
                          // Row 3
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Row(
                                children: [
                                  Icon(
                                    Icons.shopping_bag,
                                    size: 14,
                                  ),
                                  SizedBox(width: 4),
                                  Text('Handling Charge',
                                      style: TextStyle(fontSize: 14)),
                                ],
                              ),
                              Align(
                                alignment: Alignment.centerRight,
                                child: Text(
                                    '\u20B9 ${cartProvider.handlingCharge}',
                                    style: const TextStyle(fontSize: 14)),
                              ),
                            ],
                          ),
                          const SizedBox(height: 4),
                          // Row 4
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text('Grand total',
                                  style: TextStyle(
                                      fontSize: 16,
                                      fontFamily: 'Gilroy-Medium')),
                              Text(
                                  '\u20B9 ${cartProvider.calculateGrandTotal()}',
                                  style: const TextStyle(
                                      fontSize: 16,
                                      fontFamily: 'Gilroy-Medium')),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 50),

                  Center(
                    child: ElevatedButton(
                      onPressed: () {
                        HapticFeedback.heavyImpact();
                        if (cartProvider.cart.isEmpty) {
                          showMessage("Cart is empty");
                          return;
                        }

                        if (addressProvider.address.isEmpty) {
                          showMessage("Please select an address");
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (context) => const AddressInputForm(),
                            ),
                          );
                        }
                      },
                      style: ButtonStyle(
                        shape: WidgetStateProperty.all<RoundedRectangleBorder>(
                          RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(14.0),
                          ),
                        ),
                        backgroundColor: WidgetStateProperty.resolveWith<Color>(
                          (Set<WidgetState> states) {
                            return Colors.black;
                          },
                        ),
                      ),
                      child: const SizedBox(
                        width: 250,
                        height: 50.0,
                        child: Center(
                          child: Text(
                            "Continue",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 16.0,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
