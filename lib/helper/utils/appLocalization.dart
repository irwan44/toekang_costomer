import 'dart:convert';

import 'package:egrocer/helper/utils/constant.dart';
import 'package:egrocer/helper/utils/generalMethods.dart';
import 'package:egrocer/helper/utils/stringsRes.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';

//

//For localization of app
class AppLocalization {
  final Locale locale;

  //it will hold key of text and it's values in given language
  // late Map<String, String> _localizedValues;
  late Map<String, dynamic> localizedValues;

  AppLocalization(this.locale);

  //to access applocalization instance any where in app using context
  static AppLocalization? of(BuildContext context) {
    return Localizations.of(context, AppLocalization);
  }

  //to load json(language) from assets
  Future loadJson() async {
    String languageJsonName = locale.countryCode == null
        ? locale.languageCode
        : "${locale.languageCode}-${locale.countryCode}";
    String jsonStringValues = await rootBundle
        .loadString(Constant.getAssetsPath(2, languageJsonName));
    //value from rootbundle will be encoded string
    Map<String, dynamic> mappedJson = json.decode(jsonStringValues);

    localizedValues = mappedJson;

    translateLabels(mappedJson);
  }

  static translateLabels(Map localizedValues) {
    if (localizedValues.isNotEmpty) {
      StringsRes.appName = localizedValues['appName'] ?? StringsRes.appName;
      StringsRes.lblIntroTitle1 =
          localizedValues['lblIntroTitle1'] ?? StringsRes.lblIntroTitle1;
      StringsRes.lblIntroTitle2 =
          localizedValues['lblIntroTitle2'] ?? StringsRes.lblIntroTitle2;
      StringsRes.lblIntroTitle3 =
          localizedValues['lblIntroTitle3'] ?? StringsRes.lblIntroTitle3;
      StringsRes.lblIntroDesc1 =
          localizedValues['lblIntroDesc1'] ?? StringsRes.lblIntroDesc1;
      StringsRes.lblIntroDesc2 =
          localizedValues['lblIntroDesc2'] ?? StringsRes.lblIntroDesc2;
      StringsRes.lblIntroDesc3 =
          localizedValues['lblIntroDesc3'] ?? StringsRes.lblIntroDesc3;
      StringsRes.lblGetStarted =
          localizedValues['lblGetStarted'] ?? StringsRes.lblGetStarted;
      StringsRes.lblSkipLogin =
          localizedValues['lblSkipLogin'] ?? StringsRes.lblSkipLogin;
      StringsRes.lblLogin = localizedValues['lblLogin'] ?? StringsRes.lblLogin;
      StringsRes.lblWelcome =
          localizedValues['lblWelcome'] ?? StringsRes.lblWelcome;
      StringsRes.lblLoginEnterNumberMessage =
          localizedValues['lblLoginEnterNumberMessage'] ??
              StringsRes.lblLoginEnterNumberMessage;
      StringsRes.lblAgreementMsg1 =
          localizedValues['lblAgreementMsg1'] ?? StringsRes.lblAgreementMsg1;
      StringsRes.lblTermsOfService =
          localizedValues['lblTermsOfService'] ?? StringsRes.lblTermsOfService;
      StringsRes.lblPrivacyPolicy =
          localizedValues['lblPrivacyPolicy'] ?? StringsRes.lblPrivacyPolicy;
      StringsRes.lblPolicies =
          localizedValues['lblPolicies'] ?? StringsRes.lblPolicies;
      StringsRes.lblAnd = localizedValues['lblAnd'] ?? StringsRes.lblAnd;
      StringsRes.lblEnterValidMobile = localizedValues['lblEnterValidMobile'] ??
          StringsRes.lblEnterValidMobile;
      StringsRes.lblCheckInternet =
          localizedValues['lblCheckInternet'] ?? StringsRes.lblCheckInternet;
      StringsRes.lblSomethingWentWrong =
          localizedValues['lblSomethingWentWrong'] ??
              StringsRes.lblSomethingWentWrong;
      StringsRes.lblEnterVerificationCode =
          localizedValues['lblEnterVerificationCode'] ??
              StringsRes.lblEnterVerificationCode;
      StringsRes.lblOtpSendMessage =
          localizedValues['lblOtpSendMessage'] ?? StringsRes.lblOtpSendMessage;
      StringsRes.lblVerifyAndProceed = localizedValues['lblVerifyAndProceed'] ??
          StringsRes.lblVerifyAndProceed;
      StringsRes.lblDidNotGetCode =
          localizedValues['lblDidNotGetCode'] ?? StringsRes.lblDidNotGetCode;
      StringsRes.lblResendOtp =
          localizedValues['lblResendOtp'] ?? StringsRes.lblResendOtp;
      StringsRes.lblEnterOtp =
          localizedValues['lblEnterOtp'] ?? StringsRes.lblEnterOtp;
      StringsRes.lblHomeBottomMenu =
          localizedValues['lblHomeBottomMenu'] ?? StringsRes.lblHomeBottomMenu;
      StringsRes.lblProfile =
          localizedValues['lblProfile'] ?? StringsRes.lblProfile;
      StringsRes.lblAllOrders =
          localizedValues['lblAllOrders'] ?? StringsRes.lblAllOrders;
      StringsRes.lblWallet =
          localizedValues['lblWallet'] ?? StringsRes.lblWallet;
      StringsRes.lblAddress =
          localizedValues['lblAddress'] ?? StringsRes.lblAddress;
      StringsRes.lblChangeTheme =
          localizedValues['lblChangeTheme'] ?? StringsRes.lblChangeTheme;
      StringsRes.lblChangeLanguage =
          localizedValues['lblChangeLanguage'] ?? StringsRes.lblChangeLanguage;
      StringsRes.lblSelectLocation =
          localizedValues['lblSelectLocation'] ?? StringsRes.lblSelectLocation;
      StringsRes.lblProductDetail =
          localizedValues['lblProductDetail'] ?? StringsRes.lblProductDetail;
      StringsRes.lblHowItWorks =
          localizedValues['lblHowItWorks'] ?? StringsRes.lblHowItWorks;
      StringsRes.lblNotification =
          localizedValues['lblNotification'] ?? StringsRes.lblNotification;
      StringsRes.lblEmptyNotificationListMessage =
          localizedValues['lblEmptyNotificationListMessage'] ??
              StringsRes.lblEmptyNotificationListMessage;
      StringsRes.lblEmptyNotificationListDescription =
          localizedValues['lblEmptyNotificationListDescription'] ??
              StringsRes.lblEmptyNotificationListDescription;
      StringsRes.lblEmptyWishListMessage =
          localizedValues['lblEmptyWishListMessage'] ??
              StringsRes.lblEmptyWishListMessage;
      StringsRes.lblEmptyWishListDescription =
          localizedValues['lblEmptyWishListDescription'] ??
              StringsRes.lblEmptyWishListDescription;
      StringsRes.lblEmptyProductListMessage =
          localizedValues['lblEmptyProductListMessage'] ??
              StringsRes.lblEmptyProductListMessage;
      StringsRes.lblEmptyProductListDescription =
          localizedValues['lblEmptyProductListDescription'] ??
              StringsRes.lblEmptyProductListDescription;
      StringsRes.lblDoesNotDeliveryLongMessage =
          localizedValues['lblDoesNotDeliveryLongMessage'] ??
              StringsRes.lblDoesNotDeliveryLongMessage;
      StringsRes.lblSorry = localizedValues['lblSorry'] ?? StringsRes.lblSorry;
      StringsRes.lblChangeLocation =
          localizedValues['lblChangeLocation'] ?? StringsRes.lblChangeLocation;
      StringsRes.lblTransactionHistory =
          localizedValues['lblTransactionHistory'] ??
              StringsRes.lblTransactionHistory;
      StringsRes.lblReferAndEarn =
          localizedValues['lblReferAndEarn'] ?? StringsRes.lblReferAndEarn;
      StringsRes.lblContactUs =
          localizedValues['lblContactUs'] ?? StringsRes.lblContactUs;
      StringsRes.lblAboutUs =
          localizedValues['lblAboutUs'] ?? StringsRes.lblAboutUs;
      StringsRes.lblRateUs =
          localizedValues['lblRateUs'] ?? StringsRes.lblRateUs;
      StringsRes.lblShareApp =
          localizedValues['lblShareApp'] ?? StringsRes.lblShareApp;
      StringsRes.lblFAQ = localizedValues['lblFAQ'] ?? StringsRes.lblFAQ;
      StringsRes.lblTransactions =
          localizedValues['lblTransactions'] ?? StringsRes.lblTransactions;
      StringsRes.lblTermsAndConditions =
          localizedValues['lblTermsAndConditions'] ??
              StringsRes.lblTermsAndConditions;
      StringsRes.lblLogout =
          localizedValues['lblLogout'] ?? StringsRes.lblLogout;
      StringsRes.lblEditProfile =
          localizedValues['lblEditProfile'] ?? StringsRes.lblEditProfile;
      StringsRes.lblEnterValidEmail = localizedValues['lblEnterValidEmail'] ??
          StringsRes.lblEnterValidEmail;
      StringsRes.lblUserName =
          localizedValues['lblUserName'] ?? StringsRes.lblUserName;
      StringsRes.lblEnterUserName =
          localizedValues['lblEnterUserName'] ?? StringsRes.lblEnterUserName;
      StringsRes.lblEmail = localizedValues['lblEmail'] ?? StringsRes.lblEmail;
      StringsRes.lblMobileNumber =
          localizedValues['lblMobileNumber'] ?? StringsRes.lblMobileNumber;
      StringsRes.lblUpdateProfile =
          localizedValues['lblUpdateProfile'] ?? StringsRes.lblUpdateProfile;
      StringsRes.lblInviteFriendToSignup =
          localizedValues['lblInviteFriendToSignup'] ??
              StringsRes.lblInviteFriendToSignup;
      StringsRes.lblFriendDownloadApp =
          localizedValues['lblFriendDownloadApp'] ??
              StringsRes.lblFriendDownloadApp;
      StringsRes.lblFriendPlaceFirstOrder =
          localizedValues['lblFriendPlaceFirstOrder'] ??
              StringsRes.lblFriendPlaceFirstOrder;
      StringsRes.lblYouWillGetRewardAfterDelivered =
          localizedValues['lblYouWillGetRewardAfterDelivered'] ??
              StringsRes.lblYouWillGetRewardAfterDelivered;
      StringsRes.lblYourReferralCode = localizedValues['lblYourReferralCode'] ??
          StringsRes.lblYourReferralCode;
      StringsRes.lblReferNow =
          localizedValues['lblReferNow'] ?? StringsRes.lblReferNow;
      StringsRes.lblTapToCopy =
          localizedValues['lblTapToCopy'] ?? StringsRes.lblTapToCopy;
      StringsRes.lblReferCodeCopied = localizedValues['lblReferCodeCopied'] ??
          StringsRes.lblReferCodeCopied;
      StringsRes.lblProfileInfo =
          localizedValues['lblProfileInfo'] ?? StringsRes.lblProfileInfo;
      StringsRes.lblTellUsAboutYou =
          localizedValues['lblTellUsAboutYou'] ?? StringsRes.lblTellUsAboutYou;
      StringsRes.lblProfileInfoDescription =
          localizedValues['lblProfileInfoDescription'] ??
              StringsRes.lblProfileInfoDescription;
      StringsRes.lblReferralCode =
          localizedValues['lblReferralCode'] ?? StringsRes.lblReferralCode;
      StringsRes.lblSaveInfo =
          localizedValues['lblSaveInfo'] ?? StringsRes.lblSaveInfo;
      StringsRes.lblSwipeToPlaceOrder =
          localizedValues['lblSwipeToPlaceOrder'] ??
              StringsRes.lblSwipeToPlaceOrder;
      StringsRes.lblUnableToCheckout = localizedValues['lblUnableToCheckout'] ??
          StringsRes.lblUnableToCheckout;
      StringsRes.lblAddresses =
          localizedValues['lblAddresses'] ?? StringsRes.lblAddresses;
      StringsRes.lblAddNewAddress =
          localizedValues['lblAddNewAddress'] ?? StringsRes.lblAddNewAddress;
      StringsRes.lblUpdateAddress =
          localizedValues['lblUpdateAddress'] ?? StringsRes.lblUpdateAddress;
      StringsRes.lblSelectDeliveryLocation =
          localizedValues['lblSelectDeliveryLocation'] ??
              StringsRes.lblSelectDeliveryLocation;
      StringsRes.lblUseMyCurrentLocation =
          localizedValues['lblUseMyCurrentLocation'] ??
              StringsRes.lblUseMyCurrentLocation;
      StringsRes.lblOr = localizedValues['lblOr'] ?? StringsRes.lblOr;
      StringsRes.lblTypeLocationManually =
          localizedValues['lblTypeLocationManually'] ??
              StringsRes.lblTypeLocationManually;
      StringsRes.lblConfirmLocation = localizedValues['lblConfirmLocation'] ??
          StringsRes.lblConfirmLocation;
      StringsRes.lblSelectYourLocation =
          localizedValues['lblSelectYourLocation'] ??
              StringsRes.lblSelectYourLocation;
      StringsRes.lblChange =
          localizedValues['lblChange'] ?? StringsRes.lblChange;
      StringsRes.lblRecentSearches =
          localizedValues['lblRecentSearches'] ?? StringsRes.lblRecentSearches;
      StringsRes.lblRecentSearchesClear =
          localizedValues['lblRecentSearchesClear'] ??
              StringsRes.lblRecentSearchesClear;
      StringsRes.lblAcceptTermsAndCondition =
          localizedValues['lblAcceptTermsAndCondition'] ??
              StringsRes.lblAcceptTermsAndCondition;
      StringsRes.lblAddressDetail =
          localizedValues['lblAddressDetail'] ?? StringsRes.lblAddressDetail;
      StringsRes.lblContactDetails =
          localizedValues['lblContactDetails'] ?? StringsRes.lblContactDetails;
      StringsRes.lblName = localizedValues['lblName'] ?? StringsRes.lblName;
      StringsRes.lblEnterName =
          localizedValues['lblEnterName'] ?? StringsRes.lblEnterName;
      StringsRes.lblAltMobileNo =
          localizedValues['lblAltMobileNo'] ?? StringsRes.lblAltMobileNo;
      StringsRes.lblAddressDetails =
          localizedValues['lblAddressDetails'] ?? StringsRes.lblAddressDetails;
      StringsRes.lblEnterAddress =
          localizedValues['lblEnterAddress'] ?? StringsRes.lblEnterAddress;
      StringsRes.lblLandmark =
          localizedValues['lblLandmark'] ?? StringsRes.lblLandmark;
      StringsRes.lblEnterLandmark =
          localizedValues['lblEnterLandmark'] ?? StringsRes.lblEnterLandmark;
      StringsRes.lblCity = localizedValues['lblCity'] ?? StringsRes.lblCity;
      StringsRes.lblEnterCity =
          localizedValues['lblEnterCity'] ?? StringsRes.lblEnterCity;
      StringsRes.lblArea = localizedValues['lblArea'] ?? StringsRes.lblArea;
      StringsRes.lblEnterArea =
          localizedValues['lblEnterArea'] ?? StringsRes.lblEnterArea;
      StringsRes.lblPinCode =
          localizedValues['lblPinCode'] ?? StringsRes.lblPinCode;
      StringsRes.lblEnterPinCode =
          localizedValues['lblEnterPinCode'] ?? StringsRes.lblEnterPinCode;
      StringsRes.lblState = localizedValues['lblState'] ?? StringsRes.lblState;
      StringsRes.lblEnterState =
          localizedValues['lblEnterState'] ?? StringsRes.lblEnterState;
      StringsRes.lblCountry =
          localizedValues['lblCountry'] ?? StringsRes.lblCountry;
      StringsRes.lblEnterCountry =
          localizedValues['lblEnterCountry'] ?? StringsRes.lblEnterCountry;
      StringsRes.lblAddressType =
          localizedValues['lblAddressType'] ?? StringsRes.lblAddressType;
      StringsRes.lblAddressTypeHome = localizedValues['lblAddressTypeHome'] ??
          StringsRes.lblAddressTypeHome;
      StringsRes.lblAddressTypeOffice =
          localizedValues['lblAddressTypeOffice'] ??
              StringsRes.lblAddressTypeOffice;
      StringsRes.lblAddressTypeOther = localizedValues['lblAddressTypeOther'] ??
          StringsRes.lblAddressTypeOther;
      StringsRes.lblSetAsDefaultAddress =
          localizedValues['lblSetAsDefaultAddress'] ??
              StringsRes.lblSetAsDefaultAddress;
      StringsRes.lblDeliverTo =
          localizedValues['lblDeliverTo'] ?? StringsRes.lblDeliverTo;
      StringsRes.lblHomeSearchHint =
          localizedValues['lblHomeSearchHint'] ?? StringsRes.lblHomeSearchHint;
      StringsRes.lblProductSearchHint =
          localizedValues['lblProductSearchHint'] ??
              StringsRes.lblProductSearchHint;
      StringsRes.lblSeeAll =
          localizedValues['lblSeeAll'] ?? StringsRes.lblSeeAll;
      StringsRes.lblShopBy =
          localizedValues['lblShopBy'] ?? StringsRes.lblShopBy;
      StringsRes.lblCategories =
          localizedValues['lblCategories'] ?? StringsRes.lblCategories;
      StringsRes.lblProducts =
          localizedValues['lblProducts'] ?? StringsRes.lblProducts;
      StringsRes.lblAll = localizedValues['lblAll'] ?? StringsRes.lblAll;
      StringsRes.lblFilter =
          localizedValues['lblFilter'] ?? StringsRes.lblFilter;
      StringsRes.lblSortBy =
          localizedValues['lblSortBy'] ?? StringsRes.lblSortBy;
      StringsRes.lblShare = localizedValues['lblShare'] ?? StringsRes.lblShare;
      StringsRes.lblWishList =
          localizedValues['lblWishList'] ?? StringsRes.lblWishList;
      StringsRes.lblListView =
          localizedValues['lblListView'] ?? StringsRes.lblListView;
      StringsRes.lblGridView =
          localizedValues['lblGridView'] ?? StringsRes.lblGridView;
      StringsRes.lblSearch =
          localizedValues['lblSearch'] ?? StringsRes.lblSearch;
      StringsRes.lblSearchResultFor = localizedValues['lblSearchResultFor'] ??
          StringsRes.lblSearchResultFor;
      StringsRes.lblSearchEmptyMessageTitle =
          localizedValues['lblSearchEmptyMessageTitle'] ??
              StringsRes.lblSearchEmptyMessageTitle;
      StringsRes.lblSearchEmptyMessageDescription =
          localizedValues['lblSearchEmptyMessageDescription'] ??
              StringsRes.lblSearchEmptyMessageDescription;
      StringsRes.lblReturnsAndExchangesPolicy =
          localizedValues['lblReturnsAndExchangesPolicy'] ??
              StringsRes.lblReturnsAndExchangesPolicy;
      StringsRes.lblShippingPolicy =
          localizedValues['lblShippingPolicy'] ?? StringsRes.lblShippingPolicy;
      StringsRes.lblCancellationPolicy =
          localizedValues['lblCancellationPolicy'] ??
              StringsRes.lblCancellationPolicy;
      StringsRes.lblGoToProduct =
          localizedValues['lblGoToProduct'] ?? StringsRes.lblGoToProduct;
      StringsRes.lblGoToCategory =
          localizedValues['lblGoToCategory'] ?? StringsRes.lblGoToCategory;
      StringsRes.lblShareAppMessage = localizedValues['lblShareAppMessage'] ??
          StringsRes.lblShareAppMessage;
      StringsRes.lblReferAndEarnSharePrefixMessage =
          localizedValues['lblReferAndEarnSharePrefixMessage'] ??
              StringsRes.lblReferAndEarnSharePrefixMessage;
      StringsRes.lblReferAndEarnShareDisplayMessage1Prefix =
          localizedValues['lblReferAndEarnShareDisplayMessage1Prefix'] ??
              StringsRes.lblReferAndEarnShareDisplayMessage1Prefix;
      StringsRes.lblReferAndEarnShareDisplayMessage1Postfix =
          localizedValues['lblReferAndEarnShareDisplayMessage1Postfix'] ??
              StringsRes.lblReferAndEarnShareDisplayMessage1Postfix;
      StringsRes.lblReferAndEarnShareDisplayMessage2 =
          localizedValues['lblReferAndEarnShareDisplayMessage2'] ??
              StringsRes.lblReferAndEarnShareDisplayMessage2;
      StringsRes.lblReferAndEarnShareDisplayMessage3 =
          localizedValues['lblReferAndEarnShareDisplayMessage3'] ??
              StringsRes.lblReferAndEarnShareDisplayMessage3;
      StringsRes.lblOutOfStock =
          localizedValues['lblOutOfStock'] ?? StringsRes.lblOutOfStock;
      StringsRes.lblGoToCart =
          localizedValues['lblGoToCart'] ?? StringsRes.lblGoToCart;
      StringsRes.lblCart = localizedValues['lblCart'] ?? StringsRes.lblCart;
      StringsRes.lblEmptyCartListMessage =
          localizedValues['lblEmptyCartListMessage'] ??
              StringsRes.lblEmptyCartListMessage;
      StringsRes.lblEmptyCartListDescription =
          localizedValues['lblEmptyCartListDescription'] ??
              StringsRes.lblEmptyCartListDescription;
      StringsRes.lblEmptyCartListButtonName =
          localizedValues['lblEmptyCartListButtonName'] ??
              StringsRes.lblEmptyCartListButtonName;
      StringsRes.lblCancel =
          localizedValues['lblCancel'] ?? StringsRes.lblCancel;
      StringsRes.lblOrdersHistory =
          localizedValues['lblOrdersHistory'] ?? StringsRes.lblOrdersHistory;
      StringsRes.lblActiveOrders =
          localizedValues['lblActiveOrders'] ?? StringsRes.lblActiveOrders;
      StringsRes.lblPreviousOrders =
          localizedValues['lblPreviousOrders'] ?? StringsRes.lblPreviousOrders;
      StringsRes.lblOrder = localizedValues['lblOrder'] ?? StringsRes.lblOrder;
      StringsRes.lblPlacedOrderOn =
          localizedValues['lblPlacedOrderOn'] ?? StringsRes.lblPlacedOrderOn;
      StringsRes.lblViewDetails =
          localizedValues['lblViewDetails'] ?? StringsRes.lblViewDetails;
      StringsRes.lblTotal = localizedValues['lblTotal'] ?? StringsRes.lblTotal;
      StringsRes.lblTrackMyOrder =
          localizedValues['lblTrackMyOrder'] ?? StringsRes.lblTrackMyOrder;
      StringsRes.lblOrderTracking =
          localizedValues['lblOrderTracking'] ?? StringsRes.lblOrderTracking;
      StringsRes.lblOrderConfirmed =
          localizedValues['lblOrderConfirmed'] ?? StringsRes.lblOrderConfirmed;
      StringsRes.lblOrderShipped =
          localizedValues['lblOrderShipped'] ?? StringsRes.lblOrderShipped;
      StringsRes.lblOrderOutForDelivery =
          localizedValues['lblOrderOutForDelivery'] ??
              StringsRes.lblOrderOutForDelivery;
      StringsRes.lblOrderDelivered =
          localizedValues['lblOrderDelivered'] ?? StringsRes.lblOrderDelivered;
      StringsRes.lblOrderSummary =
          localizedValues['lblOrderSummary'] ?? StringsRes.lblOrderSummary;
      StringsRes.lblItems = localizedValues['lblItems'] ?? StringsRes.lblItems;
      StringsRes.lblDeliveryInformation =
          localizedValues['lblDeliveryInformation'] ??
              StringsRes.lblDeliveryInformation;
      StringsRes.lblDeliveryTo =
          localizedValues['lblDeliveryTo'] ?? StringsRes.lblDeliveryTo;
      StringsRes.lblBillingDetails =
          localizedValues['lblBillingDetails'] ?? StringsRes.lblBillingDetails;
      StringsRes.lblPaymentMethod =
          localizedValues['lblPaymentMethod'] ?? StringsRes.lblPaymentMethod;
      StringsRes.lblTransactionId =
          localizedValues['lblTransactionId'] ?? StringsRes.lblTransactionId;
      StringsRes.lblId = localizedValues['lblId'] ?? StringsRes.lblId;
      StringsRes.lblDateAndTime =
          localizedValues['lblDateAndTime'] ?? StringsRes.lblDateAndTime;
      StringsRes.lblAmount =
          localizedValues['lblAmount'] ?? StringsRes.lblAmount;
      StringsRes.lblVoiceSearchProductMessage =
          localizedValues['lblVoiceSearchProductMessage'] ??
              StringsRes.lblVoiceSearchProductMessage;
      StringsRes.lblSureToCancelProduct =
          localizedValues['lblSureToCancelProduct'] ??
              StringsRes.lblSureToCancelProduct;
      StringsRes.lblSureToReturnProduct =
          localizedValues['lblSureToReturnProduct'] ??
              StringsRes.lblSureToReturnProduct;
      StringsRes.lblSureToReturnOrder =
          localizedValues['lblSureToReturnOrder'] ??
              StringsRes.lblSureToReturnOrder;
      StringsRes.lblSureToCancelOrder =
          localizedValues['lblSureToCancelOrder'] ??
              StringsRes.lblSureToCancelOrder;
      StringsRes.lblNo = localizedValues['lblNo'] ?? StringsRes.lblNo;
      StringsRes.lblYes = localizedValues['lblYes'] ?? StringsRes.lblYes;
      StringsRes.lblUnableToReturnProduct =
          localizedValues['lblUnableToReturnProduct'] ??
              StringsRes.lblUnableToReturnProduct;
      StringsRes.lblUnableToCancelProduct =
          localizedValues['lblUnableToCancelProduct'] ??
              StringsRes.lblUnableToCancelProduct;
      StringsRes.lblUnableToReturnOrder =
          localizedValues['lblUnableToReturnOrder'] ??
              StringsRes.lblUnableToReturnOrder;
      StringsRes.lblUnableToCancelOrder =
          localizedValues['lblUnableToCancelOrder'] ??
              StringsRes.lblUnableToCancelOrder;
      StringsRes.lblChangeCoupon =
          localizedValues['lblChangeCoupon'] ?? StringsRes.lblChangeCoupon;
      StringsRes.lblClearAll =
          localizedValues['lblClearAll'] ?? StringsRes.lblClearAll;
      StringsRes.lblApply = localizedValues['lblApply'] ?? StringsRes.lblApply;
      StringsRes.lblSubTotal =
          localizedValues['lblSubTotal'] ?? StringsRes.lblSubTotal;
      StringsRes.lblItem = localizedValues['lblItem'] ?? StringsRes.lblItem;
      StringsRes.lblProceedToCheckout =
          localizedValues['lblProceedToCheckout'] ??
              StringsRes.lblProceedToCheckout;
      StringsRes.lblApplyDiscountCode =
          localizedValues['lblApplyDiscountCode'] ??
              StringsRes.lblApplyDiscountCode;
      StringsRes.lblCoupon =
          localizedValues['lblCoupon'] ?? StringsRes.lblCoupon;
      StringsRes.lblPromoCodes =
          localizedValues['lblPromoCodes'] ?? StringsRes.lblPromoCodes;
      StringsRes.lblApplied =
          localizedValues['lblApplied'] ?? StringsRes.lblApplied;
      StringsRes.lblNoAddressFoundTitle =
          localizedValues['lblNoAddressFoundTitle'] ??
              StringsRes.lblNoAddressFoundTitle;
      StringsRes.lblReturn =
          localizedValues['lblReturn'] ?? StringsRes.lblReturn;
      StringsRes.lblNoAddressFoundDescription =
          localizedValues['lblNoAddressFoundDescription'] ??
              StringsRes.lblNoAddressFoundDescription;
      StringsRes.lblDeleteAddress =
          localizedValues['lblDeleteAddress'] ?? StringsRes.lblDeleteAddress;
      StringsRes.lblPleaseSelectAddressFromMap =
          localizedValues['lblPleaseSelectAddressFromMap'] ??
              StringsRes.lblPleaseSelectAddressFromMap;
      StringsRes.lblCheckout =
          localizedValues['lblCheckout'] ?? StringsRes.lblCheckout;
      StringsRes.lblDeliveryCharge =
          localizedValues['lblDeliveryCharge'] ?? StringsRes.lblDeliveryCharge;
      StringsRes.lblSellerWiseDeliveryChargesDetail =
          localizedValues['lblSellerWiseDeliveryChargesDetail'] ??
              StringsRes.lblSellerWiseDeliveryChargesDetail;
      StringsRes.lblPreferredDeliveryTime =
          localizedValues['lblPreferredDeliveryTime'] ??
              StringsRes.lblPreferredDeliveryTime;
      StringsRes.lblRequiredLoginMessageForCart =
          localizedValues['lblRequiredLoginMessageForCart'] ??
              StringsRes.lblRequiredLoginMessageForCart;
      StringsRes.lblRequiredLoginMessageForWishlist =
          localizedValues['lblRequiredLoginMessageForWishlist'] ??
              StringsRes.lblRequiredLoginMessageForWishlist;
      StringsRes.lblRequiredLoginMessageForCartRedirect =
          localizedValues['lblRequiredLoginMessageForCartRedirect'] ??
              StringsRes.lblRequiredLoginMessageForCartRedirect;
      StringsRes.lblHideDetail =
          localizedValues['lblHideDetail'] ?? StringsRes.lblHideDetail;
      StringsRes.lblShowDetail =
          localizedValues['lblShowDetail'] ?? StringsRes.lblShowDetail;
      StringsRes.lblMaximumProductQuantityLimitReachedMessage =
          localizedValues['lblMaximumProductQuantityLimitReachedMessage'] ??
              StringsRes.lblMaximumProductQuantityLimitReachedMessage;
      StringsRes.lblOutOfStockMessage =
          localizedValues['lblOutOfStockMessage'] ??
              StringsRes.lblOutOfStockMessage;
      StringsRes.lblOrderPlaceMessage =
          localizedValues['lblOrderPlaceMessage'] ??
              StringsRes.lblOrderPlaceMessage;
      StringsRes.lblOrderPlaceDescription =
          localizedValues['lblOrderPlaceDescription'] ??
              StringsRes.lblOrderPlaceDescription;
      StringsRes.lblCashOnDelivery =
          localizedValues['lblCashOnDelivery'] ?? StringsRes.lblCashOnDelivery;
      StringsRes.lblRazorpay =
          localizedValues['lblRazorpay'] ?? StringsRes.lblRazorpay;
      StringsRes.lblPaystack =
          localizedValues['lblPaystack'] ?? StringsRes.lblPaystack;
      StringsRes.lblBy = localizedValues['lblBy'] ?? StringsRes.lblBy;
      StringsRes.lblContinueShopping = localizedValues['lblContinueShopping'] ??
          StringsRes.lblContinueShopping;
      StringsRes.lblLogoutTitle =
          localizedValues['lblLogoutTitle'] ?? StringsRes.lblLogoutTitle;
      StringsRes.lblLogoutMessage =
          localizedValues['lblLogoutMessage'] ?? StringsRes.lblLogoutMessage;
      StringsRes.lblDeleteUserAccount =
          localizedValues['lblDeleteUserAccount'] ??
              StringsRes.lblDeleteUserAccount;
      StringsRes.lblDeleteUserTitle = localizedValues['lblDeleteUserTitle'] ??
          StringsRes.lblDeleteUserTitle;
      StringsRes.lblDeleteUserMessage =
          localizedValues['lblDeleteUserMessage'] ??
              StringsRes.lblDeleteUserMessage;
      StringsRes.lblOk = localizedValues['lblOk'] ?? StringsRes.lblOk;
      StringsRes.lblVoiceToSearchProduct =
          localizedValues['lblVoiceToSearchProduct'] ??
              StringsRes.lblVoiceToSearchProduct;
      StringsRes.lblThemeDisplayNames =
          localizedValues['lblThemeDisplayNames'] ??
              StringsRes.lblThemeDisplayNames;
      StringsRes.lblWeekDaysNames =
          localizedValues['lblWeekDaysNames'] ?? StringsRes.lblWeekDaysNames;
      StringsRes.lblMonthsNames =
          localizedValues['lblMonthsNames'] ?? StringsRes.lblMonthsNames;
      StringsRes.lblSortingDisplayList =
          localizedValues['lblSortingDisplayList'] ??
              StringsRes.lblSortingDisplayList;
    }
  }

  //to get translated value of given title/key
  getTranslatedValues(String? key) {
    return localizedValues[key] ?? key;
  }

  //need to declare custom delegate
  static LocalizationsDelegate<AppLocalization> delegate =
      _AppLocalizationDelegate();
}

//Custom app delegate
class _AppLocalizationDelegate extends LocalizationsDelegate<AppLocalization> {
  _AppLocalizationDelegate();

  //providing all supporated languages
  @override
  bool isSupported(Locale locale) {
    return GeneralMethods.langList().contains(locale);
  }

  //load languageCode.json files
  @override
  Future<AppLocalization> load(Locale locale) async {
    AppLocalization localization = AppLocalization(locale);
    await localization.loadJson();
    return localization;
  }

  @override
  bool shouldReload(LocalizationsDelegate<AppLocalization> old) {
    return false;
  }
}
