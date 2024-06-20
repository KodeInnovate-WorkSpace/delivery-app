import 'dart:convert';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/address_model.dart';
import '../shared/show_msg.dart';
import 'address_provider.dart';

class AddressPicker with ChangeNotifier {

  String _defaultAdd = "No address available";
  String _newAdd = '';


}