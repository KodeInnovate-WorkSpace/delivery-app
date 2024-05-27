import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';

import '../models/category_model.dart';

class CartProvider extends ChangeNotifier {
  bool _isLoading = false;

  List<Product> _products = [];
  List<Product> get products => _products;
  bool get isLoading => _isLoading;


}
