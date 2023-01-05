import 'dart:convert';

import 'package:egrocer/helper/utils/generalMethods.dart';
import 'package:flutter/material.dart';

Future<Map<String, dynamic>> getPaystackTransactionDetailApi(
    {required BuildContext context,
    required String paystackChargeReference,
    required String paystackSecretKey}) async {
  var response = await GeneralMethods.getPaystackTransactionDetail(
      context: context,
      paystackChargeReference: paystackChargeReference,
      paystackSecretKey: paystackSecretKey);
  return json.decode(response);
}
