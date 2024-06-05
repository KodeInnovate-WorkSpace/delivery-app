import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:speedy_delivery/shared/show_msg.dart';
import '../models/address_model.dart';

class AddressProvider with ChangeNotifier {
  final List<Address> _addressList = [];

  // Getter for addressList
  List<Address> get address => _addressList;

  void addAddress(Address userAdd) {
    final index =
        _addressList.indexWhere((address) => address.flat == userAdd.flat);
    if (index >= 0) {
      _addressList[index] = userAdd;
    } else {
      _addressList.add(userAdd);
      showMessage("Address Saved!");
      log("Address: ${_addressList.map((add)=>{ "Flat: ${add.flat}  | Floor: ${add.floor} | Landmark: ${add.mylandmark}" })}");
    }
    notifyListeners();
  }

  void removeAddress(Address userAdd) {
    final index =
        _addressList.indexWhere((address) => address.flat == userAdd.flat);
    if (index >= 0) {
      _addressList.removeAt(index);
      notifyListeners();
    }
  }
}
