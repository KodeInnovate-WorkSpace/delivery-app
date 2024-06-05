import 'dart:convert';

import '../models/address_model.dart';

String addressToJson(Address address) {
  return json.encode({
    'flat': address.flat,
    'floor': address.floor,
    'mylandmark': address.mylandmark,
    // Add other fields as necessary
  });
}
