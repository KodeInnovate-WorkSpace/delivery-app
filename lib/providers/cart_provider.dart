
import 'package:flutter/cupertino.dart';

import '../models/category_model.dart';

class CartProvider extends ChangeNotifier {
  final bool _isLoading = false;

  final List<Product> _products = [];
  List<Product> get products => _products;
  bool get isLoading => _isLoading;


}
