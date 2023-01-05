class PromoCode {
  PromoCode({
    required this.status,
    required this.message,
    required this.total,
    required this.data,
  });

  late final int status;
  late final String message;
  late final int total;
  late final List<PromoCodeData> data;

  PromoCode.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    total = json['total'];
    data =
        List.from(json['data']).map((e) => PromoCodeData.fromJson(e)).toList();
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['status'] = status;
    _data['message'] = message;
    _data['total'] = total;
    _data['data'] = data.map((e) => e.toJson()).toList();
    return _data;
  }
}

class PromoCodeData {
  PromoCodeData({
    required this.id,
    required this.isApplicable,
    required this.message,
    required this.promoCode,
    required this.imageUrl,
    required this.promoCodeMessage,
    required this.total,
    required this.discount,
    required this.discountedAmount,
  });

  late final int id;
  late final int isApplicable;
  late final String message;
  late final String promoCode;
  late final String imageUrl;
  late final String promoCodeMessage;
  late final double total;
  late final double discount;
  late final double discountedAmount;

  PromoCodeData.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    isApplicable = json['is_applicable'];
    message = json['message'];
    promoCode = json['promo_code'];
    imageUrl = json['image_url'];
    promoCodeMessage = json['promo_code_message'];
    total = double.parse(json['total'].toString());
    discount = double.parse(json['discount'].toString());
    discountedAmount = double.parse(json['discounted_amount'].toString());
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['id'] = id;
    _data['is_applicable'] = isApplicable;
    _data['message'] = message;
    _data['promo_code'] = promoCode;
    _data['image_url'] = imageUrl;
    _data['promo_code_message'] = promoCodeMessage;
    _data['total'] = total;
    _data['discount'] = discount;
    _data['discounted_amount'] = discountedAmount;
    return _data;
  }
}
