import 'dart:convert';

import 'package:egrocer/helper/utils/generalMethods.dart';
import 'package:flutter/material.dart';

Future<Map<String, dynamic>> getUpdateProfileApi(
    {required String apiName,
    required Map<String, String> params,
    required List<String> fileParamsNames,
    required List<String> fileParamsFilesPath,
    required BuildContext context}) async {
  var response = await GeneralMethods.sendApiMultiPartRequest(
      apiName: apiName,
      params: params,
      fileParamsNames: fileParamsNames,
      fileParamsFilesPath: fileParamsFilesPath,
      context: context);

  Map<String, dynamic> mainData = await json.decode(response);

  return mainData;
}
