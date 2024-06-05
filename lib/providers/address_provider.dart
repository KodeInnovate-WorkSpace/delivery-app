import 'dart:convert';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:speedy_delivery/services/convert_to_json.dart';
import 'package:speedy_delivery/shared/show_msg.dart';
import '../models/address_model.dart';

class AddressProvider with ChangeNotifier {
  final List<Address> _addressList = [];

  // Getter for addressList
  List<Address> get address => _addressList;

  AddressProvider() {
    loadAddresses();
  }

  void addAddress(Address userAdd) async {
    final index =
        _addressList.indexWhere((address) => address.flat == userAdd.flat);
    if (index >= 0) {
      _addressList[index] = userAdd;
    } else {
      _addressList.add(userAdd);

      // Convert the address to json
      String jsonAddress = addressToJson(userAdd);

      // Store in shared preferences
      SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.setString('address_${userAdd.flat}', jsonAddress);

      // Show message
      showMessage("Address Saved!");
      log("Address: ${_addressList.map((add) => {
            "Flat: ${add.flat}  | Floor: ${add.floor} | Landmark: ${add.mylandmark}"
          })}");
    }
    notifyListeners();
  }

  void removeAddress(Address userAdd) async {
    final index =
        _addressList.indexWhere((address) => address.flat == userAdd.flat);
    if (index >= 0) {
      _addressList.removeAt(index);

      // Remove from shared preferences
      SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.remove('address_${userAdd.flat}');

      notifyListeners();
    }
  }

  Future<Address?> getAddress(String flat) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? addressJson = prefs.getString('address_$flat');
    if (addressJson != null) {
      Map<String, dynamic> addressMap = json.decode(addressJson);
      return Address(
        flat: addressMap['flat'],
        floor: addressMap['floor'],
        mylandmark: addressMap['mylandmark'],
        // Add other fields as necessary
      );
    }
    return null;
  }

  Future<void> loadAddresses() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final keys = prefs.getKeys();

    _addressList.clear();
    for (String key in keys) {
      if (key.startsWith('address_')) {
        String? addressJson = prefs.getString(key);
        if (addressJson != null) {
          Map<String, dynamic> addressMap = json.decode(addressJson);
          _addressList.add(Address(
            flat: addressMap['flat'],
            floor: addressMap['floor'],
            mylandmark: addressMap['mylandmark'],
            // Add other fields as necessary
          ));
        }
      }
    }
    notifyListeners();
  }
}
