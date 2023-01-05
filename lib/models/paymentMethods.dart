class PaymentMethods {
  PaymentMethods({
    required this.status,
    required this.message,
    required this.total,
    required this.data,
  });

  late final int status;
  late final String message;
  late final int total;
  late final PaymentMethodsData data;

  PaymentMethods.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    total = json['total'];
    data = PaymentMethodsData.fromJson(json['data']);
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['status'] = status;
    _data['message'] = message;
    _data['total'] = total;
    _data['data'] = data.toJson();
    return _data;
  }
}

class PaymentMethodsData {
  PaymentMethodsData({
    required this.codPaymentMethod,
    required this.codMode,
    required this.razorpayPaymentMethod,
    required this.razorpayKey,
    required this.razorpaySecretKey,
    required this.paystackPaymentMethod,
    required this.paystackPublicKey,
    required this.paystackSecretKey,
    required this.paystackCurrencyCode,
  });

  late final String codPaymentMethod;
  late final String codMode;
  late final String razorpayPaymentMethod;
  late final String razorpayKey;
  late final String razorpaySecretKey;
  late final String paystackPaymentMethod;
  late final String paystackPublicKey;
  late final String paystackSecretKey;
  late final String paystackCurrencyCode;

  PaymentMethodsData.fromJson(Map<String, dynamic> json) {
    codPaymentMethod = json['cod_payment_method'];
    codMode = json['cod_mode'];
    razorpayPaymentMethod = json['razorpay_payment_method'];
    razorpayKey = json['razorpay_key'];
    razorpaySecretKey = json['razorpay_secret_key'];
    paystackPaymentMethod = json['paystack_payment_method'];
    paystackPublicKey = json['paystack_public_key'];
    paystackSecretKey = json['paystack_secret_key'];
    paystackCurrencyCode = json['paystack_currency_code'];
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['cod_payment_method'] = codPaymentMethod;
    _data['cod_mode'] = codMode;
    _data['razorpay_payment_method'] = razorpayPaymentMethod;
    _data['razorpay_key'] = razorpayKey;
    _data['razorpay_secret_key'] = razorpaySecretKey;
    _data['paystack_payment_method'] = paystackPaymentMethod;
    _data['paystack_public_key'] = paystackPublicKey;
    _data['paystack_secret_key'] = paystackSecretKey;
    _data['paystack_currency_code'] = paystackCurrencyCode;
    return _data;
  }
}
