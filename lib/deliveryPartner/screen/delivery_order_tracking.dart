import 'dart:developer';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../model/model.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:path/path.dart' as path;

class DeliveryTrackingScreen extends StatefulWidget {
  final String orderId;
  final double orderTotalPrice;
  final List<OrderDetail> order;
  final String paymentMode;
  final String customerAddress;
  final String customerPhone;

  const DeliveryTrackingScreen({
    super.key,
    required this.order,
    required this.orderId,
    required this.orderTotalPrice,
    required this.paymentMode,
    required this.customerAddress,
    required this.customerPhone,
  });

  @override
  State<DeliveryTrackingScreen> createState() => _DeliveryTrackingScreenState();
}

class _DeliveryTrackingScreenState extends State<DeliveryTrackingScreen> {
  late Stream<DocumentSnapshot> _orderStatusStream;

  @override
  void initState() {
    super.initState();
    _orderStatusStream = FirebaseFirestore.instance
        .collection('OrderHistory')
        .doc(widget.orderId)
        .snapshots();
  }

  List<File> itemImages = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Order Tracking",
            style: TextStyle(fontSize: 20, color: Colors.black)),
        backgroundColor: Colors.white,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.black),
      ),
      body: StreamBuilder<DocumentSnapshot>(
        stream: _orderStatusStream,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
                child: CircularProgressIndicator(
              color: Colors.black,
            ));
          }

          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }

          if (snapshot.hasData) {
            var orderData = snapshot.data!;
            var status = orderData['status'];

            if (status == 5) {
              return Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(widget.orderId,
                        style: const TextStyle(
                            fontSize: 24, fontWeight: FontWeight.bold)),
                    const SizedBox(height: 20),
                    _buildCustomerDetailsTable(),
                    const SizedBox(height: 20),
                    _buildOrderDetailsTable(),
                    const SizedBox(height: 20),
                    _buildOrderFailedCard(
                        'Order Failed',
                        'Your order has failed due to a transaction issue.',
                        true,
                        Colors.red,
                        Icons.error),
                  ],
                ),
              );
            } else if (status == 6) {
              return Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(widget.orderId,
                        style: const TextStyle(
                            fontSize: 24, fontWeight: FontWeight.bold)),
                    const SizedBox(height: 20),
                    _buildCustomerDetailsTable(),
                    const SizedBox(height: 20),
                    _buildOrderDetailsTable(),
                    const SizedBox(height: 20),
                    _buildOrderStatusCard(
                        'Order Cancelled',
                        'Unfortunately, your order has been cancelled.',
                        true,
                        Colors.red,
                        Icons.cancel),
                  ],
                ),
              );
            } else {
              var statusCards = <Widget>[
                _buildOrderStatusCard('Order Received',
                    'Your order has been received.', status >= 0, Colors.green),
                _buildOrderStatusCard(
                    'Order Confirmed',
                    'Your order has been confirmed.',
                    status >= 1,
                    Colors.green),
                _buildOrderStatusCard('Order In Process',
                    'Your order is in process.', status >= 2, Colors.green),
                _buildOrderStatusCard(
                    'Order Pickup',
                    'Your order is ready for pickup.',
                    status >= 3,
                    Colors.green),
                _buildOrderStatusCard('Order Delivered',
                    'Your order has been delivered', status >= 4, Colors.green),
              ];

              return Padding(
                padding: const EdgeInsets.all(16.0),
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(widget.orderId,
                          style: const TextStyle(
                              fontSize: 24, fontWeight: FontWeight.bold)),
                      const SizedBox(height: 20),
                      _buildCustomerDetailsTable(),
                      const SizedBox(height: 20),
                      _buildOrderDetailsTable(),
                      const SizedBox(height: 20),
                      Column(children: statusCards),
                    ],
                  ),
                ),
              );
            }
          }

          return const Center(child: Text('No data available'));
        },
      ),
    );
  }

  Widget _buildOrderDetailsTable() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          color: Colors.grey[200],
          padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
          child: const Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text("Items",
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
              Text("Quantity",
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
              Text("Price",
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
              Text("Image",
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            ],
          ),
        ),
        ListView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: widget.order.length,
          itemBuilder: (context, index) {
            var orderDetail = widget.order[index];
            return Container(
              padding:
                  const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
              decoration: BoxDecoration(
                border: Border(
                  bottom: BorderSide(
                    color: Colors.grey[300]!,
                    width: 1.0,
                  ),
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(orderDetail.productName),
                  Text(orderDetail.quantity.toString()),
                  Text(orderDetail.totalPrice.toStringAsFixed(2)),
                  IconButton(
                      onPressed: () {
                        takePictureAndAddToImages()
                            .then((value) => {uploadAllImages()});
                      },
                      icon: const Icon(
                        Icons.camera_alt,
                        size: 18,
                      )),
                ],
              ),
            );
          },
        ),
        Container(
          padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                "Total Price",
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              Text(
                "Rs. ${widget.orderTotalPrice}",
                style:
                    const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Future<void> uploadAllImages() async {
    if (itemImages.length != widget.order.length) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content:
              Text('Please upload images for all items before proceeding.'),
        ),
      );
      return;
    }

    for (var image in itemImages) {
      String fileName = path.basename(image.path);
      try {
        await firebase_storage.FirebaseStorage.instance
            .ref('order_images/$fileName')
            .putFile(image);
        // Upload successful
      } catch (e) {
        // Error uploading image
        log('Error uploading image: $e');
      }
    }
  }

  Future<void> takePictureAndAddToImages() async {
    if (itemImages.length >= widget.order.length) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content:
              Text('You have already uploaded the required number of images.'),
        ),
      );
      return;
    }

    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.camera);

    if (pickedFile != null) {
      setState(() {
        itemImages.add(File(pickedFile.path));
      });
    }
  }

  Widget _buildCustomerDetailsTable() {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
      decoration: BoxDecoration(
        color: Colors.grey[200],
        borderRadius: BorderRadius.circular(5.0),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text("Customer Details",
              style: TextStyle(fontSize: 20, fontFamily: 'Gilroy-ExtraBold')),
          const SizedBox(height: 8.0),
          Text("Payment Mode: ${widget.paymentMode}",
              style: const TextStyle(
                fontSize: 16,
              )),

          //Phone
          Row(
            children: [
              const Text("Phone: ",
                  style: TextStyle(
                    fontSize: 16,
                  )),
              const Icon(
                Icons.phone,
                size: 15,
              ),
              Text(widget.customerPhone, style: const TextStyle(fontSize: 16)),
            ],
          ),

          Text("Address: ${widget.customerAddress}",
              style: const TextStyle(
                fontSize: 16,
              )),
        ],
      ),
    );
  }

  Widget _buildOrderStatusCard(String title, String description, bool done,
      [Color color = Colors.green, IconData icon = Icons.check_circle]) {
    return GestureDetector(
      onTap: () async {
        if ((title == 'Order Pickup' || title == 'Order Delivered' ) && itemImages.length < widget.order.length) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Please upload images for all items before picking up the order.'),
            ),
          );
          return;
        }
        if (!done) {
          int newStatus;
          switch (title) {
            case 'Order Received':
              newStatus = 0;
              break;
            case 'Order Confirmed':
              newStatus = 1;
              break;
            case 'Order In Process':
              newStatus = 2;
              break;
            case 'Order Pickup':
              newStatus = 3;
              break;
            case 'Order Delivered':
              newStatus = 4;
              break;
            default:
              return;
          }

          try {
            await FirebaseFirestore.instance
                .collection('OrderHistory')
                .doc(widget.orderId)
                .update({'status': newStatus});
            setState(() {});
          } catch (e) {
            log("Error updating status: $e");
          }
        }
      },
      child: Card(
        color: done ? color : Colors.grey[300],
        child: ListTile(
          leading: Icon(icon, color: done ? Colors.white : Colors.grey),
          title: Text(title,
              style: TextStyle(color: done ? Colors.white : Colors.grey)),
          subtitle: Text(description,
              style: TextStyle(color: done ? Colors.white : Colors.grey)),
        ),
      ),
    );
  }

  Widget _buildOrderFailedCard(String title, String description, bool done,
      [Color color = Colors.red, IconData icon = Icons.error]) {
    return Card(
      color: done ? color : Colors.grey[300],
      child: ListTile(
        leading: Icon(icon, color: done ? Colors.white : Colors.grey),
        title: Text(title,
            style: TextStyle(color: done ? Colors.white : Colors.grey)),
        subtitle: Text(description,
            style: TextStyle(color: done ? Colors.white : Colors.grey)),
      ),
    );
  }
}
