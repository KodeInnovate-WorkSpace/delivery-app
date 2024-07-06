import 'dart:convert';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/address_model.dart';
import '../shared/show_msg.dart';

class AddressProvider with ChangeNotifier {
  final List<Address> _addressList = [];
  String _selectedAddress = "";

  List<Address> get address => _addressList;
  String get selectedAddress => _selectedAddress;

  AddressProvider() {
    loadAddresses();
  }

  void addAddress(Address userAdd) async {
    bool addressExists = _addressList.any((address) =>
    address.flat == userAdd.flat &&
        address.floor == userAdd.floor &&
        address.building == userAdd.building &&
        address.mylandmark == userAdd.mylandmark &&
        address.phoneNumber == userAdd.phoneNumber &&
        address.pincode == userAdd.pincode &&
        address.area == userAdd.area); // Check for existing address

    if (addressExists) {
      final index = _addressList.indexWhere((address) =>
      address.flat == userAdd.flat &&
          address.floor == userAdd.floor &&
          address.building == userAdd.building &&
          address.mylandmark == userAdd.mylandmark &&
          address.phoneNumber == userAdd.phoneNumber &&
          address.pincode == userAdd.pincode &&
          address.area == userAdd.area);

      _addressList[index] = userAdd;
      showMessage("Address Updated!");
    } else {
      _addressList.add(userAdd);

      String jsonAddress = json.encode(userAdd.toJson());

      SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.setString('address_${userAdd.flat}', jsonAddress);

      setSelectedAddress(
          "${userAdd.flat}, ${userAdd.building}, ${userAdd.mylandmark}");

      showMessage("Address Saved!");
      log("Address: ${_addressList.map((add) => {
        "Flat: ${add.flat}  | Floor: ${add.floor} | Landmark: ${add.mylandmark} | Phone: ${add.phoneNumber} | Pincode: ${add.pincode} | Area: ${add.area}"
      })}");
    }
    notifyListeners();
  }

  void removeAddress(Address userAdd) async {
    final index = _addressList.indexWhere((address) => address.flat == userAdd.flat);
    if (index >= 0) {
      _addressList.removeAt(index);

      SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.remove('address_${userAdd.flat}');

      if (_selectedAddress.contains(userAdd.flat)) {
        // Clear the selected address if it was the one being removed
        _selectedAddress = "";

        // Automatically select another address if available
        if (_addressList.isNotEmpty) {
          final newAddress = _addressList.first;
          _selectedAddress = "${newAddress.flat}, ${newAddress.building}, ${newAddress.mylandmark}";
        }
      }

      // Save the selected address in SharedPreferences
      await prefs.setString('selected_address', _selectedAddress);

      notifyListeners();
    }
  }

  Future<Address?> getAddress(String flat) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? addressJson = prefs.getString('address_$flat');
    if (addressJson != null) {
      Map<String, dynamic> addressMap = json.decode(addressJson);
      return Address.fromJson(addressMap);
    }
    return null;
  }

  Future<void> loadAddresses() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final keys = prefs.getKeys();

    _addressList.clear();
    for (String key in keys) {
      if (key.startsWith('address_')) {
        String? jsonAddress = prefs.getString(key);
        if (jsonAddress != null) {
          Map<String, dynamic> addressMap = json.decode(jsonAddress);
          _addressList.add(Address.fromJson(addressMap));
        }
      }
    }

    String? selectedAddress = prefs.getString('selected_address');
    if (selectedAddress != null) {
      _selectedAddress = selectedAddress;
    }

    notifyListeners();
  }

  void clearAddress() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    // Remove all address entries from SharedPreferences
    final keys = prefs.getKeys();
    for (String key in keys) {
      if (key.startsWith('address_')) {
        await prefs.remove(key);
      }
    }

    // Clear the in-memory address list
    _addressList.clear();

    // Clear the selected address
    _selectedAddress = "";
    await prefs.remove('selected_address');

    notifyListeners();
  }

  void setSelectedAddress(String address) async {
    _selectedAddress = address;
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('selected_address', _selectedAddress);
    notifyListeners();
  }
}