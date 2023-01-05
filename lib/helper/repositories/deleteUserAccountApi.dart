import 'dart:convert';

import 'package:egrocer/helper/sessionManager.dart';
import 'package:egrocer/helper/utils/apiAndParams.dart';
import 'package:egrocer/helper/utils/constant.dart';
import 'package:egrocer/helper/utils/generalMethods.dart';
import 'package:flutter/material.dart';

Future<Map<String, dynamic>> getDeleteAccountApi(
    {required BuildContext context}) async {
  var response = await GeneralMethods.sendApiRequest(
      apiName: ApiAndParams.apiDeleteAccount,
      params: {
        ApiAndParams.authUid:
            Constant.session.getData(SessionManager.keyAuthUid)
      },
      isPost: true,
      context: context);
  Map<String, dynamic> mainData = await json.decode(response);
  return mainData;
}
