class Settings {
  late final String appName;
  late final String supportNumber;
  late final String supportEmail;
  late final String currentVersion;
  late final String minimumVersionRequired;
  late final String storeAddress;
  late final String mapLatitude;
  late final String mapLongitude;
  late final String currency;
  late final String taxName;
  late final String taxNumber;
  late final String maxCartItemsCount;
  late final String minOrderAmount;
  late final String minReferEarnOrderAmount;
  late final String referEarnBonus;
  late final String maxReferEarnAmount;
  late final String minimumWithdrawalAmount;
  late final String maxProductReturnDays;
  late final String deliveryBoyBonusPercentage;
  late final String userWalletRefillLimit;
  late final String lowStockLimit;
  late final String isVersionSystemOn;
  late final String isReferEarnOn;
  late final String referEarnMethod;
  late final String privacyPolicy;
  late final String termsConditions;
  late final String aboutUs;
  late final String contactUs;
  late final String returnsAndExchangesPolicy;
  late final String shippingPolicy;
  late final String cancellationPolicy;
  late final List<int> favoriteProductIds;
  late final String googlePlaceApiKey;
  late final String currencyCode;
  late final String decimalPoints;

  Settings({
    required this.appName,
    required this.supportNumber,
    required this.supportEmail,
    required this.currentVersion,
    required this.minimumVersionRequired,
    required this.storeAddress,
    required this.mapLatitude,
    required this.mapLongitude,
    required this.currency,
    required this.taxName,
    required this.taxNumber,
    required this.maxCartItemsCount,
    required this.minOrderAmount,
    required this.minReferEarnOrderAmount,
    required this.referEarnBonus,
    required this.maxReferEarnAmount,
    required this.minimumWithdrawalAmount,
    required this.maxProductReturnDays,
    required this.deliveryBoyBonusPercentage,
    required this.userWalletRefillLimit,
    required this.lowStockLimit,
    required this.isVersionSystemOn,
    required this.isReferEarnOn,
    required this.referEarnMethod,
    required this.privacyPolicy,
    required this.termsConditions,
    required this.aboutUs,
    required this.contactUs,
    required this.returnsAndExchangesPolicy,
    required this.shippingPolicy,
    required this.cancellationPolicy,
    required this.favoriteProductIds,
    required this.googlePlaceApiKey,
    required this.currencyCode,
    required this.decimalPoints,
  });

  Settings.fromJson(Map<String, dynamic> json) {
    appName = json['app_name'] ?? "";
    supportNumber = json['support_number'] ?? "";
    supportEmail = json['support_email'] ?? "";
    currentVersion = json['current_version'] ?? "";
    minimumVersionRequired = json['minimum_version_required'] ?? "";
    storeAddress = json['store_address'] ?? "";
    mapLatitude = json['map_latitude'] ?? "";
    mapLongitude = json['map_longitude'] ?? "";
    currency = json['currency'] ?? "";
    taxName = json['tax_name'] ?? "";
    taxNumber = json['tax_number'] ?? "";
    maxCartItemsCount = json['max_cart_items_count'] ?? "";
    minOrderAmount = json['min_order_amount'] ?? "";
    minReferEarnOrderAmount = json['min_refer_earn_order_amount'] ?? "";
    referEarnBonus = json['refer_earn_bonus'] ?? "";
    maxReferEarnAmount = json['max_refer_earn_amount'] ?? "";
    minimumWithdrawalAmount = json['minimum_withdrawal_amount'] ?? "";
    maxProductReturnDays = json['max_product_return_days'] ?? "";
    deliveryBoyBonusPercentage = json['delivery_boy_bonus_percentage'] ?? "";
    userWalletRefillLimit = json['user_wallet_refill_limit'] ?? "";
    lowStockLimit = json['low_stock_limit'] ?? "";
    isVersionSystemOn = json['is_version_system_on'] ?? "";
    isReferEarnOn = json['is_refer_earn_on'] ?? "";
    referEarnMethod = json['refer_earn_method'] ?? "";
    privacyPolicy = json['privacy_policy'] ?? "";
    termsConditions = json['terms_conditions'] ?? "";
    aboutUs = json['about_us'] ?? "";
    contactUs = json['contact_us'] ?? "";
    returnsAndExchangesPolicy = json['returns_and_exchanges_policy'] ?? "";
    shippingPolicy = json['shipping_policy'] ?? "";
    cancellationPolicy = json['cancellation_policy'] ?? "";
    favoriteProductIds =
        List.castFrom<dynamic, int>(json['favorite_product_ids']);
    googlePlaceApiKey = json['google_place_api_key'] ?? "";
    currencyCode = json['currency_code'] ?? "";
    decimalPoints = json['decimal_point'] ?? "";
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['app_name'] = appName;
    _data['support_number'] = supportNumber;
    _data['support_email'] = supportEmail;
    _data['current_version'] = currentVersion;
    _data['minimum_version_required'] = minimumVersionRequired;
    _data['store_address'] = storeAddress;
    _data['map_latitude'] = mapLatitude;
    _data['map_longitude'] = mapLongitude;
    _data['currency'] = currency;
    _data['tax_name'] = taxName;
    _data['tax_number'] = taxNumber;
    _data['max_cart_items_count'] = maxCartItemsCount;
    _data['min_order_amount'] = minOrderAmount;
    _data['min_refer_earn_order_amount'] = minReferEarnOrderAmount;
    _data['refer_earn_bonus'] = referEarnBonus;
    _data['max_refer_earn_amount'] = maxReferEarnAmount;
    _data['minimum_withdrawal_amount'] = minimumWithdrawalAmount;
    _data['max_product_return_days'] = maxProductReturnDays;
    _data['delivery_boy_bonus_percentage'] = deliveryBoyBonusPercentage;
    _data['user_wallet_refill_limit'] = userWalletRefillLimit;
    _data['low_stock_limit'] = lowStockLimit;
    _data['is_version_system_on'] = isVersionSystemOn;
    _data['is_refer_earn_on'] = isReferEarnOn;
    _data['refer_earn_method'] = referEarnMethod;
    _data['privacy_policy'] = privacyPolicy;
    _data['terms_conditions'] = termsConditions;
    _data['about_us'] = aboutUs;
    _data['contact_us'] = contactUs;
    _data['returns_and_exchanges_policy'] = returnsAndExchangesPolicy;
    _data['shipping_policy'] = shippingPolicy;
    _data['cancellation_policy'] = cancellationPolicy;
    _data['favorite_product_ids'] = favoriteProductIds;
    _data['google_place_api_key'] = googlePlaceApiKey;
    _data['currency_code'] = currencyCode;
    _data['decimal_point'] = decimalPoints;
    return _data;
  }
}
