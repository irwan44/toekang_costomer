import 'dart:convert';

import 'package:egrocer/helper/utils/apiAndParams.dart';
import 'package:egrocer/helper/utils/generalMethods.dart';
import 'package:flutter/material.dart';

Future<Map<String, dynamic>> getAddressApi(
    {required BuildContext context,
    required Map<String, dynamic> params}) async {
  var response = await GeneralMethods.sendApiRequest(
      apiName: ApiAndParams.apiAddress,
      params: params,
      isPost: false,
      context: context);

  return json.decode(response);
}

Future<Map<String, dynamic>> addAddressApi(
    {required BuildContext context,
    required Map<String, dynamic> params}) async {
  var response = await GeneralMethods.sendApiRequest(
      apiName: ApiAndParams.apiAddressAdd,
      params: params,
      isPost: true,
      context: context);

  return json.decode(response);
}

Future<Map<String, dynamic>> updateAddressApi(
    {required BuildContext context,
    required Map<String, dynamic> params}) async {
  var response = await GeneralMethods.sendApiRequest(
      apiName: ApiAndParams.apiAddressUpdate,
      params: params,
      isPost: true,
      context: context);

  return json.decode(response);
}

Future<Map<String, dynamic>> deleteAddressApi(
    {required BuildContext context,
    required Map<String, dynamic> params}) async {
  var response = await GeneralMethods.sendApiRequest(
      apiName: ApiAndParams.apiAddressRemove,
      params: params,
      isPost: true,
      context: context);

  return json.decode(response);
}
