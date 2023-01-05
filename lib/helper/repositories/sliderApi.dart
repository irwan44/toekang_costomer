import 'dart:convert';

import 'package:egrocer/helper/utils/apiAndParams.dart';
import 'package:egrocer/helper/utils/generalMethods.dart';
import 'package:egrocer/models/homeScreenData.dart';
import 'package:flutter/material.dart';

Future getSliderList({required BuildContext context}) async {
  var response = await GeneralMethods.sendApiRequest(
      apiName: ApiAndParams.apiSliders,
      params: {},
      isPost: false,
      context: context);
  Map getData = json.decode(response);
  if (getData[ApiAndParams.status] == 1) {
    return (getData['data'] as List).map((e) => Sliders.fromJson(e)).toList();
  } else {
    return [];
  }
}
