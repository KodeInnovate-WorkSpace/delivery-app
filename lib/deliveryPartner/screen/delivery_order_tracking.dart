import 'dart:developer';
import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:speedy_delivery/shared/show_msg.dart';
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
  final String orderTime;

  const DeliveryTrackingScreen({
    super.key,
    required this.order,
    required this.orderId,
    required this.orderTotalPrice,
    required this.paymentMode,
    required this.customerAddress,
    required this.customerPhone,
    required this.orderTime,
  });

  @override
  State<DeliveryTrackingScreen> createState() => _DeliveryTrackingScreenState();
}

class _DeliveryTrackingScreenState extends State<DeliveryTrackingScreen> {
  late Stream<DocumentSnapshot> _orderStatusStream;
  List<File> itemImages = [];
  List<bool> imageTaken = [];
  final TextEditingController _shopNameController = TextEditingController();
  bool _isCardLoading = false;
  int orderStatus = 0;

  @override
  @override
  void initState() {
    super.initState();
    _orderStatusStream = FirebaseFirestore.instance.collection('OrderHistory').doc(widget.orderId).snapshots();
    imageTaken = List<bool>.filled(widget.order.length, false);
    _loadImagePaths();
    _orderStatusStream.listen((snapshot) {
      if (snapshot.exists) {
        setState(() {
          orderStatus = snapshot['status'];
        });
      }
    });
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.orderId, style: const TextStyle(fontSize: 20, color: Colors.black)),
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
              ),
            );
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
                    const Text("Order Tracking", style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
                    const SizedBox(height: 20),
                    _buildCustomerDetailsTable(),
                    const SizedBox(height: 20),
                    _buildOrderDetailsTableFailed(),
                    const SizedBox(height: 20),
                    _buildOrderFailedCard('Order Failed', 'Your order has failed due to a transaction issue.', true, Colors.red, Icons.error),
                  ],
                ),
              );
            } else if (status == 6) {
              return Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text("Order Tracking", style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
                    const SizedBox(height: 20),
                    _buildCustomerDetailsTable(),
                    const SizedBox(height: 20),
                    _buildOrderDetailsTableFailed(),
                    const SizedBox(height: 20),
                    _buildOrderStatusCard('Order Cancelled', 'Unfortunately, your order has been cancelled.', true, Colors.red, Icons.cancel),
                  ],
                ),
              );
            } else {
              var statusCards = <Widget>[
                _buildOrderStatusCard('Order Received', 'Your order has been received.', status >= 0, Colors.green),
                _buildOrderStatusCard('Order Confirmed', 'Your order has been confirmed.', status >= 1, Colors.green),
                _buildOrderStatusCard('Order In Process', 'Your order is in process.', status >= 2, Colors.green),
                _buildOrderStatusCard('Order Pickup', 'Your order is ready for pickup.', status >= 3, Colors.green),
                _buildOrderStatusCard('Order Delivered', 'Your order has been delivered', status >= 4, Colors.green),
              ];

              return Padding(
                padding: const EdgeInsets.all(16.0),
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
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
        Table(
          columnWidths: const {
            0: FlexColumnWidth(),
            1: FixedColumnWidth(80.0),
            2: FixedColumnWidth(80.0),
            3: FixedColumnWidth(80.0),
          },
          border: TableBorder.all(color: Colors.grey[300]!),
          children: [
            TableRow(
              decoration: BoxDecoration(
                color: Colors.grey[200],
              ),
              children: const [
                Padding(
                  padding: EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
                  child: Text("Items", style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold)),
                ),
                Padding(
                  padding: EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
                  child: Text("Qnt", style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold)),
                ),
                Padding(
                  padding: EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
                  child: Text("Image", style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold)),
                ),
                Padding(
                  padding: EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
                  child: Text("Price", style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold)),
                ),
              ],
            ),
            for (int index = 0; index < widget.order.length; index++)
              TableRow(
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
                    child: Text(
                      widget.order[index].productName,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
                    child: Text("x ${widget.order[index].quantity.toString()}"),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
                    child: IconButton(
                      onPressed: orderStatus == 4 || orderStatus == 5 || orderStatus == 6
                          ? null
                          : () {
                        takePictureAndAddToImages(index).then((value) {
                          uploadAllImages(widget.order[index].productName);
                        });
                      },
                      icon: Icon(
                        orderStatus == 4 || orderStatus == 5 || orderStatus == 6 ? Icons.close : (imageTaken[index] ? Icons.check : Icons.camera_alt),
                        size: 18,
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
                    child: Text(widget.order[index].price.toStringAsFixed(2)),
                  ),
                ],
              ),
          ],
        ),
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                "Total Price",
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              Text(
                "Rs. ${widget.orderTotalPrice.toStringAsFixed(2)}",
                style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildOrderDetailsTableFailed() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Table(
          columnWidths: const {
            0: FlexColumnWidth(),
            1: FixedColumnWidth(80.0),
            2: FixedColumnWidth(80.0),
            3: FixedColumnWidth(80.0),
          },
          border: TableBorder.all(color: Colors.grey[300]!),
          children: [
            TableRow(
              decoration: BoxDecoration(
                color: Colors.grey[200],
              ),
              children: const [
                Padding(
                  padding: EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
                  child: Text("Items", style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold)),
                ),
                Padding(
                  padding: EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
                  child: Text("Qnt", style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold)),
                ),
                Padding(
                  padding: EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
                  child: Text("Image", style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold)),
                ),
                Padding(
                  padding: EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
                  child: Text("Price", style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold)),
                ),
              ],
            ),
            for (int index = 0; index < widget.order.length; index++)
              TableRow(
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
                    child: Text(
                      widget.order[index].productName,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
                    child: Text("x ${widget.order[index].quantity.toString()}"),
                  ),
                  const Padding(
                    padding: EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
                    child: IconButton(
                      onPressed: null,
                      icon: Icon(
                        Icons.close,
                        size: 18,
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
                    child: Text(widget.order[index].price.toStringAsFixed(2)),
                  ),
                ],
              ),
          ],
        ),
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                "Total Price",
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              Text(
                "Rs. ${widget.orderTotalPrice.toStringAsFixed(2)}",
                style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Future<void> uploadAllImages(String productName) async {
    if (itemImages.length != widget.order.length) {
      showMessage("Please upload images for all items before proceeding.");
      return;
    }
    String formattedDate = DateFormat('ddMMyyyy_HHmm').format(DateTime.now());
    for (var image in itemImages) {
      String fileName = path.basename(image.path);
      try {
        await firebase_storage.FirebaseStorage.instance.ref('order_images/${formattedDate}_$fileName').putFile(image);
      } catch (e) {
        log('Error uploading image: $e');
      }
    }
  }

  Future<void> _loadImagePaths() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String>? paths = prefs.getStringList('imagePaths_${widget.orderId}');
    if (paths != null) {
      setState(() {
        itemImages = paths.map((path) => File(path)).toList();
        for (int i = 0; i < paths.length; i++) {
          imageTaken[i] = true;
        }
      });
    }
  }

  Future<void> _saveImagePaths() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String> paths = itemImages.map((image) => image.path).toList();
    await prefs.setStringList('imagePaths_${widget.orderId}', paths);
  }


  Future<void> takePictureAndAddToImages(int index) async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.camera);

    if (pickedFile != null) {
      setState(() {
        itemImages.add(File(pickedFile.path));
        imageTaken[index] = true;
      });
      _saveImagePaths();
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
          const Text("Customer Details", style: TextStyle(fontSize: 20, fontFamily: 'Gilroy-ExtraBold')),
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

          Text("Time: ${widget.orderTime}",
              style: const TextStyle(
                fontSize: 16,
              )),
        ],
      ),
    );
  }

  Future<void> _showShopNameDialog() async {
    return showDialog<void>(
      context: context,
      barrierDismissible: true, // user can tap outside to close the dialog
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Enter Shop Name'),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                TextField(
                  controller: _shopNameController,
                  maxLines: null, // Allow the text to wrap and grow vertically
                  decoration: const InputDecoration(
                    hintText: 'Notes',
                  ),
                ),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
              },
            ),
            TextButton(
              child: const Text('OK'),
              onPressed: () {
                if (_shopNameController.text.isNotEmpty) {
                  Navigator.of(context).pop(); // Close the dialog
                } else {
                  showMessage("Shop name cannot be empty.");
                }
              },
            ),
          ],
        );
      },
    );
  }

  Future<void> _savePickupDetails() async {
    String formattedDate = DateFormat('ddMMyyyy_HHmm').format(DateTime.now());
    List<String> imageUrls = [];

    for (var image in itemImages) {
      String fileName = path.basename(image.path);
      try {
        firebase_storage.Reference ref = firebase_storage.FirebaseStorage.instance.ref('order_images/${formattedDate}_$fileName');
        await ref.putFile(image);
        String downloadUrl = await ref.getDownloadURL();
        imageUrls.add(downloadUrl);
      } catch (e) {
        log('Error uploading image: $e');
      }
    }

    await FirebaseFirestore.instance.collection('DeliveredShopName').doc(widget.orderId).set({
      'orderId': widget.orderId,
      'phoneNumber': widget.customerPhone,
      'timeOfPickup': DateTime.now(),
      'images': imageUrls,
      'shopName': _shopNameController.text,
    });

    // Clear saved image paths
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.remove('imagePaths_${widget.orderId}');
  }


  Widget _buildOrderStatusCard(String title, String description, bool done, [Color color = Colors.green, IconData icon = Icons.check_circle]) {
    return GestureDetector(
      onTap: () async {
        int? newStatus;

        setState(() {
          _isCardLoading = true;
        });

        // Fetch the current status from Firebase
        DocumentSnapshot orderSnapshot = await FirebaseFirestore.instance.collection('OrderHistory').doc(widget.orderId).get();

        int currentStatus = orderSnapshot['status'];

        // Check if 'Order Pickup' needs to be completed before proceeding with 'Order Delivered'
        if (title == 'Order Delivered' && currentStatus != 3) {
          showMessage("Complete the 'Order Pickup' step before marking the order as delivered.");
          setState(() {
            _isCardLoading = false;
          });
          return;
        }

        if (title == 'Order Pickup') {
          if (itemImages.length < widget.order.length) {
            showMessage("Please upload images for all items before picking up the order.");
            setState(() {
              _isCardLoading = false;
            });
            return;
          }

          await _showShopNameDialog();

          if (_shopNameController.text.isNotEmpty) {
            await _savePickupDetails();
          } else {
            setState(() {
              _isCardLoading = false;
            });
            return;
          }
        }

        if (!done) {
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
              setState(() {
                _isCardLoading = false;
              });
              return;
          }

          try {
            await FirebaseFirestore.instance.collection('OrderHistory').doc(widget.orderId).update({'status': newStatus});
            setState(() {
              _isCardLoading = false;
            });
          } catch (e) {
            log("Error updating status: $e");
            setState(() {
              _isCardLoading = false;
            });
          }
        } else {
          setState(() {
            _isCardLoading = false;
          });
        }
      },
      child: Card(
        color: done ? color : Colors.grey[300],
        child: ListTile(
          leading: Icon(icon, color: done ? Colors.white : Colors.grey),
          title: _isCardLoading
              ? const CupertinoActivityIndicator(
            radius: 10,
            animating: true,
            color: Colors.white,
          )
              : Text(title, style: TextStyle(color: done ? Colors.white : Colors.grey)),
          subtitle: Text(description, style: TextStyle(color: done ? Colors.white : Colors.grey)),
        ),
      ),
    );
  }

  Widget _buildOrderFailedCard(String title, String description, bool done, [Color color = Colors.red, IconData icon = Icons.error]) {
    return Card(
      color: done ? color : Colors.grey[300],
      child: ListTile(
        leading: Icon(icon, color: done ? Colors.white : Colors.grey),
        title: Text(title, style: TextStyle(color: done ? Colors.white : Colors.grey)),
        subtitle: Text(description, style: TextStyle(color: done ? Colors.white : Colors.grey)),
      ),
    );
  }
}