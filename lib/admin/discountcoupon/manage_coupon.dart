import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

class ManageOffersScreen extends StatefulWidget {
  const ManageOffersScreen({super.key});

  @override
  State<ManageOffersScreen> createState() => _ManageOffersScreenState();
}

class _ManageOffersScreenState extends State<ManageOffersScreen> {
  late OfferTableData src;

  @override
  void initState() {
    super.initState();
    src = OfferTableData(context);
    src.addListener(() {
      setState(() {});
    });
  }

  @override
  void dispose() {
    src.removeListener(() {});
    src.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Manage Offers'),
      ),
      body: Stack(
        children: [
          RefreshIndicator(
            onRefresh: src._refreshOfferList,
            child: ListView(
              children: [
                PaginatedDataTable(
                  columns: const [
                    DataColumn(label: Text('Image')),
                    DataColumn(label: Text('Offer Name')),
                    DataColumn(label: Text('Discount')),
                    DataColumn(label: Text('Status')),
                    DataColumn(label: Text('Update')),
                    DataColumn(label: Text('Delete')),
                  ],
                  source: src,
                  columnSpacing: 20,
                  rowsPerPage: 8,
                ),
              ],
            ),
          ),
          Positioned(
            bottom: 25,
            right: 20,
            child: FloatingActionButton(
              hoverColor: Colors.transparent,
              elevation: 2,
              onPressed: () async {
                final result = await Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const AddOfferScreen(),
                  ),
                );

                if (result != null && result as bool) {
                  src._refreshOfferList();
                }
              },
              backgroundColor: Colors.black,
              child: const Icon(
                Icons.add,
                color: Colors.white,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class OfferTableData extends DataTableSource {
  final BuildContext context;

  OfferModel offer = OfferModel();
  List<Map<String, dynamic>> offerData = [];
  List<int> statusOptions = [0, 1]; // 0 for inactive, 1 for active

  OfferTableData(this.context) {
    _loadOfferData();
  }

  Future<void> _loadOfferData() async {
    offerData = await offer.manageOffers();
    offerData.sort((a, b) => (a['discount'] as int).compareTo(b['discount'] as int));
    notifyListeners(); // Notify the listeners that data has changed
  }

  Future<void> _deleteOffer(dynamic offerId) async {
    await offer.deleteOffer(offerId);
    _loadOfferData(); // Reload data after deletion
  }

  Future<void> _refreshOfferList() async {
    await _loadOfferData();
    notifyListeners();
  }

  @override
  DataRow? getRow(int index) {
    if (index >= offerData.length) return null; // Check index bounds
    final data = offerData[index];
    return DataRow(cells: [
      // Image
      DataCell(
        SizedBox(
          width: 35,
          child: CachedNetworkImage(
            imageUrl: data['image'] ?? 'No Image',
          ),
        ),
      ),

      // Offer Name
      DataCell(Text(data['offerName'] ?? '')),

      // Discount
      DataCell(Text(data['discount'].toString())),

      // Status
      DataCell(
        DropdownButton<int>(
          value: data['status'], // Use the status value from data
          onChanged: (int? newValue) async {
            await offer.updateOfferStatus(data['id'], newValue);
            _loadOfferData();
          },
          items: statusOptions.map<DropdownMenuItem<int>>((int status) {
            return DropdownMenuItem<int>(
              value: status,
              child: Text(status == 0 ? 'Inactive' : 'Active'),
            );
          }).toList(),
        ),
      ),

      // Update
      DataCell(
        IconButton(
          icon: const Icon(Icons.edit),
          onPressed: () async {
            final result = await Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => UpdateOfferScreen(data: data),
              ),
            );

            if (result != null && result as bool) {
              _refreshOfferList(); // Call refresh function here
            }
          },
        ),
      ),

      // Delete
      DataCell(
        IconButton(
          icon: const Icon(Icons.delete),
          onPressed: () {
            _deleteOffer(data['id']);
          },
        ),
      ),
    ]);
  }

  @override
  bool get isRowCountApproximate => false;

  @override
  int get rowCount => offerData.length;

  @override
  int get selectedRowCount => 0;
}

class AddOfferScreen extends StatefulWidget {
  const AddOfferScreen({super.key});

  @override
  State<AddOfferScreen> createState() => _AddOfferScreenState();
}

class _AddOfferScreenState extends State<AddOfferScreen> {
  final TextEditingController offerNameController = TextEditingController();
  final TextEditingController discountController = TextEditingController();
  final TextEditingController statusController = TextEditingController();
  File? _image;

  Future<void> _pickImage() async {
    final pickedFile = await ImagePicker().pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _image = File(pickedFile.path);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Offer'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: offerNameController,
              decoration: const InputDecoration(labelText: 'Offer Name'),
            ),
            TextField(
              controller: discountController,
              decoration: const InputDecoration(labelText: 'Discount'),
              keyboardType: TextInputType.number,
            ),
            SizedBox(height: 10),
            _image == null
                ? const Text('No image selected.')
                : Image.file(_image!, height: 100),
            ElevatedButton(
              onPressed: _pickImage,
              child: const Text('Pick Image'),
            ),
            DropdownButtonFormField<int>(
              value: 1,
              items: [
                DropdownMenuItem(value: 0, child: Text('Inactive')),
                DropdownMenuItem(value: 1, child: Text('Active')),
              ],
              onChanged: (int? newValue) {
                statusController.text = newValue.toString();
              },
              decoration: const InputDecoration(labelText: 'Status'),
            ),
            ElevatedButton(
              onPressed: () async {
                if (_image != null) {
                  // Upload the image and get the URL
                  final imageUrl = await OfferModel().uploadImage(_image!);

                  // Add offer to Firebase
                  await OfferModel().addOffer({
                    'offerName': offerNameController.text,
                    'discount': int.parse(discountController.text),
                    'image': imageUrl,
                    'status': int.parse(statusController.text),
                  });
                  Navigator.pop(context, true);
                }
              },
              child: const Text('Add Offer'),
            ),
          ],
        ),
      ),
    );
  }
}

