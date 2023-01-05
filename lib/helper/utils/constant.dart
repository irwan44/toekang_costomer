import 'package:egrocer/helper/sessionManager.dart';
import 'package:firebase_dynamic_links/firebase_dynamic_links.dart';
import 'package:flutter/material.dart';

import 'apiAndParams.dart';
import 'stringsRes.dart';

enum NetworkStatus { Online, Offline }

class Constant {
  static String hostUrl = "https://egrocer.wrteam.in/";

  static String baseUrl = "${hostUrl}customer/";
  static String packageName = "com.wrteam.egrocer";
  static String appStoreUrl = "place_app_store_url_here";
  static String playStoreUrl =
      "https://play.google.com/store/apps/details?id=$packageName";

  static String appStoreId = "app_store_id_here";

  static String deepLinkPrefix = "https://egrocer.page.link";

  static String deepLinkName = "eGrocer";

  static FirebaseDynamicLinks firebaseDynamicLinksInstance =
      FirebaseDynamicLinks.instance;

  //google api keys
  static String googleApiKey = "";
  static String currencyCode = "";
  static String decimalPoints = "";
  static int homeCategoryMinLength = 6;

  static int defaultDataLoadLimitAtOnce = 20;

  static String selectedCoupon = "";
  static double discountedAmount = 0.0;
  static double discount = 0.0;
  static bool isPromoCodeApplied = false;

  static BorderRadius borderRadius5 = BorderRadius.circular(5);
  static BorderRadius borderRadius7 = BorderRadius.circular(7);
  static BorderRadius borderRadius10 = BorderRadius.circular(10);
  static BorderRadius borderRadius13 = BorderRadius.circular(13);

  static late SessionManager session;
  static List<String> searchedItemsHistoryList = [];

//authenticationScreen with phone constants
  static int otpTimeOutSecond = 60; //otp time out
  static int otpResendSecond = 60; // resend otp timer

  static int searchHistoryListLimit = 20; // resend otp timer

  static String initialCountryCode =
      "IN"; // initial country code, change as per your requirement

  // Theme list, This system default names please do not change at all
  static List<String> themeList = ["System default", "Light", "Dark"];

  //supported languages
  //https://developers.google.com/admin-sdk/directory/v1/languages
  static List<String> supportedLanguages = [
    'en',
    'hi',
    'bn',
    'ar',
    'ur',
    'es',
    'fr',
    'pt',
    'ru'
  ];

  static Map languageNames = {
    'en': 'English',
    'hi': 'Hindi',
    'bn': 'Bengali',
    'ar': 'Arabic',
    'ur': 'Urdu',
    'es': 'Spanish',
    'fr': 'French',
    'pt': 'Portuguese',
    'ru': 'Russian'
  };
  static String defaultLangCode = 'en';

//Order statues codes
  static List<String> orderStatusCode = [
    "1" /*Awaiting Payment*/,
    "2" /*Received*/,
    "3" /*Processed*/,
    "4" /*Shipped*/,
    "5" /*Out For Delivery*/,
    "6" /*Delivered*/,
    "7" /*Cancelled*/,
    "8" /*Returned*/
  ];

//Address types
  static Map addressTypes = {
    "home": StringsRes.lblAddressTypeHome,
    "office": StringsRes.lblAddressTypeOffice,
    "other": StringsRes.lblAddressTypeOther,
  };

  static Map cityAddressMap = {};

  //authenticationScreen type
  static String authTypePhone = "mobile";

  // App Settings
  static List<int> favorits = [];
  static String currentVersion = "";
  static String minimumVersionRequired = "";
  static String currency = "";
  static String maxAllowItemsInCart = "";
  static String minimumOrderAmount = "";
  static String minimumReferEarnOrderAmount = "";
  static String referEarnBonus = "";
  static String maximumReferEarnAmount = "";
  static String minimumWithdrawalAmount = "";
  static String maximumProductReturnDays = "";
  static String userWalletRefillLimit = "";
  static String isVersionSystemOn = "";
  static String isReferEarnOn = "";
  static String referEarnMethod = "";
  static String privacyPolicy = "";
  static String termsConditions = "";
  static String aboutUs = "";
  static String contactUs = "";
  static String returnAndExchangesPolicy = "";
  static String cancellationPolicy = "";
  static String shippingPolicy = "";

