import 'dart:convert';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/address_model.dart';
import '../shared/show_msg.dart';

class AddressProvider with ChangeNotifier {
  final List<Address> _addressList = [];

  List<Address> get address => _addressList;

  AddressProvider() {
    loadAddresses();
  }

  void addAddress(Address userAdd) async {
    final index = _addressList.indexWhere((address) => address.flat == userAdd.flat);
    if (index >= 0) {
      _addressList[index] = userAdd;
    } else {
      _addressList.add(userAdd);

      String jsonAddress = json.encode(userAdd.toJson());

      SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.setString('address_${userAdd.flat}', jsonAddress);

      showMessage("Address Saved!");
      log("Address: ${_addressList.map((add) => {
        "Flat: ${add.flat}  | Floor: ${add.floor} | Landmark: ${add.mylandmark} | Phone: ${add.phoneNumber}"
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
    notifyListeners();
  }
}