class UpdateOfferScreen extends StatefulWidget {
  final Map<String, dynamic> data;
  const UpdateOfferScreen({super.key, required this.data});

  @override
  State<UpdateOfferScreen> createState() => _UpdateOfferScreenState();
}

class _UpdateOfferScreenState extends State<UpdateOfferScreen> {
  late TextEditingController offerNameController;
  late TextEditingController discountController;
  late TextEditingController statusController;
  File? _image;
  String? _imageUrl;

  @override
  void initState() {
    super.initState();
    offerNameController = TextEditingController(text: widget.data['offerName']);
    discountController = TextEditingController(text: widget.data['discount'].toString());
    statusController = TextEditingController(text: widget.data['status'].toString());
    _imageUrl = widget.data['image'];
  }

  Future<void> _pickImage() async {
    final pickedFile = await ImagePicker().pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _image = File(pickedFile.path);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Update Offer'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: offerNameController,
              decoration: const InputDecoration(labelText: 'Offer Name'),
            ),
            TextField(
              controller: discountController,
              decoration: const InputDecoration(labelText: 'Discount'),
              keyboardType: TextInputType.number,
            ),
            SizedBox(height: 10),
            _image == null
                ? CachedNetworkImage(imageUrl: _imageUrl ?? 'No Image')
                : Image.file(_image!, height: 100),
            ElevatedButton(
              onPressed: _pickImage,
              child: const Text('Pick Image'),
            ),
            DropdownButtonFormField<int>(
              value: int.parse(statusController.text),
              items: [
                DropdownMenuItem(value: 0, child: Text('Inactive')),
                DropdownMenuItem(value: 1, child: Text('Active')),
              ],
              onChanged: (int? newValue) {
                statusController.text = newValue.toString();
              },
              decoration: const InputDecoration(labelText: 'Status'),
            ),
            ElevatedButton(
              onPressed: () async {
                if (_image != null) {
                  // Upload the image and get the URL
                  final imageUrl = await OfferModel().uploadImage(_image!);
                  _imageUrl = imageUrl;
                }

                // Update offer in Firebase
                await OfferModel().updateOffer(widget.data['id'], {
                  'offerName': offerNameController.text,
                  'discount': int.parse(discountController.text),
                  'image': _imageUrl,
                  'status': int.parse(statusController.text),
                });
                Navigator.pop(context, true);
              },
              child: const Text('Update Offer'),
            ),
          ],
        ),
      ),
    );
  }
}

class OfferModel {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<List<Map<String, dynamic>>> manageOffers() async {
    final snapshot = await _firestore.collection('offers').get();
    return snapshot.docs.map((doc) {
      return {
        'id': doc.id,
        'offerName': doc['offerName'],
        'discount': doc['discount'],
        'image': doc['image'],
        'status': doc['status'],
      };
    }).toList();
  }

  Future<void> deleteOffer(dynamic offerId) async {
    await _firestore.collection('offers').doc(offerId).delete();
  }

  Future<void> updateOfferStatus(dynamic offerId, int? newStatus) async {
    await _firestore.collection('offers').doc(offerId).update({'status': newStatus});
  }

  Future<void> addOffer(Map<String, dynamic> offerData) async {
    await _firestore.collection('offers').add(offerData);
  }

  Future<void> updateOffer(dynamic offerId, Map<String, dynamic> offerData) async {
    await _firestore.collection('offers').doc(offerId).update(offerData);
  }

  Future<String> uploadImage(File imageFile) async {
    // Implement your image upload logic here, for example using Firebase Storage.
    // Return the image URL after uploading.
    // This is a placeholder implementation.
    return 'https://example.com/image.jpg';
  }
}
