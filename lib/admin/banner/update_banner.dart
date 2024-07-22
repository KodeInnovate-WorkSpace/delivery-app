import 'dart:developer';
import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:speedy_delivery/widget/input_box.dart';

import '../../shared/show_msg.dart';
import '../admin_model.dart';

class UpdateBanner extends StatefulWidget {
  final Map<String, dynamic> data;

  const UpdateBanner({super.key, required this.data});

  @override
  State<UpdateBanner> createState() => _UpdateBannerState();
}

class _UpdateBannerState extends State<UpdateBanner> {
  int? dropdownValue = 1;
  final List<int> banners = [];
  int? selectedBanner;
  final TextEditingController bannerController = TextEditingController();
  final TextEditingController priorityController = TextEditingController();
  final BannerModel bannerModel = BannerModel();
  List<int> statusOptions = [0, 1]; // 0 for inactive, 1 for active

  File? _image;
  final TextEditingController imageController = TextEditingController();

  bool isLoading = false;
  @override
  void initState() {
    super.initState();
    bannerController.text = widget.data['image'];
    priorityController.text = widget.data['priority'].toString();
    dropdownValue = widget.data['status'];
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

  Future<void> updateBanner() async {
    try {
      // If an image is selected, upload it and get the URL
      String? imageUrl;
      if (_image != null) {
        imageUrl = await uploadImage(_image!);
      }

      // Update the banner fields
      await bannerModel.newupdateBanner(
        'priority',
        int.parse(priorityController.text),
        bannerId: widget.data['id'].toString(),
      );
      await bannerModel.newupdateBanner(
        'status',
        dropdownValue,
        bannerId: widget.data['id'].toString(),
      );

      if (imageUrl != null) {
        await bannerModel.newupdateBanner(
          'image',
          imageUrl,
          bannerId: widget.data['id'].toString(),
        );
      }

      Navigator.pop(context, true);
    } catch (e) {
      log("Error updating banner: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Update Banner',
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
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Image
              _image != null
                  ? Image.file(_image!, height: 100, width: 100)
                  : const Text(
                      "No image selected",
                      style: TextStyle(color: Color(0xffb3b3b3)),
                    ),

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

              // Update Priority
              InputBox(
                hintText: "Update Priority",
                myIcon: Icons.sort,
                myController: priorityController,
                keyboardType: TextInputType.text,
              ),

              // status dropdown
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    "Status: ",
                    style: TextStyle(color: Color(0xffb3b3b3)),
                  ),
                  DropdownButton<int>(
                    value: dropdownValue, // Use the state variable here
                    onChanged: (int? newValue) {
                      setState(() {
                        dropdownValue = newValue!; // Update state on change
                      });
                    },
                    items: statusOptions.map<DropdownMenuItem<int>>((int status) {
                      return DropdownMenuItem<int>(
                        value: status,
                        child: Text(
                          status == 0 ? 'Inactive' : 'Active',
                          style: const TextStyle(color: Color(0xffb3b3b3)),
                        ),
                      );
                    }).toList(),
                  ),
                ],
              ),
              const SizedBox(height: 20),

              const SizedBox(height: 20),
              //Button
              Center(
                child: ElevatedButton(
                  onPressed: isLoading
                      ? null
                      : () {
                          updateBanner();
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
                          "Update",
                          style: TextStyle(
                            color: Color(0xffb3b3b3),
                            fontFamily: 'Gilroy-Bold',
                          ),
                        ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
