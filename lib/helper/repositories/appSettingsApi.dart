import 'dart:convert';

import 'package:egrocer/helper/utils/apiAndParams.dart';
import 'package:egrocer/helper/utils/constant.dart';
import 'package:egrocer/helper/utils/generalMethods.dart';
import 'package:egrocer/models/settings.dart';
import 'package:flutter/material.dart';

Future getAppSettings({required BuildContext context}) async {
  var response = await GeneralMethods.sendApiRequest(
      apiName: ApiAndParams.apiAppSettings,
      params: {},
      isPost: false,
      context: context);
  Map<String, dynamic> getData = json.decode(response);
  if (getData[ApiAndParams.status] == 1) {
    Settings settings = Settings.fromJson(getData[ApiAndParams.data]);

    Constant.favorits = settings.favoriteProductIds;
    Constant.currentVersion =
        settings.currentVersion.isEmpty ? "1.0.0" : settings.currentVersion;
    Constant.minimumVersionRequired = settings.minimumVersionRequired;
    Constant.currency = settings.currency;
    Constant.maxAllowItemsInCart = settings.maxCartItemsCount;
    Constant.minimumOrderAmount = settings.minOrderAmount;
    Constant.minimumReferEarnOrderAmount = settings.minReferEarnOrderAmount;
    Constant.referEarnBonus = settings.referEarnBonus;
    Constant.maximumReferEarnAmount = settings.maxReferEarnAmount;
    Constant.minimumWithdrawalAmount = settings.minimumWithdrawalAmount;
    Constant.maximumProductReturnDays = settings.maxProductReturnDays;
    Constant.userWalletRefillLimit = settings.userWalletRefillLimit;
    Constant.isVersionSystemOn = settings.isVersionSystemOn;
    Constant.isReferEarnOn = settings.isReferEarnOn;
    Constant.referEarnMethod = settings.referEarnMethod;
    Constant.privacyPolicy = settings.privacyPolicy;
    Constant.termsConditions = settings.termsConditions;
    Constant.aboutUs = settings.aboutUs;
    Constant.contactUs = settings.contactUs;
    Constant.returnAndExchangesPolicy = settings.returnsAndExchangesPolicy;
    Constant.cancellationPolicy = settings.cancellationPolicy;
    Constant.shippingPolicy = settings.shippingPolicy;
    Constant.googleApiKey = /*"AIzaSyCVnWA3-SBaCiGNDqe2hZbUn46JheN2r_E"*/
        settings.googlePlaceApiKey;
    Constant.currencyCode = settings.currencyCode;
    Constant.decimalPoints = settings.decimalPoints;
    return true;
  } else {
    return false;
  }
}
