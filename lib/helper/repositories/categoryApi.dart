import 'dart:convert';

import 'package:egrocer/helper/utils/apiAndParams.dart';
import 'package:egrocer/helper/utils/generalMethods.dart';
import 'package:egrocer/models/homeScreenData.dart';
import 'package:flutter/material.dart';

Future<List<Category>> getCategoryList(
    {required BuildContext context,
    required Map<String, String> params}) async {
  var response = await GeneralMethods.sendApiRequest(
      apiName: ApiAndParams.apiCategories,
      params: params,
      isPost: false,
      context: context);
  Map getData = json.decode(response);
  if (getData[ApiAndParams.status] == 1) {
    return (getData['data'] as List).map((e) => Category.fromJson(e)).toList();
  } else {
    return [];
  }
}
