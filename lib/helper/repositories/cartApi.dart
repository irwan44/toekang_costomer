import 'dart:convert';

import 'package:egrocer/helper/utils/apiAndParams.dart';
import 'package:egrocer/helper/utils/generalMethods.dart';
import 'package:flutter/material.dart';

Future<Map<String, dynamic>> getCartListApi(
    {required BuildContext context,
    required Map<String, dynamic> params}) async {
  var response = await GeneralMethods.sendApiRequest(
      apiName: ApiAndParams.apiCart,
      params: params,
      isPost: false,
      context: context);
  return json.decode(response);
}

Future<Map<String, dynamic>> addItemToCartApi(
    {required BuildContext context,
    required Map<String, dynamic> params}) async {
  var response = await GeneralMethods.sendApiRequest(
      apiName: ApiAndParams.apiCartAdd,
      params: params,
      isPost: true,
      context: context);
  return json.decode(response);
}

Future<Map<String, dynamic>> removeItemFromCartApi(
    {required BuildContext context,
    required Map<String, dynamic> params}) async {
  var response = await GeneralMethods.sendApiRequest(
      apiName: ApiAndParams.apiCartRemove,
      params: params,
      isPost: true,
      context: context);

  return json.decode(response);
}
