import 'dart:developer';
import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import '../../shared/show_msg.dart';
import '../admin_model.dart';

class EditBanner extends StatefulWidget {
  const EditBanner({super.key});

  @override
  State<EditBanner> createState() => _EditBannerState();
}

class _EditBannerState extends State<EditBanner> with ChangeNotifier {
  final TextEditingController bannerIdController = TextEditingController();
  final TextEditingController priorityController = TextEditingController();
  final TextEditingController imageController = TextEditingController();
  File? _image;

  int? dropdownValue = 1;
  final List<String> bannerName = [];
  final Map<String, int> bannerMap = {};
  String? selectedBannerName;
  int? selectedBannerId;

  bool isLoading = false;

  BannerModel bannerObj = BannerModel();
  List<Map<String, dynamic>> bannerData = [];

  @override
  void initState() {
    super.initState();
  }

  Future<void> addNewBanner(BuildContext context) async {
    try {
      // Fetch bannerData from Firestore
      bannerData = await bannerObj.manageBanner();
      notifyListeners();

      // Check if sub-category already exists
      final querySnapshot = await FirebaseFirestore.instance.collection('Advertisement').where('id', isEqualTo: bannerIdController.text).get();

      if (querySnapshot.docs.isNotEmpty) {
        showMessage("Banner already exists");
        log("Banner already exists");
        return;
      }

      // Upload image and add sub-category to Firestore
      String imageUrl = await uploadImage(_image!);
      final subCategoryDoc = FirebaseFirestore.instance.collection('Advertisement').doc();

      await subCategoryDoc.set({
        'id': bannerData.length + 1,
        'image': imageUrl,
        'priority': int.parse(priorityController.text),
        'status': dropdownValue,
      });

      showMessage("Banner added to database");
      log("Banner added successfully");
    } catch (e) {
      showMessage("Error adding banner: $e");
      log("Error adding banner: $e");
    }
  }

  Future<String> uploadImage(File image) async {
    try {
      final storageRef = FirebaseStorage.instance.ref().child('AdvertisementImages/${DateTime.now().millisecondsSinceEpoch}');
      final uploadTask = storageRef.putFile(image);
      final snapshot = await uploadTask;
      final downloadUrl = await snapshot.ref.getDownloadURL();
      showMessage("Image Uploaded");
      return downloadUrl;
    } catch (e) {
      log("Error uploading image: $e");
      rethrow;
    }
  }

  Future<void> pickImage() async {
    final pickedFile = await ImagePicker().pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _image = File(pickedFile.path);
      });
    }
  }

  Future<void> openCamera() async {
    final pickedFile = await ImagePicker().pickImage(source: ImageSource.camera);
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
        title: const Text(
          "Add New Banner",
          style: TextStyle(color: Color(0xffb3b3b3)),
        ),
        elevation: 0,
        backgroundColor: const Color(0xff1a1a1c),
        surfaceTintColor: Colors.transparent,
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: const Icon(
            Icons.keyboard_backspace,
            color: Color(0xffb3b3b3),
          ),
        ),
      ),
      backgroundColor: const Color(0xff1a1a1c),
      body: Padding(
        padding: const EdgeInsets.all(15.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _image != null
                ? Image.file(_image!, height: 100, width: 100)
                : const Text(
                    "No image selected",
                    style: TextStyle(color: Color(0xffb3b3b3)),
                  ),
            const SizedBox(height: 20),

            // Open Camera
            ElevatedButton(
              onPressed: openCamera,
              style: ButtonStyle(
                shape: WidgetStateProperty.all<RoundedRectangleBorder>(
                  RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                ),
                backgroundColor: WidgetStateProperty.resolveWith<Color>(
                  (Set<WidgetState> states) {
                    return Colors.black;
                  },
                ),
              ),
              child: const Text(
                "Open Camera",
                style: TextStyle(color: Color(0xffb3b3b3), fontFamily: 'Gilroy-Bold'),
              ),
            ),
            const SizedBox(width: 10),

            // select image from gallery
            ElevatedButton(
              onPressed: pickImage,
              style: ButtonStyle(
                shape: WidgetStateProperty.all<RoundedRectangleBorder>(
                  RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                ),
                backgroundColor: WidgetStateProperty.resolveWith<Color>(
                  (Set<WidgetState> states) {
                    return Colors.black;
                  },
                ),
              ),
              child: const Text(
                "Pick Image",
                style: TextStyle(color: Color(0xffb3b3b3), fontFamily: 'Gilroy-Bold'),
              ),
            ),
            const SizedBox(height: 20),

            //Priority
            SizedBox(
              width: 250,
              child: TextFormField(
                controller: priorityController,
                cursorColor: Colors.black,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  hintText: 'Enter Priority',
                  hintStyle: const TextStyle(color: Colors.black, fontWeight: FontWeight.normal),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(14.0),
                    borderSide: const BorderSide(color: Colors.black),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(14.0),
                    borderSide: const BorderSide(color: Colors.black),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(14.0),
                    borderSide: const BorderSide(color: Colors.black),
                  ),
                  filled: true,
                  fillColor: Colors.white,
                  prefixIcon: const Icon(Icons.sort),
                ),
              ),
            ),
            const SizedBox(height: 20),

            //Status Dropdown
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text("Status: ",
                  style: TextStyle(color: Color(0xffb3b3b3)),
                ),
                DropdownButton<int>(
                  value: dropdownValue,
                  onChanged: (int? value) {
                    setState(() {
                      dropdownValue = value;
                    });

                    log("Status: ${value.toString()}");
                    value == 1 ? log("Enabled") : log("Disabled");
                  },
                  items: const [
                    DropdownMenuItem(
                        value: 1,
                        child: Text(
                          "Enable",
                          style: TextStyle(color: Color(0xffb3b3b3)),
                        )),
                    DropdownMenuItem(
                        value: 0,
                        child: Text(
                          "Disable",
                          style: TextStyle(color: Color(0xffb3b3b3)),
                        )),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 20),

            // Add button
            Center(
              child: ElevatedButton(
                onPressed: isLoading
                    ? null
                    : () async {
                        if (_image == null) {
                          showMessage("Please fill necessary details");
                          log("Please fill all the fields");

                          setState(() {
                            isLoading = false;
                          });

                          return;
                        }

                        setState(() {
                          isLoading = true;
                        });

                        await addNewBanner(context);

                        setState(() {
                          isLoading = false;
                        });

                        Navigator.pop(context, true);
                      },
                style: ElevatedButton.styleFrom(
                  backgroundColor: isLoading ? Colors.black.withOpacity(0.3) : Colors.black, // Set the color directly
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                  textStyle: const TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                ),
                child: isLoading
                    ? const CircularProgressIndicator(
                        color: Colors.white,
                        strokeWidth: 2,
                      )
                    : const Text(
                        "Add",
                        style: TextStyle(
                          color: Color(0xffb3b3b3),
                          fontFamily: 'Gilroy-Bold',
                        ),
                      ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
