import 'dart:convert';

import 'package:egrocer/helper/utils/apiAndParams.dart';
import 'package:egrocer/helper/utils/generalMethods.dart';
import 'package:flutter/material.dart';

Future<Map<String, dynamic>> getInitiatedTransactionApi(
    {required BuildContext context,
    required Map<String, dynamic> params}) async {
  var response = await GeneralMethods.sendApiRequest(
      apiName: ApiAndParams.apiInitiateTransaction,
      params: params,
      isPost: true,
      context: context);
  return json.decode(response);
}