  static String getAssetsPath(int folder, String filename) {
    //0-image,1-svg,2-language,3-animation

    String path = "";
    switch (folder) {
      case 0:
        path = "assets/images/$filename";
        break;
      case 1:
        path = "assets/svg/$filename.svg";
        break;
      case 2:
        path = "assets/language/$filename.json";
        break;
      case 3:
        path = "assets/animation/$filename.json";
        break;
    }

    return path;
  }

  //Default padding and margin variables

  static double paddingOrMargin2 = 2.00;
  static double paddingOrMargin3 = 3.00;
  static double paddingOrMargin5 = 5.00;
  static double paddingOrMargin7 = 7.00;
  static double paddingOrMargin8 = 8.00;
  static double paddingOrMargin10 = 10.00;
  static double paddingOrMargin12 = 12.00;
  static double paddingOrMargin14 = 14.00;
  static double paddingOrMargin15 = 15.00;
  static double paddingOrMargin18 = 18.00;
  static double paddingOrMargin20 = 20.00;
  static double paddingOrMargin25 = 20.00;
  static double paddingOrMargin30 = 30.00;
  static double paddingOrMargin40 = 40.00;

  static Future<Map<String, String>> getProductsDefaultParams() async {
    Map<String, String> params = {};
    params[ApiAndParams.cityId] =
        Constant.session.getData(SessionManager.keyCityId);
    params[ApiAndParams.latitude] =
        Constant.session.getData(SessionManager.keyLatitude);
    params[ApiAndParams.longitude] =
        Constant.session.getData(SessionManager.keyLongitude);
    return params;
  }

  static Future<String> getGetMethodUrlWithParams(
      String mainUrl, Map params) async {
    if (params.isNotEmpty) {
      mainUrl = "$mainUrl?";
      for (int i = 0; i < params.length; i++) {
        mainUrl =
            "$mainUrl${i == 0 ? "" : "&"}${params.keys.toList()[i]}=${params.values.toList()[i]}";
      }
    }

    return mainUrl;
  }

  /// Intro slider list ...
  /// You can add or remove items from below list as well
  /// Add svg images into asset > svg folder and set name here without any extension and image should not contains space
  static List introSlider = [
    {
      "image": "location",
      "title": StringsRes.lblIntroTitle1,
      "description": StringsRes.lblIntroDesc1,
    },
    {
      "image": "order",
      "title": StringsRes.lblIntroTitle2,
      "description": StringsRes.lblIntroDesc2,
    },
    {
      "image": "delivered",
      "title": StringsRes.lblIntroTitle3,
      "description": StringsRes.lblIntroDesc3,
    },
  ];

  static List<String> selectedBrands = [];
  static List<String> selectedSizes = [];
  static RangeValues currentRangeValues = RangeValues(0, 0);

  static String getOrderActiveStatusLabelFromCode(String value) {
    if (value.isEmpty) {
      return value;
    }
    /*
      1 -> Payment pending
      2 -> Received
      3 -> Processed
      4 -> Shipped
      5 -> Out For Delivery
      6 -> Delivered
      7 -> Cancelled
      8 -> Returned
     */

    if (value == "1") {
      return "Payment pending";
    }
    if (value == "2") {
      return "Received";
    }
    if (value == "3") {
      return "Confirmed";
    }
    if (value == "4") {
      return "Shipped";
    }
    if (value == "5") {
      return "Out For Delivery";
    }
    if (value == "6") {
      return "Delivered";
    }
    if (value == "7") {
      return "Cancelled";
    }
    return "Returned";
  }

  static resetTempFilters() {
    selectedBrands = [];
    selectedSizes = [];
    currentRangeValues = RangeValues(0, 0);
  }

  //apis
  // https://maps.googleapis.com/maps/api/place/nearbysearch/json?location=-33.8670,151.1957&radius=500&types=food&name=cruise&key=API_KEY

  static String apiGeoCode =
      "https://maps.googleapis.com/maps/api/geocode/json?key=$googleApiKey&latlng=";
}
